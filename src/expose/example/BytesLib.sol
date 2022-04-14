// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import { BytesLib } from "../../implementation/example/BytesLib.sol";

contract ExposedBytesLib {

    function slice(bytes calldata _bytes, uint256 _start, uint256 _length) external pure returns (bytes memory) {
        return BytesLib.slice(_bytes, _start, _length);
    }

}