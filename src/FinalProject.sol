//SPDX-Licence-Identifier: MIT
pragma solidity 0.8.20;

// import Openzeppelin Ownable contract
import "@openzeppelin/contracts/access/Ownable.sol";

// @title the contract name is FinalprojectContract
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

    function deposit() external payable{
        require(msg.value > 0, "You must send some ether");
        balanceOf[msg.sender] += msg.value;
        emit FundsDeposited(msg.sender,msg.value);
    }

    // make only the owner is the one who can call this function
    function withdraw(uint256 amount) external onlyOwner{
        require(amount > 0, "Amount must be greater than 0");
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
        emit FundsWithdrawn(msg.sender,amount);
       
    }

    function getBalance() external view returns (uint256) {
        return balanceOf[msg.sender];
    }

}