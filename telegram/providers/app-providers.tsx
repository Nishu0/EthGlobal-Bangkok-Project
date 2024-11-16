"use client";

import { type ReactNode, useState } from "react";
import { AppQueryClientProvider } from "./react-query-provider";

type Props = {
  children: ReactNode;
};

export function Providers({ children }: Props) {
  return <AppQueryClientProvider>{children}</AppQueryClientProvider>;
}
