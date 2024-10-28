// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/interfaces/dydx/ISoloMargin.sol";
import "./Helper.sol";
import "./Interface.sol";

import "../src/ERC20.sol";
import "../src/mocks/Uni2Pool.sol";
import "../src/mocks/Uni3Pool.sol";

contract MulticallerCallbackTest is Test, Helper, TestHelper {
    function testCallErcInsideUni2CallbackArray2() public {
        console.log("testCallErcInsideUni2CallbackArray");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callData = abi.encodeWithSignature(
            "transfer(address,uint256)",
            addr,
            0x1111111111
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                EncodeStack(1, 0, 0x24, 0x20),
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                EncodeStack(1, 0, 0x24, 0x20),
                0xFFFFFF
            )
        );

        bytes memory callDoCallsData = abi.encodeWithSignature(
            "doCalls(bytes)",
            callDataArray
        );

        multicaller.uniswapV2Call(
            addr,
            0x300,
            0x0,
            removeSignature(callDoCallsData)
        );
    }

    function testCallErcInsideUni3CallbackArray() public {
        console.log("testCallErcInsideUni3CallbackArray");
        address addr = address(0x1122334455667788990011223344556677889977);
        address addr2 = address(0x2233445566778899001122334455667788990088);

        bytes memory callData = abi.encodeWithSignature(
            "transfer(address,uint256)",
            addr,
            0x1111111111
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                EncodeStack(1, 1, 0x24, 0x20),
                0xFFFFFF
            )
        );

        bytes memory callDoCallsData = abi.encodeWithSignature(
            "doCalls(bytes)",
            callDataArray
        );

        multicaller.uniswapV3SwapCallback(
            0x200,
            -0x300,
            removeSignature(callDoCallsData)
        );
        //assertEq(amount1, 0x300);
    }

    function testCallErcInsideUni2QuickTransfer() public {
        return; // disable test
        console.log("testCallErcInsideUni2CallbackArray");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callDoCallsRetToken = abi.encodePacked(address(erc20Mock));

        bytes memory callData = abi.encodeWithSignature(
            "swap(uint256,uint256,address,bytes)",
            0x11111,
            0x0,
            address(multicaller),
            callDoCallsRetToken
        );

        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(uni2Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        multicaller.doCalls(callDataArray);
    }

    function testCallErcInsideUni2QuickTransfer2() public {
        return; // disable test
        console.log("testCallErcInsideUni2CallbackArray");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callDoCallsRetToken = abi.encodePacked(address(erc20Mock));

        bytes memory callData = abi.encodeWithSignature(
            "swap(uint256,uint256,address,bytes)",
            0x0,
            0x11111,
            address(multicaller),
            callDoCallsRetToken
        );

        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(uni2Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        multicaller.doCalls(callDataArray);

        //uni2Mock.swap( 0x11111, 0x0, address(multicaller), callDoCallsData);

        //assertEq(counter.number(), 22);
    }

    function testCallErcInsideUni3QuickTransfer() public {
        console.log("testCallErcInsideUni3CallbackArray");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callDoCallsData = abi.encodePacked(address(erc20Mock));

        bytes memory callData = abi.encodeWithSignature(
            "swap(address,bool,int256,uint160,bytes)",
            addr,
            true,
            0x11111,
            0x0,
            callDoCallsData
        );

        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(uni3Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        multicaller.doCalls(callDataArray);

        //uni3Mock.swap( addr, true, 0x11111, 0x0,  callDoCallsData);

        //assertEq(counter.number(), 22);
    }

    function testCallErcInsideUni3CallbackQuickTransfer() public {
        console.log("testCallErcInsideUni3CallbackArray");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callDoCallsData = abi.encodePacked(address(erc20Mock));

        bytes memory callData = abi.encodeWithSignature(
            "swap(address,bool,int256,uint160,bytes)",
            addr,
            true,
            0x11111,
            0x0,
            callDoCallsData
        );

        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(uni3Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        bytes memory callData2 = abi.encodeWithSignature(
            "swap(address,bool,int256,uint160,bytes)",
            addr,
            true,
            0x11111,
            0x0,
            callDoCallsData
        );

        bytes[2] memory script0 = [
            NewOpcodeNoArg(OPCODE_LOAD_STACK_1),
            NewOpcodeNoArg(OPCODE_NEG)
        ];

        bytes memory vmCode = AddOpcodes(script0);

        bytes memory callDataArray2 = abi.encodePacked(
            mergeData(
                address(0),
                vmCode,
                CALCULATION_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(uni3Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                EncodeStack(1, 0, 0x44, 0x20),
                0xFFFFFF
            )
        );

        bytes memory callData3 = abi.encodeWithSignature(
            "swap(address,bool,int256,uint160,bytes)",
            addr,
            true,
            0x11111,
            0x0,
            callDataArray2
        );
        bytes memory callDataArray3 = abi.encodePacked(
            mergeData(
                address(uni3Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        multicaller.doCalls(callDataArray3);
    }
}
