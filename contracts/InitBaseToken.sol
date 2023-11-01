// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./BaseToken.sol";

contract InitBaseToken is BaseToken {

    constructor(address initialOwner, string memory name, string memory symbol, string memory image, uint256 supply, uint256 mintPrice) 
        BaseToken(initialOwner, name, symbol) {
            setup(image, supply, mintPrice);
    }

}