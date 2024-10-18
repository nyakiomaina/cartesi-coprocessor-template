pragma solidity ^0.8.0;

interface ICoprocessor {
    event TaskIssued(bytes32 machineHash, bytes input, address callback);

    function issueTask(
        bytes32 machineHash,
        bytes calldata input,
        address callback
    ) external;
}
