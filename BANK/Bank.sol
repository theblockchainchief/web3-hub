pragma solidity ^0.5.16;

contract Bank{
    address payable owner;
    address payable receiver;
    address payable bank;

    uint No_of_Users = 0;
    uint No_of_Transactions = 0;
    uint No_of_WithdrawlRequest = 0;
    
    
    constructor() public{
        bank = msg.sender;
    }

    struct User{
        uint user_id;
        string fname;
        string lname;
        string pan_number;
        address payable user_address;
        uint created_on;
        uint available_balance;
        uint pending_balance;
        uint last_transaction_no;
    }

    mapping(address => User) User_list;
    mapping(address => bool) Bool_User_Exists;

    struct Transaction{
        uint transaction_id;
        uint amount;
        string sender;
        string receiver;
        address payable sender_address;
        address payable receiver_address;
        uint timestamp;
        string Type;
        bool pending;
    }

    mapping(uint => Transaction) public Transaction_list;

    struct Withdrawal{
        uint withdraw_id;
        uint transaction_id;
        address payable requesteduser;
        uint amount;
        uint timestamp;
        bool pending;
    }

    mapping(uint => Withdrawal) public Withdrawl_List;

    modifier User_Not_Exist(){
        require(Bool_User_Exists[msg.sender] == false, "You already have an account with same address.");
        _;
    }

    modifier User_Exist(){
        require(Bool_User_Exists[msg.sender] == true, "You don`t have an account with us.");
        _;
    }

    modifier Not_NULL()
    {
        require(msg.sender != address(0), "Null Address");
        _;
    }

    modifier Enough_Ether(uint amount) {
        require(msg.value >= amount, "You dont have enough ether in your wallet");
        _;
    }

    modifier Enough_Balance(uint amount) {
        require(amount < User_list[msg.sender].available_balance, "Insufficeint Balance");
        _;
    }

    modifier onlyBank() {
        require(msg.sender == bank, "Only Bank have authority to access this transaction");
        _;
    }

    modifier pending(uint id) {
        require(Withdrawl_List[id].pending == true, "Transaction already completed");
        _;
    }

    modifier Receiver_Exist(address payable Receiver){
        require(Bool_User_Exists[Receiver] == true, "Receiver don't have an account with us.");
        _;
    }

    // Create Account
    function Create_Account(string memory First_Name, string memory Last_Name, string memory PAN_Number) public payable User_Not_Exist() Not_NULL(){
        require(bytes(First_Name).length >= 0, "First Name can't be Empty");
        require(bytes(Last_Name).length >= 0, "Last Name can't be Empty");
        require(bytes(PAN_Number).length == 10, "Invalid PAN Number");

        No_of_Users++;
        User_list[msg.sender] = User(No_of_Users, First_Name, Last_Name, PAN_Number, msg.sender, now, 0,0, 0);
        Bool_User_Exists[msg.sender] = true;
    }

    // Deposit Balance
    function Deposit(uint amount) public payable Enough_Ether(amount) User_Exist() Not_NULL(){
        uint balance = User_list[msg.sender].available_balance;
        string memory firstname = User_list[msg.sender].fname;
    
        
        User_list[msg.sender].available_balance = balance + amount;
        User_list[msg.sender].pending_balance = User_list[msg.sender].available_balance;
        bank.transfer(amount);
        No_of_Transactions++;
        Transaction_list[No_of_Transactions] = Transaction(No_of_Transactions,amount,firstname,"Bank", msg.sender,bank,now,"Deposit",false);
        User_list[msg.sender].last_transaction_no = No_of_Transactions;
    }

    // Withdraw Balance
    function Withdraw(uint amount) public payable Enough_Balance(amount) User_Exist Not_NULL{
        uint balance = User_list[msg.sender].available_balance;
        string memory firstname = User_list[msg.sender].fname;
    
        // bank.transfer(amount);
        User_list[msg.sender].available_balance = balance - amount;

        No_of_Transactions++;
        Transaction_list[No_of_Transactions] = Transaction(No_of_Transactions,amount,"Bank",firstname,bank, msg.sender,now,"Withdraw", true);
        No_of_WithdrawlRequest++;
        Withdrawl_List[No_of_WithdrawlRequest] = Withdrawal(No_of_WithdrawlRequest, No_of_Transactions,  msg.sender, amount, now, true);
        User_list[msg.sender].last_transaction_no = No_of_Transactions;
    }

    // Transfer Fund
    function Transfer(uint amount, address payable Receiver) public payable Enough_Balance(amount) User_Exist Receiver_Exist(Receiver) Not_NULL{
        uint sender_balance = User_list[msg.sender].available_balance;
        uint receiver_balance = User_list[Receiver].available_balance;
        string memory sender_firstname = User_list[msg.sender].fname;
        string memory receiver_firstname = User_list[Receiver].fname;

        // bank.transfer(amount);
        User_list[msg.sender].available_balance = sender_balance - amount;
        User_list[Receiver].available_balance = receiver_balance + amount;

        No_of_Transactions++;
        Transaction_list[No_of_Transactions] = Transaction(No_of_Transactions,amount,sender_firstname,receiver_firstname,msg.sender,Receiver, now,"Transfer", false);
        User_list[msg.sender].last_transaction_no = No_of_Transactions;
    }

    // Current Balance
    function Account_Details() public Not_NULL User_Exist returns (uint Account_Number, string memory First_Name, string memory Last_Name, string memory PAN_Number, uint Current_Balance, uint Pending_Balance, uint Last_Transaction_No){
        uint account_number = User_list[msg.sender].user_id;
        string memory first_name = User_list[msg.sender].fname;
        string memory last_name = User_list[msg.sender].lname;
        string memory pan = User_list[msg.sender].pan_number;
        address user = User_list[msg.sender].user_address;
        uint account_created_on = User_list[msg.sender].created_on;
        uint current_bal = User_list[msg.sender].available_balance;
        uint pending_bal = User_list[msg.sender].pending_balance;
        uint last_transaction_no = User_list[msg.sender].last_transaction_no;

        return (account_number,first_name,last_name,pan,current_bal,pending_bal,last_transaction_no);
    }

    // For Bank Only
    function Last_Pending_request() public onlyBank Not_NULL returns (uint Last_Pending_Withdrawl_Request_No){
        uint total_withdrawl_request = No_of_WithdrawlRequest;
        for (uint i = total_withdrawl_request; i >= 0; i--) {
            if(Withdrawl_List[i].pending == true)
            {
                return i;
            }
        }
    }

    // Accept Withdrawl request
    function Pending_Withdrawl_Request(uint id) public payable onlyBank Not_NULL pending(id) returns (string memory Message){
        address payable user = Withdrawl_List[id].requesteduser;
        uint amount = Withdrawl_List[id].amount;
        uint transaction_no = Withdrawl_List[id].transaction_id;

        if (msg.value >= amount)
        {
            user.transfer(amount);
            User_list[user].pending_balance = User_list[user].pending_balance - amount;
            Withdrawl_List[id].pending = false;
            Transaction_list[transaction_no].pending = false;
            return ("Transaction Successful");
        }
        else 
        {
            User_list[user].available_balance = User_list[user].available_balance + amount;
            Withdrawl_List[id].pending = false;
            Transaction_list[transaction_no].pending = false;
            return ("Not Enough Ether To Accept This Request.");
        }
    }
}