// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Faucet {
    address public owner;
    uint256 public amount; //requested amount
    address payable public recipient;
    uint256 public count;
    mapping (address => uint256) userReqTimes;
    uint256 public reqCooldown = 1 days;

    event UserDeposited(uint256 amount, string message);
    event TokensSent(address indexed user, string message);
    event TokensRequested(uint256, string message);

    constructor(uint256 _amount) {
        owner = msg.sender;
        amount = _amount;
        recipient = payable(owner);
    }

    

    function requestTokens() public {
        require(address(this).balance > amount, "Not enough tokens in faucet");
        require(block.timestamp - userReqTimes[msg.sender] >= reqCooldown, "Req too soon");
        _sendTokens(payable(msg.sender), amount);

        count++;
        userReqTimes[msg.sender]= block.timestamp;
        emit TokensRequested(amount, "User has requested tokens");
    }

// 0xa97e8DcA4c2e798696a8023DD0e8aAc01F327802
    function depositTokens() public payable {
        require(msg.value > 0, "Must deposit some ETH");
        emit UserDeposited(msg.value, "Deposited into faucet");
    }

    function setFaucetLimit(uint _amount) public onlyOwner {
        amount = _amount;
    }

    function setReqCooldown(uint256 _seconds) public onlyOwner {
        reqCooldown = _seconds;
    }

    function withdrawFaucetTokens(uint _amount) public onlyOwner {
        require(address(this).balance >= _amount, "Not enough tokens in faucet"); 
        recipient.transfer(_amount);
    }

    function faucetBalance() public view returns (uint256) {
        return address(this).balance;
    }


    function _sendTokens(address payable _recipient, uint256 _amount) internal {
        _recipient.transfer(_amount);
        emit TokensSent(_recipient, "Tokens sent to user");
    }

   

    modifier onlyOwner() {
    require(msg.sender == owner, "Not the contract owner");
    _;
}


}
