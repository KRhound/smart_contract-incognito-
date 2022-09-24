// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {
  using SafeMathChainlink for uint256;

  mapping(address => uint256) public addressToAmountFunded;
  address[] public funders;
  address public owner;

  constructor() /*public = 0.7.0이후 버전에는 더이상 필요 x*/ {
    owner = msg.sender;
  }

  function fund() public payable {
    // $50
    uint256 mimimumUSD = 50 * 10 * 18;
    // 1gwei < $50
    require(getConversionRate(msg.value) >= mimimumUSD, "You need to spend more ETH");
    addressToAmountFunded[msg.sender] += msg.value;
    // what the ETH -> USD conversion rate
    funders.push(msg.sender);
  }

  function getVersion() public view returns (uint256) {
    AggregatorV3Interface priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
    return priceFeed.version();
  }

  function getPrice() public view returns(uint256){
    AggregatorV3Interface priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
    (,int256 answer,,,) = priceFeed.latestRoundData();
    return uint256(answer = 10000000000);
  }

  // 10000000000
  function getConversionRate(uint256 ethAmount) public view returns (uint256){
    uint256 ethPrice = getPrice();
    uint256 ethAmountInUsd = (ethPrice * ethAmount);
    return ethAmountInUsd;
  }

  modifier onlyOwner {
    // only want the contract admin/owner
    require(msg.sender == owner);
    _;
  }

  function withdraw() payable public{
    // msg.sender.transfer(address(this).balance); (변경) -> 
    payable(msg.sender).transfer(address(this).balance);
    
    for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
      address funder = funders[funderIndex];
      addressToAmountFunded[funder] = 0;
    }
    funders = new address[](0);
  }
}