"use client";

import { type ReactNode, useState } from "react";
import { AppQueryClientProvider } from "./react-query-provider";
import { getWagmiConfig } from "@/config/wagmi-config";
import { type State, WagmiProvider } from "wagmi";
import { DynamicContextProvider } from "@dynamic-labs/sdk-react-core";
import { EthereumWalletConnectors } from "@dynamic-labs/ethereum";
import { DynamicWagmiConnector } from "@dynamic-labs/wagmi-connector";

type Props = {
  children: ReactNode;
  initialState: State | undefined;
};

export function Providers({ children, initialState }: Props) {
  const [config] = useState(() => getWagmiConfig());

  return (
    <DynamicContextProvider
      settings={{
        environmentId: "21f77e40-0851-43bc-a534-ff0fa86511c3",
        walletConnectors: [EthereumWalletConnectors],
      }}
    >
      <WagmiProvider config={config} initialState={initialState}>
        <AppQueryClientProvider>
          <DynamicWagmiConnector>{children}</DynamicWagmiConnector>
        </AppQueryClientProvider>
      </WagmiProvider>
    </DynamicContextProvider>
  );
}
