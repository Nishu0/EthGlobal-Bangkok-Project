// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IJsonApiVerification, IJsonApi} from "./generated/interfaces/verification/IJsonApiVerification.sol";
import {JsonApiVerification} from "./generated/implementation/verification/JsonApiVerification.sol";
import {Weather} from "./Weather.sol";

contract JsonApiExample {
    Weather[] public weathers;
    IJsonApiVerification public jsonApiAttestationVerification;

    constructor() {
        jsonApiAttestationVerification = new JsonApiVerification();
    }

    function addWeather(IJsonApi.Response calldata jsonResponse) public {
        // We mock the proof for testing and hackathon
        IJsonApi.Proof memory proof = IJsonApi.Proof({
            merkleProof: new bytes32[](0),
            data: jsonResponse
        });
        require(
            jsonApiAttestationVerification.verifyJsonApi(proof),
            "Invalid proof"
        );

        Weather memory _weather = abi.decode(
            jsonResponse.responseBody.abi_encoded_data, (Weather)
        );

        weathers.push(_weather);
    }
}
