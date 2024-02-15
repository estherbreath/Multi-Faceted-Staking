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
}