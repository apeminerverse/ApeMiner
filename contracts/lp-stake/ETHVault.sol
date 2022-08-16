 // SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract ETHVault is Ownable, ReentrancyGuard{
    using SafeMath for uint;

    event Stake(address indexed who, uint amnt);
    event Withdraw(address indexed who, uint amnt);
    event DeadLineSet(uint time);

    mapping(address => uint) private savings;
    mapping(address => uint) private moments;
    address[] private savers;
    uint deadLine;

    struct Balance{
        address saver;
        uint amount;
        uint time;
    } 
    constructor(uint _deadLine){
        deadLine= _deadLine;
        emit DeadLineSet(deadLine);
    }

    fallback() external {
    }

    receive() external payable {
        this.transfer();
    }
    function setDeadLine(uint _deadLine) external onlyOwner{
        deadLine= _deadLine;

        emit DeadLineSet(deadLine);
    }

    function transfer() external payable nonReentrant(){
        address saver= address(msg.sender);
        uint amnt= msg.value;

        require(amnt>0, "0 fund to stake");
        require(saver.balance>= amnt, "No enough ethers");
        if(moments[saver]==0){
            // First time saver in
            savers.push(saver);
            savings[saver]=0;
        }

        moments[saver]= block.timestamp;
        savings[saver]=  savings[saver].add(amnt);

        emit Stake(saver, amnt);
    }

    function withdraw(uint256 amnt) external nonReentrant(){
        address payable saver= payable(msg.sender);

        require(block.timestamp>= deadLine, "Still in lock");
        require(savings[saver]>= amnt, "Not enough ethers");


        saver.transfer(amnt);
        savings[saver]= savings[saver].sub(amnt);

        emit Withdraw(saver, amnt);
    }

    function balanceOf() view external returns (uint){
        return this.balanceOf(address(this));
    }
    function balanceOf(address who) view external returns (uint){
        return savings[who];
    }

    function getBalances() view external returns(Balance [] memory){
        uint count= savers.length;
        uint ValidCount=0;

        for (uint i = 0; i < count; i++) {
            if (savings[savers[i]]> 0) {ValidCount++;}
        }

        Balance[] memory items=new Balance[](ValidCount);
        for (uint i = 0; i < count; i++) {
            if (savings[savers[i]]> 0) {
                ValidCount--;
                items[ValidCount]= Balance(savers[i], savings[savers[i]], moments[savers[i]]);
            }
        }
        return items;
    }
}