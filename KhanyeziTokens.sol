pragma solidity ^0.5;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";


contract KhanyeziTokens is IERC20, Ownable {
    // We inherit from two contracts: ERC20 to make it represent a fungible token, that can be traded
    // and Ownable to manage authorization and restrict certain methods to the owner only, like minting
    // Safe math is better for mathematical functions
    using SafeMath for uint256;
    mapping (address => uint256) private _balances; // to obtain balance of a given address
    mapping (address => mapping (address => uint256)) private _allowed; // the amount allowed to spend


    // token identifier
    string internal constant name ;
    string internal constant symbol;
    uint internal decimals;                // how divisable you want your coins to be
    uint internal interest;
    address public SPV;                     // current address of token owner
    uint private totalSupply;
    uint public price;


    constructor (
      string memory _name,
      string memory _symbol,
      uint _decimals,
      uint _interest,
      uint256 _totalSupply,
      uint _price
      ) public {
        // the contract is constructed once
        require(_price > 0, "Price of the token need to be positive");

        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        interest = _interest;

        totalSupply = _totalSupply;                            //Update total supply
        price = _price;
    }

    constructor () public {
        // Initially assign all tokens to the contract's creator.
        balanceOf[msg.sender].balance = totalSupply;
        SPV = msg.sender;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    // Total number of tokens in existence
    function totalSupply() external view returns (uint256) {
        return totalSupply;
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
        emit Transfer(_sender, _to, _amount);
        return true;
   }

    // function to check that the sender (investor) approves the transfer of the tokens
    function approve(address _sender, uint256 _amount) external returns (bool){
        _allowed[msg.sender][_sender] = _amount;
        emit Approval(msg.sender, _sender, _amount);
        return true;
        }

    // function to be able to mint new coins
    function _mint(address _account, uint256 _amount) internal onlyOwner {
        require(_account != 0, "Account is not allowed to be account(0)");

        _totalSupply = _totalSupply.add(_amount);
        _balances[_account] = _balances[_account].add(_amount);
        emit Transfer(address(0), _account, _amount);
  }

    function name() public view returns (string memory){
        return name;
    }
	function symbol() public view returns (string memory){
        return symbol;
    }
	function decimals() public view returns (uint8){
        return decimals;
    }

}

/* 
We then deply 3 different contracts to represent each branch in 2_khanyeziToken_deploy.js as such:
by defining each of the state variables

module.exports = async function(deployer) {
  const KhanyeziSenior = await deployer.deploy(KhanyeziTokens, "KhanyeziSenior", "K_SEN", 0, 0.06, 0.75*1000000 , 1);
  const KhanyeziMezzanine = await deployer.deploy(KhanyeziTokens, "KhanyeziMezzanine", "K_MEZ", 0, 0.11, 0.15*1000000 , 1);;
  const KhanyeziEquity = await deployer.deploy(KhanyeziTokens, "KhanyeziEquity", "K_EQT", 0, 0, 0.1*1000000, 1);
  await deployer.deploy(InvestmentVehicle, KhanyeziSenior.address, KhanyeziMezzanine.address, KhanyeziEquity.address)
};

where the InvestmentVehicle can then use the tokens by knowing the tokens' adresses

*/
