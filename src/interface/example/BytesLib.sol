// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

interface BytesLib {
    function slice(bytes calldata _bytes, uint256 _start, uint256 _length) external pure returns (bytes memory);
}