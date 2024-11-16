import CheckFootprint from "@/components/CheckFootprint";
import NavigationBar from "@/components/NavigationBar";
import TabContainer from "@/components/TabContainer";
import { TabProvider } from "@/contexts/TabContext";
import { EthereumWalletConnectors } from "@dynamic-labs/ethereum";
import { DynamicContextProvider } from "@dynamic-labs/sdk-react-core";
import Image from "next/image";

export default function Home() {
  return (
    <DynamicContextProvider
      settings={{
        environmentId: "21f77e40-0851-43bc-a534-ff0fa86511c3",
        walletConnectors: [EthereumWalletConnectors],
      }}
    >
      <TabProvider>
        <main className="min-h-screen bg-black text-white">
          {/* <CheckFootprint /> */}
          <TabContainer />
          <NavigationBar />
        </main>
      </TabProvider>
    </DynamicContextProvider>
  );
}
