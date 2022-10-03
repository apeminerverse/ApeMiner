// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

error OnlyExternallyOwnedAccountsAllowed();
error AmountExceedsSupply();
error UserHadOne();

contract ApeMinerInfinityGauntlet is ERC721A, Ownable {
    using Strings for uint256;

    uint256 public constant MAX_SUPPLY = 300;

    string private _baseTokenURI;

    mapping(address => bool) users;

    event AirdropStart();
    event AirdropPaused();
    event baseUIRChanged(string);

    constructor(string memory baseURI)
        ERC721A("AprMinerYachtPartyAirdrop", "AYA")
    {
        _baseTokenURI = baseURI;
    }

    // Airdrop

    function airdropMint(address[] memory _to) external onlyOwner {
        if (totalSupply() + _to.length > MAX_SUPPLY)
            revert AmountExceedsSupply();

        for (uint256 i = 0; i < _to.length; i++) {
            if (users[_to[i]]) revert UserHadOne();
            _safeMint(_to[i], 1);
            users[_to[i]] = true;
        }
    }

    // METADATA

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function tokensOf(address owner) public view returns (uint256[] memory) {
        uint256 count = balanceOf(owner);
        uint256[] memory tokenIds = new uint256[](count);
        for (uint256 i; i < count; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(owner, i);
        }
        return tokenIds;
    }

    // DISPLAY

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(_exists(tokenId), "nonexistent token");
        bytes memory meta = abi.encodePacked(
            '{"name": "Infinity Gauntlet #',
            tokenId.toString(),
            '", "description": "This is the limited edition NFT of Miner Ape, jointly issued by ape miner and filswan.Infinity Gauntlet is the first accessory in the ape miner ecology.", "image": "',
            _baseTokenURI,
            '", "designer": "apeminer.io","attributes": [{"trait_type": "Date","value": "2022-09-27"},{"trait_type": "In-memory","value": "ApeMiner Yacht Party 2022"}, {"trait_type": "Gmstones","value": "2"}, {"trait_type": "Skills","value": "Enhanced earnings"}, {"trait_type": "Upgradeable","value": "None"}]}'
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(meta)
                )
            );
    }

    // OWNERS + HELPERS
    function setURInew(string memory uri)
        external
        onlyOwner
        returns (string memory)
    {
        _baseTokenURI = uri;
        emit baseUIRChanged(uri);
        return _baseTokenURI;
    }
}
