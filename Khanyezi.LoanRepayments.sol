/*Author: Nyasha C */
//test2

/*
pragma solidity ^0.5.0;

/* This contract stores the following:

Details of all applicants
Loan approval status of loans
Loan terms
SPV which each loan belongs to

And facilitates the following:

Track balances
Assign repayments and amend balance accordingly
Check if the loan has been settled - if so change ownership of the token */


/* This is the constructor which will deploy the contract on the blockchain */


/*struct dataatype to store the loan details */
contract LoanRepayments {

function studentLoan (){
    loanApplicant = msg.sender;
    loan.status = STATUS_INITIATED;
    balances[msg.sender]=150000; /* just a test case */
}

    struct TheLoan{
        uint addressOfLoan;
        uint LoanAmount;
        address owner; /*The students */
    }

    /* struct datatype to store the loan terms */
    struct LoanTerms{
        uint term;
        uint interest;
        uint gracePeriod; /* Will be used to create data from which repayments are expected - dates can be in a separate contract */
        uint loanAmount;
      //  string Tranche;     /* possible values: "KhanyeziSenior","KhanyeziMezzanine",""KhanyeziEquity"" */


}
  /* struct datatype to store the monthly payment structure */
    struct MonthlyPayment{
        uint instalment;
        uint admin_fee; /* to account for gas costs*/

    }

/* The parties involved */
    struct Parties{
        address studentfunded;
        address loanfinancer;
    }
/* Keep a running balance */
    struct Tracker{
        uint PaymentsToDate;
        uint ArrearsStatus;
        uint AmountOverDue;
        uint AmountOverPaid;
        uint LastPayment;
        uint NextPaymentDue;
        uint FirstPaymentDate;
        uint NextPaymentDate;
    }


 /* struct datatype to store the details of the loan contract */
    struct Loan{
        LoanTerms loanterms;
        TheLoan theloan;
        MonthlyPayment monthlypayment;
        Parties parties;
        Tracker tracker;
        int status;
    }

    LoanTerms loanterms;
    TheLoan theloan;
    MonthlyPayment monthlypayment;
    Parties parties;


/*Maps the assosciated financer & student address to their balances */

mapping ( address => uint256) public balances;

/* Only the parties involved may call this function i.e. the student and the investor*/

modifier partiesOnly {
    if(msg.sender != loan.parties.studentfunded) { /* check if there is an or statement which can be used here */
        throw;
    }
}

/* repayment function */
/* Tracking and transferring repayments */
/* Returns the outstanding balance after payment was made*/
/* Calculates next payment due and the date */
/* Keeps track of payment shortfalls and underpayments*/

function repayment(address receiver, uint amount) returns(uint256){
    balances[msg.sender] -= amount; /*reduce students outstanding balance by amount paid */
    balances[receiver]   += amount; /*increase balance of the investor by this amount* */

    if (amount < loan.tracker.NextPaymentDue) { /* if there is a shortfall on the repayment */
        loan.tracker.ArrearsStatus += 1;
    }

    loan.tracker.LastPayment == amount; /* Keep track of most recent repayment amount */
    /* How much is due next month */
    if (balances[msg.sender] < loan.monthlypayment){ /* if the balance remaining is less than the repayment amount */
        loan.tracker.NextPaymentDue == balances[msg.sender];
    } else if (loan.tracker.ArrearsStatus == 0){ /* If no arrears just the contractual amount is due */
        loan.tracker.NextPaymentDue == loan.monthlypayment;
    } else { /* The are in arrears */
        loan.tracker.NextPaymentDue == (loan.monthlypayment - amount) + loan.monthlypayment; /* interest on arrears should be added*/

    }
  }
    checkLoanPayoff() /* Check if this payment has settled the loan */
    return balances[receiver];
}

// Check if the loan payment is complete,
// If complete release the token to the student

function checkLoanPayoff() {
    if(balances[loan.parties.studentfunded])==0{
        loan.TheLoan.owner = loan.parties.studentfunded;
    /* At this point the relevant KhanyeziToken owner would be changed to the student? */
    
    }
}
}

// Tracking of dates , and function to add loans into array still to be done

