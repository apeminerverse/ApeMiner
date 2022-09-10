// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

error OnlyExternallyOwnedAccountsAllowed();
error AmountExceedsSupply();
error UserHadOne();

contract YachtPartyAirdrop is ERC721A, Ownable {
    using Strings for uint256;

    uint256 public constant MAX_SUPPLY = 300;
    uint256 private constant FAR_FUTURE = 0xFFFFFFFFF;

    string private _baseTokenURI;

    mapping(address => bool) users;

    event AirdropStart();
    event AirdropPaused();
    event baseUIRChanged(string);

    modifier onlyEOA() {
        if (tx.origin != msg.sender)
            revert OnlyExternallyOwnedAccountsAllowed();
        _;
    }

    constructor(string memory baseURI)
        ERC721A("AprMinerYachtPartyAirdrop", "AYA")
    {
        _baseTokenURI = baseURI;
    }

    // Airdrop

    function airdropMint(address[] memory _to) external onlyEOA onlyOwner {
        if (totalSupply() + _to.length > MAX_SUPPLY)
            revert AmountExceedsSupply();

        for (uint256 i = 0; i < _to.length; i++) {
            if (users[msg.sender]) revert UserHadOne();
            _safeMint(_to[i], 1);
            users[msg.sender] = true;
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

        string memory baseURI = _baseURI();
        return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
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
