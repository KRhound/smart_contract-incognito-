// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

interface AggregatorV3Interface {

  function decimals() external view returns (uint8);
  function description() external view returns (string memory);
  function version() external view returns (uint256);
  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

}

contract FundMe {
  using SafeMathChainlink for uint256;

  mapping(address => uint256) public addressToAmountFunded;

  function fund() public payable {
    // $50
    addressToAmountFunded[msg.sender] += msg.value;
    // what the ETH -> USD conversion rate 
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

}