// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

interface IBaseToken {

    function setup(string memory image, uint256 supply, uint256 mintPrice) external;

}