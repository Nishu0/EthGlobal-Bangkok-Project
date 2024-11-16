// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import '../../../interfaces/types/ISolanaApi.sol';
import '../../interfaces/verification/ISolanaApiVerification.sol';

/**
 * Contract for verifying Solana transaction attestations.
 */
contract SolanaApiVerification is ISolanaApiVerification {

    /**
     * @inheritdoc ISolanaApiVerification
     */
    function verifySolanaTransaction(
        ISolanaApi.Proof calldata _proof
    ) external pure returns (bool _proved) {
        return _proof.data.attestationType == bytes32("SolanaApi");
    }
}
