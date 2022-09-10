// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

error OnlyExternallyOwnedAccountsAllowed();
error SaleNotStarted();
error AmountExceedsSupply();
error UserHadOne();
error InsufficientPayment();
error NeedRecommender(address);

contract ApeMinerBodyNFT is ERC721A, Ownable, ReentrancyGuard {
    using Strings for uint256;
    using SafeMath for uint256;

    uint256 public constant MAX_SUPPLY = 2000;
    uint256 private constant FAR_FUTURE = 0xFFFFFFFFF;

    uint256 private _publicSaleStart = FAR_FUTURE;
    string private _baseTokenURI;

    uint256 private _price;
    uint8 private _share;
    mapping(address => bool) members;

    event publicSaleStart();
    event publicSalePaused();
    event baseUIRChanged(string);

    modifier onlyEOA() {
        if (tx.origin != msg.sender)
            revert OnlyExternallyOwnedAccountsAllowed();
        _;
    }

    constructor(
        string memory baseURI,
        uint256 price,
        uint8 share
    ) ERC721A("ApeMinerBodyNFT", "ABN") {
        _baseTokenURI = baseURI;
        _price = price;
        require(share > 0 && share < 100, "share must between 0 and 100");
        _share = share;
        members[msg.sender] = true;
    }

    // publicSale

    function ispublicSaleActive() public view returns (bool) {
        return block.timestamp > _publicSaleStart;
    }

    function publicSaleMint(address recommender, uint256 quantity)
        external
        payable
        onlyEOA
        nonReentrant
    {
        if (!ispublicSaleActive()) revert SaleNotStarted();
        if (totalSupply() + quantity > MAX_SUPPLY) revert AmountExceedsSupply();
        if (recommender == address(0)) recommender = owner();
        if (!members[recommender]) revert NeedRecommender(recommender);

        uint256 cost = _price.mul(quantity);
        if (msg.value < cost) revert InsufficientPayment();

        _safeMint(msg.sender, quantity);

        uint256 split = cost.mul(_share).div(100);
        payable(recommender).transfer(split);
        members[msg.sender] = true;

        // Refund overpayment
        if (msg.value > cost) {
            payable(msg.sender).transfer(msg.value - cost);
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
