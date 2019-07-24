// first need to check whether web3 is installed

if (typeof web3 != "undefined"){
    web3 = new Web3(web3.currentProvider); // create new isntance
} else {
    web3 = new Web3(new Web3.providers.HttpProvider('HTTP://localhost:7545')) // localhost : use Http provider
}

// store file permanently ""

web3.eth.defaultAccount = web3.eth.accounts[0]; // account we want to use to execute things (takes first account in array)

// want to now store the JSON representation of the smert contract here

// copy the API from remix and paste into contract()
// created a new variable that houses the smart contract

 var userContract = web3.eth.contract([
	{
		"constant": true,
		"inputs": [],
		"name": "TotalInvestors",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "totalSupply",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "buyTokens",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "_totalAmount",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"name": "investors",
		"outputs": [
			{
				"name": "InvestorAddrs",
				"type": "address"
			},
			{
				"name": "registerDate",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "registerInvestor",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"name": "_AddrsToInvestorNo",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "totalTokensNeeded",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "TokenHolderCount",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"name": "_token",
				"type": "address"
			},
			{
				"name": "_tokensNeeded",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "OwnerAddrs",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "amount",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "depositeDate",
				"type": "uint256"
			}
		],
		"name": "InvestorTransaction",
		"type": "event"
	}
]);

// havent given the smart contract address yet, which we need to do
// use the address after deploying contract using environment: Web3 Provider

var User = userContract.at("0x02ceae7a80c9eaf4ae889392d4a483b8c88d86db");

// want to lonk the contract variables to update when clicking the Update User button

$("#button").click(function(){
	User.buyTokens($("#PurchaseTokens").val(), 
	{from : web3.eth.defaultAccount,  
	 value: $("#PurchaseTokens").val()}); // calls the buy Tokens function from the smart contract
})

// to get something back from a smart contarct, need to create an event to see what is happening (can then use event listener)
// always need to copy the new address and API when changing something in your contract

// add event listener

var userEvent = User.InvestorTransaction(); // takes a solidity event and stores is in a java variable

userEvent.watch(function(error, result) { // watch is a function for event 
    if(!error){

        $("#InvestorPurchase").html("Congradulations! You just purchased " + result.args.amount + " KhanyeziTokens")

    } else {

        console.log(error)

    }

})

// add the total token supply and our goal supply

var TotalTokens = User.totalSupply.call();

var NeededTokens = User.totalTokensNeeded.call();

document.getElementById("TokenProgress").innerHTML = "We have reached " + TotalTokens/NeededTokens + " % of our KhayeziToken sale!" ;

// calculating the current investment value


let CurrentInvestment = function() {

	InvestmentAmount = User.InvestmentValue.call();
	InvestmentDate = User.InvestorDepositeDate.call();
	interest = User.interest.call();

	CurrentTime = Math.round((new Date()).getTime() / 1000);

	CurrentInvestment = InvestmentAmount*(1 + (interest/12)/100)*(CurrentTime - InvestmentDate) / 3.85802469136e-7
	
	return CurrentInvestment;
}



