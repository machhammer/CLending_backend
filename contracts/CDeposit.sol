// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;


import "./CElement.sol";


contract CDeposit is CElement{ 

    event Debug (uint);

    function addDeposit(uint duration_in_days) external payable {        
        addElement("Deposit", duration_in_days);
    }

    function removeDeposit(bytes32 _key) public  {
        removeElement(_key);
    }
    
    function containsDeposit(bytes32 _key) public view returns (bool) {
        return containsElement(_key);
    }
    
    function handbackExpiredDeposits() public {
        handbackExpiredElements();
    }

    function handbackDeposit(bytes32 _key) public {
        handbackElement(_key);
    }

    function getDepositByKey(bytes32 _key) public view returns (Element memory) {
        return getElementByKey(_key);
    }

    function sizeDeposit() public view returns (uint) {
        return sizeElement();
    }

    function getDepositKeys() public view returns (bytes32[] memory) {
        return getElementKeys();
    }

   function getDepositAddresses() public view returns (address[] memory) {
        return getElementAddresses();
    }

    function getDepositbyAddress(address _address) public view returns (Element[] memory) {
        return getElementbyAddress(_address);
    }

    function getAllDeposits() public view returns (Element[] memory) {
        return getAllElements();
    }
    
}