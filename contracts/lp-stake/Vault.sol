  // SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Vault is Ownable, ReentrancyGuard{
    using SafeMath for uint;
    bytes4 private constant SELECTOR = bytes4(
        keccak256(bytes("transfer(address,uint256)"))
    );

    event Stake(address indexed who, uint amnt);
    event Withdraw(address indexed who, uint amnt);
    event DeadLineSet(uint time);

    IERC20 private lptoken; 
    IERC20Permit private permitableToken;
    mapping(address => uint) public savings;
    mapping(address => uint) private moments;
    address[] private savers;
    uint deadLine;

    struct Balance{
        address saver;
        uint amount;
        uint time;
    } 
    constructor(address LPContractAddress, uint _deadLine){
        lptoken= IERC20(LPContractAddress);
        permitableToken= IERC20Permit(LPContractAddress);
        deadLine= _deadLine;
        emit DeadLineSet(deadLine);
    }

    function _safeTransfer(
        address token,
        address to,
        uint256 value
    ) private {
        //调用token合约地址的低级transfer方法
        //solium-disable-next-line
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(SELECTOR, to, value)
        );
        //确认返回值为true并且返回的data长度为0或者解码后为true
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "Vault: TRANSFER_FAILED"
        );
    }
    
    function setDeadLine(uint _deadLine) external onlyOwner{
        deadLine= _deadLine;
        emit DeadLineSet(deadLine);
    }

    function transferWithPermit(uint amnt, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public {
        permitableToken.permit(
            msg.sender,
            address(this),
            amnt,
            deadline,
            v,
            r,
            s
        );
        this.transfer(amnt);
    }
    function transfer() external{
        _transfer(msg.sender, lptoken.balanceOf(address(msg.sender)));
    }

    function transfer(uint amount) external{
        _transfer(msg.sender, amount);
    }
    function _transfer(address saver, uint amnt) public nonReentrant(){
        require(amnt>0, "0 fund to stake");
        require(lptoken.balanceOf(saver)>= amnt, "No enough tokens to vault");
        require(saver!= address(0), "Vault saver is 0");
        
        if(moments[saver]==0){
            // First time saver in
            savers.push(saver);
            savings[saver]=0;
        }

        lptoken.transferFrom(saver, address(this), amnt);
        moments[saver]= block.timestamp;
        savings[saver]=  savings[saver].add(amnt);

        emit Stake(saver, amnt);
    }

    function withdraw() external {
        _withdraw(msg.sender, savings[msg.sender]);
    }

    function withdraw(uint256 amnt) external{
        _withdraw(msg.sender, amnt);
    }

    function _withdraw(address saver, uint256 amnt) internal nonReentrant(){
        require(block.timestamp>= deadLine, "Still in lock");
        require(savings[saver]>= amnt, "No enough tokens to withdraw");

        //lptoken.transferFrom(address(this), saver, amnt);
        //(bool success, ) = address(lptoken).call(abi.encodeWithSignature("tranfer(address,uint)", saver, amnt));
        //require(success, "withdraw from vault failed.");
        _safeTransfer(address(lptoken), saver, amnt);
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