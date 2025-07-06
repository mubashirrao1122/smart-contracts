// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EventDemo {
    uint public number;

    event NumberUpdated(uint newNumber);

    function updateNumber(uint _number) public {
        number = _number;
        emit NumberUpdated(_number);
    }
}