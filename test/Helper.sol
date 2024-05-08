pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/ERC20.sol";
import "../src/interfaces/dydx/ISoloMargin.sol";

address constant Operator = address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);

contract Helper {
    uint256 public constant VALUE_CALL_SELECTOR =  0x7ffa;
    uint256 public constant CALCULATION_CALL_SELECTOR =  0x7ffb;
    uint256 public constant ZERO_VALUE_CALL_SELECTOR =  0x7ffc;
    uint256 public constant INTERNAL_CALL_SELECTOR =  0x7ffd;
    uint256 public constant STATIC_CALL_SELECTOR   =  0x7ffe;
    uint256 public constant DELEGATE_CALL_SELECTOR =  0x7fff;


    uint8 public constant OPCODE_LOAD_STACK_1 = 0x1;
    uint8 public constant OPCODE_LOAD_STACK_2 = 0x2;
    uint8 public constant OPCODE_LOAD_STACK_3 = 0x3;
    uint8 public constant OPCODE_LOAD_STACK_4 = 0x4;
    uint8 public constant OPCODE_LOAD_STACK_5 = 0x5;
    uint8 public constant OPCODE_LOAD_STACK_6 = 0x6;
    uint8 public constant OPCODE_LOAD_STACK_7 = 0x7;
    uint8 public constant OPCODE_POP_STACK = 0x8;
    uint8 public constant OPCODE_SELFBALANCE = 0xA;
    uint8 public constant OPCODE_ADD = 0x11;
    uint8 public constant OPCODE_SUB = 0x12;
    uint8 public constant OPCODE_MUL = 0x13;
    uint8 public constant OPCODE_DIV = 0x14;
    uint8 public constant OPCODE_SDIV = 0x15;
    uint8 public constant OPCODE_AND = 0x16;
    uint8 public constant OPCODE_OR = 0x17;
    uint8 public constant OPCODE_XOR = 0x18;
    uint8 public constant OPCODE_NOT = 0x19;
    uint8 public constant OPCODE_SHL = 0x1A;
    uint8 public constant OPCODE_SHR = 0x1B;
    uint8 public constant OPCODE_INC = 0x1C;
    uint8 public constant OPCODE_DEC = 0x1D;
    uint8 public constant OPCODE_SUB_REVERSED = 0x1E;
    uint8 public constant OPCODE_DIV_REVERSED = 0x1F;

    uint8 public constant OPCODE_LOADUIN256ARG = 0x20;

    uint8 public constant OPCODE_NEG = 0x2A;


    uint8 public constant OPCODE_EQ_REVERT = 0x40;
    uint8 public constant OPCODE_NEQ_REVERT = 0x41;
    uint8 public constant OPCODE_LT_REVERT = 0x42;
    uint8 public constant OPCODE_GTE_REVERT = 0x43;
    uint8 public constant OPCODE_GT_REVERT = 0x44;
    uint8 public constant OPCODE_LTE_REVERT = 0x45;
    uint8 public constant OPCODE_ZR_REVERT = 0x46;
    uint8 public constant OPCODE_NZR_REVERT = 0x47;

    uint8 public constant OPCODE_EQ_RETURN = 0x48;
    uint8 public constant OPCODE_NEQ_RETURN = 0x49;
    uint8 public constant OPCODE_LT_RETURN = 0x4A;
    uint8 public constant OPCODE_GTE_RETURN = 0x4B;
    uint8 public constant OPCODE_GT_RETURN = 0x4C;
    uint8 public constant OPCODE_LTE_RETURN = 0x4D;
    uint8 public constant OPCODE_ZR_RETURN = 0x4E;
    uint8 public constant OPCODE_NZR_RETURN = 0x4F;

    uint8 public constant OPCODE_SUM_POP = 0x50;
    uint8 public constant OPCODE_SUM = 0x51;
    uint8 public constant OPCODE_PCT_POP = 0x50;
    uint8 public constant OPCODE_PCT = 0x51;


    function removeSignature(bytes memory data) public pure returns (bytes memory) {
        require(data.length >= 0x44, "Data must include function signature");
        bytes memory result = new bytes(data.length - 0x44);

        for (uint i = 0x44; i < data.length; i++) {
            result[i - 0x44] = data[i];
        }

        return result;
    }   


    function mergeData(address callee, bytes memory data, uint256 callSelector, uint256 presetStackParam, uint256 storeStackResult) public pure returns (bytes memory) {
        if( callSelector == CALCULATION_CALL_SELECTOR || callSelector == INTERNAL_CALL_SELECTOR ) {
            uint96 callParams;
            callParams |= uint96(data.length);
            callParams |= (uint96(presetStackParam) << 16);
            callParams |= (uint96(storeStackResult) << 40);

            callParams |= (uint96(callSelector) << 80);
            return abi.encodePacked(callParams, data);

        }
        uint256 callParams = uint256(uint160(callee));
        callParams |= (data.length << 160);
        callParams |= (presetStackParam << 176);
        callParams |= (storeStackResult << 200);

        callParams |= (callSelector << 240);
        return abi.encodePacked(callParams, data);
    }

    function mergeValueCallData(address callee, bytes memory data, uint256 value) public pure returns (bytes memory) {
        uint256 callParams = uint256(uint160(callee));
        callParams |= (data.length << 160);
        callParams |= (value << 176);
        callParams |= 1 << 255;
        return abi.encodePacked(callParams, data);
    }

    function AddOpcode(bytes memory buf, bytes memory opcode) public pure returns (bytes memory) {
        return abi.encodePacked(buf, opcode);
    }

    function AddOpcodes(bytes[1] memory opcodes) public pure returns (bytes memory script) {
        
        for(uint i = 0 ; i < opcodes.length; i ++) {
            script = AddOpcode(script, opcodes[i]);
        }
        script = AddOpcode(script, NewOpcodeNoArg(0));
    }

    function AddOpcodes(bytes[2] memory opcodes) public pure returns (bytes memory script) {
        
        for(uint i = 0 ; i < opcodes.length; i ++) {
            script = AddOpcode(script, opcodes[i]);
        }
        script = AddOpcode(script, NewOpcodeNoArg(0));
    }

    function AddOpcodes(bytes[3] memory opcodes) public pure returns (bytes memory script) {
        
        for(uint i = 0 ; i < opcodes.length; i ++) {
            script = AddOpcode(script, opcodes[i]);
        }
        script = AddOpcode(script, NewOpcodeNoArg(0));
    }
    function AddOpcodes(bytes[4] memory opcodes) public pure returns (bytes memory script) {
        for(uint i = 0 ; i < opcodes.length; i ++) {
            script = AddOpcode(script, opcodes[i]);
        }
        script = AddOpcode(script, NewOpcodeNoArg(0));
    }
    function AddOpcodes( bytes[5] memory opcodes) public pure returns (bytes memory script) {
        for(uint i = 0 ; i < opcodes.length; i ++) {
            script = AddOpcode(script, opcodes[i]);
        }
        script = AddOpcode(script, NewOpcodeNoArg(0));
    
    }


    function NewOpcodeNoArg(uint8 opcode) public pure returns (bytes memory) {
        return abi.encodePacked(opcode);
    }

    function NewOpcodeUint8(uint8 opcode, uint8 arg) public pure returns (bytes memory) {
        return abi.encodePacked(opcode, arg);
    }

    function NewOpcodeAddress(uint8 opcode, address arg) public pure returns (bytes memory) {
        return abi.encodePacked(opcode, arg);
    }

    function NewOpcodeUint256(uint8 opcode, uint256 arg) public pure returns (bytes memory) {
        return abi.encodePacked(opcode, arg);
    }
    function NewOpcodeInt256(uint8 opcode, int256 arg) public pure returns (bytes memory) {
        return abi.encodePacked(opcode, arg);
    }

    function EncodeStack(uint256 rel, uint256 offsetWord, uint256 offsetByte, uint256 lenBytes) public pure returns(uint256) {
        uint256 ret = (rel & 1) << 23;
        ret |= (offsetWord & 7) << 20;
        ret |= (lenBytes & 0xFF) << 12;
        ret |= (offsetByte + 0x20 & 0xFFF);
        return ret;

    }

    function EncodeShortStack(uint256 rel, uint256 offsetWord, uint256 offsetByte, uint256 lenBytes) public pure returns(uint256) {
        uint256 ret = (rel & 1) << 23;
        ret |= (offsetWord & 7) << 20;
        ret |= (lenBytes & 0xFF) << 12;
        ret |= (offsetByte + 0xC & 0xFFF);
        return ret;

    }

    function EncodeReturnStack(uint256 rel, uint256 offsetWord, uint256 offsetByte, uint256 lenBytes) public pure returns(uint256) {
        uint256 ret = (rel & 1) << 23;
        ret |= (offsetWord & 7) << 20;
        ret |= (lenBytes & 0xFF) << 12;
        ret |= (offsetByte & 0xFFF);
        return ret;

    }



}