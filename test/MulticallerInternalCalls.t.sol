pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/interfaces/dydx/ISoloMargin.sol";
import "./Interface.sol";
import "./Helper.sol";

import "../src/ERC20.sol";
import "../src/mocks/Uni2Pool.sol";

contract MulticallerInternalCallsTest is Test, Helper {
    MultiCaller public multicaller;
    ERC20 public erc20Mock;
    ERC20 public erc20Mock2;
    UniswapV2Pair public uni2Mock;

    /// @dev Setup the testing environment.
    function setUp() public {
        erc20Mock = new ERC20();
        erc20Mock2 = new ERC20();
        uni2Mock = new UniswapV2Pair();

        console.log(address(erc20Mock));
        console.log(address(erc20Mock2));
        console.log(address(uni2Mock));
        multicaller = MultiCaller(HuffDeployer.deploy("Multicaller"));
        console.log(address(multicaller));
        vm.deal(address(multicaller), 1000000);
    }

    function testCallUni2GetInAmount0() public {
        console.log("testCallErcInsideUni2CallbackArray");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callData = abi.encodeWithSignature(
            "uni2GetInAmountFrom0(address,uint256)",
            address(uni2Mock),
            0x11111
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData,
                INTERNAL_CALL_SELECTOR,
                0xFFFFFF,
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

        uint256 ret = multicaller.doCalls(callDataArray);
        assertEq(ret, 0x24ae8);
    }

    function testCallUni2GetInAmount0Comms() public {
        console.log("testCallErcInsideUni2CallbackArray");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callData = abi.encodeWithSignature(
            "uni2GetInAmountFrom0Comms(address,uint256,uint256)",
            address(uni2Mock),
            0x11111,
            9900
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData,
                INTERNAL_CALL_SELECTOR,
                0xFFFFFF,
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

        uint256 ret = multicaller.doCalls(callDataArray);
        assertEq(ret, 151310);
    }

    function testCallUni2GetInAmount1() public {
        console.log("testCallErcInsideUni2CallbackArray");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callData = abi.encodeWithSignature(
            "uni2GetInAmountFrom1(address,uint256)",
            address(uni2Mock),
            0x11111
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData,
                INTERNAL_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        bytes memory callDoCallsData = abi.encodeWithSignature(
            "doCalls(bytes)",
            callDataArray
        );

        multicaller.uniswapV2Call(
            addr,
            0x0,
            0x300,
            removeSignature(callDoCallsData)
        );
        uint256 ret = multicaller.doCalls(callDataArray);
        assertEq(ret, 0x8dab);
    }

    function testCallUni2GetInAmount1Comms() public {
        console.log("testCallErcInsideUni2CallbackArray");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callData = abi.encodeWithSignature(
            "uni2GetInAmountFrom1Comms(address,uint256,uint256)",
            address(uni2Mock),
            0x11111,
            9900
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData,
                INTERNAL_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        bytes memory callDoCallsData = abi.encodeWithSignature(
            "doCalls(bytes)",
            callDataArray
        );

        multicaller.uniswapV2Call(
            addr,
            0x0,
            0x300,
            removeSignature(callDoCallsData)
        );
        uint256 ret = multicaller.doCalls(callDataArray);
        assertEq(ret, 36523);
    }

    function testCallUni2GetOutAmount0() public {
        console.log("testCallErcInsideUni2CallbackArray");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callData = abi.encodeWithSignature(
            "uni2GetOutAmountFrom0(address,uint256)",
            address(uni2Mock),
            0x8dab
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData,
                INTERNAL_CALL_SELECTOR,
                0xFFFFFF,
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

        uint256 ret = multicaller.doCalls(callDataArray);
        assertEq(ret, 0x11111);
    }

    function testCallUni2GetOutAmount0Comms() public {
        console.log("testCallErcInsideUni2CallbackArray");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callData = abi.encodeWithSignature(
            "uni2GetOutAmountFrom0Comms(address,uint256,uint256)",
            address(uni2Mock),
            0x8dab,
            9900
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData,
                INTERNAL_CALL_SELECTOR,
                0xFFFFFF,
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

        uint256 ret = multicaller.doCalls(callDataArray);
        assertEq(ret, 69431);
    }

    function testCallUni2GetOutAmount1() public {
        console.log("testCallErcInsideUni2CallbackArray");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callData = abi.encodeWithSignature(
            "uni2GetOutAmountFrom1(address,uint256)",
            address(uni2Mock),
            0x24ae8
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData,
                INTERNAL_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        bytes memory callDoCallsData = abi.encodeWithSignature(
            "doCalls(bytes)",
            callDataArray
        );
        multicaller.uniswapV2Call(
            addr,
            0x0,
            0x300,
            removeSignature(callDoCallsData)
        );

        //bytes memory callDoCallsData = abi.encodeWithSignature("doCalls(bytes)",callDataArray);
        uint256 ret = multicaller.doCalls(callDataArray);
        assertEq(ret, 0x11111);
    }

    function testCallUni2GetOutAmount1Comms() public {
        console.log("testCallErcInsideUni2CallbackArray");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callData = abi.encodeWithSignature(
            "uni2GetOutAmountFrom1Comms(address,uint256,uint256)",
            address(uni2Mock),
            0x24ae8,
            9900
        );
        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(erc20Mock),
                callData,
                INTERNAL_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            )
        );

        bytes memory callDoCallsData = abi.encodeWithSignature(
            "doCalls(bytes)",
            callDataArray
        );
        multicaller.uniswapV2Call(
            addr,
            0x0,
            0x300,
            removeSignature(callDoCallsData)
        );

        //bytes memory callDoCallsData = abi.encodeWithSignature("doCalls(bytes)",callDataArray);
        uint256 ret = multicaller.doCalls(callDataArray);
        assertEq(ret, 69447);
    }

    function testCallUni2GetOutAmount1WithBalance() public {
        console.log("testCallErcInsideUni2CallbackArray");
        address addr = address(0x1122334455667788990011223344556677889900);
        address addr2 = address(0x2233445566778899001122334455667788990011);

        bytes memory callData = abi.encodeWithSignature(
            "uni2GetOutAmountFrom1(address,uint256)",
            address(uni2Mock),
            0x24ae8
        );
        bytes memory callData2 = abi.encodeWithSignature(
            "balanceOf(address)",
            address(multicaller)
        );
        bytes memory callData3 = abi.encodeWithSignature(
            "transfer(address,uint256)",
            address(multicaller),
            0
        );

        bytes memory callDataArray = abi.encodePacked(
            mergeData(
                address(0),
                callData,
                INTERNAL_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(0),
                callData,
                INTERNAL_CALL_SELECTOR,
                EncodeShortStack(0, 0, 0x24, 0x20),
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData2,
                STATIC_CALL_SELECTOR,
                0xFFFFFF,
                0xFFFFFF
            ),
            mergeData(
                address(erc20Mock),
                callData3,
                STATIC_CALL_SELECTOR,
                EncodeStack(0, 1, 0x24, 0x20),
                0xFFFFFF
            )
        );

        bytes memory callDoCallsData = abi.encodeWithSignature(
            "doCalls(bytes)",
            callDataArray
        );
        multicaller.uniswapV2Call(
            addr,
            0x0,
            0x300,
            removeSignature(callDoCallsData)
        );

        //bytes memory callDoCallsData = abi.encodeWithSignature("doCalls(bytes)",callDataArray);
        uint256 ret = multicaller.doCalls(callDataArray);
        assertEq(ret, 33726);
    }
}
