//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.2;

interface IWETH {
    function deposit() external payable;
    function withdraw(uint wad) external;
    function transfer(address, uint256) external;
    function approve(address, uint256) external;
    function balanceOf(address) external view returns (uint256);
}
