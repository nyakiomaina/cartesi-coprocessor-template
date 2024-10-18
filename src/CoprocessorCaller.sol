// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ICoprocessor.sol";

contract CoprocessorCaller {
    ICoprocessor public coprocessor;
    bytes32 public machineHash;

    bytes public lastResult;

    address public coprocessorAddress;

    constructor(address _coprocessorAddress, bytes32 _machineHash) {
        coprocessor = ICoprocessor(_coprocessorAddress);
        coprocessorAddress = _coprocessorAddress;
        machineHash = _machineHash;
    }

    function callCoprocessor(bytes calldata input) external {
        coprocessor.issueTask(machineHash, input, address(this));
    }

    function onResult(bytes calldata output) external {
        require(msg.sender == coprocessorAddress, "Unauthorized caller");

        lastResult = output;

        emit ResultReceived(output);
    }

    event ResultReceived(bytes output);
}
