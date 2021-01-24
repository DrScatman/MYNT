// SPDX-License-Identifier: --🦉--

pragma solidity ^0.5.14;

interface IMyntToken {

    function currentMyntDay()
        external view
        returns (uint64);

    function approve(
        address _spender,
        uint256 _value
    ) external returns (bool success);

    function mintSupply(
        address _investorAddress,
        uint256 _amount
    ) external;

    function giveStatus(
        address _referrer
    ) external;
}

// interface UniswapRouterV2 {

//     function addLiquidityETH(
//         address token,
//         uint256 amountTokenMax,
//         uint256 amountTokenMin,
//         uint256 amountETHMin,
//         address to,
//         uint256 deadline
//     ) external payable returns (
//         uint256 amountToken,
//         uint256 amountETH,
//         uint256 liquidity
//     );

//     function quote(
//         uint256 amountA,
//         uint256 reserveA,
//         uint256 reserveB
//     ) external pure returns (
//         uint256 amountB
//     );

//     function swapExactTokensForETH(
//         uint256 amountIn,
//         uint256 amountOutMin,
//         address[] calldata path,
//         address to,
//         uint256 deadline
//     ) external returns (
//         uint256[] memory amounts
//     );
// }

interface JustswapExchange {

    // function getReserves() external view returns (
    //     uint112 reserve0,
    //     uint112 reserve1,
    //     uint32 blockTimestampLast
    // );
    
    function getOutputPrice(
    uint256 output_amount, 
    uint256 input_reserve, 
    uint256 output_reserve
    ) external view returns (uint256);
    
    function addLiquidity(
        uint256 min_liquidity, 
        uint256 max_tokens, 
        uint256 deadline
    ) external payable returns (uint256);

    
    function trxToTokenSwapInput(
        uint256 min_tokens, 
        uint256 deadline
    ) external payable returns (uint256);

    function tokenToTokenSwapInput(
        uint256 tokens_sold, 
        uint256 min_tokens_bought, 
        uint256 min_trx_bought, 
        uint256 deadline, 
        address token_addr
    ) external returns (uint256);

    function tokenAddress() external view returns (address);
}

interface RefundSponsorI {
    function addGasRefund(address _a, uint256 _c) external;
}

interface ITRC20Token {
    
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    )  external returns (
        bool success
    );

    function approve(
        address _spender,
        uint256 _value
    )  external returns (
        bool success
    );
}