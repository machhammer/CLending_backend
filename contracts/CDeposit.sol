// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

struct Deposit {
    bytes32 key;
    address depositor;
    uint256 amount;
    uint256 timestamp;
    uint duration_in_days;
    bool expired;
}


contract CDeposit {

    mapping(bytes32 => Deposit) internal map;
    
    bytes32[] internal keyList;
    address[] internal addressList;

    event Debug (uint);

    function addDeposit(uint duration_in_days) external payable {
        bytes32 _key = keccak256(abi.encode(msg.sender, block.timestamp, sizeDeposit()));
        Deposit memory _deposit = Deposit(_key, msg.sender, msg.value, block.timestamp, duration_in_days, true);
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
    
    function handbackExpiredDeposits() public {
        Deposit[] memory _deposits = getAllDeposits();
        for (uint i = 0; i < _deposits.length; i++) {
            if (_deposits[i].expired == true) {
                transferAmount(_deposits[i].depositor, _deposits[i].amount);
                removeDeposit(_deposits[i].key);
            }
        }
    }

    function handbackDeposit(bytes32 _key) public {
        Deposit memory _deposit = getDepositByKey(_key);
        transferAmount(_deposit.depositor, _deposit.amount);
        removeDeposit(_deposit.key);
    }

    function transferAmount(address receiver, uint256 amount) internal {
        payable(receiver).transfer(amount);
    }
    
    function getDepositByKey(bytes32 _key) public view returns (Deposit memory) {
        Deposit memory _deposit = map[_key];
        bool _expired = false;
        if (block.timestamp >= _deposit.timestamp + _deposit.duration_in_days * 60 * 60 * 24)
            _expired = true;
        else
            _expired = false;
        _deposit.expired = _expired;
        return _deposit;
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
                _deposits[j] = getDepositByKey(keyList[i]);
                j++;
            }
        }
        return _deposits;
    }

    function getAllDeposits() public view returns (Deposit[] memory) {
        
        Deposit[] memory _deposits = new Deposit[](keyList.length);

        for (uint i = 0; i < keyList.length; i++) {
            _deposits[i] = getDepositByKey(keyList[i]);
        }
        return _deposits;
    }
    
}