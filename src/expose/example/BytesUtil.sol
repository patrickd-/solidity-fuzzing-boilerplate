// SPDX-License-Identifier: MIT
pragma solidity ^0.4.24;

import { BytesUtil } from "../../implementation/example/BytesUtil.sol";

contract ExposedBytesUtil {

    function slice(bytes bs, uint start, uint length) external pure returns (bytes) {
        return BytesUtil.slice(bs, start, length);
    }

}