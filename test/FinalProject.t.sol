// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "forge-std/Test.sol";
import {FinalProject} from "../src/FinalProject.sol";

contract FinalProjectTest is Test {
    FinalProject public finalProject;
    address public owner = makeAddr("owner");
    address public nonOwner = makeAddr("nonOwner");

    function setUp() public {
        vm.prank(owner);
        finalProject = new FinalProject(); // Deploy the FinalProject contract as the owner
        vm.deal(owner, 10 ether); // Give the owner 10 ether for testing
    }

    //test case for the deposit function: the owner deposits 1 ether into the contract
    //the contract should update the owner's balance correctly: the balance is 1 ether
    function testDeposit() public {
        vm.prank(owner); // Start impersonating the owner
        finalProject.deposit{value: 1 ether}(); // owner deposits 1 ether
        assertEq(finalProject.balanceOf(owner), 1 ether); // Check if the owner's balance is updated correctly
    }

    //test case for the withdraw function: the owner deposits 1 ether into the contract and then he withdraws 0.5 ether from the contract
    //the contract should update the owner's balance correctly: the balance is 0.5 ether
    function testWithdrawAsOwner() public {
        vm.startPrank(owner); // Start impersonating the owner
        finalProject.deposit{value: 1 ether}(); // owner deposits 1 ether
        finalProject.withdraw(0.5 ether); // owner withdraws 0.5 ether
        assertEq(finalProject.balanceOf(owner), 0.5 ether); // Check if the owner's balance is updated correctly
        vm.stopPrank(); // Stop impersonating the owner
    }

    //test case for the withdraw function: a non-owner tries to withdraw ether from the contract
    //the contract should revert with an error message: "Ownable: caller is not the owner"
    function testRevertIfNotOwnerCallsWithdraw() public {
        vm.prank(nonOwner);
        vm.expectRevert("The caller is not the owner");
        finalProject.withdraw(1 ether);
    }

    //test case for the withdraw function: the owner deposits 1 ether into the contract and then he tries to withdraw more than his balance
    //the contract should revert with an error message: "Insufficient balance"
    function testRevertWithdrawMoreThanBalance() public {
        vm.startPrank(owner); // Start impersonating the owner
        finalProject.deposit{value: 1 ether}(); // owner deposits 1 ether
        vm.expectRevert("Insufficient balance"); // Expect revert if owner tries to withdraw more than balance
        finalProject.withdraw(2 ether); // owner tries to withdraw 2 ether
        vm.stopPrank(); // Stop impersonating the owner
    }

    //test case for the GetBalance function: the owner deposits 1 ether into the contract
    //the contract should return the owner's balance correctly: the balance is 1 ether
    function testGetBalance() public {
        vm.startPrank(owner); // Start impersonating the owner
        finalProject.deposit{value: 1 ether}(); // owner deposits 1 ether
        uint256 balance = finalProject.getBalance(); // Get the owner's balance
        assertEq(balance, 1 ether); // Check if the balance is correct
        vm.stopPrank(); // Stop impersonating the owner
    }
}
