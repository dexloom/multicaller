// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "forge-std/console.sol";
import "forge-std/console.sol";

interface IPancakeV3SwapCallback {
    function pancakeV3SwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata data
    ) external;
}

contract PancakeV3Pool {
    struct Slot0 {
        // the current price
        uint160 sqrtPriceX96;
        // the current tick
        int24 tick;
        // the most-recently updated index of the observations array
        uint16 observationIndex;
        // the current maximum number of observations that are being stored
        uint16 observationCardinality;
        // the next maximum number of observations to store, triggered in observations.write
        uint16 observationCardinalityNext;
        // the current protocol fee as a percentage of the swap fee taken on withdrawal
        // represented as an integer denominator (1/x)%
        uint8 feeProtocol;
        // whether the pool is locked
        bool unlocked;
    }

    Slot0 public slot0;
    uint128 public liquidity;

    function swap(
        address recipient,
        bool zeroForOne,
        int256 amountSpecified,
        uint160 sqrtPriceLimitX96,
        bytes calldata data
    ) public {
        int256 amount0;
        int256 amount1;
        if (zeroForOne) {
            amount0 = int256(amountSpecified);
            amount1 = -amount0 >> 1;
        } else {
            amount1 = int256(amountSpecified);
            amount0 = -amount1 >> 1;
        }
        IPancakeV3SwapCallback(msg.sender).pancakeV3SwapCallback(
            amount0,
            amount1,
            data
        );
    }
}
