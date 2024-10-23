// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ICoprocessor.sol";
import { LibMerkle32 } from "../lib/rollups-contracts/contracts/library/LibMerkle32.sol";

contract CoprocessorCaller {
    using LibMerkle32 for bytes32[];

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

    function singleCheck(bytes calldata data) public pure returns (bytes32) {
        bytes32 hash = keccak256(data);
        bytes32[] memory foo;
        foo[0] = hash;
        return LibMerkle32.merkleRoot(foo, 63);
    }
}
