// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
// IERC-20 contract 
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract cUSDSavings {
  using SafeMath for uint256;
  
  IERC20 private cUSDToken;
  address payable creator; 
  uint256 public balance; 

  event ReceivedFunding(address contributor, uint amount, uint currentTotal);
  event WithdrewFunding(address contributor);

  constructor (IERC20 token, address payable savingsCreator) {
    cUSDToken = token; 
    creator = savingsCreator; 
  }

  // Fund savings
  function contribute(uint256 amount) external payable {
    require(msg.sender == creator);
    cUSDToken.transferFrom(msg.sender, address(this), amount);
    
    balance = balance.add(amount);
    emit ReceivedFunding(msg.sender, amount, balance);
  }

  function payOut(uint256 amount) external returns (bool result) {
    require(msg.sender == creator);
    
    cUSDToken.transfer(msg.sender, amount);
    emit WithdrewFunding(creator);
    return true;
  }
}