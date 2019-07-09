/*Author: Julika P */

pragma solidity ^0.5;

import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../contracts/KhanyeziTokens.sol";

contract InvestmentVehicle is Ownable, KhanyeziTokens {

/* Our handle to the token contract. */
    address[][3] public tokens;

    constructor(address _tokens) public {
        tokens[1] = seniorToken;
        tokens[2] = mezzanineToken;
        tokens[3] = equityToken;
    }

// adding 3 arrays, one for each tranche
// define the struct Song
  struct Investor {
    address payable InvestorAddrs;
    string Token;
    uint amountInvested;
  }

    uint public TotalInvestors;

    Investor[] public investors;

    // call the owner of the contract SPV
    address payable private _owner = SPV; // will send funds to the wallet

    event Investment(
        _investor,
        _token,
        _amount
    );

    // register investment
    function registerInvestor(string calldata _Token, uint _amountInvested) external onlyOwner returns(uint) {
        // get an instance of Investor using the input variables and push into the array of songs, returns the id
        uint index = investors.push(Investor(msg.sender, _Token, _amountInvested)) - 1;
        // add the msg.sender to the array of buyer addresses corresponding to the song id
        investors[index].push(msg.sender);
        // return the investor id
        return index;
  }

    /* Map all our balances for issued tokens */
    mapping (address => uint256) balances;

    /* Returns the total number of holders of this currency. */
    function TokenHolderCount() public view returns (uint256) {
        return investors.length;
    }

    /* Gets the token holder at the specified index. */
    function SentokenHolder(uint256 _index) public view returns (address) {
        return investors[_index];
    }

    // public so that investors can call the function and buy tokens
    function buyTokens(_amount, _tokenIndex) public payable {
        require(msg.value == _amount, "value sent by address must equal amount of tokens");
        KhanyeziTokens _tokens = KhanyeziToken(address(tokens[_tokenIndex]));
        // call the transfer function to transfer from tokens_contract specfic token to investor (msg.sender)
        _tokens.transfer(msg.sender, _amount);
        // _balances[msg.sender].add(_amount); -> this should be done in the transfer function
        _SPV.transfer(msg.value);
        // buy a token (_amount = amount of tokens bought)
        // with ether for now and send ether to SPV wallet
        emit Investment(msg.sender, tokens[_tokenIndex], _amount);

    }




}
