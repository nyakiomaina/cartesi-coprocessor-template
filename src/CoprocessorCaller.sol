// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ICoprocessor.sol";
import "./ICoprocessorCallback.sol";

contract CoprocessorCaller is ICoprocessorCallback {

    ICoprocessor public coprocessor;
    bytes32 public machineHash;
    bytes public lastResult;

    address constant TASK_ISSUER_CONTRACT = 0x32A5C3F0ac48691F58C1D227Ab4B2909f1AC1Fb1;

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
