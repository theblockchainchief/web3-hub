// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

contract Bank {
    mapping (address => uint) internal balances ;
    mapping (address => bool) public enrolled;

    address payable public owner;

    constructor() public {
        owner = payable(msg.sender);
    }
    

    event LogEnrolled(address accountAddress);

    event LogDepositMade(address accountAddress, uint amount);

    event LogWithdrawal(address accountAddress, uint withdrawAmount, uint newBalance);

    /// @notice Get balance
    /// @return The balance of the user
    function getBalance() public view returns (uint) {     
      return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    // Emit the appropriate event
    function enroll() public returns (bool){
      enrolled[msg.sender] = true;
      
      emit LogEnrolled(msg.sender);
      
      return enrolled[msg.sender];
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint) {
      require(enrolled[msg.sender], 'Sender Not Enrolled');
      
      balances[msg.sender] += msg.value;
      
      emit LogDepositMade(msg.sender, msg.value);
      
      return balances[msg.sender];
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint withdrawAmount) public returns (uint) {
      address payable transferAccountAddress = payable(msg.sender);
      require(withdrawAmount <= balances[msg.sender], "Not enough balance");
      
      (bool success, ) = transferAccountAddress.call{value : withdrawAmount}("");
      balances[transferAccountAddress] -= withdrawAmount;
      
      require(success, "Transfer not successful");
      emit LogWithdrawal(transferAccountAddress, withdrawAmount, balances[transferAccountAddress]);

      return balances[transferAccountAddress];
    }

    // Fallback function - Called if other functions don't match call or sent ether without data
    fallback () external payable {
      revert();
    }

}