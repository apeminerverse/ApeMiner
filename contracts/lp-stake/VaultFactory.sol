  // SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./Vault.sol";
import "./ETHVault.sol";

contract VaultFactory{
    mapping (address  => address[]) private ownerPairs;

    event VaultCreated(address indexed who, address indexed at, address indexed token);

    function newVault(uint256 deadLine) external returns (address vault){
        vault= address(new ETHVault(deadLine));
        Ownable(vault).transferOwnership(msg.sender);
        ownerPairs[msg.sender].push(vault);

        emit VaultCreated(msg.sender, vault, address(0));
    }
    function newVault(address tokenAddress, uint256 deadLine) external returns (address vault){
        require(tokenAddress!= address(0),"Token Address is 0");
        vault= address(new Vault(tokenAddress, deadLine));

        Ownable(vault).transferOwnership(msg.sender);
        ownerPairs[msg.sender].push(vault);

        emit VaultCreated(msg.sender, vault, tokenAddress);
    }

    function getVaults() view external returns (address [] memory vaultList ){
        uint Count;
        Count= ownerPairs[msg.sender].length;
        vaultList= new address[](Count);

        for(uint i=0; i<Count; i++){
            vaultList[i]=ownerPairs[msg.sender][i];
        }
        return vaultList;
    }
}