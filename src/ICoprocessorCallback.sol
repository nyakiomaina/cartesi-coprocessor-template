pragma solidity ^0.8.0;

interface ICoprocessorCallback {
    function coprocessorCallbackOutputsOnly(
        bytes32 machineHash,
        bytes32 payloadHash,
        bytes[] calldata outputs
    ) external;
}
