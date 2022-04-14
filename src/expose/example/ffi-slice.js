#!/usr/bin/env node
const { AbiCoder } = require("@ethersproject/abi");

abiCoder = new AbiCoder();

// Input is passed hex-encoded since it likely contains special chars and HEVM isn't using stdin.
const bytes = Buffer.from(process.argv[2], 'hex');
const start = Buffer.from(process.argv[3], 'hex').readInt32BE();
const length = Buffer.from(process.argv[4], 'hex').readInt32BE();

const result = bytes.subarray(start, start + length);

// Output is returned via stdout. It needs to be ABI and then hex encoded and will be decoded by HEVM.
const abiEncoded = abiCoder.encode(['bytes'], [result]);
process.stdout.write(abiEncoded);
