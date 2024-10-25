// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ICoprocessor.sol";
import "./ICoprocessorCallback.sol";

contract CoprocessorCaller is ICoprocessorCallback {

    ICoprocessor public coprocessor;
    bytes32 public machineHash;
    bytes public lastResult;

    mapping(bytes32 => bool) public computationSent;

    constructor(address _coprocessorAddress, bytes32 _machineHash) {
        coprocessor = ICoprocessor(_coprocessorAddress);
        machineHash = _machineHash;
    }

    function callCoprocessor(bytes calldata input) external {
        bytes32 inputHash = keccak256(input);

        computationSent[inputHash] = true;

        coprocessor.issueTask(machineHash, input, address(this));
    }

    function coprocessorCallbackOutputsOnly(
        bytes32 _machineHash,
        bytes32 _payloadHash,
        bytes[] calldata outputs
    ) external override {
        require(msg.sender == address(coprocessor), "Unauthorized caller");

        require(_machineHash == machineHash, "Machine hash mismatch");

        require(computationSent[_payloadHash] == true, "Computation not found");

        bytes memory concatenatedOutputs;
        for (uint256 i = 0; i < outputs.length; i++) {
            concatenatedOutputs = abi.encodePacked(concatenatedOutputs, outputs[i]);
        }
        lastResult = concatenatedOutputs;

        emit ResultReceived(concatenatedOutputs);

        // clean up the mapping
        delete computationSent[_payloadHash];
    }

    event ResultReceived(bytes output);

}
