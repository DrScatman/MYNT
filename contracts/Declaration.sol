// SPDX-License-Identifier: --🦉--

pragma solidity ^0.5.14;

import "./Global.sol";

interface IJustswapFactory {
   function createExchange(
       address token
    ) external returns (address);
}

interface IJustswapExchange {

    function getTrxToTokenOutputPrice(
        uint256 tokens_bought
    ) external view returns (uint256);

    function getOutputPrice(
        uint256 output_amount, 
        uint256 input_reserve, 
        uint256 output_reserve
    ) external view returns (uint256);

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

interface ILiquidityGuard {
    function getInflation(uint32 _amount) external view returns (uint256);
}

interface TRC20TokenI {

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

contract Declaration is Global {

    uint256 constant _decimals = 18;
    uint256 constant YODAS_PER_MYNT = 10 ** _decimals;

    // uint32 constant SECONDS_IN_DAY = 86400 seconds;
    uint16 constant SECONDS_IN_DAY = 30 seconds;
    uint16 constant MIN_LOCK_DAYS = 1;
    uint16 constant FORMULA_DAY = 65;
    uint16 constant MAX_LOCK_DAYS = 15330;
    uint16 constant MAX_BONUS_DAYS_A = 1825;
    uint16 constant MAX_BONUS_DAYS_B = 13505;
    uint16 constant MIN_REFERRAL_DAYS = 365;

    uint32 constant MIN_STAKE_AMOUNT = 1000000;
    uint32 constant REFERRALS_RATE = 366816973; // 1.000% (direct value, can be used right away)
    uint32 constant INFLATION_RATE_MAX = 103000; // 3.000% (indirect -> checks throgh LiquidityGuard)

    uint32 public INFLATION_RATE = 103000; // 3.000% (indirect -> checks throgh LiquidityGuard)
    uint32 public LIQUIDITY_RATE = 100006; // 0.006% (indirect -> checks throgh LiquidityGuard)

    uint64 constant PRECISION_RATE = 1E18;

    uint96 constant THRESHOLD_LIMIT = 10000E18; // $10,000 DAI

    uint96 constant DAILY_BONUS_A = 13698630136986302; // 25%:1825 = 0.01369863013 per day;
    uint96 constant DAILY_BONUS_B = 370233246945575;   // 5%:13505 = 0.00037023324 per day;

    uint256 LAUNCH_TIME;

    // address constant WBTC = address(0x41EFC230E125C24DE35F6290AFCAFA28D50B436536); // mainnet
    address constant WBTC = address(0x41C81BF28D35CF5A918BF0C2028796AF7718C5476E); // shasta
    
    IJustswapFactory public constant JUSTSWAP_FACTORY = IJustswapFactory(
        // address(0x41EED9E56A5CDDAA15EF0C42984884A8AFCF1BDEBB) // mainnet
        address(0x415D2840648A30B65695FC342D4E202C4947975FC5) // shasta
    );

    ILiquidityGuard public constant LIQUIDITY_GUARD = ILiquidityGuard(
        // 0x9C306CaD86550EC80D77668c0A8bEE6eB34684B6 // mainnet
        // 0x0C914aAE959e3099815e373d94DFfBA5F9E0Fdf8 // ropsten
        // 0xEeAd57F022Af8f6b2544BFE7A39C80CdCFe07E4E // 
        0x41
    );

    IJustswapExchange public JUSTSWAP_EXCHANGE;
    bool public isLiquidityGuardActive;

    uint256 public latestTetherEquivalent;

    constructor() public {
        // LAUNCH_TIME = 1605052800; // (11th November 2020 @00:00 GMT == day 0)
        // LAUNCH_TIME = 1604966400; // (10th November 2020 @00:00 GMT == day 0)
        LAUNCH_TIME = block.timestamp;
    }
    
    function createExchange() external {
        JUSTSWAP_EXCHANGE = IJustswapExchange(
            JUSTSWAP_FACTORY.createExchange(WBTC)
        );
    }

    struct Stake {
        uint256 stakesShares;
        uint256 stakedAmount;
        uint256 rewardAmount;
        uint64 startDay;
        uint64 lockDays;
        uint64 finalDay;
        uint64 closeDay;
        uint256 scrapeDay;
        uint256 tetherEquivalent;
        uint256 referrerShares;
        address referrer;
        bool isActive;
    }

    struct ReferrerLink {
        address staker;
        bytes16 stakeID;
        uint256 rewardAmount;
        uint256 processedDays;
        bool isActive;
    }

    struct LiquidityStake {
        uint256 stakedAmount;
        uint256 rewardAmount;
        uint64 startDay;
        uint64 closeDay;
        bool isActive;
    }

    struct CriticalMass {
        uint256 totalAmount;
        uint256 activationDay;
    }

    mapping(address => uint256) public stakeCount;
    mapping(address => uint256) public referralCount;
    mapping(address => uint256) public liquidityStakeCount;

    mapping(address => CriticalMass) public criticalMass;
    mapping(address => mapping(bytes16 => uint256)) public scrapes;
    mapping(address => mapping(bytes16 => Stake)) public stakes;
    mapping(address => mapping(bytes16 => ReferrerLink)) public referrerLinks;
    mapping(address => mapping(bytes16 => LiquidityStake)) public liquidityStakes;

    mapping(uint256 => uint256) public scheduledToEnd;
    mapping(uint256 => uint256) public referralSharesToEnd;
    mapping(uint256 => uint256) public totalPenalties;
}
