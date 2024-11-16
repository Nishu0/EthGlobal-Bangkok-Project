// import { http } from "viem";
// import { cookieStorage, createConfig, createStorage } from "wagmi";
// import { getCurrentNetworks } from "./chain";

// export const getWagmiConfig = () => {
//   const chains = getCurrentNetworks();
//   return createConfig({
//     chains: [...chains],
//     transports: Object.fromEntries(chains.map((chain) => [chain.id, http()])),
//     ssr: true,
//     storage: createStorage({
//       storage: cookieStorage,
//     }),
//   });
// };
