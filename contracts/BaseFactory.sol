// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./BaseToken.sol";
import "./InitBaseToken.sol";

error NotAllowed(address account);

contract BaseFactory is Ownable {

    event AddAllowed(address newAddress);

    event TokenCreated(address contractAddress);

    mapping(address => bool) private _allowedWallets;

    constructor() Ownable(_msgSender()) {
        addAllowed(owner());
    }

    function addAllowed(address newAddress) public onlyOwner {
        _allowedWallets[newAddress] = true;
        emit AddAllowed(newAddress);
    }

    function addBaseToken(string memory name, string memory symbol) public onlyAllowed returns (address) {
        IBaseToken t = new BaseToken(_msgSender(), name, symbol);
        return _createBaseToken(t);
    }

    function addSetupBaseToken(string memory name, string memory symbol, string memory image, uint256 supply, uint256 mintPrice) public onlyAllowed returns (address) {
        IBaseToken t = new BaseToken(_msgSender(), name, symbol);
        t.setup(image, supply, mintPrice);
        return _createBaseToken(t);
    }

    function addInitBaseToken(string memory name, string memory symbol, string memory image, uint256 supply, uint256 mintPrice) public onlyAllowed returns (address) {
        IBaseToken t = new InitBaseToken(_msgSender(), name, symbol, image, supply, mintPrice);
        return _createBaseToken(t);
    }

    function _createBaseToken(IBaseToken token) internal returns (address) {
        emit TokenCreated(address(token));
        return address(token);
    }

    modifier onlyAllowed() {
        _checkAllowed();
        _;
    }
    
    /**
     * @dev Throws if the sender is not allowed
     */
    function _checkAllowed() internal view virtual {
        if (!_allowedWallets[_msgSender()]) {
            revert NotAllowed(_msgSender());
        }
    }

}