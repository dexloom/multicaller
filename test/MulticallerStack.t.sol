// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/ERC20.sol";
import "../src/interfaces/dydx/ISoloMargin.sol";
import "./Interface.sol";
import "./Helper.sol";

contract MulticallerStackTest is Test, Helper {
    MultiCaller public multicaller;
    ERC20 public erc20Mock;
    ERC20 public erc20Mock2;

    /// @dev Setup the testing environment.
    function setUp() public {
        erc20Mock = new ERC20();
        erc20Mock2 = new ERC20();
        console.log(address(erc20Mock));
        console.log(address(erc20Mock2));
        multicaller = MultiCaller(HuffDeployer.deploy("Multicaller"));
        console.log(address(multicaller));
        vm.deal(address(multicaller), 1000000);
    }

    function testBalanceCall() public {
        //console.log("testCallERC20");
        address addr = address(erc20Mock);

        bytes memory callData = abi.encodeWithSignature(
            "balanceOf(address)",
            addr
        );

        multicaller.doCalls(
            mergeData(
                address(erc20Mock),
                callData,
                STATIC_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );
        //assertEq(counter.number(), 22);
    }
    function testBalanceStaticCallReturn() public {
        //console.log("testCallERC20");
        address addr = address(erc20Mock);

        bytes memory callData = abi.encodeWithSignature(
            "balanceOf(address)",
            addr
        );

        uint256 ret = multicaller.doCalls(
            mergeData(
                address(erc20Mock),
                callData,
                STATIC_CALL_SELECTOR,
                0xFFFFFF,
                EncodeReturnStack(1, 0, 0, 0x20)
            )
        );
        assertEq(ret, 4660);
    }
    function testBalanceDelegateCallReturn() public {
        //console.log("testCallERC20");
        address addr = address(erc20Mock);

        bytes memory callData = abi.encodeWithSignature(
            "balanceOf(address)",
            addr
        );

        uint256 ret = multicaller.doCalls(
            mergeData(
                address(erc20Mock),
                callData,
                DELEGATE_CALL_SELECTOR,
                0xFFFFFF,
                EncodeReturnStack(1, 0, 0, 0x20)
            )
        );
        assertEq(ret, 4660);
    }
    function testBalanceCallReturn() public {
        //console.log("testCallERC20");
        address addr = address(erc20Mock);

        bytes memory callData = abi.encodeWithSignature(
            "balanceOf(address)",
            addr
        );

        uint256 ret = multicaller.doCalls(
            mergeData(
                address(erc20Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                EncodeReturnStack(1, 0, 0, 0x20)
            )
        );
        assertEq(ret, 4660);
    }

    function testBalanceStaticCallAndTransfer() public {
        address addr = address(erc20Mock);

        bytes memory callData = abi.encodeWithSignature(
            "balanceOf(address)",
            addr
        );
        bytes memory callData2 = abi.encodeWithSignature(
            "transfer(address,uint256)",
            addr,
            0x0
        );

        bytes memory callDataMerged = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData,
                STATIC_CALL_SELECTOR,
                0xFFFFFF,
                EncodeReturnStack(1, 0, 0, 0x20)
            ),
            mergeData(
                address(erc20Mock),
                callData2,
                ZERO_VALUE_CALL_SELECTOR,
                EncodeStack(1, 0, 0x44, 0x20),
                0xFFFFFF
            )
        );

        uint ret = multicaller.doCalls(callDataMerged);
        assertEq(ret, 4660);
    }
}
