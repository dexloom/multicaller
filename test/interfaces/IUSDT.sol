//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.2;

interface IUSDT {
    event Transfer(address indexed from, address indexed to, uint value);

    function totalSupply() external returns (uint);
    function balanceOf(address who) external returns (uint);
    // USDT has a none standard transfer function that does not return bool
    function transfer(address to, uint value) external;
}
