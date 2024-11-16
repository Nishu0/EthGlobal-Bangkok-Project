// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {FtsoV2FeedConsumer} from "src/FtsoV2Example.sol";
import {Script, console} from "forge-std/Script.sol";

contract DeployFtsoV2 is Script {
    FtsoV2FeedConsumer public feedConsumer;

    function setUp() public {
        feedConsumer = new FtsoV2FeedConsumer();
        console.log("FtsoV2FeedConsumer deployed at:", address(feedConsumer));
    }
}