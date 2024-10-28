// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/ERC20.sol";
import "../src/interfaces/dydx/ISoloMargin.sol";
import "./Helper.sol";
import "./Interface.sol";

contract MulticallerCallValueTest is Test, Helper {
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

    function testCall2() public {
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
            mergeValueCallData(address(erc20Mock2), callData2, 0x100)
        );

        multicaller.doCalls(callDataArray);
        //assertEq(counter.number(), 22);
    }

    function testCall3() public {
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
            ),
            mergeValueCallData(address(erc20Mock2), callData2, 0x100)
        );

        multicaller.doCalls(callDataArray);
        //assertEq(counter.number(), 22);
    }

    function testCall4() public {
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
            mergeValueCallData(address(erc20Mock2), callData2, 0x100),
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

    function testCall5() public {
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
                VALUE_CALL_SELECTOR,
                EncodeStack(1, 0, 0x24, 0x20),
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData2,
                ZERO_VALUE_CALL_SELECTOR,
                EncodeStack(1, 0, 0x24, 0x20),
                0xFFFFFF
            )
        );

        uint ret = multicaller.doCalls(callDataMerged);
        assertEq(ret, 4660);
    }

    function testCall6() public {
        address addr = address(erc20Mock);

        bytes memory callData = abi.encodeWithSignature(
            "balanceOf(address)",
            addr
        );
        bytes memory callData2 = abi.encodeWithSignature(
            "transfer(address,uint256)",
            addr,
            0x1111
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
                VALUE_CALL_SELECTOR,
                EncodeStack(1, 0, 0x24, 0x0),
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData2,
                ZERO_VALUE_CALL_SELECTOR,
                EncodeStack(1, 0, 0x24, 0x0),
                0xFFFFFF
            )
        );

        uint ret = multicaller.doCalls(callDataMerged);
        assertEq(ret, 4660);
    }
}
