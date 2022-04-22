// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

address constant HEVM_ADDRESS = 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D;
interface CheatCodes {
    // Performs a foreign function call via terminal.
    function ffi(string[] calldata) external returns (bytes memory);
    // Foundry: Generate new fuzzing inputs if conditional not met.
    function assume(bool) external;
}

/**
 * Skip invalid fuzzing inputs.
 *
 * Both Foundry and Echidna (in dapptest mode) will take revert/assert errors
 * as test failure. This helper function is for skipping invalid inputs that
 * shouldn't be misunderstood as a fuzzer-finding.
 */
function assuming(bool condition) {
    // Foundry has a special cheatcode for this:
    if (block.gaslimit > 0) {
        // This call will cause Echidna to get stuck, so this "gaslimit" check
        // ensures it's only executed when doing fuzzing within foundry.
        // NOTE: The gaslimit in Echidna will only be 0 if there's an init file!
        CheatCodes(HEVM_ADDRESS).assume(condition);
    }
    // For Echidna in dapptest mode: Use a specific revert reason for skipping.
    require(condition, "FOUNDRY::ASSUME");
}

function exec(string[] memory args) returns (bytes memory) {
    return CheatCodes(HEVM_ADDRESS).ffi(args);
}

function toHex(bytes memory data) pure returns (bytes memory res) {
    res = new bytes(data.length * 2);
    bytes memory alphabet = "0123456789abcdef";
    for (uint i = 0; i < data.length; i++) {
        res[i*2 + 0] = alphabet[uint256(uint8(data[i])) >> 4];
        res[i*2 + 1] = alphabet[uint256(uint8(data[i])) & 15];
    }
}
