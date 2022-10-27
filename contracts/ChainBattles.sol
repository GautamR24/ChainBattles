//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol"; //For minting NFT's
import "@openzeppelin/contracts/utils/Counters.sol"; //for adding some tokenIds
import "@openzeppelin/contracts/utils/Base64.sol"; // helps while working with svg's
import "@openzeppelin/contracts/utils/Strings.sol"; //will be used for typecasting

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct traits {
        uint256 Level;
        uint256 Speed;
        uint256 Strength;
        uint256 Life;
    }

    mapping(uint256 => traits) public tokenIdToLevels;

    constructor() ERC721("Chain Battles", "CBTLS") {}

    function generateCharacter(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior",
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Levels: ",
            getLevels(tokenId),
            "Speed: ",
            getSpeed(tokenId),
            "Strength: ",
            getStrength(tokenId),
            "Life: ",
            getLife(tokenId),
            "</text>",
            "</svg>"
        );
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getLevels(uint256 tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToLevels[tokenId].Level;
        return levels.toString(); //we are converting to strings because the content of abi.encode must always resolve to a string
    }

    function getSpeed(uint256 tokenId) public view returns (string memory) {
        uint256 speed = tokenIdToLevels[tokenId].Speed;
        return speed.toString(); //we are converting to strings because the content of abi.encode must always resolve to a string
    }

    function getStrength(uint256 tokenId) public view returns (string memory) {
        uint256 strength = tokenIdToLevels[tokenId].Strength;
        return strength.toString(); //we are converting to strings because the content of abi.encode must always resolve to a string
    }

    function getLife(uint256 tokenId) public view returns (string memory) {
        uint256 life = tokenIdToLevels[tokenId].Life;
        return life.toString(); //we are converting to strings because the content of abi.encode must always resolve to a string
    }

    /*
     * @dev this will be used for generating the Json object
     */
    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            tokenId.toString(),
            '",',
            '"description": "Battles on chain",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToLevels[newItemId].Level = 0;
        tokenIdToLevels[newItemId].Speed = 0;
        tokenIdToLevels[newItemId].Strength = 0;
        tokenIdToLevels[newItemId].Life = 0;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Please use an existing token");
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this token to train it"
        );
        uint256 currentLevel = tokenIdToLevels[tokenId].Level;
        tokenIdToLevels[tokenId].Level = currentLevel + 1;
        tokenIdToLevels[tokenId].Level = currentLevel + 1;
        tokenIdToLevels[tokenId].Speed = currentLevel + 1;
        tokenIdToLevels[tokenId].Strength = currentLevel + 1;
        tokenIdToLevels[tokenId].Life = currentLevel + 1;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}
