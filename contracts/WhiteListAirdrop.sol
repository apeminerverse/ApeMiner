// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

error OnlyExternallyOwnedAccountsAllowed();
error SaleNotStarted();
error AmountExceedsSupply();
error UserHadOne();
error MerkleTreeVerify();

contract WhitelistAirdrop is ERC721A, Ownable {
    using Strings for uint256;

    uint256 public constant MAX_SUPPLY = 300;
    uint256 private constant FAR_FUTURE = 0xFFFFFFFFF;

    uint256 private _airdropStart = FAR_FUTURE;
    string private _baseTokenURI;
    bytes32 private _merkleRoot;

    mapping(address => bool) users;

    event AirdropStart();
    event AirdropPaused();
    event baseUIRChanged(string);

    modifier onlyEOA() {
        if (tx.origin != msg.sender)
            revert OnlyExternallyOwnedAccountsAllowed();
        _;
    }

    constructor(string memory baseURI, bytes32 merkleRoot)
        ERC721A("AprMinerYachtPartyAirdrop", "AYA")
    {
        _baseTokenURI = baseURI;
        _merkleRoot = merkleRoot;
    }

    // Airdrop

    function isAirdropActive() public view returns (bool) {
        return block.timestamp > _airdropStart;
    }

    function airdropMint(
        bytes32[] calldata _merkleProof,
        string calldata _ticketNumber,
        string calldata _lastName
    ) external onlyEOA {
        if (!isAirdropActive()) revert SaleNotStarted();
        if (totalSupply() + 1 > MAX_SUPPLY) revert AmountExceedsSupply();

        if (users[msg.sender]) revert UserHadOne();

        bytes32 leaf = keccak256(
            abi.encodePacked(_ticketNumber, _lastName, msg.sender)
        );
        if (!MerkleProof.verify(_merkleProof, _merkleRoot, leaf))
            revert MerkleTreeVerify();

        _safeMint(msg.sender, 1);

        users[msg.sender] = true;
    }

    function testMint() external {
        _safeMint(msg.sender, 1);
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

    function startAirdrop() external onlyOwner {
        _airdropStart = block.timestamp;

        emit AirdropStart();
    }

    function pauseAirdrop() external onlyOwner {
        _airdropStart = FAR_FUTURE;
        emit AirdropPaused();
    }

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
