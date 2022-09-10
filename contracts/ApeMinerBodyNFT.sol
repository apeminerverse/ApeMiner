// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

error OnlyExternallyOwnedAccountsAllowed();
error SaleNotStarted();
error AmountExceedsSupply();
error UserHadOne();
error InsufficientPayment();

contract ApeMinerBodyNFT is ERC721A, Ownable, ReentrancyGuard {
    using Strings for uint256;

    uint256 public constant MAX_SUPPLY = 2000;
    uint256 private constant FAR_FUTURE = 0xFFFFFFFFF;

    uint256 private _publicSaleStart = FAR_FUTURE;
    string private _baseTokenURI;

    uint256 private _price;

    event publicSaleStart();
    event publicSalePaused();
    event baseUIRChanged(string);

    modifier onlyEOA() {
        if (tx.origin != msg.sender)
            revert OnlyExternallyOwnedAccountsAllowed();
        _;
    }

    constructor(string memory baseURI, uint256 price)
        ERC721A("ApeMinerBodyNFT", "ABN")
    {
        _baseTokenURI = baseURI;
        _price = price;
    }

    // publicSale

    function ispublicSaleActive() public view returns (bool) {
        return block.timestamp > _publicSaleStart;
    }

    function publicSaleMint(uint256 quantity)
        external
        payable
        onlyEOA
        nonReentrant
    {
        if (!ispublicSaleActive()) revert SaleNotStarted();
        if (totalSupply() + quantity > MAX_SUPPLY) revert AmountExceedsSupply();

        uint256 price = _price * quantity;
        if (msg.value < price) revert InsufficientPayment();

        _safeMint(msg.sender, quantity);

        // Refund overpayment
        if (msg.value > price) {
            payable(msg.sender).transfer(msg.value - price);
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

    function startPublicSale() external onlyOwner {
        _publicSaleStart = block.timestamp;

        emit publicSaleStart();
    }

    function pausePublicSale() external onlyOwner {
        _publicSaleStart = FAR_FUTURE;
        emit publicSalePaused();
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

    // Team/Partnerships & Community
    function marketingMint(uint256 quantity) external onlyOwner {
        if (totalSupply() + quantity > MAX_SUPPLY) revert AmountExceedsSupply();

        _safeMint(owner(), quantity);
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
