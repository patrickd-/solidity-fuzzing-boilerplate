// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

interface BytesUtil {
    function slice(bytes calldata bs, uint start, uint length) external pure returns (bytes memory);
}