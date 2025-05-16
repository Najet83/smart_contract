///SPDX-Licence-Identifier: MIT
pragma solidity 0.8.30;

// import Openzeppelin Ownable contract
import "@openzeppelin/contracts/access/Ownable.sol";

// @title the contract name is FinalprojectContract
// @author the author is Najet Ben Hamouda
// @notice this contract is a simple wallet contract that allows users to deposit and withdraw ether
// @dev this contract uses the OpenZeppelin Ownable contract to manage ownership
contract FinalProjectContract is Ownable {

    // State variables
    address public owner;

   // call Ownable constructor of openzeppelin contract
    constructor () Ownable(msg.sender){
        owner = msg.sender;
    }

    
    // mapping of address to uint256
    // this mapping is used to store the balance of each address
    // the key is the address and the value is the balance
    mapping(address => uint256) public balanceOf;
    
    
    function deposit() external payable{
        require(msg.value > 0, "You must send some ether");
        balanceOf[msg.sender] += msg.value;
    }

    // make only the owner is the one who can call this function
    function withdraw(uint256 calldata amount) external onlyOwner{
        require(amount > 0, "Amount must be greater than 0");
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
        payable(owner).transfer(_amount);
    }

    function getBalance() external view returns (uint256) {
        return balanceOf[msg.sender];
    }

}