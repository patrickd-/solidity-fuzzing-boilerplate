// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "../helpers.sol";

// Using via exposer to make external calls.
import { ExposedBytesLib } from "../../expose/example/BytesLib.sol";

// Using via interface due to incompatible solidity version.
import { ExposedBytesUtil } from "../addresses.sol";
import { BytesUtil } from "../../interface/example/BytesUtil.sol";

contract Test {
    ExposedBytesLib immutable bytesLib;
    BytesUtil immutable bytesUtil;
    constructor() {
        bytesLib = new ExposedBytesLib();
        bytesUtil = BytesUtil(ExposedBytesUtil);
    }

    function test_BytesLib_BytesUtil_diff_slice(bytes calldata input, uint256 start, uint256 length) external {
        // Using calls to ensure reverts from either lib won't make forge fuzzing consider this a failed test.
        (bool successA, bytes memory outputA) = address(bytesLib).call(abi.encodeWithSelector(bytesLib.slice.selector, input, start, length));
        (bool successB, bytes memory outputB) = address(bytesUtil).call(abi.encodeWithSelector(bytesUtil.slice.selector, input, start, length));

        // Both should either error or succeed.
        assert(successA == successB);
        // Only compare outputs if both calls succeeded (since it's unlikely for error data to match).
        assert((!successA && !successB) || keccak256(outputA) == keccak256(outputB));
    }
}
