import {
    SDK,
    NetworkEnum,
    HashLock,
    QuoteParams,
    OrderInfo,
    PrivateKeyProviderConnector
} from '@1inch/cross-chain-sdk'
import { randomBytes } from 'crypto';
import {config} from 'dotenv'
config()

const { Web3 } = require('web3');

import {privateKeyToAddress, privateKeyToAccount} from "viem/accounts";
import { http, createPublicClient, createWalletClient, encodePacked } from "viem"
import {sepolia} from "viem/chains";

const privateKey = process.env.PRIVATE_KEY
const rpcURL = process.env.RPC_URL
if (!privateKey || !rpcURL) {
    throw new Error('PRIVATE_KEY or RPC_URL is not defined')
}
const makerAddress = privateKeyToAddress(`0x${privateKey}`)
const account = privateKeyToAccount(`0x${privateKey}`)

const walletClient = createWalletClient({
    account,
    chain: sepolia,
    transport: http(rpcURL),
})

const publicClient = createPublicClient({
    chain: sepolia,
    transport: http(rpcURL),
})

function getRandomBytes32() {
    return "0x" + randomBytes(32).toString("hex");
}

async function main() {
    const web3Instance = new Web3(rpcURL)
    const blockchainProvider = new PrivateKeyProviderConnector(privateKey!, web3Instance)

    const sdk = new SDK({
        url: 'https://api.1inch.dev/fusion-plus',
        authKey: 'iknN9var1mKaqg9LoZnkZKgoB8Cw7afz',
        blockchainProvider: blockchainProvider,
    })

    // Define source and destination chain details
    let srcChainId = NetworkEnum.POLYGON;
    let dstChainId = NetworkEnum.OPTIMISM;
    // let srcTokenAddress: `0x${string}` = '0x3c499c542cEF5E3811e1192ce70d8cC03d5c3359'; // POLYGON USDC
    let srcTokenAddress: `0x${string}` = '0xc2132D05D31c914a87C6611C10748AEb04B58e8F'; // POLYGON USDT
    let dstTokenAddress: `0x${string}` = '0x94b008aA00579c1307B0EF2c499aD98a8ce58e58'; // OPTIMISM USDT

    const maxAmt = 115792089237316195423570985008687907853269984665640564039457584007913129639934n
    const approveABI = [
        {
            constant: false,
            inputs: [
                { name: "spender", type: "address" },
                { name: "amount", type: "uint256" }
            ],
            name: "approve",
            outputs: [{ name: "", type: "bool" }],
            payable: false,
            stateMutability: "nonpayable",
            type: "function"
        }
    ];

    walletClient.writeContract({
        address: srcTokenAddress,
        abi: approveABI,
        functionName: 'approve',
        args: ["0x111111125421ca6dc452d289314280a0f8842a65", maxAmt] // approval for 1inch aggregator router v6
    })

    // Get a quote
    const params: QuoteParams = {
        srcChainId,
        dstChainId,
        srcTokenAddress,
        dstTokenAddress,
        amount: '20000000', // 20 USDT
        enableEstimate: true,
        walletAddress: makerAddress
    };

    const quote = await sdk.getQuote(params);
    const secretsCount = quote.getPreset().secretsCount;
    console.log("secretsCount", secretsCount)

    // Generate secrets and create hash lock
    const secrets = Array.from({ length: secretsCount }).map(() => getRandomBytes32());
    const secretHashes = secrets.map(x => HashLock.hashSecret(x));

    const hashLock = secretsCount === 1
        ? HashLock.forSingleFill(secrets[0])
        : HashLock.forMultipleFills(
            // @ts-ignore
            secretHashes.map((secretHash, i) =>
                encodePacked(
                    ['uint64', 'bytes32'],
                    [BigInt(i), secretHash as `0x${string}`],
                )
            )
        );

    console.log("Received Fusion+ quote from 1inch API");

    // Place an order
    let orderResponse: OrderInfo;
    try {
        orderResponse = await sdk.placeOrder(quote, {
            walletAddress: makerAddress,
            hashLock,
            secretHashes
        });
    } catch (error) {
        console.error(`Error placing order: ${error}`);
        process.exit(1);
    }

    console.log(`Order successfully placed with hash: ${orderResponse.orderHash}`);

    // Poll for order status
    await new Promise<void>((resolve, reject) => {
        // Poll for order status
        const intervalId = setInterval(async () => {
            console.log("Polling for fills until order status is set to 'executed'...");
            try {
                const order = await sdk.getOrderStatus(orderResponse.orderHash);
                if (order.status === 'executed') {
                    console.log("Order is complete. Exiting.");
                    clearInterval(intervalId);
                    resolve(); // Resolve the promise to continue execution
                }
                if (order.status === 'expired' || order.status === 'cancelled' || order.status === 'refunded' || order.status === 'refunding') {
                    console.log("Order was unsuccessful (not picked by anyone). Exiting.");
                    clearInterval(intervalId);
                    resolve(); // Resolve the promise to continue execution
                }
            } catch (error) {
                console.error(`Error fetching order status: ${error}`);
            }

            // Check for fills and submit secrets if needed
            try {
                const fillsObject = await sdk.getReadyToAcceptSecretFills(orderResponse.orderHash);
                if (fillsObject.fills.length > 0) {
                    for (const fill of fillsObject.fills) {
                        await sdk.submitSecret(orderResponse.orderHash, secrets[fill.idx]);
                        console.log(`Fill order found! Secret submitted: ${secretHashes[fill.idx]}`);
                    }
                }
            } catch (error) {
                console.error(`Error checking fills: ${error}`);
            }
        }, 5000);
    });
}
main().then(() => {
    process.exit(0)
}).catch(error => {
    console.error(error)
    process.exit(1)
})