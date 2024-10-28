// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "forge-std/console.sol";
import "forge-std/console.sol";

interface IShibaswapV2Callee {
    function shibaswapV2Call(
        address sender,
        uint amount0,
        uint amount1,
        bytes calldata data
    ) external;
}

contract ShibaswapV2Pair {
    uint112 private reserve0; // uses single storage slot, accessible via getReserves
    uint112 private reserve1; // uses single storage slot, accessible via getReserves
    uint32 private blockTimestampLast; // uses single storage slot, accessible via getReserves

    function getReserves()
        public
        view
        returns (
            uint112 _reserve0,
            uint112 _reserve1,
            uint32 _blockTimestampLast
        )
    {
        _reserve0 = 0x100000;
        _reserve1 = 0x200000;
        _blockTimestampLast = uint32(444455555);
    }

    function swap(
        uint amount0Out,
        uint amount1Out,
        address to,
        bytes calldata data
    ) public {
        IShibaswapV2Callee(to).shibaswapV2Call(
            msg.sender,
            amount0Out,
            amount1Out,
            data
        );
    }
}
