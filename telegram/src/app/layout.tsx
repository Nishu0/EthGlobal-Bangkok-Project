import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import {
  DynamicContextProvider,
  DynamicWidget,
  useDynamicContext,
  useTelegramLogin,
} from "@dynamic-labs/sdk-react-core";
import { EthereumWalletConnectors } from "@dynamic-labs/ethereum";
import { Providers } from "../../providers/app-providers";
const inter = Inter({ subsets: ["latin"] });
import { cookieToInitialState } from "wagmi";
import { getWagmiConfig } from "@/config/wagmi-config";
import { headers } from "next/headers";

export const metadata: Metadata = {
  title: "Pool Bets",
  description: "A Fun way of Betting",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const initialState = cookieToInitialState(
    getWagmiConfig(),
    headers().get("cookie")
  );
  return (
    <html lang="en">
      <body className={inter.className}>
        <Providers initialState={initialState}>{children}</Providers>
      </body>
    </html>
  );
}
