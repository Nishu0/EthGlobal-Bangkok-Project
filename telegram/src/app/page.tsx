import Image from "next/image";
import {
  DynamicContextProvider,
  DynamicWidget,
} from "@dynamic-labs/sdk-react-core";
import { EthereumWalletConnectors } from "@dynamic-labs/ethereum";
export default function Home() {
  return (
    <DynamicContextProvider
      settings={{
        environmentId: "21f77e40-0851-43bc-a534-ff0fa86511c3",
        walletConnectors: [EthereumWalletConnectors],
      }}
    >
      <DynamicWidget />
    </DynamicContextProvider>
  );
}
