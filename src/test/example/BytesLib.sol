// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "../helpers.sol";

import { BytesLib } from "../../implementation/example/BytesLib.sol";

contract Test {

    function test_BytesLib_slice(bytes calldata input, uint256 start, uint256 length) external {
        // Skip invalid fuzzer inputs.
        unchecked {
            assuming(length + 31 >= length);
            assuming(start + length >= start);
        }
        assuming(input.length >= start + length);

        // We can compare the libraries result with Solidity's calldata slicing.
        bytes memory outputA = input[start : start + length];

        // Surround memory of input with some junk that could be accidentially read/overwritten by lib.
        bytes memory preJunk1 = hex'f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f';
        bytes memory memInput = input;
        bytes memory preJunk2 = hex'f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f';

        bytes memory outputB = BytesLib.slice(memInput, start, length);

        // Fill memory with more junk that could overwrite memory of lib return value (if free mem pointer wasn't updated).
        bytes memory postJunk = hex'f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f';

        // Check last bytes memslot for pollution (was more copied than the slice?)
        bytes32 slotA;
        bytes32 slotB;
        uint256 lastSlotAddress = ((length / 32) * 32) + ((length % 32 == 0) ? 0 : 32); // First bytes slot contains length that we need to skip.
        assembly {
            slotA := mload(add(outputA, lastSlotAddress))
            slotB := mload(add(outputB, lastSlotAddress))
        }
        assert(slotA == slotB);

        // Check whether input passed was modified.
        assert(keccak256(input) == keccak256(memInput));
        // Check whether preJunk was overwritten by lib.
        assert(keccak256(preJunk1) == keccak256(postJunk));
        assert(keccak256(preJunk2) == keccak256(postJunk));
        // Whether library read and used preJunk, or whether postJunk overwrote return value, can be detected by comparison with correct result.
        assert(keccak256(outputA) == keccak256(outputB));
    }

}