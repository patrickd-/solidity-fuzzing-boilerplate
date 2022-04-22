// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

address constant HEVM_ADDRESS = 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D;
interface CheatCodes {
    // Performs a foreign function call via terminal.
    function ffi(string[] calldata) external returns (bytes memory);
    // Foundry: Generate new fuzzing inputs if conditional not met.
    function assume(bool) external;
}

// For skipping invalid fuzzing input.
function assuming(bool condition) {
    // Foundry uses assume cheatcode which is not available in Echidna.
    if (block.gaslimit > 0) { // Echidna's gaslimit is 0.
        CheatCodes(HEVM_ADDRESS).assume(condition);
    }
    // For Echidna in assertion testMode use require() instead.
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
