// SPDX-License-Identifier: GPL-2.0-or-later

pragma solidity ^0.8.7;

/*
    1. One account can vote only once.
    2. Voter has to send 1 ether to vote.
    3. Make sure ethers don't stay locked in the contract.
    4. Contract stages.
*/
contract VotingApp {
    address payable owner;
    mapping (address => bool) hasVoted;
    uint votingFee = 1 ether;
    enum VotingStages { OPEN, CLOSED }
    VotingStages votingStage = VotingStages.CLOSED;

    event logger(uint value);

    constructor() {
        owner = payable(msg.sender);
    }

    function vote() public payable {
        require(votingStage == VotingStages.OPEN, "Voting is closed!");
        require(hasVoted[msg.sender] == false, "You have already voted!");
        require(msg.value >= votingFee, "Need to send 1 ETH to vote!");
        hasVoted[msg.sender] = true;
    }

    function getFunds() public view returns(uint) {
        require(msg.sender == owner, "Not Authorized!"); 
        return address(this).balance;
    }

    function withdrawFunds(uint _amount) public {
        require(msg.sender == owner, "Not Authorized!"); 
        require(_amount <= address(this).balance, "Insufficient Funds!"); 
        owner.transfer(_amount);
    }

    function openVoting() public {
        require(msg.sender == owner, "Not Authorized!"); 
        votingStage = VotingStages.OPEN;
    }

    function closeVoting() public {
        require(msg.sender == owner, "Not Authorized!"); 
        votingStage = VotingStages.CLOSED;
    }
}
