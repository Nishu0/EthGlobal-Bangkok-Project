import { Chain } from "viem";
import { flowTestnet, flareTestnet, mainnet, polygon, iota } from "viem/chains";
import { env } from "./env";

export enum NETWORK {
  MAINNET = "MAINNET",
  TESTNET = "TESTNET",
}

export enum CHAIN_TYPE {
  EVM = "EVM",
}

const evmTestNets = [flowTestnet] as const;
const evmMainNets = [mainnet, polygon, iota] as const;

export function getCurrentNetworks(): readonly [Chain, ...Chain[]] {
  const networks = env.NETWORK === NETWORK.TESTNET ? evmTestNets : evmMainNets;

  return networks as readonly [Chain, ...Chain[]];
}
