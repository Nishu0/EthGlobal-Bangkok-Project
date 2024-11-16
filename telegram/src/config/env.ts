import { NETWORK } from "./chain";

export type ENV = {
  NETWORK: NETWORK;
  API_URL: string;
};

export const env: ENV = {
  NETWORK: process.env.NEXT_PUBLIC_NETWORK as NETWORK,
  API_URL: process.env.NEXT_PUBLIC_API_URL!,
} as const;
