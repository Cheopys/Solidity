pragma solidity >=0.7.0 <0.9.0;

contract ChainBank
{
    address private administrator;
    mapping (address => Account) private accounts;
    
     // event for EVM logging
    event AdminSet(address indexed adminbOld, address indexed adminNew);
    
    event AccountAdded(address addressNew);
    
    event BalanceChanged(address Address, uint256 balanceOld, uint256 balanceNew);
    
    // modifier to check if caller is admin
    
    modifier isAdmin() 
    {
        // If the sender is not administrator, execution terminates 
        
        require(msg.sender == administrator, "Caller is not admin");
        _;
    }
    
    constructor ()
    {
        administrator = msg.sender;
        emit AdminSet(address(0), administrator);
   }
   
   // administrative functions
   
   function addAccount(address addressNew, string nameNew) public isAdmin
   {
       require(! accounts[addressNew]);
       
       accounts[addressNew] = Account(nameNew);
       emit AccountAdded(addressNew);
       emit BalanceChanged(addressNew, 0, addressNew.balance);
   }
   
   function removeAccount(address addressRemove) public isAdmin
   {
       require(accounts[addressRemove]);
       
       delete accounts[addressRemove];
   }
   
   // account functions
   
   function payInterest(address recipient) payable private
   {
       require(accounts[recipient]);
       
       uint256 balanceOld = recipient.balance;
       
       recipient.transfer(msg.value);
       
       emit BalanceChanged(recipient, balanceOld, recipient.balance);
   }
   
   function spend(address payable accountRecipient) external 
   {
       require(accounts[msg.sender]);

       uint256 balanceBefore = msg.sender.balance;
       
       // transfer to recipient 
       
       accountRecipient.transfer(msg.value);
       
       emit BalanceChanged(msg.sender, balanceBefore, msg.sender.balance);
   }
   
   
   struct Account
   {
       string name;
   }
}

