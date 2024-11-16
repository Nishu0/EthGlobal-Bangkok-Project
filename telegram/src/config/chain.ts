import { Chain } from "viem";
import {
  iota,
  iotaTestnet,
  mainnet,
  plumeTestnet,
  polygon,
  polygonAmoy,
  sepolia,
} from "viem/chains";
import { env } from "./env";

export enum NETWORK {
  MAINNET = "MAINNET",
  TESTNET = "TESTNET",
}

export enum CHAIN_TYPE {
  EVM = "EVM",
}

const evmTestNets = [
  sepolia,
  plumeTestnet,
  polygonAmoy,
  iotaTestnet,
  iota,
] as const;
const evmMainNets = [mainnet, polygon, iota] as const;

export function getCurrentNetworks(): readonly [Chain, ...Chain[]] {
  const networks = env.NETWORK === NETWORK.TESTNET ? evmTestNets : evmMainNets;

  return networks as readonly [Chain, ...Chain[]];
}
