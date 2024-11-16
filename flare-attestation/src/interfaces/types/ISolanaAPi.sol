// SPDX-License-Identifier: MIT
pragma solidity >=0.7.6 <0.9;

/**
 * @custom:name ISolanaApi
 * @custom:supported Solana Blockchain
 * @notice Defines the request and response structure for Solana transaction attestations.
 * @custom:verification Data is fetched from Solana, validated through attestation providers,
 * and returned in an ABI-encoded format for on-chain usage.
 */
interface ISolanaApi {
    /**
     * @notice Toplevel request
     * @param attestationType ID of the attestation type.
     * @param sourceId ID of the data source.
     * @param messageIntegrityCode `MessageIntegrityCode` derived from the expected response.
     * @param requestBody Data defining the request, specific to Solana transactions.
     */
    struct Request {
        bytes32 attestationType;
        bytes32 sourceId;
        bytes32 messageIntegrityCode;
        RequestBody requestBody;
    }

    /**
     * @notice Toplevel response
     * @param attestationType Extracted from the request.
     * @param sourceId Extracted from the request.
     * @param votingRound The ID of the State Connector round in which the request was considered.
     * @param lowestUsedTimestamp The lowest timestamp used to generate the response.
     * @param requestBody Extracted from the request.
     * @param responseBody Data defining the response, specific to Solana transactions.
     */
    struct Response {
        bytes32 attestationType;
        bytes32 sourceId;
        uint64 votingRound;
        uint64 lowestUsedTimestamp;
        RequestBody requestBody;
        ResponseBody responseBody;
    }

    /**
     * @notice Toplevel proof
     * @param merkleProof Merkle proof corresponding to the attestation response.
     * @param data Attestation response.
     */
    struct Proof {
        bytes32[] merkleProof;
        Response data;
    }

    /**
     * @notice Request body for Solana transaction attestation
     * @param transactionHash Hash of the Solana transaction.
     * @param commitment Commitment level (e.g., "confirmed", "finalized").
     * @param blockHeight Block height of the transaction.
     */
    struct RequestBody {
        string transactionHash;
        string commitment;
        uint256 blockHeight;
    }

    /**
     * @notice Response body for Solana transaction attestation
     * @param abi_encoded_data ABI encoded transaction data.
     */
    struct ResponseBody {
        bytes abi_encoded_data;
    }
}
