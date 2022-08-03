// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";


struct Element {
    bytes32 key;
    uint element_type;
    address participant;
    uint256 amount;
    uint    duration_in_days;
    uint256 timestamp;
    bool    expired;
}


contract CCollection is Ownable{

    mapping(bytes32 => Element) internal map;
    
    bytes32[] internal keyList;
    address[] internal addressList;


    function addElement(uint element_type, uint duration_in_days, uint256 amount) internal {
        bytes32 _key = keccak256(abi.encode(msg.sender, block.timestamp, sizeCollection()));
        uint256 _value = 0;
        if (amount == 0) {
            _value = msg.value;
        } else {
            _value = amount;
        }
        Element memory _element = Element(_key, element_type, msg.sender, _value, duration_in_days, block.timestamp, false);
        map[_key] = _element;
        keyList.push(_key);
        bool found = false;
        for (uint i = 0; i < addressList.length; i++) {
            if (addressList[i] == msg.sender) {
                found = true;
            }
        }
        if (found==false) addressList.push(msg.sender);
    }

    function removeElement(bytes32 _key) internal  {
        address _participant = map[_key].participant;

        uint _count = 0;
        uint _id = 0;
        for (uint i = 0; i < addressList.length; i++) {
            if (addressList[i] == _participant) {
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
    
    function containsElement(bytes32 _key) public view returns (bool) {
        return map[_key].timestamp != 0;
    }
    
    function handbackExpiredElements() internal {
        Element[] memory _elements = getAllElements();
        for (uint i = 0; i < _elements.length; i++) {
            if (_elements[i].expired == true) {
                transferAmount(_elements[i].participant, _elements[i].amount);
                removeElement(_elements[i].key);
            }
        }
    }

    function handbackElement(bytes32 _key) internal {
        Element memory _element = getElementByKey(_key);
        transferAmount(_element.participant, _element.amount);
        removeElement(_element.key);
    }

    function transferAmount(address receiver, uint256 amount) internal {
        payable(receiver).transfer(amount);
    }
    
    function getElementByKey(bytes32 _key) internal view returns (Element memory) {
        Element memory _element = map[_key];
        bool _expired = false;
        if (block.timestamp >= _element.timestamp + _element.duration_in_days * 60 * 60 * 24)
            _expired = true;
        else
            _expired = false;
        _element.expired = _expired;
        return _element;
    }

    function sizeCollection() public view returns (uint) {
        return uint(keyList.length);
    }

    function getElementKeys() public view returns (bytes32[] memory) {
        return keyList;
    }

   function getElementAddresses() public view returns (address[] memory) {
        return addressList;
    }

    function getElementbyAddress(address _address) public view returns (Element[] memory) {
        uint256 _resultCount;

        for (uint i = 0; i < keyList.length; i++) {
            if (map[keyList[i]].participant == _address) {
                _resultCount++;
            }
        }
        
        Element[] memory _elements = new Element[](_resultCount);
        uint256 j;

        for (uint i = 0; i < keyList.length; i++) {
            if (map[keyList[i]].participant == _address) {
                _elements[j] = getElementByKey(keyList[i]);
                j++;
            }
        }
        return _elements;
    }

    function getElementByElementType(uint _elementType) public view returns (Element[] memory) {
        uint256 _resultCount;

        for (uint i = 0; i < keyList.length; i++) {
            if (map[keyList[i]].element_type == _elementType) {
                _resultCount++;
            }
        }
        
        Element[] memory _elements = new Element[](_resultCount);
        uint256 j;

        for (uint i = 0; i < keyList.length; i++) {
            if (map[keyList[i]].element_type == _elementType) {
                _elements[j] = getElementByKey(keyList[i]);
                j++;
            }
        }
        return _elements;
    }

    function getElementByElementTypeAndAddress(uint _elementType, address _address) public view returns (Element[] memory) {
        uint256 _resultCount;

        for (uint i = 0; i < keyList.length; i++) {
            if (map[keyList[i]].element_type == _elementType && map[keyList[i]].participant == _address) {
                _resultCount++;
            }
        }
        
        Element[] memory _elements = new Element[](_resultCount);
        uint256 j;

        for (uint i = 0; i < keyList.length; i++) {
            if (map[keyList[i]].element_type == _elementType && map[keyList[i]].participant == _address) {
                _elements[j] = getElementByKey(keyList[i]);
                j++;
            }
        }
        return _elements;
    }

    function getAllElements() public view returns (Element[] memory) {
        
        Element[] memory _elements = new Element[](keyList.length);

        for (uint i = 0; i < keyList.length; i++) {
            _elements[i] = getElementByKey(keyList[i]);
        }
        return _elements;
    }
    
}