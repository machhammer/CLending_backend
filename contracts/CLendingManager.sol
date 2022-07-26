// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "./CCollection.sol";


import "@openzeppelin/contracts/access/Ownable.sol";


contract CLendingManager is Ownable, CCollection {

    event Debug (uint256 info);

    function getOwner() external view returns (address)  {
        return owner();
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
   function borrow(uint256) external view returns (uint256) {
        uint256 _sum_collaterals;
        Element[] memory collaterals = getElementByElementTypeAndAddress(2, msg.sender);

        for (uint i = 0; i < collaterals.length; i++) {
            _sum_collaterals += collaterals[i].amount;
        }
        
        return _sum_collaterals;
    }
 

}