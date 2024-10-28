// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.20;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Script.sol";

interface MultiCaller {
    function doCalls(bytes calldata data) external payable;
    function uniswapV2Call(
        address sender,
        uint amount0,
        uint amount1,
        bytes calldata data
    ) external;
    function isValidSignature(
        bytes32,
        bytes calldata
    ) external view returns (bytes4);
    function uniswapV3SwapCallback(
        int256,
        int256,
        bytes calldata data
    ) external;
    function callFunction(address, address, uint, bytes calldata data) external;
    function receiveFlashLoan(
        address[] memory,
        uint256[] memory,
        uint256[] memory,
        bytes calldata
    ) external;
    function transferTipsMinBalance(
        address token,
        uint256 minBalanceChange,
        uint256 tips
    ) external payable;
    function transferTipsMinBalanceWETH(
        uint256 minBalanceChange,
        uint256 tips
    ) external payable;
}

contract Deploy is Script {
    function run() external returns (address deployedAddress) {
        bytes memory bytecode = HuffDeployer.config().creation_code(
            "Multicaller"
        );
        vm.stopPrank();
        vm.startBroadcast();
        assembly {
            let val := 0
            deployedAddress := create(val, add(bytecode, 0x20), mload(bytecode))
        }
        vm.stopBroadcast();
    }
}
