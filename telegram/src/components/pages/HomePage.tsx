"use client";

import Image from "next/image";
import { Icons } from "../icons";
import { DynamicWidget, useDynamicContext } from "@dynamic-labs/sdk-react-core";
import { useEffect, useState } from "react";
import Spinner from "../Spinner";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";

const HomePage = () => {
  const { sdkHasLoaded, user, primaryWallet } = useDynamicContext();
  const [isLoading, setIsLoading] = useState<boolean>(true);
  const queryClient = useQueryClient();

  // Create user mutation
  const createUserMutation = useMutation({
    mutationFn: async (address: string) => {
      const response = await fetch(
        "http://localhost:8000/api/users/connect-wallet",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            address,
          }),
        }
      );

      if (!response.ok) {
        throw new Error("Failed to create user");
      }

      return response.json();
    },
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: ["user"] });
      toast.success("Wallet connected successfully!");
      console.log("User created/connected:", data);
    },
    onError: (error) => {
      console.error("Error creating user:", error);
      toast.error("Failed to connect wallet. Please try again.");
    },
  });

  useEffect(() => {
    if (!sdkHasLoaded) return;

    const signIn = async () => {
      setIsLoading(false);
    };

    signIn();
  }, [sdkHasLoaded]);

  // Effect to create user when wallet is connected
  useEffect(() => {
    if (user && primaryWallet?.address && !createUserMutation.isPending) {
      createUserMutation.mutate(primaryWallet.address);
    }
  }, [user, primaryWallet?.address]);

  return (
    <div
      className={`home-tab-con transition-all duration-300 flex flex-col items-center justify-center w-full bg-black text-white font-[SF Pro] gap-2`}
    >
      {/* Main heading */}
      <h1 className="font-semibold text-center gap-2 font-[SF Pro] text-3xl font-bold">
        Welcome to Pool Bets!
        <br />
        Where You Bet,
      </h1>

      {/* Image above the main heading */}
      <Image
        src="up_header.svg"
        alt="Header Image"
        width={160}
        height={100}
        className="m-4"
      />

      {/* Gradient middle text */}
      <h2 className="text-5xl font-bold text-center mb-2 bg-gradient-to-r from-blue-400 via-blue-500 to-purple-500 text-transparent bg-clip-text">
        Thrill, Fun, Challenge
      </h2>

      {/* Image below the main heading */}
      <Image
        src="down_header.svg"
        alt="Header Image"
        width={200}
        height={150}
        className="m-4"
      />

      {/* Wallet connection button */}
      <button className="shine-effect px-6 py-3 bg-[#ffffff0d] border-[1px] border-[#2d2d2e] rounded-lg flex items-center justify-between gap-3 font-medium">
        <div className="flex items-center">
          {isLoading || createUserMutation.isPending ? (
            <Spinner />
          ) : (
            <DynamicWidget />
          )}
        </div>
        <Icons.ArrowBigRight className="w-6 h-6 text-gray-400" />
      </button>

      <p className="text-lg text-center mb-8">
        All that for Free and with a <br />
        Big Bonus for You!
      </p>
    </div>
  );
};

export default HomePage;
