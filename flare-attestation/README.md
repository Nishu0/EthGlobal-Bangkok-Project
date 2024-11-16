# Solana API Verification on Flare

This repository implements a Flare-compatible verification system for Solana transaction attestations. It leverages the Flare Data Connector protocol to validate transaction proofs through decentralized attestation providers. The contracts are optimized for EVM environments, ensuring seamless integration with Flare's state connector and Merkle root verification.

### Overview

The system is designed to enable cross-chain interactions by verifying Solana transaction data within the Flare network. It utilizes Flare's CCCR protocol to process attestations and ensures the validity of transaction data through Merkle proof verification. The implementation includes:

- **SolanaApiVerification**: A verification contract to check if a Solana transaction proof is valid based on attestation type and Merkle root inclusion.
- **ISolanaApiVerification**: Interface for interacting with the verification logic.
- **ISolanaApi**: Defines request, response, and proof structures specific to Solana attestations. The `RequestBody` includes fields like `transactionHash`, `commitment`, and `blockHeight`, while the `ResponseBody` contains ABI-encoded transaction data.

### Workflow

1. **Proof Submission**: A Merkle proof, generated through the Flare Data Connector, is passed to the `verifySolanaTransaction` function.
2. **Verification**: The contract validates the `attestationType` and ensures the proof corresponds to a finalized Merkle root stored by the Data Connector.
3. **Integration**: Verified transaction data can be used within other Flare-based contracts, enabling decentralized and trustless Solana-to-Flare applications.

### Key Features

- Integration with Flare’s Data Connector for decentralized attestation.
- Support for Solana-specific transaction data.
- Efficient Merkle proof verification optimized for gas usage.
- Compatibility with EVM-based development frameworks.
