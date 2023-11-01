// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./InitBaseToken.sol";

contract BaseTokenExample is InitBaseToken {

   constructor() InitBaseToken(
    _msgSender(),
    "NFT Test", 
    "NFT", 
    "ipfs://bafybeigi65dui5cikqizz4qpxwighq6sw66w4xavoqu3enoxgheckybt34",
    1000, 
    0) {

    }

}