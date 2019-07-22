pragma solidity ^0.5;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
// import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";


contract KhanyeziTokens is IERC20 {
    // We inherit from two contracts: ERC20 to make it represent a fungible token, that can be traded
    // and Ownable to manage authorization and restrict certain methods to the owner only, like minting
    // Safe math is better for mathematical functions
    using SafeMath for uint256;
    mapping (address => uint256) private _balances; // to obtain balance of a given address
    mapping (address => mapping (address => uint256)) private _allowed; // the amount allowed to spend

   struct Investment {
        uint256 amount;
        uint256 date;
    }

    // Investments[] public investments;

    mapping (address => Investment) public _investments;

    // include another struct to add the details of the investor and not just the balances


    // token identifier
    string public _name ;
    string public _symbol;
    uint8 public _decimals;                // how divisable you want your coins to be
    uint public _interest;
    address public _SPV;                     // current address of token holder & borrower
    uint public _totalSupply;
    uint public _price;


    constructor (
      string memory name,
      string memory symbol,
      uint8 decimals,
      uint interest,
      uint256 totalSupply,
      uint price
      ) public {
        // the contract is constructed once
        require(price > 0, "Price of the token need to be positive");

        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        _interest = interest;

        _totalSupply = totalSupply;                            //Update total supply
        _price = price;

        _balances[msg.sender] = _totalSupply;
        _SPV = msg.sender;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    // Total number of tokens in existence
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

  // returns the account balance of another account with address _sender
    function balanceOf(address _owner) public view returns (uint256) {
       return _balances[_owner];
   }

   // this function return both the amount and the date the investor made the investment
   function InvestorAmount(address _owner) public view returns (uint256) {
       return _investments[_owner].amount;
   }
   
   function InvestorDate(address _owner) public view returns (uint256) {
       return _investments[_owner].date;
   }
   
   

   // Function to check the amount of tokens that an owner("sender") allowed to a recipient.
    function allowance(address _owner, address _to) public view returns (uint256){
      return _allowed[_owner][_to];
   }

    // function to be used when investors buy the debt products form spv
   function transfer(address _to, uint256 _amount) public returns (bool){
        require(_amount <= _balances[msg.sender], "not enough money");
        require(_to != address(0), "cant have that address");

        emit Transfer(msg.sender, _to, _amount); // msg.sender may need to tx.origin
        _balances[msg.sender] = _balances[msg.sender].sub(_amount);
        _balances[_to] = _balances[_to].add(_amount);

        _investments[_to].amount = _amount;
        _investments[_to].date = now;

        return true;
   }

   // function to check that the sender (investor) approves the transfer of the tokens
    function approve(address _sender, uint256 _amount) public returns (bool){
        _allowed[msg.sender][_sender] = _amount;
        emit Approval(msg.sender, _sender, _amount);
        return true;
        }

    // function to use when repaying investor
    function transferFrom(address _sender, address _to, uint256 _amount) public returns (bool){
        require(_amount <= _balances[_sender], "value must be less than balance");
        require(_amount <= _allowed[_sender][msg.sender], "value must be less than what is allowed to be sent");
        require(_sender != address(0), "cant have that address");

        _balances[_sender] = _balances[_sender].sub(_amount);
        _balances[_to] = _balances[_to].add(_amount);

        _allowed[_sender][msg.sender] = _allowed[_sender][msg.sender].sub(_amount); // subtract what is allowed to be spent
        emit Transfer(_sender, _to, _amount);
        return true;
   }

    // function to be able to mint new coins
    function mint(address _account, uint256 _amount) public {
        // require() add require function that only the creator of the contract can call this
        // create a require function so that only the investment contract can call this function

        _totalSupply = _totalSupply.add(_amount);
        _balances[_account] = _balances[_account].add(_amount); // may need to use tx.origin
        
        _investments[_account].amount = _amount;
        _investments[_account].date = now;
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
    function interest() public view returns (uint){
        return _interest;
    }
    function price() public view returns (uint){
        return _price;
    }


}