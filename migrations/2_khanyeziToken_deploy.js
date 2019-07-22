const KhanyeziTokens = artifacts.require("./KhanyeziTokens.sol");
const InvestmentVehicle = artifacts.require("./InvestmentVehicle.sol")

module.exports = function(deployer) {
  deployer.deploy(KhanyeziTokens, "KhanyeziTokens", "KZT", 8, 7, 0, 1).then((contractInstance) => {
    deployer.deploy(InvestmentVehicle, contractInstance.address, 1000);
  })

  // await 
}
/* for the test
module.exports = async function(deployer) {
  deployer.deploy(KhanyeziTokens, "KhanyeziSenior", "K_SEN", 0, 0, 100 , 1);
};
*/

