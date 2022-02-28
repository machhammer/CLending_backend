pragma solidity ^0.8.10;

import "./CDeposit.sol";
import "./CBorrow.sol";

import "@openzeppelin/contracts/access/Ownable.sol";


contract CLendingManager is Ownable, CBorrow, CDeposit{
    
    function getOwner() external view returns (address)  {
        return owner();
    }

}