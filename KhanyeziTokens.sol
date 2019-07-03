pragma solidity ^0.5;

import "zeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";


contract KhanyeziTokens is IERC20, Ownable {
    // We inherit from two contracts: ERC20 to make it represent a fungible token, that can be traded
    // and Ownable to manage authorization and restrict certain methods to the owner only, like minting
    // Safe math is better for mathematical functions
    using SafeMath for uint256;

    // token identifier
    string internal constant name ;
    string internal constant symbol;
    uint internal decimals ;                // how divisable you want your coins to be
    address public SPV;                     // current address of token holder & borrower
    uint private totalSupply = 1000000;
    uint public price;


    constructor(
      string _name,
      string _symbol,
      uint256 _totalSupply,
      address _SPV
      ) {
        // the contract is constructed once
        require(_price > 0, "Price of the token need to be positive");
        require(ownerAddress != address(0) && ownerAddress != address(this), "Wrong address");
        
        require(_SPV != 0x0, "Wrong address");

        price = _price;
        name = _name;
        symbol = _symbol;
        decimals = _decimals;

        totalSupply = _totalSupply;                            //Update total supply
        SPV = _SPV;
    }

    constructor(string memory _totalSupply, string memory _SPV) public{
        _SPV = msg.sender;
        totalSupply = _totalSupply;
    }

    constructor () public {
        // Initially assign all tokens to the contract's creator.
        balanceOf[msg.sender].balance = _totalSupply;
        owner = msg.sender;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    // Total number of tokens in existence
    function totalSupply() external view returns (uint256) {
        return _totalSupply;
   }

  // returns the account balance of another account with address _sender
    function balanceOf(address _owner) external view returns (uint256){
       return _balances[_owner];
   }

   // Function to check the amount of tokens that an owner("sender") allowed to a recipient.
    function allowance(address _owner, address _to) external view returns (uint256){
      return _allowed[_owner][_to];
   }

    // function to be used when investors buy the debt products form spv
   function transfer(address _to, uint256 _amount) external returns (bool){
        require(_amount <= _balances[msg.sender], "not enough money");
        require(_to != address(0), "cant have that address");

        owner = _to; // becomes new owner
        emit Transfer(msg.sender, _to, _amount);
        _balances[msg.sender] = _balances[msg.sender].sub(_amount);
        _balances[_to] = _balances[_to].add(_amount);
        return true;
   }

    // function to use when repaying investor
    function transferFrom(address _sender, address _to, uint256 _amount) external returns (bool){
        require(_amount <= _balances[_sender], "value must be less than balance");
        require(_amount <= _allowed[_sender][msg.sender], "value must be less than what is allowed to be sent");
        require(_sender != address(0), "cant have that address");

        _balances[_sender] = _balances[_sender].sub(_amount);
        _balances[_to] = _balances[_to].add(_amount);

        _allowed[_sender][msg.sender] = _allowed[_sender][msg.sender].sub(_amount); // subtract what is allowed to be spent
        emit Transfer(_sender, _recipient, _amount);
        return true;
   }

    // function to check that the sender (investor) approves the transfer of the tokens
    function approve(address _sender, uint256 _amount) external returns (bool){
        _allowed[msg.sender][_sender] = _amount;
        emit Approval(msg.sender, _sender, _amount);
        return true;
        }

    // function to be able to mint new coins
    function _mint(address _account, uint256 _amount) internal {
        require(_account != 0, "Account is not allowed to be account(0)");

        _totalSupply = _totalSupply.add(_amount);
        _balances[_account] = _balances[_account].add(_amount);
        Mint(_to, _amount);
        emit Transfer(address(0), _account, _amount);
  }

    function name() public view returns (string memory){
        return _name;
    }
	function symbol() public view returns (string memory){
        return _symbol;
    }
	function decimals() public view returns (uint8){
        return _decimals;
    }

}

contract KhanyeziSenior is KhanyeziTokens {

// First create the senior tranche token

    string internal constant name = "KhanyeziSenior";
    string internal constant symbol = "K_SEN";
    uint internal interest = 0.6;
    uint internal decimals = 18; // how divisable you want your coins to be
    address public SPV; // current address of token holder & borrower
    uint public price;
    uint private totalSupply = 0.75*1000000;
}



contract KhanyeziMezzanine is KhanyeziTokens {

// Middle tranche
    string internal constant name = "KhanyeziMezzanine";
    string internal constant symbol = "K_MEZ";
    uint internal interest = 0.11;
    uint internal decimals = 18; // how divisable you want your coins to be
    address public SPV; // current address of token holder
    uint public price;
    uint private totalSupply = 0.15*1000000;

}


contract KhanyeziEquity is KhanyeziTokens {

// Equity tranche
    string internal constant name = "KhanyeziEquity";
    string internal constant symbol = "K_EQT";
    uint internal interest = 0;
    uint internal decimals = 18; // how divisable you want your coins to be
    address public ownerAddress; // current address of token holder
    uint public price;
    uint private totalSupply = 0.1*1000000;

}

