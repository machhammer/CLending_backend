// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";


contract CBorrow is Ownable{

    struct Credit {
        bytes32 id;
        address borrower;
        uint256 amount;
        bool confirmed;
        uint256 timestamp;
        uint duration_in_month;
    }

    uint private applications_count = 0;

    mapping(bytes32 => Credit) private borrower_application;
    
    mapping(address => uint) private applications;
    address[] private all_borrowers;
    bytes32[] private all_ids;

    mapping(address => uint) private borrower_confirmed_amount;



    function applyForCredit(address payable applicant, uint256 amount, uint duration_in_month) external  {
        require ((address(this).balance > amount), "Not enough balance");
        bytes32 id = keccak256(abi.encode(msg.sender, block.timestamp));
        borrower_application[id] = Credit(id, msg.sender, amount, true, block.timestamp, duration_in_month);
        applicant.transfer(amount);
        all_borrowers.push(msg.sender);
        all_ids.push(id);
        applications_count++;
    }

    function getApplications() external onlyOwner view returns (Credit[] memory)  {
        Credit[] memory c_list = new Credit[](applications_count);
        for (uint i = 0; i < applications_count; i++) {
          Credit storage application = borrower_application[all_ids[i]];
          c_list[i] = application;
        }
        return c_list;
    }
}