pragma solidity ^0.5;

import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../contracts/KhanyeziTokens.sol";

contract InvestmentVehicle is Ownable, KhanyeziTokens {

/* Defines our interface to the contract. */
    address KhanyeziSenior;
/* Our handle to the token contract. */

    constructor(address _token) public {
        KhanyeziSenior = _token;
    }

// adding 3 arrays, one for each tranche
// define the struct Song
  struct Investor {
    address payable InvestorAddrs;
    uint amountInvested;
    uint date;
  }

    Investor[] public investors;
    
    uint public TotalInvestors;

    // call the owner of the contract SPV
    address payable private _SPV; // will send funds to the wallet

    event Investment(
        address _OwnerAddrs,
        uint _amount,
        uint _date
    );

    // register investment
    function registerInvestor(uint _amountInvested, uint _date) public onlyOwner returns(uint) {
        // get an instance of Investor using the input variables and push into the array of songs, returns the id
        uint index = investors.push(Investor(msg.sender, _amountInvested, _date)) - 1;
        // add the msg.sender to the array of buyer addresses corresponding to the song id
        investors[index].push(msg.sender);
        // return the investor id
        return index;
  }

    /* Returns the total number of holders of this currency. */
    function TokenHolderCount() public view returns (uint256) {
        return investors.length;
    }

    /* Gets the token holder at the specified index. */
    function TokenHolder(uint256 _index) public view returns (address) {
        return investors[_index];
    }

    // public so that investors can call the function and buy tokens
    function buyTokens(uint _amount) public payable {
        require(msg.value == _amount, "value sent by address must equal amount of tokens");
        require(totalSupply() >= _amount, "There must be enough tokens on sale");

        _tokens = KhanyeziTokens(address(KhanyeziSenior));
        // call the transfer function to transfer from tokens_contract specfic token to investor (msg.sender)
        _tokens.transfer(msg.sender, _amount);
        // _balances[msg.sender].add(_amount); -> this should be done in the transfer function
        _SPV.transfer(msg.value);
        // buy a token (_amount = amount of tokens bought)
        // with ether for now and send ether to SPV wallet
        
        _date = now;
        emit Investment(msg.sender, _amount, _date);

    }




}
