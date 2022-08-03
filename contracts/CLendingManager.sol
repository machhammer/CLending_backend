// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "./CCollection.sol";


import "@openzeppelin/contracts/access/Ownable.sol";


contract CLendingManager is Ownable, CCollection {

    event Debug (uint256 info);
    event Debug2 (address info);
    

    function getOwner() external view returns (address)  {
        return owner();
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function stake(uint duration_in_days) external payable {
        addElement(1, duration_in_days, 0);
    }

    function collateral(uint duration_in_days) external payable {
        addElement(2, duration_in_days, 0);
    }

    function borrow(uint256 amount, address payable borrower) external {
        uint256 _sum_collaterals;
        Element[] memory collaterals = getElementByElementTypeAndAddress(2, borrower);

        for (uint i = 0; i < collaterals.length; i++) {
            _sum_collaterals += collaterals[i].amount;
        }
        
        uint256 _sum_borrowings;
        Element[] memory borrowings = getElementByElementTypeAndAddress(3, borrower);

        for (uint i = 0; i < borrowings.length; i++) {
            _sum_borrowings += borrowings[i].amount;
        }

        require(
            _sum_collaterals >= _sum_borrowings + amount,
            "Not enough collateral."
        );

        addElement(3, 10, amount);
        borrower.transfer(amount);
    }

}