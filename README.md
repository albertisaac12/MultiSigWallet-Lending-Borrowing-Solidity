# MultiSigWallet-Lending-Borrowing Contract

This contract is a Solidity implementation of a MultiSigWallet-Lending-Borrowing system, enabling decentralized peer-to-peer lending and borrowing of digital assets through multi-signature wallets.

## Features

- **Multi-Signature Wallets**: Control over funds is distributed among multiple parties, typically lenders and borrowers, using multi-signature wallets.
- **Lending and Borrowing**: Lenders can deposit digital assets into a shared pool, while borrowers can request loans from this pool with predefined terms.
- **Transaction Approval**: Transactions are initiated, approved, and executed through a consensus mechanism involving multiple signers.
- **Loan Approval and Repayment**: Loans can be approved by signers and repaid by borrowers with interest, facilitating transparent and secure lending processes.
- **Financial Inclusion**: The contract promotes financial inclusion by offering borderless and permissionless access to lending and borrowing facilities.

## Contract Structure

The contract consists of the following key components:

- **MultiSigWallet**: Manages the multi-signature wallets and facilitates transaction approval.
- **Loan Management**: Handles loan requests, approvals, and repayments, ensuring transparent and secure lending operations.
- **Event Logging**: Logs events such as transaction raising, approval, execution, loan requests, approvals, and repayments for transparency and auditing purposes.

## Modifiers

- `onlyowner`: Ensures that only the contract owner can execute the function.
- `onlysigner`: Restricts the function to be accessible only by authorized signers.
- `signerexists(address _signer)`: Verifies the existence of a signer with the provided address.
- `txnexists(uint _txid)`: Checks the existence of a transaction with the given ID.
- `txnexists2(uint _txid)`: Validates the existence of a transaction and that the sender has already approved it.
- `exestatus(uint _txid)`: Verifies that the transaction with the given ID has not been executed yet.
- `notasigner`: Ensures that the sender is not a signer.
- `loanexists(uint _lnid)`: Checks if a loan exists with the provided ID.
- `loannotexecuted(uint _lnid)`: Verifies that the loan with the given ID has not been executed yet.
- `hasnotrepayed(uint _lnid)`: Checks if the borrower has not repaid the loan yet.
- `amtrequire(uint _lnid)`: Requires the sent amount to match the loan amount plus interest.

## Functions

### Callable Functions

- `addsigner(address _signer)`: Adds a new signer to the list of authorized signers.
- `revokesigner(address _signer)`: Revokes signer privileges from a specified address.
- `raiseatxnrequest(address _to, uint _amount, bytes calldata _data)`: Initiates a transaction request to transfer funds.
- `txnapproval(uint _txid)`: Approves a transaction request.
- `lnapprovals(uint _lnID)`: Approves a loan request.
- `executetxn(uint _txid)`: Executes an approved transaction.
- `raiseloanrequest(uint _amount, bytes calldata _data)`: Initiates a loan request from the shared pool.
- `approveloan(uint _lnid)`: Approves a loan request.
- `repayloan(uint _lnid)`: Repays a loan with interest.
- `deposit()`: Allows signers to deposit funds into the shared pool.

### Internal Functions

- `gettotalamount()`: Calculates the total amount of funds in the shared pool.
- `getapproval(uint _txid)`: Gets the number of approvals for a transaction.
- `getlnapprovals(uint _lnID)`: Gets the number of approvals for a loan.

## Events

- `SignerAdded(address indexed signer)`: Triggered when a new signer is added.
- `SignerRevoked(address indexed signer)`: Triggered when signer privileges are revoked.
- `TransactionRaised(uint indexed txid, address indexed from, address indexed to, uint amount, bytes data)`: Triggered when a transaction is raised.
- `TransactionApproved(uint indexed txid, address indexed signer)`: Triggered when a transaction is approved.
- `TransactionExecuted(uint indexed txid, address indexed from, address indexed to, uint amount, bytes data)`: Triggered when a transaction is executed.
- `LoanRequested(uint indexed lnid, address indexed borrower, uint amount, bytes data)`: Triggered when a loan is requested.
- `LoanApproved(uint indexed lnid, address indexed borrower, uint amount, bytes data)`: Triggered when a loan is approved.
- `LoanRepaid(uint indexed lnid, address indexed borrower, uint amount)`: Triggered when a loan is repaid.
- `DepositReceived(address indexed sender, uint amount)`: Triggered when funds are deposited into the shared pool.

## Getting Started

To deploy the contract and interact with it, follow these steps:

1. **Setup Environment**: Ensure you have a Solidity development environment set up, including a compatible compiler and a suitable development network.
2. **Compile Contract**: Compile the `mutlisiglend.sol` Solidity file using your preferred compiler.
3. **Deploy Contract**: Deploy the compiled contract to your chosen development network or blockchain platform.
4. **Interact with Contract**: Use provided functions and events to interact with the contract, including raising transactions, approving transactions, requesting loans, approving loans, and repaying loans.

## Usage Examples

Here are some example interactions with the contract:

1. **Raising a Transaction**: Lenders or borrowers can raise transactions to deposit or withdraw funds from the shared pool.
2. **Approving a Transaction**: Signers can approve transactions initiated by lenders or borrowers.
3. **Requesting a Loan**: Borrowers can request loans from the shared pool, specifying the loan amount and terms.
4. **Approving a Loan**: Signers can approve loan requests initiated by borrowers.
5. **Repaying a Loan**: Borrowers can repay loans with interest, ensuring timely repayment and maintaining the integrity of the lending system.

## NOTICE

1. PLEASE NOTE THAT THIS SMART CONTRACT WAS WRITTEN TO SHOW MY DEVELOPMENT SKILLS. IF DEPLOYED ON THE MAINNET AND LOSSES ARE INCURRED I AM NOT RESPONSIBLE.
2. ALSO IF YOU ARE NOT SURE HOW TO DEPLOY A SMART CONTRACT OR SET UP A WALLET PLEASE REFER TO MY MULTISIG WALLET SMART CONTRACT CODE [https://github.com/albertisaac12/MultiSigWallet]
3. FOR ANY QUERIES PLEASE FEEL FREE PING ME ON LINKEDIN [https://www.linkedin.com/in/abhigadipalli/]
