pragma solidity ^0.5.0;

import "./KhanyeziTokens.sol";

contract InvestmentVehicle {

/* Defines interface to the contract. */

    KhanyeziTokens khanyeziTokens;


    // call the owner of the contract SPV
    address payable private _SPV; // will send funds to the wallet
    uint256 public _totalAmount; // set a total amount needed every year we deploy a new contract
    
    constructor(address _token, uint256 _tokensNeeded) public {
       khanyeziTokens = KhanyeziTokens(_token);
       _totalAmount = _tokensNeeded;
    }

    uint public TotalInvestors;
    
    struct Investor {
        address InvestorAddrs;
        uint256 registerDate;
    }
    
    Investor[] public investors;
    
    // owner address to investor number "index"
    mapping (address => uint256) public _AddrsToInvestorNo;

   
    event InvestorTransaction (
        address OwnerAddrs,
        uint amount,
        uint depositeDate
    );
    

    // register investment, by updating the Investment struct from the KhanyeziTokens contract
    function registerInvestor() public returns(uint) {
        // get an instance of Investor using the input variables and push into the array of songs, returns the id

        uint index = investors.push(Investor(msg.sender, now)) - 1;
        
        _AddrsToInvestorNo[msg.sender] = index; // to get the index for an address
        // return the investor id
        return index;
  }

    /* Returns the total number of holders of this currency. */
    function TokenHolderCount() public view returns (uint256) {
        return investors.length;
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


