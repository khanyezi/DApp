const KhanyeziTokens = artifacts.require("./KhanyeziTokens.sol");
const InvestmentVehicle = artifacts.require("./InvestmentVehicle.sol")

module.exports = async function(deployer) {
  const KhanyeziTokens = await deployer.deploy(KhanyeziTokens, "KhanyeziTokens", "KZT", 8, 7, 0, 1);

  await deployer.deploy(InvestmentVehicle, KhanyeziTokens.address, 1000);
}
/* for the test
module.exports = async function(deployer) {
  deployer.deploy(KhanyeziTokens, "KhanyeziSenior", "K_SEN", 0, 0, 100 , 1);
};


/*
module.exports = async function(deployer) {
  deployer.deploy(KhanyeziTokens, "KhanyeziSenior", "K_SEN", 0, 0, 0.75*1000000 , 1);
  deployer.deploy(KhanyeziTokens, "KhanyeziMezzanine", "K_MEZ", 0, 0, 0.15*1000000 , 1);
  deployer.deploy(KhanyeziTokens, "KhanyeziEquity", "K_EQT", 0, 0, 0.1*1000000, 1);
};



/*
module.exports = async function(deployer) {
  const KhanyeziSenior = await deployer.deploy(KhanyeziTokens, "KhanyeziSenior", "K_SEN", 0, 0, 0.75*1000000 , 1);
  const KhanyeziMezzanine = await deployer.deploy(KhanyeziTokens, "KhanyeziMezzanine", "K_MEZ", 0, 0, 0.15*1000000 , 1);
  const KhanyeziEquity = await deployer.deploy(KhanyeziTokens, "KhanyeziEquity", "K_EQT", 0, 0, 0.1*1000000, 1);
  await deployer.deploy(KhanyeziSenior, KhanyeziMezzanine, KhanyeziEquity)
};
*/

