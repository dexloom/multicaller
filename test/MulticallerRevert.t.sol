// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

import "./Interface.sol";
import "./Helper.sol";
import "../src/ERC20.sol";

contract MulticallerRevertTest is Test, Helper, TestHelper {
    function testCallRevert() public {
        address addr = address(erc20Mock);
        bytes memory callData = abi.encodeWithSignature("revertfx()");
        bytes memory revertMsg = "RVC";
        vm.expectRevert(revertMsg);
        multicaller.doCalls(
            mergeData(
                address(erc20Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFF,
                0xFFFFF
            )
        );
    }
    function testStaticCallRevert() public {
        address addr = address(erc20Mock);
        bytes memory callData = abi.encodeWithSignature("revertfx()");
        bytes memory revertMsg = "RVC";
        vm.expectRevert(revertMsg);
        multicaller.doCalls(
            mergeData(
                address(erc20Mock),
                callData,
                STATIC_CALL_SELECTOR,
                0xFFFFF,
                0xFFFFF
            )
        );
    }
    function testDelegateCallRevert() public {
        address addr = address(erc20Mock);
        bytes memory callData = abi.encodeWithSignature("revertfx()");
        bytes memory revertMsg = "RVC";
        vm.expectRevert(revertMsg);
        multicaller.doCalls(
            mergeData(
                address(erc20Mock),
                callData,
                DELEGATE_CALL_SELECTOR,
                0xFFFFF,
                0xFFFFF
            )
        );
    }

    function testCallErcInside20CallArray_Revert() public {
        console.log("testCallERC20Array");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callData = abi.encodeWithSignature(
            "balanceOf(address)",
            addr
        );
        bytes memory callData2 = abi.encodeWithSignature("revertfx()");
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFF,
                0xFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData2,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFF,
                0xFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFF,
                0xFFFFF
            )
        );

        bytes memory callDoCallsData = abi.encodeWithSignature(
            "doCalls(bytes)",
            callDataArray
        );

        vm.expectRevert();

        multicaller.doCalls(
            abi.encodePacked(
                mergeData(
                    address(multicaller),
                    callDoCallsData,
                    ZERO_VALUE_CALL_SELECTOR,
                    0xFFFFF,
                    0xFFFFF
                )
            )
        );
    }

    function testCallTransferTipsMinBalanceWethCallArray_Revert() public {
        console.log("testCallTransferTipsMinBalanceWethCallArray");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callData = abi.encodeWithSignature(
            "balanceOf(address)",
            addr
        );
        bytes memory callData2 = abi.encodeWithSignature(
            "transfer(address,uint256)",
            addr2,
            100
        );
        bytes memory callData3 = abi.encodeWithSignature(
            "transferTipsMinBalanceWETH(uint256,uint256,address)",
            1000000000000,
            5,
            address(0x7777)
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock2),
                callData2,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFF,
                0xFFFFF
            ),
            mergeData(
                address(0x1111),
                callData3,
                INTERNAL_CALL_SELECTOR,
                0xFFFFF,
                0xFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFF,
                0xFFFFF
            )
        );
        vm.expectRevert();

        multicaller.doCalls(callDataArray);
    }
}
