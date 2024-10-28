// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "forge-std/console.sol";
import "forge-std/console.sol";

contract ERC20 {
    function balanceOf(address owner) public view returns (uint) {
        console.log("balanceOf", owner);
        return 0x1234;
    }

    function transfer(address to, uint value) public payable {
        console.log("transfer", to, value);
    }

    function withdraw(uint value) public payable {
        console.log("withdraw", value);
    }

    function revertfx() public {
        require(msg.sender == address(0), "RVC");
    }
}
