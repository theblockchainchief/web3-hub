pragma solidity 0.8.3;

import "./ExternalStakingContract.sol";

contract Staker {

  ExternalStakingContract public externalStakingContract;

  mapping(address => uint256) public balances;

  uint256 public constant threshold = 1 ether;

  uint256 public immutable deadline ;

  bool public openToWithdraw;

  event Stake(address staker, uint256 amount);

  constructor(address externalStakingContractAddress) public {
    externalStakingContract = ExternalStakingContract(externalStakingContractAddress);
    deadline = block.timestamp + 30 seconds;
    openToWithdraw = false;
  }

  /// @notice Modifier chaeck if deadline is reached or not
  modifier deadlineReached() {
    require(block.timestamp > deadline, "Deadline not reached");
    _;
  }

  /// @notice Modifier check if eth has been staked to external contract or not
  modifier notCompleted() {
    require(!externalStakingContract.completed(), "Already Completed");
    _;
  }

  /// @notice stake() function to stake ether whaen the deadline is not reached
  /// @dev The function stakes ether to the contract and icrements the balance of the staker
  function stake() public payable {
    require(block.timestamp < deadline, "Cannot stake, deadline reached");
    balances[msg.sender] += msg.value;

    emit Stake(msg.sender, msg.value);
  }

  /// @notice execute() function to be called by anyone once after the deadline is reached.
  /// @dev  It calls `ExternalStakingContract.complete{value: address(this).balance}()` to send all the value to the external staking contract
 function execute() notCompleted deadlineReached public {
    require(address(this).balance >= threshold, "threshold not reached");
    externalStakingContract.complete{value : address(this).balance}();
 }

  /// @notice withdraw()` function to be called by anyone if the `threshold` was not met after the deadline is reached
  /// @param _to the address withdrawing ether from the contract
  function withdraw(address payable _to) notCompleted deadlineReached  public {
    if(address(this).balance < threshold)
      openToWithdraw = true;
    else
      revert("threshold reached, cannot withdraw");

    require(openToWithdraw, "Not open to withdraw");
    uint256 amount = balances[_to];

    balances[_to] = 0;

    (bool success , ) = _to.call{value : amount}("");

    require(success, "Error in withdrawing");
  }

  /// @notice `timeLeft()` function to view the time left before the deadline
  /// @return uint256 time left before deadline
  function timeLeft() public view returns(uint256) {
    if(block.timestamp >= deadline) {
      return 0;
    }

    return deadline - block.timestamp;
  }

  /// @notice receive() function to "catch" ETH sent to the contract and call stake() to update balances.
  receive() external payable{
    stake();
  }

}