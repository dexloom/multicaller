// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/ERC20.sol";
import "../src/interfaces/dydx/ISoloMargin.sol";
import "./Helper.sol";
import "./Interface.sol";

contract MulticallerTest is Test, Helper {
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

    function testCall1() public {
        //console.log("testCallErc20MixedTwoCallArray");
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
            "transfer(address,uint256)",
            addr,
            200
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock2),
                callData2,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        multicaller.doCalls(callDataArray);
        //assertEq(counter.number(), 22);
    }

    function testCallErc20MixedTwoCallArray() public {
        //console.log("testCallErc20MixedTwoCallArray");
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
            "transfer(address,uint256)",
            addr,
            200
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData,
                STATIC_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock2),
                callData2,
                DELEGATE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
            //mergeData(address(erc20Mock2), callData2, ZERO_VALUE_CALL_SELECTOR,0xFFFFFF,0xFFFFFF),
            //mergeData(address(erc20Mock2), callData2, ZERO_VALUE_CALL_SELECTOR,0xFFFFFF,0xFFFFFF),
            //mergeData(address(erc20Mock), callData3, ZERO_VALUE_CALL_SELECTOR,0xFFFFFF,0xFFFFFF)
        );

        multicaller.doCalls(callDataArray);
        //assertEq(counter.number(), 22);
    }

    function testCallErc20MixedCallArray() public {
        //console.log("testCallERC20StaticArray");
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
            "transfer(address,uint256)",
            addr,
            200
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData,
                STATIC_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock2),
                callData2,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock2),
                callData2,
                DELEGATE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock2),
                callData2,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData3,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        multicaller.doCalls(callDataArray);
        //assertEq(counter.number(), 22);
    }

    function testCallErc20StaticCallArray() public {
        //console.log("testCallERC20StaticArray");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callData = abi.encodeWithSignature(
            "balanceOf(address)",
            addr
        );
        bytes memory callData2 = abi.encodeWithSignature(
            "balanceOf(address)",
            addr2
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData,
                STATIC_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock2),
                callData2,
                STATIC_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        multicaller.doCalls(callDataArray);
        //assertEq(counter.number(), 22);
    }

    function testCallErc20StaticCallArray2() public {
        //console.log("testCallERC20StaticArray");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);
        address addr3 = address(0x3333445566778899001122334455667788990022);

        bytes memory callData = abi.encodeWithSignature(
            "balanceOf(address)",
            addr
        );
        bytes memory callData2 = abi.encodeWithSignature(
            "balanceOf(address)",
            addr2
        );
        bytes memory callData3 = abi.encodeWithSignature(
            "balanceOf(address)",
            addr3
        );

        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData,
                STATIC_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock2),
                callData2,
                STATIC_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData3,
                STATIC_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        multicaller.doCalls(callDataArray);
        //assertEq(counter.number(), 22);
    }

    function testCallErc20CallArrayWithValue() public {
        console.log("testCallERC20ArrayWithValue");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callData = abi.encodeWithSignature(
            "transfer(address,uint256)",
            addr,
            1
        );
        bytes memory callData2 = abi.encodeWithSignature(
            "transfer(address,uint256)",
            addr2,
            0x222
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeValueCallData(address(erc20Mock), callData, 0x7777),
            mergeValueCallData(address(erc20Mock2), callData2, 0x8888)
        );

        multicaller.doCalls(callDataArray);
        //assertEq(counter.number(), 22);
    }

    function testCallErcInside20CallArray() public {
        console.log("testCallERC20Array");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callData = abi.encodeWithSignature(
            "balanceOf(address)",
            addr
        );
        bytes memory callData2 = abi.encodeWithSignature(
            "balanceOf(address)",
            addr2
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData2,
                STATIC_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        bytes memory callDoCallsData = abi.encodeWithSignature(
            "doCalls(bytes)",
            callDataArray
        );

        multicaller.doCalls(
            abi.encodePacked(
                mergeData(
                    address(multicaller),
                    callDoCallsData,
                    ZERO_VALUE_CALL_SELECTOR,
                    0xFFFFFF,
                    0xFFFFFF
                )
            )
        );
        //assertEq(counter.number(), 22);
    }

    function testCallErcInside20DelegateCallArray() public {
        console.log("testCallERC20Array Delegate");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callData = abi.encodeWithSignature(
            "balanceOf(address)",
            addr
        );
        bytes memory callData2 = abi.encodeWithSignature(
            "balanceOf(address)",
            addr2
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData,
                DELEGATE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData2,
                DELEGATE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        bytes memory callDoCallsData = abi.encodeWithSignature(
            "doCalls(bytes)",
            callDataArray
        );

        multicaller.doCalls(
            abi.encodePacked(
                mergeData(
                    address(multicaller),
                    callDoCallsData,
                    DELEGATE_CALL_SELECTOR,
                    0xFFFFFF,
                    0xFFFFFF
                )
            )
        );
        //assertEq(counter.number(), 22);
    }

    //#define constant _ERC1271_MAGICVALUE = 0x20c13b0b
    //#define constant _ERC1271_MAGICVALUE_BYTES32 = 0x1626ba7e
    function testIsValidSignature1() public {
        bytes memory param1 = "asd";
        bytes memory param2 = "sdf";

        bytes4 shouldRet = 0x20c13b0b;
        bytes4 ret = multicaller.isValidSignature(param1, param2);

        assertEq(ret, shouldRet);

        //console.log(ret);
    }
    function testIsValidSignature2() public {
        bytes32 param1 = "asd";
        bytes memory param2 = "sdf";
        bytes4 shouldRet = 0x1626ba7e;

        bytes4 ret = multicaller.isValidSignature(param1, param2);

        assertEq(ret, shouldRet);
    }

    function testCallErcInsideUni2CallbackArray() public {
        console.log("testCallErcInsideUni2CallbackArray");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callData = abi.encodeWithSignature(
            "balanceOf(address)",
            addr
        );
        bytes memory callData2 = abi.encodeWithSignature(
            "balanceOf(address)",
            addr2
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData2,
                STATIC_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        //bytes memory callDoCallsWithSigData = abi.encodeWithSignature("doCalls(bytes)",callDataArray);
        //(,bytes memory callDoCallsData ) = abi.decode(bytes(callDoCallsWithSigData), (uint32,bytes));
        //(bytes memory callDoCallsData ) = abi.encode("(bytes)",callDataArray);
        bytes memory callDoCallsData = abi.encodeWithSignature(
            "doCalls(bytes)",
            callDataArray
        );

        multicaller.uniswapV2Call(
            addr,
            0x200,
            0x300,
            removeSignature(callDoCallsData)
        );
        //assertEq(counter.number(), 22);
    }

    function testCallErcInsideUni3CallbackArray() public {
        console.log("testCallErcInsideUni3CallbackArray");
        address addr = address(0x1122334455667788990011223344556677889977);
        address addr2 = address(0x2233445566778899001122334455667788990088);

        bytes memory callData = abi.encodeWithSignature(
            "balanceOf(address)",
            addr
        );
        bytes memory callData2 = abi.encodeWithSignature(
            "balanceOf(address)",
            addr2
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData2,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData,
                STATIC_CALL_SELECTOR,
                0xFFFFFF,
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
        //assertEq(counter.number(), 22);
    }

    function testCallErcInsideUni3CallbackArrayCalculation() public {
        console.log("testCallErcInsideUni3CallbackArray");
        address addr = address(0x1122334455667788990011223344556677889977);
        address addr2 = address(0x2233445566778899001122334455667788990088);

        bytes[2] memory script0 = [
            NewOpcodeNoArg(OPCODE_LOAD_STACK_1),
            NewOpcodeNoArg(OPCODE_NEG)
        ];

        bytes memory vmCode = AddOpcodes(script0);

        bytes memory callData = abi.encodeWithSignature(
            "balanceOf(address)",
            addr
        );
        bytes memory callData2 = abi.encodeWithSignature(
            "transfer(address,uint256)",
            addr2,
            0
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                vmCode,
                CALCULATION_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData2,
                ZERO_VALUE_CALL_SELECTOR,
                EncodeStack(1, 0, 0x24, 0x20),
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData,
                STATIC_CALL_SELECTOR,
                0xFFFFFF,
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
        //assertEq(counter.number(), 22);
    }

    function testCallErcInsideBalancerCallbackArray() public {
        console.log("testCallErcInsideDyDxCallbackArray");
        address addr = address(0x1122334455667788990011223344556677889977);
        address addr2 = address(0x2233445566778899001122334455667788990088);

        bytes memory callData = abi.encodeWithSignature(
            "balanceOf(address)",
            addr
        );
        bytes memory callData2 = abi.encodeWithSignature(
            "balanceOf(address)",
            addr2
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData2,
                STATIC_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        //bytes memory callDoCallsData = abi.encodeWithSignature("uniswapV2Call(address,uint,uint,bytes)", addr, 0x200, 0x300, callDataArray);
        address[] memory tokens = new address[](2);

        tokens[0] = address(erc20Mock);
        tokens[1] = address(erc20Mock2);

        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 100;
        amounts[1] = 200;

        uint256[] memory fee = new uint256[](2);
        fee[0] = 10;
        fee[1] = 20;

        multicaller.receiveFlashLoan(tokens, amounts, fee, callDataArray);
        //assertEq(counter.number(), 22);
    }
}
