pragma solidity ^0.5.0;

import "./KhanyeziTokens.sol";

contract InvestmentVehicle {

/* Defines interface to the contract. */

    KhanyeziTokens khanyeziTokens;


    // call the owner of the contract SPV
    address payable private _SPV; // will send funds to the wallet
    uint256 public _totalAmount; // set a total amount needed every year we deploy a new contract
    
    uint _studentInterest;
    uint _studentTerm;
    // uint gracePeriod; /* Will be used to create data from which repayments are expected - dates can be in a separate contract */
    uint _studentLoanAmount;

    // make constants for now

    constructor(address _token,
    uint256 _tokensNeeded,
    uint256 studentInterest,
    uint256 studentTerm,
    uint256 studentLoanAmount) public
    {
       khanyeziTokens = KhanyeziTokens(_token);
       _totalAmount = _tokensNeeded;
       _studentInterest = studentInterest;
       _studentTerm = studentTerm;
       _studentLoanAmount = studentLoanAmount;
    }

    uint public TotalInvestors;

    struct Investor {
        address InvestorAddrs;
        uint256 registerDate;
    }

    struct Student {
        address StudentAddrs;
        uint256 applicationDate;
    }

    Investor[] public investors;
    Student[] public students;

    // owner address to investor number "index"
    mapping (address => uint256) public _AddrsToInvestorNo;
    mapping (address => uint256) public _AddrsToStudentNo;

    event InvestorTransaction (
        address OwnerAddrs,
        uint amount,
        uint depositeDate
    );

    event StundentTransaction (
        address OwnerAddrs,
        uint repaymentAmount,
        uint depositeDate
    );



    // register investment, by updating the Investment struct from the KhanyeziTokens contract
    function registerInvestor() public returns(uint) {
        // get an instance of Investor using the input variables and push into the array of investors, returns the index
        uint index = investors.push(Investor(msg.sender, now)) - 1;
        
        _AddrsToInvestorNo[msg.sender] = index; // to get the index for an address
        // return the investor id
        return index;
  }

  function registerStudent() public returns(uint) {
       // get an instance of Student using the input variables and push into the array of students, returns the index
        uint index = students.push(Student(msg.sender, now)) - 1;
    
        _AddrsToStudentNo[msg.sender] = index; // to get the index for an address
        // return the investor id
        return index;
  }

    /* Returns the total number of holders of this currency. */
    function InvestorCount() public view returns (uint256) {
        return investors.length;
    }

    function StudnetCount() public view returns (uint256) {
        return students.length;
    }

    
    function totalTokensNeeded() public view returns (uint256) {
        return _totalAmount;
    }
    
    function totalSupply() public view returns (uint256) {
        return khanyeziTokens.totalSupply();
    }
    
    // public so that investors can call the function and buy tokens
    // as the investor purchases tokens, tokens are minted
    function buyTokens(uint256 _amount) public payable {
        require(msg.value >= _amount, "not enough funds sent");
        require(khanyeziTokens.totalSupply() + _amount <= _totalAmount, "There must be enough tokens on sale");

        // call the transfer function to transfer from tokens_contract specfic token to investor (msg.sender)
        khanyeziTokens.mint(msg.sender, _amount);
    
        _SPV.transfer(msg.value);

        //send ether to SPV wallet
    
        uint256 _depositeDate = now;
        emit InvestorTransaction(msg.sender, _amount, _depositeDate);
    }

    // check investment 


    function InvestmentValue() public view returns (uint256) {
        // first need to see whether this is a registered address
        // require(_AddrsToInvestorNo[msg.sender] != 0, "Not an investor");

        return khanyeziTokens.InvestorAmount(msg.sender);
    }

    function InvestorDepositeDate() public view returns (uint256) {
        return khanyeziTokens.InvestorDate(msg.sender);
    }

    function interest() public view returns (uint256) {
        uint256 _interest = khanyeziTokens.interest();
        return _interest;
    }




}

 // check investment 

    /*

    function CurrentInvestmentValue() public {
        // first need to see whether this is a registered address
        require(_AddrsToInvestorNo[msg.sender] != 0, "Not an investor");

        //uint256 _InvestmentDate = khanyeziTokens._investments[msg.sender].depositeDate;
        uint256 _InvestmentAmount = khanyeziTokens._investments[msg.sender].amount;
        uint256 _interest = khanyeziTokens.interest();

        uint256 _timeNow = now;
        uint256 _approximateMonths = (_timeNow - _InvestmentDate) / 3.85802469136e-7;

        uint256 CurrentValue = _InvestmentAmount*(1 + _interest/100)*_approximateMonths;
        // can use message.sender as we want to map the address that calls the function
        return CurrentValue;
    }

*/


