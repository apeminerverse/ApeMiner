// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NFT is Ownable, ERC1155 {
    using Strings for uint256;

    uint256 public immutable ordinaryNumber;
    uint256 public immutable uniqueNumber;
    uint256 public immutable fitNumber;

    uint256 public uniqueMinted;
    struct SaleConfig {
        uint32 publicSaleStartTime;
        uint64 publicPriceWei;
    }

    SaleConfig public saleConfig;

    constructor(
        uint256 _ordinaryNumber,
        uint256 _uniqueNumber,
        uint256 _fitNumber,
        string memory _uri
    ) ERC1155(_uri) {
        require(_fitNumber>0 && _ordinaryNumber>=_fitNumber && _uniqueNumber>0, "Invalid arg");

        ordinaryNumber = _ordinaryNumber;
        uniqueNumber = _uniqueNumber;
        fitNumber= _fitNumber;

        _mint(msg.sender, 0, _ordinaryNumber, "");
    }

    modifier callerIsUser() {
        require(tx.origin == msg.sender, "The caller is another contract");
        _;
    }

    // *****************************************************************************
    // Public Functions

    function fit() external callerIsUser {
        require(uniqueMinted <= uniqueNumber, "Reached max supply" );
        require(balanceOf(msg.sender, 0)>= fitNumber, "no enough tokens to fit");

        safeTransferFrom(msg.sender, owner(), 0, fitNumber, "");

        _mint(msg.sender,uniqueMinted++, 1, "");
    }

    function isPublicSaleOn() public view returns(bool) {
        require(
            saleConfig.publicSaleStartTime != 0,
            "Public Sale Time is TBD."
        );

        return block.timestamp >= saleConfig.publicSaleStartTime;
    }

    // Owner Controls

    // Public Views
    // ****************************************************************************

    function uri(uint256 tokenId) public view virtual override returns (string memory){
        require(tokenId< uniqueMinted+1, "Non existing token");
        return string(abi.encodePacked(super.uri(tokenId), tokenId.toString(), ".json"));
    }

    // Contract Controls (onlyOwner)
    // *****************************************************************************
    function sale(address _to, uint256 _amount) external onlyOwner{
        require(isPublicSaleOn(), "Public sale has not begun yet");

        safeTransferFrom(msg.sender, _to, 0, _amount, "");
    }

    function withdrawMoney() external onlyOwner {
        (bool success, ) = msg.sender.call{ value: address(this).balance } ("");
        require(success, "Transfer failed.");
    }

    function setupNonAuctionSaleInfo(
        uint64 publicPriceWei,
        uint32 publicSaleStartTime
    ) public onlyOwner {
        saleConfig = SaleConfig(
            publicSaleStartTime,
            publicPriceWei
        );
    }

    function _setBaseURI(string memory newuri) external  onlyOwner{
        _setURI(newuri);
    }

    // Internal Functions
    // *****************************************************************************

    function refundIfOver(uint256 price) internal {
        require(msg.value >= price, "Need to send more ETH.");
        if (msg.value > price) {
            payable(msg.sender).transfer(msg.value - price);
        }
    }
}
