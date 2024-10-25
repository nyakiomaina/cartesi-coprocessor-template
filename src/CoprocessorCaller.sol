// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ICoprocessor.sol";
import "./ICoprocessorCallback.sol";

contract CoprocessorCaller is ICoprocessorCallback {

    ICoprocessor public coprocessor;
    bytes32 public machineHash;
    bytes public lastResult;

    address constant TASK_ISSUER_CONTRACT = 0xB819BA4c5d2b64d07575ff4B30d3e0Eca219BFd5;

    constructor(address _coprocessorAddress, bytes32 _machineHash) {
        coprocessor = ICoprocessor(_coprocessorAddress);
        machineHash = _machineHash;
    }

    function callCoprocessor(bytes calldata input) external {
        coprocessor.issueTask(machineHash, input, address(this));
    }

    function coprocessorCallbackOutputsOnly(
        bytes32 _machineHash,
        bytes32 _payloadHash,
        bytes[] calldata outputs
    ) external override {
        require(msg.sender == TASK_ISSUER_CONTRACT, "Unauthorized caller");

        bytes memory concatenatedOutputs;
        for (uint256 i = 0; i < outputs.length; i++) {
            concatenatedOutputs = abi.encodePacked(concatenatedOutputs, outputs[i]);
        }
        lastResult = concatenatedOutputs;

        emit ResultReceived(concatenatedOutputs);
    }

    event ResultReceived(bytes output);

}
