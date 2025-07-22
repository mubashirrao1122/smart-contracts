// SPDX-License-Identifier: MIT

pragma solidity 0.8.30;

import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory{
    SimpleStorage[] public listOfSimpleStorage;

    function createSimpleStorageContract() public {
        
        SimpleStorage newsimpleStorage = new SimpleStorage();
        listOfSimpleStorage.push(newsimpleStorage);
    }
    function sfStore(uint256 _simpleStorageIndex, uint256 _newSimpleStorageNumber)public{
        SimpleStorage mySimpleStorage = listOfSimpleStorage[_simpleStorageIndex];
        mySimpleStorage.store(_newSimpleStorageNumber);
    }
    function sfGet(uint _simpleStorageIndex) public view returns(uint256){
        return listOfSimpleStorage[_simpleStorageIndex].retrieve();
    }
}
