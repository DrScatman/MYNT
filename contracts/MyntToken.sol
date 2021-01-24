pragma solidity ^0.5.14;

import "./LiquidityToken.sol";

contract MyntToken is LiquidityToken {

    address public LIQUIDITY_TRANSFORMER;
    address public transformerGateKeeper;

    constructor() public TRC20("Mynt Token", "MYNT") {
        transformerGateKeeper = msg.sender;
    }

    // receive() external payable {
    //     revert();
    // }

    /**
     * @notice ability to define liquidity transformer contract
     * @dev this method renounce transformerGateKeeper access
     * @param _immutableTransformer contract address
     */
    function setLiquidityTransfomer(
        address _immutableTransformer
    )
        external
    {
        require(
            transformerGateKeeper == msg.sender
            // 'WISE: transformer defined'
        );
        LIQUIDITY_TRANSFORMER = _immutableTransformer;
        transformerGateKeeper = address(0x0);
    }

    /**
     * @notice allows liquidityTransformer to mint supply
     * @dev executed from liquidityTransformer upon UNISWAP transfer
     * and during reservation payout to contributors and referrers
     * @param _investorAddress address for minting WISE tokens
     * @param _amount of tokens to mint for _investorAddress
     */
    function mintSupply(
        address _investorAddress,
        uint256 _amount
    )
        external
    {
        require(
            msg.sender == LIQUIDITY_TRANSFORMER
            // 'WISE: wrong transformer'
        );

        _mint(
            _investorAddress,
            _amount
        );
    }

    /**
     * @notice allows to grant permission to CM referrer status
     * @dev called from liquidityTransformer if user referred 50 ETH
     * @param _referrer - address that becomes a CM reffer
     */
    function giveStatus(
        address _referrer
    )
        external
    {
        require(
            msg.sender == LIQUIDITY_TRANSFORMER
            // 'WISE: wrong transformer'
        );
        criticalMass[_referrer].totalAmount = THRESHOLD_LIMIT;
        criticalMass[_referrer].activationDay = _nextMyntDay();
    }

    function createStakeWithToken(
        address _tokenAddress,
        uint256 _tokenAmount,
        uint64 _lockDays,
        address _referrer
    )
        external
        returns (bytes16, uint256, bytes16 referralID)
    {
        TRC20TokenI token = TRC20TokenI(
            _tokenAddress
        );

        token.transferFrom(
            msg.sender,
            address(this),
            _tokenAmount
        );

        token.approve(
            address(JUSTSWAP_EXCHANGE),
            _tokenAmount
        );

        uint256 amount = JUSTSWAP_EXCHANGE.tokenToTokenSwapInput(
            _tokenAmount, 
            1, 
            1, 
            block.timestamp + 2 hours, 
            address(this)
        );

        return createStake(
            amount,
            _lockDays,
            _referrer
        );
    }
}