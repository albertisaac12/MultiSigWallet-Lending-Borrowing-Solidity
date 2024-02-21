// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract mutlisiglend {
    event SignerAdded(address indexed signer);
    event SignerRevoked(address indexed signer);
    event TransactionRaised(uint indexed txid, address indexed from, address indexed to, uint amount, bytes data);
    event TransactionApproved(uint indexed txid, address indexed signer);
    event LoanApproved(uint indexed lnID, address indexed signer);
    event TransactionExecuted(uint indexed txid, address indexed from, address indexed to, uint amount, bytes data);
    event LoanRequested(uint indexed lnid, address indexed borrower, uint amount, bytes data);
    event LoanApproved(uint indexed lnid, address indexed borrower, uint amount, bytes data);
    event LoanRepaid(uint indexed lnid, address indexed borrower, uint amount);
    event DepositReceived(address indexed sender, uint amount);

    struct txnobj {
        uint txid;
        address from;
        address to;
        uint amount;
        bytes data;
        bool status;
    }

    struct loan {
        uint lnid;
        address borrowe;
        uint amount;
        bytes data;
        bool status;
    }

    uint private signercount;
    uint private txID;
    uint private loanID;
    uint private nextloanID;
    uint public approvals;
    uint private lnID;

    address public owner;
    address[] public sigenrlist;
    address[] public borrowers;
   
    mapping(address=>uint) private amount;
    mapping(address=>bool) public isasigner;
    mapping(address=>mapping(uint=>txnobj)) public txnlist;
    mapping(uint=>mapping(address=>bool)) private appr;
    mapping(uint=>mapping(address=>bool)) private lnapproval;
    mapping(address=>mapping(uint=>loan)) public loanlist;
    mapping(address=>bool) public hasrepayed;
    mapping(address=>uint) public hastaken;
    mapping(address=>uint) public deposits;

    txnobj[] private listoftxns;
    loan[] private listofloans;

    modifier onlyowner {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    modifier onlysigner {
        require(isasigner[msg.sender]);
        _;
    }

    modifier signerexists(address _signer) {
        require(isasigner[_signer], "Invalid Signer address");
        _;
    }

    modifier txnexists(uint _txid) {
        require(_txid <= txID, "Invalid txnID");
        require(!appr[_txid][msg.sender]);
        _;
    }

    modifier txnexists2(uint _txid) {
        require(_txid <= txID, "Invalid txnID");
        require(appr[_txid][msg.sender]);
        _;
    }

    modifier exestatus(uint _txid) {
        require(_txid <= txID, "Invalid txnID");
        require(!listoftxns[_txid].status);
        _;
    }
    
    modifier notasigner {
        require(!isasigner[msg.sender]);
        _;
    }

    modifier loanexists(uint _lnid) {
        require(_lnid < borrowers.length);
        _;
    }

    modifier loannotexecuted(uint _lnid) {
        require(!listofloans[_lnid].status);
        _;
    }

    modifier hasnotrepayed(uint _lnid) {
        require(!hasrepayed[listofloans[_lnid].borrowe]);
        _;
    }

    modifier amtrequire(uint _lnid) {
        uint k = listofloans[_lnid].amount;
        require(msg.value == k + (k / 100));
        _;
    }

    constructor(address[] memory _signers, uint _approvals) {
        require(_approvals >= 4);
        approvals = _approvals;
        owner = msg.sender;
        if (_signers.length >= 1) {
            for (uint k; k < _signers.length; k++) {
                sigenrlist.push(_signers[k]);
                isasigner[_signers[k]] = true;
                signercount++;
            }
        }
    }

    function addsigner(address _signer) external onlyowner {
        sigenrlist.push(_signer);
        isasigner[_signer] = true;
        emit SignerAdded(_signer);
    }
   
    function revokesigner(address _signer) external onlyowner signerexists(_signer) {
        uint index;
        isasigner[_signer] = false;
        for (uint m; m < sigenrlist.length; m++) {
            if (sigenrlist[m] == _signer) {
                index = m;
                break;
            }
        }
        delete sigenrlist[index];
        emit SignerRevoked(_signer);
    }

    function raiseatxnrequest(address _to, uint _amount, bytes calldata _data) external onlysigner returns(uint) {
        txnobj memory tranction =  txnobj(txID, msg.sender, _to, _amount, _data, false);
        listoftxns.push(tranction);
        txnlist[msg.sender][txID] = tranction;
        appr[txID][msg.sender] = true;
        txID++;
        emit TransactionRaised(txID - 1, msg.sender, _to, _amount, _data);
        return txID - 1;
    }

    function txnapproval(uint _txid) external onlysigner txnexists(_txid) {
        appr[_txid][msg.sender] = true;
        emit TransactionApproved(_txid, msg.sender);
    }

    function lnapprovals(uint _lnID) external onlysigner loanexists(_lnID){
        lnapproval[_lnID][msg.sender]=true;
        emit LoanApproved(_lnID, msg.sender);
    }

    function executetxn(uint _txid) external onlysigner txnexists2(_txid) exestatus(_txid) {
        require(getapproval(_txid) >= approvals);
        (bool success,) = (listoftxns[_txid].to).call{value : listoftxns[_txid].amount}(listoftxns[_txid].data);
        require(success, "Execution failed");
        listoftxns[_txid].status = true;
        emit TransactionExecuted(_txid, listoftxns[_txid].from, listoftxns[_txid].to, listoftxns[_txid].amount, listoftxns[_txid].data);
    }

    function raiseloanrequest(uint _amount, bytes calldata _data) notasigner external returns(uint) {
        require(_amount < gettotalamount());
        borrowers.push(msg.sender);
        loan memory Loan = loan(loanID, msg.sender, _amount, _data, false);
        listofloans.push(Loan);
        loanID++;
        emit LoanRequested(loanID - 1, msg.sender, _amount, _data);
        return loanID - 1;
    }

    function approveloan(uint _lnid) external onlysigner loanexists(_lnid) loannotexecuted(_lnid) {
        require(getlnapprovals(_lnid)==3,"This loan was not approved by the majority of the Signers");
        listofloans[_lnid].status = true;
        hastaken[listofloans[_lnid].borrowe] = listofloans[_lnid].amount;
        hasrepayed[listofloans[_lnid].borrowe] = false;
        (bool success,) = (listofloans[_lnid].borrowe).call{value : listofloans[_lnid].amount}(listofloans[_lnid].data);
        require(success);
        emit LoanApproved(_lnid, listofloans[_lnid].borrowe, listofloans[_lnid].amount, listofloans[_lnid].data);
    }

    function repayloan(uint _lnid) external loanexists(_lnid) hasnotrepayed(_lnid) amtrequire(_lnid) payable {
        require(msg.value == listofloans[_lnid].amount);
        for (uint k; k < sigenrlist.length; k++) {
            uint share = (deposits[sigenrlist[k]] * listofloans[_lnid].amount) / gettotalamount();
            payable(sigenrlist[k]).transfer(share);
        }
        emit LoanRepaid(_lnid, listofloans[_lnid].borrowe, msg.value);
    }

    function deposit() external payable onlysigner {
        require(msg.value > 0);
        deposits[msg.sender] += msg.value;
        emit DepositReceived(msg.sender, msg.value);
    }

    function gettotalamount() private view returns(uint _amount) {
        for (uint m; m < sigenrlist.length; m++) {
            _amount += amount[sigenrlist[m]];
        }
    }
    
    function getapproval(uint _txid) private view returns(uint ct) {
        for (uint i; i < sigenrlist.length; i++) {
            if (appr[_txid][sigenrlist[i]]) {
                ct++;
            }
        }
    }

    function getlnapprovals(uint _lnID) private view returns(uint ct){
        for(uint i;i<sigenrlist.length;i++){
            if(lnapproval[_lnID][sigenrlist[i]]){
                ct++;
            }
        }
    }


    receive() external payable {
        amount[msg.sender] += msg.value;
    }
}
