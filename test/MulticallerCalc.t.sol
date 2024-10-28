// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/ERC20.sol";
import "../src/interfaces/dydx/ISoloMargin.sol";
import "./Interface.sol";
import "./Helper.sol";

contract MulticallerCalcTest is Test, Helper {
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

    function testCalcLoadUint() public {
        bytes[1] memory script0 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x77777777)
        ];

        bytes memory vmCode = AddOpcodes(script0);
        uint256 ret = multicaller.doCalls(
            mergeData(
                address(0),
                vmCode,
                CALCULATION_CALL_SELECTOR,
                0xFFFFF,
                0xFFFFF
            )
        );
        assertEq(ret, 0x77777777);
    }

    function testCalcSelfBalance() public {
        bytes[1] memory script0 = [NewOpcodeNoArg(OPCODE_SELFBALANCE)];

        bytes memory vmCode = AddOpcodes(script0);
        uint256 ret = multicaller.doCalls(
            mergeData(
                address(0),
                vmCode,
                CALCULATION_CALL_SELECTOR,
                0xFFFFF,
                0xFFFFF
            )
        );
        assertEq(ret, 1000000);
    }

    function testCalcSelfBalanceDiff() public {
        bytes[1] memory script0 = [NewOpcodeNoArg(OPCODE_SELFBALANCE)];
        bytes[4] memory script1 = [
            NewOpcodeNoArg(OPCODE_POP_STACK),
            NewOpcodeNoArg(OPCODE_SELFBALANCE),
            NewOpcodeNoArg(OPCODE_INC),
            NewOpcodeNoArg(OPCODE_SUB)
        ];

        bytes memory vmCode0 = AddOpcodes(script0);
        bytes memory vmCode1 = AddOpcodes(script1);

        uint256 ret = multicaller.doCalls(
            abi.encodePacked(
                mergeData(
                    address(0),
                    vmCode0,
                    CALCULATION_CALL_SELECTOR,
                    0xFFFFF,
                    0xFFFFF
                ),
                mergeData(
                    address(0),
                    vmCode1,
                    CALCULATION_CALL_SELECTOR,
                    0xFFFFF,
                    0xFFFFF
                )
            )
        );
        assertEq(ret, 1);
    }

    function testCalcAdd() public {
        bytes[3] memory script0 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x77777777),
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x11111111),
            NewOpcodeNoArg(OPCODE_ADD)
        ];

        bytes memory vmCode = AddOpcodes(script0);
        uint256 ret = multicaller.doCalls(
            mergeData(
                address(0),
                vmCode,
                CALCULATION_CALL_SELECTOR,
                0xFFFFF,
                0xFFFFF
            )
        );
        assertEq(ret, 0x88888888);
    }

    function testCalcXor() public {
        bytes[3] memory script0 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x77777777),
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x11111111),
            NewOpcodeNoArg(OPCODE_XOR)
        ];

        bytes memory vmCode = AddOpcodes(script0);
        uint256 ret = multicaller.doCalls(
            mergeData(
                address(0),
                vmCode,
                CALCULATION_CALL_SELECTOR,
                0xFFFFF,
                0xFFFFF
            )
        );
        assertEq(ret, 0x66666666);
    }

    function testCalcOr() public {
        bytes[3] memory script0 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x66666666),
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x11111111),
            NewOpcodeNoArg(OPCODE_OR)
        ];

        bytes memory vmCode = AddOpcodes(script0);
        uint256 ret = multicaller.doCalls(
            mergeData(
                address(0),
                vmCode,
                CALCULATION_CALL_SELECTOR,
                0xFFFFF,
                0xFFFFF
            )
        );
        assertEq(ret, 0x77777777);
    }

    function testCalcAnd() public {
        bytes[3] memory script0 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x77777777),
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x11111111),
            NewOpcodeNoArg(OPCODE_AND)
        ];

        bytes memory vmCode = AddOpcodes(script0);
        uint256 ret = multicaller.doCalls(
            mergeData(
                address(0),
                vmCode,
                CALCULATION_CALL_SELECTOR,
                0xFFFFF,
                0xFFFFF
            )
        );
        assertEq(ret, 0x11111111);
    }

    function testCalcMul() public {
        bytes[3] memory script0 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x77777777),
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x11111111),
            NewOpcodeNoArg(OPCODE_MUL)
        ];

        bytes memory vmCode = AddOpcodes(script0);
        uint256 ret = multicaller.doCalls(
            mergeData(
                address(0),
                vmCode,
                CALCULATION_CALL_SELECTOR,
                0xFFFFF,
                0xFFFFF
            )
        );
        assertEq(ret, 573898704248165863);
    }

    function testCalcDiv() public {
        bytes[3] memory script0 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x11111111),
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x77777777),
            NewOpcodeNoArg(OPCODE_DIV)
        ];

        bytes memory vmCode = AddOpcodes(script0);
        uint256 ret = multicaller.doCalls(
            mergeData(
                address(0),
                vmCode,
                CALCULATION_CALL_SELECTOR,
                0xFFFFF,
                0xFFFFF
            )
        );
        assertEq(ret, 7);
    }

    function testCalcShl() public {
        bytes[2] memory script0 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x77777777),
            NewOpcodeUint8(OPCODE_SHL, 8)
        ];

        bytes memory vmCode = AddOpcodes(script0);
        uint256 ret = multicaller.doCalls(
            mergeData(
                address(0),
                vmCode,
                CALCULATION_CALL_SELECTOR,
                0xFFFFF,
                0xFFFFF
            )
        );
        assertEq(ret, 0x7777777700);
    }

    function testCalcShr() public {
        bytes[2] memory script0 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x77777777),
            NewOpcodeUint8(OPCODE_SHR, 8)
        ];

        bytes memory vmCode = AddOpcodes(script0);
        uint256 ret = multicaller.doCalls(
            mergeData(
                address(0),
                vmCode,
                CALCULATION_CALL_SELECTOR,
                0xFFFFF,
                0xFFFFF
            )
        );
        assertEq(ret, 0x777777);
    }

    function testCalcInc() public {
        bytes[2] memory script0 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x77777777),
            NewOpcodeNoArg(OPCODE_INC)
        ];

        bytes memory vmCode = AddOpcodes(script0);
        uint256 ret = multicaller.doCalls(
            mergeData(
                address(0),
                vmCode,
                CALCULATION_CALL_SELECTOR,
                0xFFFFF,
                0xFFFFF
            )
        );
        assertEq(ret, 0x77777778);
    }

    function testCalcDec() public {
        bytes[2] memory script0 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x77777777),
            NewOpcodeNoArg(OPCODE_DEC)
        ];

        bytes memory vmCode = AddOpcodes(script0);

        bytes memory callData = mergeData(
            address(0),
            vmCode,
            CALCULATION_CALL_SELECTOR,
            0xFFFFF,
            0xFFFFF
        );

        uint256 gasUsed = gasleft();
        uint256 ret = multicaller.doCalls(callData);
        gasUsed -= gasleft();
        assertEq(ret, 0x77777776);
        //console.log("GasUsed:", gasUsed);
    }

    function testCalcIncDec() public {
        bytes[3] memory script0 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x77777777),
            NewOpcodeNoArg(OPCODE_INC),
            NewOpcodeNoArg(OPCODE_DEC)
        ];

        bytes memory vmCode = AddOpcodes(script0);

        bytes memory callData = mergeData(
            address(0),
            vmCode,
            CALCULATION_CALL_SELECTOR,
            0xFFFFF,
            0xFFFFF
        );
        uint256 gasUsed = gasleft();
        uint256 ret = multicaller.doCalls(callData);
        gasUsed -= gasleft();
        assertEq(ret, 0x77777777);
        //console.log("GasUsed:", gasUsed);
    }

    function testCalcIncDecSplit() public {
        bytes[2] memory script0 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x77777777),
            NewOpcodeNoArg(OPCODE_INC)
        ];

        bytes[3] memory script1 = [
            NewOpcodeNoArg(OPCODE_POP_STACK),
            NewOpcodeNoArg(OPCODE_DEC),
            NewOpcodeNoArg(OPCODE_DEC)
        ];

        bytes memory vmCode0 = AddOpcodes(script0);
        bytes memory vmCode1 = AddOpcodes(script1);

        bytes memory callData0 = mergeData(
            address(0),
            vmCode0,
            CALCULATION_CALL_SELECTOR,
            0xFFFFF,
            0xFFFFF
        );
        bytes memory callData1 = mergeData(
            address(0),
            vmCode1,
            CALCULATION_CALL_SELECTOR,
            0xFFFFF,
            0xFFFFF
        );

        uint256 gasUsed = gasleft();
        uint256 ret = multicaller.doCalls(
            abi.encodePacked(callData0, callData1)
        );
        gasUsed -= gasleft();
        assertEq(ret, 0x77777776);
        //console.log("GasUsed:", gasUsed);
    }

    function calcCheck(
        uint8 opcodeRevert,
        uint8 opcodeReturn,
        uint256 ok_arg0,
        uint256 ok_arg1,
        uint256 fail_arg0,
        uint256 fail_arg1,
        bytes memory revertMsg
    ) public {
        bytes[3] memory script0 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, ok_arg0),
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, ok_arg1),
            NewOpcodeNoArg(opcodeRevert)
        ];

        bytes memory vmCode = AddOpcodes(script0);

        bytes memory callData = mergeData(
            address(0),
            vmCode,
            CALCULATION_CALL_SELECTOR,
            0xFFFFF,
            0xFFFFF
        );

        uint256 ret = multicaller.doCalls(callData);

        script0 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, fail_arg0),
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, fail_arg1),
            NewOpcodeNoArg(opcodeRevert)
        ];

        vmCode = AddOpcodes(script0);

        callData = mergeData(
            address(0),
            vmCode,
            CALCULATION_CALL_SELECTOR,
            0xFFFFF,
            0xFFFFF
        );

        vm.expectRevert(revertMsg);
        ret = multicaller.doCalls(callData);

        script0 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, fail_arg0),
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, fail_arg1),
            NewOpcodeNoArg(opcodeReturn)
        ];

        vmCode = AddOpcodes(script0);

        callData = mergeData(
            address(0),
            vmCode,
            CALCULATION_CALL_SELECTOR,
            0xFFFFF,
            0xFFFFF
        );

        ret = multicaller.doCalls(callData);

        assertEq(ret, 0x0);

        script0 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, ok_arg0),
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, ok_arg1),
            NewOpcodeNoArg(opcodeReturn)
        ];

        vmCode = AddOpcodes(script0);

        callData = mergeData(
            address(0),
            vmCode,
            CALCULATION_CALL_SELECTOR,
            0xFFFFF,
            0xFFFFF
        );

        ret = multicaller.doCalls(callData);

        assertEq(ret, 0x1);
    }

    function testCalcEq() public {
        calcCheck(
            OPCODE_EQ_REVERT,
            OPCODE_EQ_RETURN,
            0x77777777,
            0x77777777,
            0x77777777,
            0x77777778,
            bytes("EQ")
        );
    }

    function testCalcNeq() public {
        calcCheck(
            OPCODE_NEQ_REVERT,
            OPCODE_NEQ_RETURN,
            0x77777778,
            0x77777777,
            0x77777777,
            0x77777777,
            bytes("NEQ")
        );
    }

    function testCalcLt() public {
        calcCheck(
            OPCODE_LT_REVERT,
            OPCODE_LT_RETURN,
            0x77777777,
            0x77777776,
            0x77777777,
            0x77777777,
            bytes("LT")
        );
        calcCheck(
            OPCODE_LT_REVERT,
            OPCODE_LT_RETURN,
            0x2,
            0x0,
            0x77777770,
            0x77777777,
            bytes("LT")
        );
    }

    function testCalcGt() public {
        calcCheck(
            OPCODE_GT_REVERT,
            OPCODE_GT_RETURN,
            0x77777777,
            0x77777778,
            0x77777777,
            0x77777776,
            bytes("GT")
        );
        calcCheck(
            OPCODE_GT_REVERT,
            OPCODE_GT_RETURN,
            0x0,
            0x2,
            0x77777777,
            0x77777777,
            bytes("GT")
        );
    }

    function testCalcLte() public {
        calcCheck(
            OPCODE_LTE_REVERT,
            OPCODE_LTE_RETURN,
            0x77777777,
            0x77777777,
            0x77777777,
            0x77777778,
            bytes("LTE")
        );
        calcCheck(
            OPCODE_LTE_REVERT,
            OPCODE_LTE_RETURN,
            0x77777777,
            0x77777776,
            0x0,
            0x2,
            bytes("LTE")
        );
    }

    function testCalcGte() public {
        calcCheck(
            OPCODE_GTE_REVERT,
            OPCODE_GTE_RETURN,
            0x77777777,
            0x77777777,
            0x77777777,
            0x77777776,
            bytes("GTE")
        );
        calcCheck(
            OPCODE_GTE_REVERT,
            OPCODE_GTE_RETURN,
            0x77777777,
            0x77777778,
            0x2,
            0x0,
            bytes("GTE")
        );
    }

    function testCalcZr() public {
        calcCheck(
            OPCODE_ZR_REVERT,
            OPCODE_ZR_RETURN,
            0x77777777,
            0x0,
            0x77777777,
            0x77777776,
            bytes("ZR")
        );
        calcCheck(
            OPCODE_ZR_REVERT,
            OPCODE_ZR_RETURN,
            0x77777777,
            0x0,
            0x2,
            0x1,
            bytes("ZR")
        );
    }
    function testCalcNzr() public {
        calcCheck(
            OPCODE_NZR_REVERT,
            OPCODE_NZR_RETURN,
            0x0,
            0x77777777,
            0x77777777,
            0x0,
            bytes("NZR")
        );
        calcCheck(
            OPCODE_NZR_REVERT,
            OPCODE_NZR_RETURN,
            0x77777777,
            0x2,
            0x0,
            0x0,
            bytes("NZR")
        );
    }

    function testCalcSumPop() public {
        bytes[1] memory script0 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x77777777)
        ];
        bytes[1] memory script1 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x11111111)
        ];
        bytes[1] memory script2 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x22222222)
        ];
        bytes[2] memory script3 = [
            NewOpcodeUint8(OPCODE_SUM_POP, 0x3),
            NewOpcodeNoArg(OPCODE_INC)
        ];

        bytes memory vmCode0 = AddOpcodes(script0);
        bytes memory vmCode1 = AddOpcodes(script1);
        bytes memory vmCode2 = AddOpcodes(script2);
        bytes memory vmCode3 = AddOpcodes(script3);

        bytes memory callData0 = mergeData(
            address(0),
            vmCode0,
            CALCULATION_CALL_SELECTOR,
            0xFFFFF,
            0xFFFFF
        );
        bytes memory callData1 = mergeData(
            address(0),
            vmCode1,
            CALCULATION_CALL_SELECTOR,
            0xFFFFF,
            0xFFFFF
        );
        bytes memory callData2 = mergeData(
            address(0),
            vmCode2,
            CALCULATION_CALL_SELECTOR,
            0xFFFFF,
            0xFFFFF
        );
        bytes memory callData3 = mergeData(
            address(0),
            vmCode3,
            CALCULATION_CALL_SELECTOR,
            0xFFFFF,
            0xFFFFF
        );

        uint256 ret = multicaller.doCalls(
            abi.encodePacked(callData0, callData1, callData2, callData3)
        );
        assertEq(ret, 0xAAAAAAAB);

        script3 = [
            NewOpcodeUint8(OPCODE_SUM_POP, 0x2),
            NewOpcodeNoArg(OPCODE_INC)
        ];
        vmCode3 = AddOpcodes(script3);

        callData3 = mergeData(
            address(0),
            vmCode3,
            CALCULATION_CALL_SELECTOR,
            0xFFFFF,
            0xFFFFF
        );
        ret = multicaller.doCalls(
            abi.encodePacked(callData0, callData1, callData2, callData3)
        );
        assertEq(ret, 0x33333334);
    }

    function testCalcSum() public {
        bytes[1] memory script0 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x77777777)
        ];
        bytes[1] memory script1 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x11111111)
        ];
        bytes[1] memory script2 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x22222222)
        ];
        bytes[2] memory script3 = [
            NewOpcodeUint8(OPCODE_SUM, 0x3),
            NewOpcodeNoArg(OPCODE_INC)
        ];

        bytes memory vmCode0 = AddOpcodes(script0);
        bytes memory vmCode1 = AddOpcodes(script1);
        bytes memory vmCode2 = AddOpcodes(script2);
        bytes memory vmCode3 = AddOpcodes(script3);

        bytes memory callData0 = mergeData(
            address(0),
            vmCode0,
            CALCULATION_CALL_SELECTOR,
            0xFFFFF,
            0xFFFFF
        );
        bytes memory callData1 = mergeData(
            address(0),
            vmCode1,
            CALCULATION_CALL_SELECTOR,
            0xFFFFF,
            0xFFFFF
        );
        bytes memory callData2 = mergeData(
            address(0),
            vmCode2,
            CALCULATION_CALL_SELECTOR,
            0xFFFFF,
            0xFFFFF
        );
        bytes memory callData3 = mergeData(
            address(0),
            vmCode3,
            CALCULATION_CALL_SELECTOR,
            0xFFFFF,
            0xFFFFF
        );

        uint256 ret = multicaller.doCalls(
            abi.encodePacked(callData0, callData1, callData2, callData3)
        );
        assertEq(ret, 0xAAAAAAAB);

        script3 = [NewOpcodeUint8(OPCODE_SUM, 0x2), NewOpcodeNoArg(OPCODE_INC)];
        vmCode3 = AddOpcodes(script3);

        callData3 = mergeData(
            address(0),
            vmCode3,
            CALCULATION_CALL_SELECTOR,
            0xFFFFF,
            0xFFFFF
        );
        ret = multicaller.doCalls(
            abi.encodePacked(callData0, callData1, callData2, callData3)
        );
        assertEq(ret, 0x33333334);
    }

    function testCalcNeg() public {
        bytes[2] memory script0 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, 0x77777777),
            NewOpcodeNoArg(OPCODE_NEG)
        ];

        bytes memory vmCode = AddOpcodes(script0);

        bytes memory callData = mergeData(
            address(0),
            vmCode,
            CALCULATION_CALL_SELECTOR,
            0xFFFFF,
            0xFFFFF
        );
        uint256 ret = multicaller.doCalls(callData);
        int256 iret = int256(ret);
        assertEq(iret, -0x77777777);

        int256 a = -1;

        script0 = [
            NewOpcodeUint256(OPCODE_LOADUIN256ARG, uint256(a)),
            NewOpcodeNoArg(OPCODE_NEG)
        ];
        vmCode = AddOpcodes(script0);

        callData = mergeData(
            address(0),
            vmCode,
            CALCULATION_CALL_SELECTOR,
            0xFFFFF,
            0xFFFFF
        );
        ret = multicaller.doCalls(callData);
        iret = int256(ret);
        assertEq(iret, 0x1);
    }
}
