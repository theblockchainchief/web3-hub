pragma solidity 0.8.3;

contract ExternalStakingContract {

  bool public completed;

  function complete() public payable {
    completed = true;
  }

}
