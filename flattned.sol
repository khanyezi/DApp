
// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see `ERC20Detailed`.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * > Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an `Approval` event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to `approve`. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

pragma solidity ^0.5.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

// File: contracts/KhanyeziTokens.sol

pragma solidity ^0.5.0;

// import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";



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

// File: contracts/InvestmentVehicle.sol

pragma solidity ^0.5.0;


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
