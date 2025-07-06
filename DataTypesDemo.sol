// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataTypesDemo {
    uint public myUint;
    int public myInt;
    bool public myBool;
    address public myAddress;
    string public myString;

    function setValues(uint _u, int _i, bool _b, address _a, string memory _s) public {
        myUint = _u;
        myInt = _i;
        myBool = _b;
        myAddress = _a;
        myString = _s;
    }
}