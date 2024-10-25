pragma solidity ^0.8.0;

interface ICoprocessor {
    function issueTask(
        bytes32 machineHash,
        bytes calldata input,
        address callbackAddress
    ) external;
}
