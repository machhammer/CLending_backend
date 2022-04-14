// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

struct Deposit {
    address depositor;
    uint256 amount;
    uint256 timestamp;
    uint duration_in_month;
}


contract CDeposit {

    mapping(bytes32 => Deposit) internal map;
    
    bytes32[] internal keyList;
    address[] internal addressList;

    event Debug (uint);

    function addDeposit(uint duration_in_month) external payable {
        bytes32 _key = keccak256(abi.encode(msg.sender, block.timestamp, sizeDeposit()));
        Deposit memory _deposit = Deposit(msg.sender, msg.value, block.timestamp, duration_in_month);
        map[_key] = _deposit;
        keyList.push(_key);
        bool found = false;
        for (uint i = 0; i < addressList.length; i++) {
            if (addressList[i] == msg.sender) {
                found = true;
            }
        }
        if (found==false) addressList.push(msg.sender);
    }

    function removeDeposit(bytes32 _key) public  {
        address _depositor = map[_key].depositor;

        uint _count = 0;
        uint _id = 0;
        for (uint i = 0; i < addressList.length; i++) {
            if (addressList[i] == _depositor) {
                _count ++;
                _id = i;
            }
        }
        if (_count==1) {
            addressList[_id] = addressList[addressList.length - 1];
            addressList.pop();
        }

        for (uint i = 0; i < keyList.length; i++) {
            if (keyList[i] == _key) {
                _id = i;
            }
        }
        keyList[_id] = keyList[keyList.length - 1];
        keyList.pop();
        
        delete map[_key];
        
    }
    
    function containsDeposit(bytes32 _key) public view returns (bool) {
        return map[_key].timestamp != 0;
    }
    
    function getDepositByKey(bytes32 _key) public view returns (Deposit memory) {
        return map[_key];
    }

    function sizeDeposit() public view returns (uint) {
        return uint(keyList.length);
    }
    
    function getDepositKeys() public view returns (bytes32[] memory) {
        return keyList;
    }

   function getDepositAddresses() public view returns (address[] memory) {
        return addressList;
    }

    function getDepositbyAddress(address _address) public view returns (Deposit[] memory) {
        uint256 _resultCount;

        for (uint i = 0; i < keyList.length; i++) {
            if (map[keyList[i]].depositor == _address) {
                _resultCount++;
            }
        }
        
        Deposit[] memory _deposits = new Deposit[](_resultCount);
        uint256 j;

        for (uint i = 0; i < keyList.length; i++) {
            if (map[keyList[i]].depositor == _address) {
                _deposits[j] = map[keyList[i]];
                j++;
            }
        }
        return _deposits;
    }

    

}