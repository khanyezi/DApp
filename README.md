# Smart-contracts

## KhanyeziTokens

First added smart contract is for the 3 different tokens we are creating for investors to invest in:

* KhanyeziSenior
* KhanyeziMezzanine
* KhanyeziEquity

These were created using ERC20 standard. 

Each token is deployed from the main Khanyezi token smart contract, under the different details. 

## Khanyezi.LoanRepayments

The second smart contract keeps track of all Khanyezi student loans.

It does the following:

* Adds all new Khanyezi student loans to Khanyezi loan directory
* Tracks and assigns deposits made into loan account by students
* Generates invoice amounts, and dates
* Creates and monitors the status of loans i.e. up to date or in arrears
* Allocates deposits to relevant tranches
* Checks if the loan is settled, if so transfers token ownership to student

## InvestmentVehicle

The investment vehicle smart contract keeps track of the investors and allows them to purchase one of the three Khanyezi tokens. 

This contract is still in it's early development starges. 
This contract may include the struture of the SPV.
