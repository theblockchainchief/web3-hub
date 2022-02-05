//SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import { Base64 } from "./libraries/Base64.sol";

/// @title TextNFT
/// @author Abhinav Pathak
/// @notice This contract is used to create an NFT token that can be minted and owned by anyone.
/// @dev Inherits from ERC721URIStorage contract for ERC-721 token functionality.
/// @dev Uses Counters library for tracking tokenId of the minted tokens.
/// @dev Uses Base64 library for for encoding the tokenURI.
contract TextNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;
   
    string public collectionName;
    string public collectionSymbol;


    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] element = [
        'Fire',
        'Wind',
        'Wave',
        'Earth',
        'Thunder',
        'Space',
        'Time'
    ];

    string[] weapon = [
        'Sword',
        'Spear',
        'Shield',
        'Hammer',
        'Saber',
        'Axe',
        'Bow'
    ];

    string[] rank = [
        'Lord',
        'King',
        'Emperor',
        'Venerable',
        'Ancestor',
        'Saint',
        'God'
    ];

    constructor() ERC721("TextNFT", "TNFT") {
        collectionName = name();
        collectionSymbol = symbol();
    }


    /// @notice Generates a random number using hash of the encoded imput string
    /// @param _input The string used in generating random number
    /// @return uint256 The random number generated
    function random(string memory _input) internal pure returns(uint256) {
        return uint256(keccak256(abi.encodePacked(_input)));
    }


    /// @notice Randomly picks first word of the NFT from the element array
    /// @param tokenId TokenId of the current NFT
    /// @return string The word picked from the array
    function pickFirstWord(uint256 tokenId) public view returns(string memory) {
        uint256 rand = random(string(abi.encodePacked("element", Strings.toString(tokenId))));
        rand = rand % element.length;
        return element[rand];
    }


    /// @notice Randomly picks second word of the NFT from the wepon array
    /// @param tokenId TokenId of the current NFT
    /// @return string The word picked from the array
    function pickSecondWord(uint256 tokenId) public view returns(string memory) {
        uint256 rand = random(string(abi.encodePacked("weapon", Strings.toString(tokenId))));
        rand = rand % weapon.length;
        return weapon[rand];
    }


    /// @notice Randomly picks third word of the NFT from the wepon array
    /// @param tokenId TokenId of the current NFT
    /// @return string The word picked from the array
    function pickThirdWord(uint256 tokenId) public view returns(string memory) {
        uint256 rand = random(string(abi.encodePacked("rank", Strings.toString(tokenId))));
        rand = rand % rank.length;
        return rank[rand];
    }


    /// @notice Mints a new Eternal NFT token
    /// @dev uses generates a final tokenURI by using the base64 encoded json data
    /// @return uint256 The tokenId of the minted NFT
    function createTextNFT() public returns(uint256) {
        uint256 newItemId = _tokenId.current();

        string memory first = pickFirstWord(newItemId);
        string memory second = pickSecondWord(newItemId);
        string memory third = pickThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first,second,third));

        string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                    '{"name": "',
                        combinedWord,
                        '", "description": "A highly acclaimed collection Eternal Warriors", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                    '"}'
                    )
                )
            )
        );

        string memory finalTokenURI = string(abi.encodePacked(
            "data:application/json;base64,", json
        ));
    
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenURI);

        _tokenId.increment();

        return newItemId;
    }
}