// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

import "./Interface.sol";
import "./Helper.sol";
import "../src/ERC20.sol";

contract MulticallerPayoutTest is Test, Helper {
    MultiCaller public multicaller;
    ERC20 public erc20Mock;
    ERC20 public erc20Mock2;
    address constant WETHAddress =
        address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    /// @dev Setup the testing environment.
    function setUp() public {
        erc20Mock = new ERC20();
        erc20Mock2 = new ERC20();
        console.log(address(erc20Mock));
        console.log(address(erc20Mock2));
        multicaller = MultiCaller(HuffDeployer.deploy("Multicaller"));
        console.log(address(multicaller));
        vm.deal(address(multicaller), 1000000);

        ERC20 weth = ERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        vm.prank(
            0x741AA7CFB2c7bF2A1E7D4dA2e3Df6a56cA4131F3,
            0x741AA7CFB2c7bF2A1E7D4dA2e3Df6a56cA4131F3
        );
        weth.transfer(address(multicaller), 1000000);
        vm.coinbase(address(0x333777));
    }

    function testCallTransferTipsMinBalanceCallArray_Transfer() public {
        console.log("testCallTransferTipsMinBalanceCallArray");
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
            "transferTipsMinBalance(address,uint256,uint256,address)",
            address(erc20Mock2),
            10,
            5,
            address(0x8888)
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock2),
                callData,
                Helper.STATIC_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(0x1111),
                callData3,
                Helper.INTERNAL_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData2,
                Helper.ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        multicaller.doCalls(callDataArray);
        //assertEq(counter.number(), 22);
    }

    function testCallTransferTipsMinBalanceCallArray_NoTip() public {
        console.log("testCallTransferTipsMinBalanceCallArray");
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
            "transferTipsMinBalance(address,uint256,uint256,address)",
            address(erc20Mock2),
            0,
            0,
            address(0x8888)
        );
        bytes memory callDataArray = abi.encodePacked(
            Helper.mergeData(
                address(erc20Mock2),
                callData2,
                Helper.ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            Helper.mergeData(
                address(0x1111),
                callData3,
                Helper.INTERNAL_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            Helper.mergeData(
                address(erc20Mock),
                callData,
                Helper.ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        multicaller.doCalls(callDataArray);
        //assertEq(counter.number(), 22);
    }

    function testCallTransferTipsMinBalanceCallArrayRevert() public {
        console.log("testCallTransferTipsMinBalanceCallArray");
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
            "transferTipsMinBalance(address,uint256,uint256,address)",
            address(erc20Mock2),
            10000000,
            5,
            address(0x8888)
        );
        bytes memory callDataArray = abi.encodePacked(
            Helper.mergeData(
                address(erc20Mock2),
                callData2,
                Helper.ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            Helper.mergeData(
                address(0x1111),
                callData3,
                Helper.INTERNAL_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            Helper.mergeData(
                address(erc20Mock),
                callData,
                Helper.STATIC_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );
        bytes memory revertMsg = bytes("BB");

        vm.expectRevert(revertMsg);

        multicaller.doCalls(callDataArray);
        //assertEq(counter.number(), 22);
    }

    function testCallTransferTipsMinBalanceWethCallArray_Transfer() public {
        //console.log("testCallTransferTipsMinBalanceWethCallArray");
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
            100,
            5,
            address(0x7777)
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData,
                Helper.STATIC_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(0x1111),
                callData3,
                Helper.INTERNAL_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock2),
                callData2,
                Helper.ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        multicaller.doCalls(callDataArray);
        //assertEq(counter.number(), 22);
    }

    function testCallTransferTipsMinBalanceWethCallArray_NoTips() public {
        //console.log("testCallTransferTipsMinBalanceWethCallArray");
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
            0,
            0,
            address(0x7777)
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock2),
                callData2,
                Helper.ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(0x1111),
                callData3,
                Helper.INTERNAL_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData,
                Helper.STATIC_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        multicaller.doCalls(callDataArray);
        //assertEq(counter.number(), 22);
    }

    function testCallTransferTipsMinBalanceWethCallArray_Revert() public {
        //console.log("testCallTransferTipsMinBalanceWethCallArray");
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
                Helper.ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(0x1111),
                callData3,
                Helper.INTERNAL_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData,
                Helper.STATIC_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );
        bytes memory revertMsg = bytes("BB");

        vm.expectRevert(revertMsg);
        multicaller.doCalls(callDataArray);
        //assertEq(counter.number(), 22);
    }

    function testCallTransferTipsMinBalanceNoPayoutCallArray_Transfer() public {
        console.log("testCallTransferTipsMinBalanceNoPayoutCallArray");
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
            "transferTipsMinBalanceNoPayout(address,uint256,uint256)",
            WETHAddress,
            1000,
            5
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock2),
                callData2,
                Helper.ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(0x1111),
                callData3,
                Helper.INTERNAL_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData,
                Helper.STATIC_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );
        uint256 coinbaseBalance = address(block.coinbase).balance;
        multicaller.doCalls(callDataArray);
        assertEq(address(block.coinbase).balance, coinbaseBalance + 5);
    }

    function testCallTransferTipsMinBalanceNoPayoutCallArray_Revert() public {
        console.log("testCallTransferTipsMinBalanceNoPayoutCallArray");
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
            "transferTipsMinBalanceNoPayout(address,uint256,uint256)",
            WETHAddress,
            1000000000,
            5
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock2),
                callData2,
                Helper.ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(0x1111),
                callData3,
                Helper.INTERNAL_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData,
                Helper.STATIC_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );
        bytes memory revertMsg = bytes("BB");

        vm.expectRevert(revertMsg);

        multicaller.doCalls(callDataArray);
        //assertEq(counter.number(), 22);
    }
}
