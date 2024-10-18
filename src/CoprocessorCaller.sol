// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ICoprocessor.sol";

contract CoprocessorCaller {
    ICoprocessor public immutable coprocessor;
    bytes32 public immutable machineHash;

    bytes public lastResult;

    event ResultReceived(bytes output);

    constructor(address _coprocessorAddress, bytes32 _machineHash) {
        require(_coprocessorAddress != address(0), "Invalid coprocessor address");
        coprocessor = ICoprocessor(_coprocessorAddress);
        machineHash = _machineHash;
    }

    /// @notice Calls the coprocessor to issue a task
    /// @param input The input data for the coprocessor
    function callCoprocessor(bytes calldata input) external {
        coprocessor.issueTask(machineHash, input, address(this));
    }

    /// @notice Callback function for the coprocessor to send back results
    /// @param output The output data from the coprocessor
    function onResult(bytes calldata output) external {
        require(msg.sender == address(coprocessor), "Unauthorized caller");

        lastResult = output;

        emit ResultReceived(output);
    }
}
