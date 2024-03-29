// first need to check whether web3 is installed

if (typeof web3 != "undefined"){
    web3js = new Web3(web3.currentProvider);; // create new isntance
} else {
	web3 = new Web3(new Web3.providers.HttpProvider('HTTP://localhost:7545')) // localhost : use Http provider
  //  web3 = new Web3(new Web3.providers.HttpProvider("https://ropsten.infura.io/v3/690b7afa33b64ed985dcd53eb8091ba4"));
}





// store file permanently ""

web3.eth.defaultAccount = web3.eth.accounts[0]; // account we want to use to execute things (takes first account in array)
// web3.eth.defaultAccount = '0xpersonalaccount'

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
		"name": "registerStudent",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
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
		"inputs": [],
		"name": "InvestmentValue",
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
		"name": "InvestorDepositeDate",
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
		"name": "repayment",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "InvestorCount",
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
				"type": "address"
			}
		],
		"name": "_students",
		"outputs": [
			{
				"name": "StudentAddrs",
				"type": "address"
			},
			{
				"name": "applicationDate",
				"type": "uint256"
			},
			{
				"name": "_studentLoanAmount",
				"type": "uint256"
			},
			{
				"name": "loanStatus",
				"type": "uint256"
			},
			{
				"name": "RepaymentsLeft",
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
		"name": "interest",
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
		"name": "StundentLoanAmount",
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
			},
			{
				"name": "studentInterest",
				"type": "uint256"
			},
			{
				"name": "studentTerm",
				"type": "uint256"
			},
			{
				"name": "studentLoanAmount",
				"type": "uint256"
			},
			{
				"name": "studentRepayment",
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
				"name": "_studentLoanAmount",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "RepaymentsLeft",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "loanStatus",
				"type": "uint256"
			}
		],
		"name": "StundentTransaction",
		"type": "event"
	}
]);

// havent given the smart contract address yet, which we need to do
// use the address after deploying contract using environment: Web3 Provider

var User = userContract.at("0xd992333d32ea60f0f0a3d7a8553101e1da18570c");

// want to lonk the contract variables to update when clicking the Update User button

$("#button").click(function(){
	User.buyTokens($("#PurchaseTokens").val(), 
	{from : web3.eth.defaultAccount,  
	 value: $("#PurchaseTokens").val()}); 
})
	//User.buyTokens($("#PurchaseTokens").val(), 
	//{from : web3.eth.defaultAccount,  
	// value: $("#PurchaseTokens").val()}); // calls the buy Tokens function from the smart contract

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


$("#TokenProgress").html("We have reached " + (TotalTokens/NeededTokens)*100 + " % of our KhayeziToken goal!") ;
$("#TotalTokens").html("We aim to raise " + NeededTokens + " KhanyeziTokens")

// calculating the current investment value for Investor profile page 

var InvestmentAmount = User.InvestmentValue.call();
var InvestmentDate = User.InvestorDepositeDate.call();
var interest = User.interest.call();


$("#CalculateInvestment").click(function(error, CurrentInvestment) {
	
	var CurrentTime = Math.round((new Date()).getTime() / 1000);
	//console.log(CurrentTime);
	var TimeDifference = Math.round((CurrentTime - InvestmentDate)/86400);

	console.log("the time in months is " + TimeDifference);
	var CurrentInvestment = InvestmentAmount*222.55*(1 + (interest/365)/100*(TimeDifference));
	//console.log("your current value is " + CurrentInvestment);
	
		$("#InvestmentValue").html("Your current investment value in is R" + CurrentInvestment)

})

// student profile calculation, repayment and returning the number of payments left and how many payments behind

$("#studentbutton").click(function(){
	User.repayment($("#repayment").val(), 
	{from : web3.eth.defaultAccount,  
	 value: $("#repayment").val()}); 
})

var studentEvent = User.StundentTransaction(); // takes a solidity event and stores is in a java variable

studentEvent.watch(function(error, result) { // watch is a function for event 
	
	console.log("you have " + result.args.RepaymentsLeft + " repayments left");

	if(!error){

		$("#studentdetails").html("You have " + result.args.RepaymentsLeft + " payments left, and you are " 
		+ result.args.loanStatus + " payments behind")

    } else {

        console.log(error)

    }

})

// register investors and students when they press the submit button

$("#investorSubmit").click(function(){
	User.registerInvestor({from : web3.eth.defaultAccount})
})

$("#studentSubmit").click(function(){
	User.registerStudent({from : web3.eth.defaultAccount})
})

var studentLoan = User.StundentLoanAmount.call()

$("#loanDetails").html("Your loan is worth " + studentLoan + " ether, and repayment starts today!")




