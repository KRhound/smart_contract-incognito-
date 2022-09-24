// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Overflow{


    function overflow() public /* view -> */ pure returns(uint8){
        uint8 big = 255 + uint8(100);
        return big;
    }
}