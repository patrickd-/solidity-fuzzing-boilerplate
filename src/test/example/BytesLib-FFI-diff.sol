// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "../helpers.sol";

import { BytesLib } from "../../implementation/example/BytesLib.sol";

contract Test {

    function test_BytesLib_FFI_diff_slice(bytes calldata input, uint32 start, uint32 length) external {
        // Skip invalid fuzzer inputs.
        unchecked {
            assuming(length + 31 >= length);
            assuming(start + length >= start);
        }
        assuming(input.length >= start + length);

        bytes memory outputA = BytesLib.slice(input, start, length);

        // Calling NodeJS script via HEVM FFI cheatcode.
        string[] memory inputs = new string[](5);
        inputs[0] = "node";
        inputs[1] = "./src/expose/example/ffi-slice.js";
        // Since input is passed via args, not stdin, we have to hex encode for special chars.
        inputs[2] = string(toHex(input));
        inputs[3] = string(toHex(abi.encodePacked(start)));
        inputs[4] = string(toHex(abi.encodePacked(length)));
        (bytes memory outputB) = abi.decode(exec(inputs), (bytes));

        assert(keccak256(outputA) == keccak256(outputB));
    }

}
