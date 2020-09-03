/*
    This exercise has been updated to use Solidity version 0.6.12
    Breaking changes from 0.5 to 0.6 can be found here: 
    https://solidity.readthedocs.io/en/v0.6.12/060-breaking-changes.html
*/

pragma solidity ^0.5.0;

contract SimpleBank {

    //
    // State variables
    // 
    mapping (address => uint) private balances;
    mapping (address => bool) public enrolled;
    address public owner;
    
    //
    // Events
    //
    event LogEnrolled(address indexed accountAddress);
    event LogDepositMade(address indexed accountAddress, uint amount);
    event LogWithdrawal(address indexed accountAddress, uint withdrawAmount, uint newBalance);

    //
    // Modifiers
    //
    modifier isEnrolled(address account) {
        require(enrolled[account] == true);
        _;
    }

    modifier sufficientBalance(address account, uint amount) {
        require(balances[account] >= amount);
        _;
    }

    //
    // Functions
    //
    constructor() public {
        owner = msg.sender;
    }

    // Fallback
    function () 
        external 
        payable 
    {
        revert();
    }

    function getBalance() 
        public 
        view 
        isEnrolled(msg.sender)
        returns (uint)
    {
        return balances[msg.sender];
    }

    function enroll() 
        public 
        returns (bool)
    {
        enrolled[msg.sender] = true;
        emit LogEnrolled(msg.sender);
        return true;
    }

    function deposit() 
        public 
        payable 
        isEnrolled(msg.sender)
        returns (uint) 
    {
        balances[msg.sender] += msg.value;
        emit LogDepositMade(msg.sender, msg.value);
        return balances[msg.sender];
    }
 
    function withdraw(uint withdrawAmount) 
        public 
        isEnrolled(msg.sender)
        sufficientBalance(msg.sender, withdrawAmount)
        returns (uint) 
    {
        balances[msg.sender] -= withdrawAmount;
        msg.sender.transfer(withdrawAmount);
        emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
    }
}