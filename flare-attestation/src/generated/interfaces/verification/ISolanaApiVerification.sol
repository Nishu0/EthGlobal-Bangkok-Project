// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "../../../interfaces/types/ISolanaApi.sol";

/**
 * Interface for Solana transaction verification.
 */
interface ISolanaApiVerification {
    function verifySolanaTransaction(
        ISolanaApi.Proof calldata _proof
    ) external view returns (bool _proved);
}
