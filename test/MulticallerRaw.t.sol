// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/ERC20.sol";
import "../src/interfaces/dydx/ISoloMargin.sol";
import "./Interface.sol";
import "./Helper.sol";


contract MulticallerSwapStepCurveTest is Test {
    MultiCaller public multicaller;
    ERC20 public weth;
    ERC20 public erc20Mock;
    ERC20 public erc20Mock2;


   function setUp() public {
        erc20Mock = new ERC20();
        erc20Mock2 = new ERC20();

        multicaller = MultiCaller(HuffDeployer.deploy("Multicaller"));
        
        console.log("Multicaller:", address(multicaller));
        vm.deal(address(multicaller), 0.3 ether);

        weth = ERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        vm.prank(0x741AA7CFB2c7bF2A1E7D4dA2e3Df6a56cA4131F3);
        weth.transfer(address(multicaller), 10.0 ether);
        vm.startPrank(Operator, Operator);
    }

    function test_single() public {
    }


}