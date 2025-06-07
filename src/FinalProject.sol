// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

// import Openzeppelin Ownable contract
import "@openzeppelin/contracts/access/Ownable.sol";


// @title the contract name is Finalproject
// @author the author is Najet Ben Hamouda
// @notice this contract is a simple wallet contract that allows users to deposit and withdraw ether
// @dev this contract uses the OpenZeppelin Ownable contract to manage ownership
contract FinalProject is Ownable {

    // mapping of address to uint256
    // this mapping is used to store the balance of each address
    // the key is the address and the value is the balance
    mapping(address => uint256) public balanceOf;

   // call Ownable constructor of openzeppelin contract
    constructor () Ownable(msg.sender){
      
    }
    
    event FundsDeposited(address indexed sender, uint amount);
    event FundsWithdrawn(address indexed receiver, uint amount);

    // @notice this function allows users to deposit ether into the contract
    // @dev this function updates the balance of the sender and emits an event
    function deposit() external payable{
        require(msg.value > 0, "You must send some ether");
        balanceOf[msg.sender] += msg.value;
        emit FundsDeposited(msg.sender,msg.value);
    }

    // @notice this function allows users to withdraw ether from the contract
    // @dev this function checks if the sender has enough balance, updates the balance, and sends ether to the sender
    // make only the owner is the one who can call this function
    function withdraw(uint256 amount) external onlyOwner{
        require(amount > 0, "Amount must be greater than 0");
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
        emit FundsWithdrawn(msg.sender,amount);
       
    }
    // @notice this function allows users to check their balance
    // @return the balance of the sender
    function getBalance() external view returns (uint256) {
        return balanceOf[msg.sender];
    }

}