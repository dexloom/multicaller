// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

import "./mocks/ERC20.sol";
import "./interfaces/dydx/ISoloMargin.sol";
import "./Interface.sol";
import "./Helper.sol";

contract MulticallerSwapStepWstEthTest is Test, TestHelper {
    string[1] testname = ["0 WstEth UniswapV3"];

    bytes[1] callsdata = [
        bytes(
            hex"28472417000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000002c47ffc000000000000000002a4109830a1aaad605bbf02a9dfa7b0b92ec2fb7daa128acb0800000000000000000000000078787878787878787878787878787878787878780000000000000000000000000000000000000000000000000000000000000001fffffffffffffffffffffffffffffffffffffffffffffffffe9cdedd19cd8f1c00000000000000000000000000000000000000000000000000000001000276a400000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000001d87ffc00000000000000000024c02aaa39b223fe8d0a0e5c4f27ead9083c756cc22e1a7d4d000000000000000000000000000000000000000000000000016345785d8a00008000016345785d8a00000024ae7ab96520de3a18e5e111b5eaab095312d7fe84a1903eab00000000000000000000000000000000000000000000000000000000000000007ffe00008200000000000024ae7ab96520de3a18e5e111b5eaab095312d7fe8470a0823100000000000000000000000078787878787878787878787878787878787878787ffc00000000008200440044ae7ab96520de3a18e5e111b5eaab095312d7fe84095ea7b30000000000000000000000007f39c581f595b53c5cb19bd0b3f8da6c935e2ca000000000000000000000000000000000000000000000000000000000000000007ffc000000000082002400247f39c581f595b53c5cb19bd0b3f8da6c935e2ca0ea598cb000000000000000000000000000000000000000000000000000000000000000007ffc000000000012004400447f39c581f595b53c5cb19bd0b3f8da6c935e2ca0a9059cbb000000000000000000000000109830a1aaad605bbf02a9dfa7b0b92ec2fb7daa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
        )
    ];

    function get_call_data(uint256 i) internal returns (bytes memory) {
        return callsdata[i];
    }

    function get_test_name(uint256 i) internal returns (string memory) {
        return testname[i];
    }

    function test_combo1() public {
        for (uint256 i = 0; i < callsdata.length; i++) {
            uint256 snapshot = vm.snapshot();
            uint256 gasLeft = gasleft();
            uint256 balanceBefore = weth.balanceOf(address(multicaller));
            (bool result, ) = address(multicaller).call(get_call_data(i));
            uint256 gasUsed = gasLeft - gasleft();
            uint256 balanceAfter = weth.balanceOf(address(multicaller));
            //uint256 balanceUsed = balanceBefore - weth.balanceOf(address(multicaller));
            console.log(i, result, get_test_name(i), balanceAfter);
            vm.revertTo(snapshot);
            //if( balanceUsed >= 0.1 ether ) {
            //    console.log(i,"failed");
            //}

            // assertEq(result, true);
        }
    }

    function test_single() public {
        uint256 i = 0;
        uint256 gasLeft = gasleft();
        uint256 balanceBefore = weth.balanceOf(address(multicaller));
        (bool result, ) = address(multicaller).call(get_call_data(i));
        uint256 gasUsed = gasLeft - gasleft();
        uint256 balanceUsed = balanceBefore -
            weth.balanceOf(address(multicaller));
        console.log(i, result, get_test_name(i), balanceBefore);
    }

    function test_combo2() public {
        bytes[1] memory call_data = [
            bytes(
                hex"28472417000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000003447ffc00000000000000000324ba12222222228d8ba445958a75a0704d566bf2c85c38449e0000000000000000000000007878787878787878787878787878787878787878000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc20000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000016345785d8a000000000000000000000000000000000000000000000000000000000000000001f47ffc00000000000000000024c02aaa39b223fe8d0a0e5c4f27ead9083c756cc22e1a7d4d000000000000000000000000000000000000000000000000016345785d8a00008000016345785d8a00000024ae7ab96520de3a18e5e111b5eaab095312d7fe84a1903eab00000000000000000000000000000000000000000000000000000000000000007ffe00008200000000000024ae7ab96520de3a18e5e111b5eaab095312d7fe8470a0823100000000000000000000000078787878787878787878787878787878787878787ffc00000000008200440044ae7ab96520de3a18e5e111b5eaab095312d7fe84095ea7b3000000000000000000000000828b154032950c8ff7cf8085d841723db269605600000000000000000000000000000000000000000000000000000000000000007ffc000082000082006400a4828b154032950c8ff7cf8085d841723db2696056ddc1f59d0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000787878787878787878787878787878787878787800000000000000000000000000000000000000000000000000000000000000000000000000000000"
            )
        ];

        for (uint256 i = call_data.length; i > 0; i--) {
            uint256 gasLeft = gasleft();
            uint256 balanceBefore = weth.balanceOf(address(multicaller));
            (bool result, ) = address(multicaller).call(call_data[i - 1]);
            uint256 gasUsed = gasLeft - gasleft();
            uint256 balanceAfter = weth.balanceOf(address(multicaller));
            uint256 balanceUsed = balanceBefore - balanceAfter;
            console.log(i, gasUsed, balanceAfter);
            if (balanceUsed >= 0.001 ether) {
                console.log(i, "failed");
            }
            assertEq(result, true);
        }
    }
}
