// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {IBaseToken} from "./interfaces/IBaseToken.sol";

error NotEnough();

error NotToken();

error OverSupply();

error NotTransfer();

contract BaseToken is ERC721, Ownable, IBaseToken {

    string private _image = "";
    uint256 private _maxSupply = 0;
    uint256 private _mintPrice = 0 ether;
    bool private _freeMint = true;

    uint256 private _tokenIdCounter = 0;

    constructor(address initialOwner, string memory name, string memory symbol) 
        ERC721(name, symbol)
        Ownable(initialOwner) {
    }

    function setup(string memory image, uint256 supply, uint256 mintPrice) public onlyOwner override(IBaseToken) {
        _image = image;
        _maxSupply = supply;
        _mintPrice = mintPrice;
    }

    function contractURI() public view virtual returns (string memory) { 
        return string(abi.encodePacked('data:application/json,', string(abi.encodePacked(
          '{',
              '"name": "', name(), '"',
              ', "image": "', _image, '"',
              ', "external_link": "https://linktr.ee/nftgate"',
              ', "external_url": "https://linktr.ee/nftgate"',
          '}'
        ))));
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721) returns (string memory) {
        if (tokenId < 0) {
            revert NotToken();
        }
        return contractURI();
    }

    function mint(uint quantity) public payable {
        smint(quantity);
        transferAmount(msg.value);
    }

    function smint(uint quantity) public payable {
        if ( (_tokenIdCounter + quantity) > _maxSupply ) {
            revert OverSupply();
        }
        if ( !_freeMint && (msg.value < (_mintPrice * quantity)) ) {
            revert NotEnough();
        }
        uint256 i = 0;
        do {
            _mint(_msgSender(), _tokenIdCounter + 1);
            unchecked{++_tokenIdCounter;}
            unchecked{++i;}            
        } while (i < quantity);
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(owner()).transfer(balance);
    }

    function transferAmount(uint256 value) internal {
        if (msg.value > 0) {
            (bool success, ) = owner().call{ value: value }("");
            if (!success) {
                revert NotTransfer();
            }
        }
    }

    function toggleFMint() public onlyOwner {
        _freeMint = !_freeMint;
    }

    function totalSupply() public view returns (uint256) {
        return _tokenIdCounter;
    }

    function maxSupply() public view returns (uint256) {
        return _maxSupply;
    }

    function price() public view returns (uint256) {
        return _mintPrice;
    }

}