// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {ContractRegistry} from "@flarenetwork/flare-periphery-contracts/coston2/ContractRegistry.sol";
/* THIS IS A TEST IMPORT, in production use: import {FtsoV2Interface} from "@flarenetwork/flare-periphery-contracts/coston2/FtsoV2Interface.sol"; */
import {TestFtsoV2Interface} from "@flarenetwork/flare-periphery-contracts/coston2/TestFtsoV2Interface.sol";

/**
 * THIS IS AN EXAMPLE CONTRACT.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */
contract FtsoV2FeedConsumer {
    TestFtsoV2Interface internal ftsoV2;
    // Feed IDs, see https://dev.flare.network/ftso/feeds for full list
    bytes21[] public feedIds = [
    bytes21(0x014254432f55534400000000000000000000000000), // BTC/USD
    bytes21(0x01555344542f555344000000000000000000000000), // USDT/USD
    bytes21(0x014554482f55534400000000000000000000000000), // ETH/USD
    bytes21(0x01534f4c2f55534400000000000000000000000000) //SOL/USD
    ];

    /**
     * Constructor initializes the FTSOv2 contract.
     * The contract registry is used to fetch the FtsoV2 contract address.
     */
    constructor() {
        ftsoV2 = ContractRegistry.getTestFtsoV2();
    }

    /**
     * Get the current value of the feeds.
     */
    function getFtsoV2CurrentFeedValues()
    external
    view
    returns (
        uint256[] memory _feedValues,
        int8[] memory _decimals,
        uint64 _timestamp
    )
    {
        return ftsoV2.getFeedsById(feedIds);
    }

    /**
     * Get the value of a specific feed by name (e.g., "BTC", "ETH").
     */
    function getFeedValueByName(string memory feedName)
    external
    view
    returns (
        uint256 feedValue,
        int8 decimals,
        uint64 timestamp
    )
    {
        (uint256[] memory feedValues, int8[] memory decimalsArray, uint64 fetchedTimestamp) = ftsoV2.getFeedsById(feedIds);

        if (keccak256(abi.encodePacked(feedName)) == keccak256(abi.encodePacked("BTC"))) {
            return (feedValues[0], decimalsArray[0], fetchedTimestamp);
        } else if (keccak256(abi.encodePacked(feedName)) == keccak256(abi.encodePacked("USDT"))) {
            return (feedValues[1], decimalsArray[1], fetchedTimestamp);
        } else if (keccak256(abi.encodePacked(feedName)) == keccak256(abi.encodePacked("ETH"))) {
            return (feedValues[2], decimalsArray[2], fetchedTimestamp);
        } else if (keccak256(abi.encodePacked(feedName)) == keccak256(abi.encodePacked("SOL"))) {
            return (feedValues[3], decimalsArray[3], fetchedTimestamp);
        } else {
            revert("Invalid feed name");
        }
    }

    /**
     * Get the value of a specific feed by feed ID.
     */
    function getFeedValueById(bytes21 feedId)
    external
    view
    returns (
        uint256 feedValue,
        int8 decimals,
        uint64 timestamp
    )
    {
        (uint256[] memory feedValues, int8[] memory decimalsArray, uint64 fetchedTimestamp) = ftsoV2.getFeedsById(feedIds);

        if (feedId == feedIds[0]) {
            return (feedValues[0], decimalsArray[0], fetchedTimestamp);
        } else if (feedId == feedIds[1]) {
            return (feedValues[1], decimalsArray[1], fetchedTimestamp);
        } else if (feedId == feedIds[2]) {
            return (feedValues[2], decimalsArray[2], fetchedTimestamp);
        } else if (feedId == feedIds[3]) {
            return (feedValues[3], decimalsArray[3], fetchedTimestamp);
        } else {
            revert("Invalid feed ID");
        }
    }
}
