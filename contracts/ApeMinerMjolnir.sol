// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

// import "./ERC721A.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

error AmountExceedsSupply();

contract ApeMinerMjolnir is ERC721Enumerable, Ownable {
    using Strings for uint256;

    uint256 public constant MAX_SUPPLY = 3000;

    string private _baseTokenURI;

    event baseUIRChanged(string);

    constructor(string memory baseURI) ERC721("ApeMinerMjolnir", "AMM") {
        _baseTokenURI = baseURI;
    }

    // Airdrop

    function mint(address[] memory _to) external onlyOwner {
        if (totalSupply() + _to.length > MAX_SUPPLY)
            revert AmountExceedsSupply();
        for (uint256 i = 0; i < _to.length; i++) _mint(_to[i], totalSupply());
    }

    function mint(address _to, uint256 _amount) external onlyOwner {
        if (totalSupply() + _amount > MAX_SUPPLY) revert AmountExceedsSupply();
        for (uint256 i = 0; i < _amount; i++) _mint(_to, totalSupply());
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
            unicode'{"name": "ApeMiner Mjölnir #',
            tokenId.toString(),
            unicode'", "description": "Mjölnir(Thors Hammer) is a limited-edition key to the upcoming Miner Ape Blind Box. It contains enormous energy and can unlock unimaginable gift equipment and increase props for Apes Miner future income.", "image": "',
            _baseTokenURI,
            '", "designer": "apeminer.io","attributes": [{"trait_type": "Date","value": "2022-10-10"},{"trait_type": "In-memory","value": "ApeMiner First-Round Airdrop"}, {"trait_type": "Energy","value": "3000"}, {"trait_type": "Skills","value": "Enhanced Earnings"}, {"trait_type": "Upgradeable","value": "None"}]}'
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
