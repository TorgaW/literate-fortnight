// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Promise is ERC721, ERC721Enumerable, Ownable {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    string private _uri;
    uint256 private _maxSupply;

    // if you give a public promise, you should set this to 'true'
    bool private _isPublicPromise;

    // only trusted friends can see your promise
    address[] private _allowners;

    // you can customise your promise
    struct PromiseStruct {

        string image;
        string text;

    }

    // promise by default is nothing
    PromiseStruct _myPromise = PromiseStruct("","");

    // but when you realize all responsibility you can deploy REAL promise
    constructor(string memory uri, bool isPublic, string memory image, string memory text) ERC721("Promise for my love", "LOV") {
        _uri = uri;
        _isPublicPromise = isPublic;
        _maxSupply = 1;
        _myPromise.image = image;
        _myPromise.text = text;
        _mint(owner(), 0);
    }

    // add wallet to allowners
    function addTrustedFriend(address inaddr) public payable onlyOwner returns(bool) {
        if(isTrustedUser(inaddr))
            return false;
        _allowners.push(inaddr);
        return true;
    }

    // see your promise
    function getPromise() public view returns(string memory image, string memory text) {
        if(_isPublicPromise)
        {
            image = _myPromise.image;
            text = _myPromise.text;
        }
        else
        {
            if(ownerOf(0) == msg.sender)
            {
                image = _myPromise.image;
                text = _myPromise.text;
            }
            else
            {
                image = "Your are not trusted";
                text = "Your are not trusted";
            }
        }
    }

    // returns if this user is trusted to see your promise
    function isTrustedUser(address usr) public view returns(bool){
        if(owner() == usr)
            return true;
        for(uint i = 0; i < _allowners.length; i++)
        {
            if(_allowners[i] == usr)
                return true;
        }
        return false;
    }

    // you can transfer your promise with ownership
    function transferPromise(address to) public payable {
        transferFrom(msg.sender, to, 0);
        transferOwnership(to);
    }

    // change promise privacy 
    function setIsPublicPromise(bool newState) public payable onlyOwner {
        _isPublicPromise = newState;
    }


    // getters
    function getIsPublicPromise() public view returns(bool) { return _isPublicPromise; }

    function getMaxSupply() external view returns (uint256) { return _maxSupply; }

    function getBaseURI() external view returns (string memory) { return _uri; }
    //

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
        delete _allowners;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}