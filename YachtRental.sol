// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract YachtRental {

    // state variables
    address payable public owner;
    bool public available;
    uint public ratePerDay;

    event Log(address indexed sender, string message);

    constructor() {
        owner = payable(msg.sender);
        available = true;
        ratePerDay = 1 ether;
    }

    // Modifier to check that the caller is the owner of the contract.
    modifier onlyOwner() {
        require(msg.sender == owner, "Must be the contract owner to use this function.");
        _;
    }
    modifier whenAvailable() {
        require(available, "Yacht not available.");
        _;
    }
    modifier validAddress(address addr) {
        require(addr != address(0), "Invalid Address.");
        _;
    }

    function bookYacht(uint numDay) public payable whenAvailable {

        // Check payment
        uint minOffer = ratePerDay * numDay;
        require(msg.value >= minOffer, "Take your broke arse home.");

        // owner.transfer(msg.value);
        (bool sent, ) = owner.call{value: msg.value}("");

        require(sent, "Transaction failed. Try again.");

        available = false;
        emit Log(msg.sender, "Yacht is booked.");
    }

    function makeYachtAvailable() public onlyOwner {
        // require(msg.sender == owner, "Only the owner can make yacht available.");
        available = true;

        emit Log(msg.sender, "Yacht is now available.");
    }

    function updateRate(uint newRate) public onlyOwner {
        // require(msg.sender == owner, "Only the owner can update the rate.");
        ratePerDay = newRate;
    }

    function transferYachtOwnership(address payable newOwner) public onlyOwner validAddress(newOwner){
        owner = newOwner;
        emit Log(msg.sender, "Yacht has a new owner.");
    }


}