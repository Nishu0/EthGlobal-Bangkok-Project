// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ISolanaApiVerification} from "./interfaces/verification/ISolanaApiVerification.sol";
import {SolanaApiVerification} from "./implementation/verification/SolanaApiVerification.sol";

contract SolanaApiExample {
    struct SolanaTransaction {
        uint256 blockNumber;
        uint256 blockTimestamp;
        bytes32 sourceAddressHash;
        bytes32 receivingAddressHash;
        uint256 amountTransferred;
    }

    SolanaTransaction[] public solanaTransactions;

    ISolanaApiVerification public solanaApiAttestationVerification;

    constructor(address _solanaVerificationContract) {
        solanaApiAttestationVerification = ISolanaApiVerification(_solanaVerificationContract);
    }

    function addSolanaTransaction(
        ISolanaApiVerification.Proof calldata proof
    ) external {
        // Verify the attestation using Flare's Data Connector verification
        require(
            solanaApiAttestationVerification.verifySolanaTransaction(proof),
            "Invalid Solana transaction proof"
        );

        // Decode the response into a SolanaTransaction struct
        SolanaTransaction memory transaction = abi.decode(
            proof.data.responseBody.abi_encoded_data,
            (SolanaTransaction)
        );

        // Store the transaction on-chain for later use
        solanaTransactions.push(transaction);
    }

    function getTransaction(uint256 index) external view returns (SolanaTransaction memory) {
        require(index < solanaTransactions.length, "Index out of bounds");
        return solanaTransactions[index];
    }
}
