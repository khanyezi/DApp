# Smart-contracts

## KhanyeziTokens

First added smart contract is for the 3 different tokens we are creating for investors to invest in:

* KhanyeziSenior
* KhanyeziMezzanine
* KhanyeziEquity

These were created using ERC20 standard

## Khanyezi.LoanRepayments

The second smart contract keeps track of all Khanyezi student loans.

It does the following:

* Adds all new Khanyezi student loans to Khanyezi loan directory
* Tracks and assigns deposits made into loan account by students
* Generates invoice amounts, and dates
* Creates and monitors the status of loans i.e. up to date or in arrears
* Allocates deposits to relevant tranches
* Checks if the loan is settled, if so transfers token ownership to student
