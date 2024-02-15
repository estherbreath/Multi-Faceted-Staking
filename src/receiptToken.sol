// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IUniswapV2Router02} from "./interfaces/IUniswapV2.sol";

contract ReceiptToken is Ownable(msg.sender), ERC20("Boss-WETH", "JWETH") {
    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }

        function burn(uint256 _amount) public onlyOwner {
        _burn(address(909), _amount);
    }

}

  contract RewardToken is Ownable(msg.sender), ERC20("boss-reward", "BRWD") {
    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }
}

