// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/interfaces/dydx/ISoloMargin.sol";
import "./Helper.sol";
import "./Interface.sol";

import "../src/ERC20.sol";
import "../src/mocks/Pancake3Pool.sol";
import "../src/mocks/ShibaswapPool.sol";
import "../src/mocks/Uni2Pool.sol";
import "../src/mocks/Uni3Pool.sol";

contract MulticallerCallback2Test is Test, Helper {
    MultiCaller public multicaller;
    ERC20 public erc20Mock;
    ERC20 public erc20Mock2;
    UniswapV2Pair public uni2Mock;
    UniswapV3Pool public uni3Mock;
    PancakeV3Pool public pancake3Mock;
    ShibaswapV2Pair public shibaMock;

    /// @dev Setup the testing environment.
    function setUp() public {
        erc20Mock = new ERC20();
        erc20Mock2 = new ERC20();

        uni2Mock = new UniswapV2Pair();
        uni3Mock = new UniswapV3Pool();
        shibaMock = new ShibaswapV2Pair();
        pancake3Mock = new PancakeV3Pool();

        console.log(address(erc20Mock));
        console.log(address(erc20Mock2));
        multicaller = MultiCaller(HuffDeployer.deploy("Multicaller"));
        console.log(address(multicaller));
        vm.deal(address(multicaller), 1000000);
        vm.startPrank(0xffFf14106945bCB267B34711c416AA3085B8865F);
    }

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
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        bytes memory callData3 = abi.encodeWithSignature(
            "swap(uint256,uint256,address,bytes)",
            0x11111,
            0x0,
            address(multicaller),
            callDataArray
        );
        bytes memory callDataArray3 = abi.encodePacked(
            mergeData(
                address(uni2Mock),
                callData3,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        multicaller.doCalls(callDataArray3);

        //assertEq(counter.number(), 22);
    }

    function testCallErcInsideUni3CallbackArray() public {
        console.log("testCallErcInsideUni3CallbackArray");
        address addr = address(0x1122334455667788990011223344556677889977);
        address addr2 = address(0x2233445566778899001122334455667788990088);

        bytes memory callData = abi.encodeWithSignature(
            "balanceOf(address)",
            addr2
        );
        bytes memory callData2 = abi.encodeWithSignature(
            "transfer(address,uint256)",
            addr,
            0x1111111111
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
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        bytes memory callData3 = abi.encodeWithSignature(
            "swap(address,bool,int256,uint160,bytes)",
            addr,
            true,
            0x11111,
            0x0,
            callDataArray
        );
        bytes memory callDataArray3 = abi.encodePacked(
            mergeData(
                address(uni3Mock),
                callData3,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        multicaller.doCalls(callDataArray3);

        //assertEq(amount1, 0x300);
    }

    function testCallErcInsideUni3QuickTransfer() public {
        console.log("testCallErcInsideUni3CallbackArray");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callDoCallsData = abi.encodePacked(address(erc20Mock));

        /*address recipient,
        bool zeroForOne,
        int256 amountSpecified,
        uint160 sqrtPriceLimitX96,
        bytes calldata data
        */

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

        /*address recipient,
        bool zeroForOne,
        int256 amountSpecified,
        uint160 sqrtPriceLimitX96,
        bytes calldata data
        */

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

        bytes memory callDataArray2 = abi.encodePacked(
            mergeData(
                address(uni3Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
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
        //uni3Mock.swap( addr, true, 0x33333, 0x22222,  callDataArray2);

        //assertEq(counter.number(), 22);
    }

    function testCallErcInsidePancake3CallbackQuickTransfer() public {
        console.log("testCallErcInsideUni3CallbackArray");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callDoCallsData = abi.encodePacked(address(erc20Mock));

        /*address recipient,
        bool zeroForOne,
        int256 amountSpecified,
        uint160 sqrtPriceLimitX96,
        bytes calldata data
        */

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

        bytes memory callDataArray2 = abi.encodePacked(
            mergeData(
                address(uni3Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
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
                address(pancake3Mock),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        multicaller.doCalls(callDataArray3);
        //uni3Mock.swap( addr, true, 0x33333, 0x22222,  callDataArray2);

        //assertEq(counter.number(), 22);
    }

    function testCallErcInsidePancake3CallbackArray() public {
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
            callDataArray
        );

        bytes memory callDataArray2 = abi.encodePacked(
            mergeData(
                address(uni3Mock),
                callData2,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
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
                address(pancake3Mock),
                callData3,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        multicaller.doCalls(callDataArray3);
        //uni3Mock.swap( addr, true, 0x33333, 0x22222,  callDataArray2);

        //assertEq(counter.number(), 22);
    }

    function testCallErcInsideShiba2CallbackArray2() public {
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
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock2),
                callData,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        bytes memory callData3 = abi.encodeWithSignature(
            "swap(uint256,uint256,address,bytes)",
            0x11111,
            0x0,
            address(multicaller),
            callDataArray
        );
        bytes memory callDataArray3 = abi.encodePacked(
            mergeData(
                address(shibaMock),
                callData3,
                ZERO_VALUE_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        multicaller.doCalls(callDataArray3);

        //assertEq(counter.number(), 22);
    }
}
