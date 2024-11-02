pragma solidity ^0.8.15;

import "../src/interfaces/dydx/ISoloMargin.sol";



interface MultiCaller {
    event Stack(uint256 indexed, uint256 indexed);

    function doCalls(bytes calldata data) external payable returns(uint256);
    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
    function isValidSignature(bytes32, bytes calldata) external view returns (bytes4);
    function isValidSignature(bytes calldata, bytes calldata) external view returns (bytes4);
    function uniswapV3SwapCallback(int256 , int256 , bytes calldata data) external;
    function swapCallback(int256 , int256 , bytes calldata data) external;
    function callFunction(address, Account.Info memory, bytes calldata data) external;
    function receiveFlashLoan(address[] memory,uint256[] memory ,uint256[] memory,bytes calldata) external;
    function transferTipsMinBalance(address token, uint256 minBalance, uint256 tips, address owner) external payable;
    function transferTipsMinBalanceWETH(uint256 minBalance, uint256 tips,address owner) external payable;
    function transferTipsMinBalanceNoPayout(address token, uint256 minBalance, uint256 tips) external payable;
    function uni2GetInAmountFrom0(address pool,uint256 amount) external;
    function uni2GetInAmountFrom1(address pool,uint256 amount) external;
    function uni2GetOutAmountFrom0(address pool,uint256 amount) external;
    function uni2GetOutAmountFrom1(address pool,uint256 amount) external;
    function uni2GetInAmountFrom0Comms(address pool,uint256 amount, uint256 fee) external;
    function uni2GetInAmountFrom1Comms(address pool,uint256 amount, uint256 fee) external;
    function uni2GetOutAmountFrom0Comms(address pool,uint256 amount, uint256 fee) external;
    function uni2GetOutAmountFrom1Comms(address pool,uint256 amount, uint256 fee) external;
    function logStack() external;
    function logStackOffset(uint256) external;

}
