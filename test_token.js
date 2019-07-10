// import the contract artifacts

const KhanyeziTokens = artifacts.require('./KhanyeziTokens.sol') 


contract('KhanyeziTokens', accounts => {
  // test starts here
  
  const _name = "KhanyeziSenior";
  const _symbol = "K_SEN";
  const _decimals = 0;
  const _interest = 0;
  const _totalSupply = 100;
  const _price = 5;

  beforeEach(async function() {
    token = await KhanyeziTokens.new(_name, _symbol, _decimals, _interest, _totalSupply, _price);
  }); // need to use async and await together
  // basically we want to wait for that functio to run before going to the next functions

  describe('token attributes', function() {
    it("should have a name", async function () {
        const name = await token.name();
        assert.equal(name, _name);
    });

    it("should have a symbol", async function () {
        const symbol = await token.symbol();
        assert.equal(symbol, _symbol);
    });

    it("should have 0 decimals", async function () {
        const decimals = await token.decimals();
        assert.equal(decimals.toNumber(), _decimals);
    });

    it("should have 0 interest", async function () {
      const interest = await token.interest();
      assert.equal(interest.toNumber(), _interest);
  });

    it("should have a total supply of 100", async function () {
        const totalSupply = await token.totalSupply();
        assert.equal(totalSupply.toNumber(), _totalSupply, "total supply is wrong")
    });

    it("should have a price of 5", async function () {
      const price = await token.price();
      assert.equal(price.toNumber(), _price, "total supply is wrong")
  });
  });

  

  it("should return the balance of token owner", function() {
    var token;
    return KhanyeziTokens.deployed().then(function(instance){
      token = instance;
      return token.balanceOf.call(accounts[0]);
    }).then(function(result){
      assert.equal(result.toNumber(), 100, 'balance is wrong');
    })
  })

  

    // second test
    it("should transfer right token", function() {
      var token;
      return KhanyeziTokens.deployed().then(function(instance){
        token = instance;
        return token.transfer(accounts[1], 50);
      }).then(function(){
        return token.balanceOf.call(accounts[0]);
      }).then(function(result){
        assert.equal(result.toNumber(), 50, 'accounts[0] balance is wrong');
        return token.balanceOf.call(accounts[1]);
      }).then(function(result){
        assert.equal(result.toNumber(), 50, 'accounts[1] balance is wrong');
      })
    });
    
    // third test
    it('should mint 10 coins if sent from account 0', async function () {
      // again fetch the instance of the contract
      let token = await KhanyeziTokens.deployed()
      // call the mint function to mint 10 coins to account 0
      await token.mint(accounts[0], 10, { 'from': accounts[0] })
      // retrieve the updated balance of account 0
      let balance = await token.balanceOf(accounts[0])
      let totalSupply = await token.totalSupply()
      // check that the balance is now 10
      assert.equal(balance.toNumber(), 60, "60 wasn't in account 0")
      assert.equal(totalSupply.toNumber(), 110, "total supply should be 110")
    });
  

    // fourth test
    it('should mint no coins if sent from account 1', async function () {
      var token;
      return KhanyeziTokens.deployed().then(function(instance){
        token = instance;
        return token.mint(accounts[1], 10, { 'from': accounts[1] });
      }).then(function(){
        return token.balanceOf.call(accounts[1]);
      }).then(function(result){
        assert.equal(result.toNumber(), 50, 'accounts[1] balance is wrong');
      })
    });

    // fifth test
    // I assume that changes of the unit tests above remain, so accounts[0] has (100 - 50 + 10 = 60) and accounts[1] has 50
    it("should give accounts[1] authority to spend account[0]'s token", function() {
      var token;
      return KhanyeziTokens.deployed().then(function(instance){
      token = instance;
      return token.approve(accounts[1], 20); // account0 authorizes account1 to transfer her funds
      }).then(function(){
      return token.allowance.call(accounts[0], accounts[1]); // returns the a,iunt authorised to spend
      }).then(function(result){
      assert.equal(result.toNumber(), 20, 'allowance is wrong');
      return token.transferFrom(accounts[0], accounts[2], 20, {from: accounts[1]}); // checks that the transaction takes place
      }).then(function(){
      return token.balanceOf.call(accounts[0]);
      }).then(function(result){
      assert.equal(result.toNumber(), 40, 'accounts[0] balance is wrong');
      return token.balanceOf.call(accounts[1]);
      }).then(function(result){
      assert.equal(result.toNumber(), 50, 'accounts[1] balance is wrong');
      return token.balanceOf.call(accounts[2]);
      }).then(function(result){
      assert.equal(result.toNumber(), 20, 'accounts[2] balance is wrong');
      })
    });

   // more tests here
  })
