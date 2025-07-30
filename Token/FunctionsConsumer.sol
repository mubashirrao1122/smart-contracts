// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Deployed on Sepolia

import {FunctionsClient} from "@chainlink/contracts@1.3.0/src/v0.8/functions/v1_0_0/FunctionsClient.sol";
import {FunctionsRequest} from "@chainlink/contracts@1.3.0/src/v0.8/functions/v1_0_0/libraries/FunctionsRequest.sol";

contract FunctionsConsumer is FunctionsClient {
    using FunctionsRequest for FunctionsRequest.Request;

    string public s_lastCity;   
    string public s_requestedCity;
    string public s_lastTemperature;

    bytes32 public s_lastRequestId;
    bytes public s_lastResponse;
    bytes public s_lastError;

    // Hardcoded for Sepolia
    address constant ROUTER = 0xb83E47C2bC239B3bf370bc41e1459A34b41238D0;
    bytes32 constant DON_ID =
        0x66756e2d657468657265756d2d7365706f6c69612d3100000000000000000000;
    //Callback gas limit
    uint32 constant GAS_LIMIT = 300000;
    string public  constant SOURCE =
        "const city = args[0];"
        "const apiResponse = await Functions.makeHttpRequest({"
        "url: `https://wttr.in/${city}?format=3&m`,"
        "responseType: 'text'"
        "});"
        "if (apiResponse.error) {"
        "throw Error('Request failed');"
        "}"
        "const { data } = apiResponse;"
        "return Functions.encodeString(data);";

    event Response(
        bytes32 indexed requestId,
        string temperature,
        bytes response,
        bytes err
    );
    
    error UnexpectedRequestID(bytes32 requestId);

    constructor() FunctionsClient(ROUTER) {}

    function getTemperature(
        string memory city,
        uint64 subscriptionId
    ) external returns (bytes32 requestId) {
        FunctionsRequest.Request memory req;
        req.initializeRequestForInlineJavaScript(SOURCE); // Initialize the request with JS code

        string[] memory args = new string[](1);
        args[0] = city;
        req.setArgs(args); // Set the arguments for the request
        s_lastRequestId = _sendRequest(
            req.encodeCBOR(),
            subscriptionId,
            GAS_LIMIT,
            DON_ID
        );
        s_requestedCity = city;
        return s_lastRequestId;
    }

    function fulfillRequest(
        bytes32 requestId,
        bytes memory response,
        bytes memory err
    ) internal override {
        if (s_lastRequestId != requestId) {
            revert UnexpectedRequestID(requestId); // Check if request IDs match
        }

        s_lastError = err;
        s_lastResponse = response;

        s_lastTemperature = string(response);
        s_lastCity = s_requestedCity;

        emit Response(requestId, s_lastTemperature, s_lastResponse, s_lastError);
    }
}
