// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MappingArrayDemo {
    mapping(address => uint) public balances;
    uint[] public numbers;

    function setBalance(uint _amount) public {
        balances[msg.sender] = _amount;
    }

    function addNumber(uint _num) public {
        numbers.push(_num);
    }

    function getNumber(uint _index) public view returns (uint) {
        return numbers[_index];
    }
}