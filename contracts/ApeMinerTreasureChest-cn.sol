// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./ERC721Psi/extension/ERC721PsiBurnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error OnlyExternallyOwnedAccountsAllowed();
error AmountExceedsSupply();
error SaleNotStarted();

contract ApeMinerTreasureChestCN is ERC721PsiBurnable, Ownable {
    uint256 public constant MAX_SUPPLY = 20000;
    uint256 private constant FAR_FUTURE = 0xFFFFFFFFF;

    uint256 private _airdropStart = block.timestamp;
    uint256 private _showTimeStart = FAR_FUTURE;

    string private _baseTokenURI;
    string private _coverURI;

    event airdropStart();
    event airdropPaused();
    event showTimeNotStart();
    event showTimeStart();
    event baseUIRChanged(string);
    event coverChanged(string);

    constructor(string memory baseURI, string memory coverURI)
        ERC721Psi("ApeMinerTreasureChestCN", "AMTC")
    {
        _baseTokenURI = baseURI;
        _coverURI = coverURI;
    }

    function isAirdropActive() public view returns (bool) {
        return block.timestamp > _airdropStart;
    }

    function isShowTimeStart() public view returns (bool) {
        return block.timestamp > _showTimeStart;
    }

    // Airdrop

    function mint(address[] memory _to) external onlyOwner {
        if (totalSupply() + _to.length > MAX_SUPPLY)
            revert AmountExceedsSupply();

        for (uint256 i = 0; i < _to.length; i++) {
            _safeMint(_to[i], totalSupply());
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

        if (!isShowTimeStart()) return _coverURI;

        return
            string(abi.encodePacked(_baseURI(), _toString(tokenId), ".json"));
    }

    // OWNERS + HELPERS

    function burn(uint256 tokenId) external {
        //solhint-disable-next-line max-line-length
        require(
            _msgSender() == owner() ||
                _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: caller is not token owner, not admin or approved"
        );
        _burn(tokenId);
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

    function setCoverNew(string memory uri)
        external
        onlyOwner
        returns (string memory)
    {
        _coverURI = uri;
        emit coverChanged(uri);
        return _coverURI;
    }

    function startAirdrop() external onlyOwner {
        _airdropStart = block.timestamp;

        emit airdropStart();
    }

    function pauseAirdrop() external onlyOwner {
        _airdropStart = FAR_FUTURE;
        emit airdropPaused();
    }

    function startShowTime() external onlyOwner {
        _showTimeStart = block.timestamp;
        emit showTimeStart();
    }

    function pauseShowTime() external onlyOwner {
        _showTimeStart = FAR_FUTURE;
        emit showTimeNotStart();
    }

    /**
     * @dev Converts a uint256 to its ASCII string decimal representation.
     */
    function _toString(uint256 value)
        internal
        pure
        virtual
        returns (string memory str)
    {
        assembly {
            // The maximum value of a uint256 contains 78 digits (1 byte per digit),
            // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aligned.
            // We will need 1 32-byte word to store the length,
            // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
            str := add(mload(0x40), 0x80)
            // Update the free memory pointer to allocate.
            mstore(0x40, str)

            // Cache the end of the memory to calculate the length later.
            let end := str

            // We write the string from rightmost digit to leftmost digit.
            // The following is essentially a do-while loop that also handles the zero case.
            // prettier-ignore
            for { let temp := value } 1 {} {
                str := sub(str, 1)
                // Write the character to the pointer.
                // The ASCII index of the '0' character is 48.
                mstore8(str, add(48, mod(temp, 10)))
                // Keep dividing `temp` until zero.
                temp := div(temp, 10)
                // prettier-ignore
                if iszero(temp) { break }
            }

            let length := sub(end, str)
            // Move the pointer 32 bytes leftwards to make room for the length.
            str := sub(str, 0x20)
            // Store the length.
            mstore(str, length)
        }
    }
}
