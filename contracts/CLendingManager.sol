// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "./CBorrow.sol";
import "./CDeposit.sol";


import "@openzeppelin/contracts/access/Ownable.sol";




contract CLendingManager is Ownable, CDeposit, CBorrow {

    function getOwner() external view returns (address)  {
        return owner();
    }


    
}