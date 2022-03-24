// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";



contract CDeposit is Ownable {
    
    mapping(address => uint) private depositor_amount;

    function depositAmount() external payable {
        depositor_amount[msg.sender] = msg.value;
    }

    function getDepositFor(address _addr) external onlyOwner view returns (uint256) {
        return depositor_amount[_addr];
    }
    
    function getDepositBalance() public view returns (uint256) {
        return address(this).balance;
    }

}