// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import { StringUtils } from "./libs/StringUtils.sol";
import {Base64} from "./libs/Base64.sol";
import "hardhat/console.sol";


contract Domains is ERC721URIStorage{
    // Here's our domain TLD!
  string public tld;
    struct Record{
        address owner;
        string ip;
    }

  // A "mapping" data type to store their names
  mapping(string => Record) public domains;

// Checkout our new mapping! This will store values
//   mapping(string => string) public records;

  constructor(string memory _tld) payable {
    tld = _tld;
    console.log("%s name service deployed", _tld);
  }



  // A register function that adds their names to our mapping
  function register(string calldata name) public payable{
      require(getAddress(name) == address(0));
      uint _price = price(name);
      // Check if enough Matic was paid in the transaction
        require(msg.value >= _price, "Not enough Matic paid");
      setAddress(name, msg.sender);
      console.log("%s has registered a domain!", msg.sender);
  }

// This function will give us the price of a domain based on length
  function price(string calldata name) public pure returns(uint) {
    uint len = StringUtils.strlen(name);
    require(len > 0);
    if (len == 3) {
      return 5 * 10**17; // 5 MATIC = 5 000 000 000 000 000 000 (18 decimals). We're going with 0.5 Matic cause the faucets don't give a lot
    } else if (len == 4) {
      return 3 * 10**17; // To charge smaller amounts, reduce the decimals. This is 0.3
    } else {
      return 1 * 10**17;
    }
  }


  // This will give us the domain owners' address
  function getAddress(string calldata name) public view returns (address) {
      return domains[name].owner;
  }

  function setAddress(string calldata name, address caller) public {
      domains[name].owner = caller;
  }

  function getIp(string calldata name) public view returns (string memory){
      return domains[name].ip;
  }

  function setIp(string calldata name, string calldata ip) public {
      require(getAddress(name) == msg.sender);
      domains[name].ip = ip;
  }

//   function setRecord(string calldata name, string calldata record) public {
//       // Check that the owner is the transaction sender
//       require(getAddress(name) == msg.sender);
//       records[name] = record;
//   }

//   function getRecord(string calldata name) public view returns(string memory) {
//       return records[name];
//   }
}