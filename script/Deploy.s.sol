// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Script.sol";

interface MultiCaller {
    function doCalls(bytes calldata data) external payable;
    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
    function isValidSignature(bytes32, bytes calldata) external view returns (bytes4);
    function uniswapV3SwapCallback(int256 , int256 , bytes calldata data) external;
    function callFunction(address,address,uint, bytes calldata data) external;
    function receiveFlashLoan(address[] memory,uint256[] memory ,uint256[] memory,bytes calldata) external;
    function transferTipsMinBalance(address token, uint256 minBalanceChange, uint256 tips) external payable;
    function transferTipsMinBalanceWETH(uint256 minBalanceChange, uint256 tips) external payable;
}


contract Deploy is Script {
  function run() public returns (MultiCaller multicaller) {
    //vm.startBroadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);
    //vm.startBroadcast();
    //multicaller = MultiCaller(HuffDeployer.config().set_broadcast(true).deploy("Multicaller"));
    //vm.stopPrank();
    
    //HuffDeployer.config().set_broadcast(true).deploy("Multicaller");
    HuffConfig cfg = HuffDeployer.config();
    cfg.set_broadcast(true);
    //vm.stopPrank();
    cfg.deploy("Multicaller");

    //vm.stopBroadcast();
  }
}
