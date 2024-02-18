// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {IWETH} from "./interfaces/IWETH.sol";
import {ReceiptToken, RewardToken} from "./receiptToken.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IUniswapV2Router02} from "./interfaces/IUniswapV2.sol";

contract Staker is Ownable(msg.sender) {
    IWETH weth;
    IUniswapV2Router02 uniRouter;
    ReceiptToken public receiptToken;
    RewardToken public rewardToken;
    uint256 public totalFee;
    uint256 public totalRewards;
    uint256 public lastCompounding;

    struct StakeInfo {
        uint256 totalStaked;
        uint256 totalReward;
        uint256 lastStaked;
        bool allowCompound;
    }

    mapping(address => StakeInfo) public stakers;
    mapping(address => bool) public hasStaked;
    address[] public stakerArr;

      constructor() {
        weth = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        uniRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        receiptToken = new ReceiptToken();
        rewardToken = new RewardToken();
        lastCompounding = block.timestamp;
    }

        function stake(bool _allowCompound) public payable {
        StakeInfo storage _staker = stakers[msg.sender];

        (bool success,) = address(weth).call{value: msg.value}("");
        if (!success) revert("Staking Failed");
        uint256 _totalStaked = _staker.totalStaked + msg.value;
        uint256 _totalReward = _calculateReward(_staker);

        _staker.totalStaked = _totalStaked;
        _staker.totalReward += _totalReward;
        totalRewards += _totalReward;
        _staker.lastStaked = block.timestamp;
        _staker.allowCompound = _allowCompound;

        if (!hasStaked[msg.sender]) {
            stakerArr.push(msg.sender);
            hasStaked[msg.sender] = true;
        }

        if (_allowCompound) {
            receiptToken.mint(msg.sender, msg.value * 99 / 100);
            totalFee += msg.value * 1 / 100;
        } else {
            receiptToken.mint(msg.sender, msg.value);
        }
    }

}