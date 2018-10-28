pragma solidity ^0.4.24;

//import "./DotToken.sol";


contract VoteProposal {

    //DotToken public dotTokenContract;

    struct Voter {
        bool voted;
        uint8 vote;
    }

    //address chairperson;
    mapping(address => Voter) public voters;
    uint256[16] public proposals;


    /// Create a new ballot with $(_numProposals) different proposals.
    /*
    constructor(address dotTokenAddr) public {
        dotTokenContract = DotToken(dotTokenAddr);
    }


    /// Give a single vote to proposal $(toProposal).
    function vote(uint8 toProposal, uint8 weight) public {
        
        Voter storage sender = voters[msg.sender];
        if (sender.voted || toProposal >= proposals.length) return;
        
        uint balance = dotTokenContract.balanceOf(msg.sender);
        //No right to vote if voter has no balance.
        if (weight < balance) return;
        
        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal] += weight;
    }

    function winningProposal() public constant returns (uint8 _winningProposal) {
        uint256 winningVoteCount = 0;
        for (uint8 prop = 0; prop < proposals.length; prop++)
            if (proposals[prop] > winningVoteCount) {
                winningVoteCount = proposals[prop];
                _winningProposal = prop;
            }
    }

    function getProposals() public constant returns (uint256[16]) {
        return proposals;
    }
    */

    constructor() public {}


    /// Give a single vote to proposal $(toProposal).
    function vote(uint8 toProposal) public {
        
        Voter storage sender = voters[msg.sender];
        if (sender.voted || toProposal >= proposals.length) return;
        
        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal] += 1;
    }

    function winningProposal() public constant returns (uint8 _winningProposal) {
        uint256 winningVoteCount = 0;
        for (uint8 proposalId = 0; proposalId < proposals.length; proposalId++)
            if (proposals[proposalId] > winningVoteCount) {
                winningVoteCount = proposals[proposalId];
                _winningProposal = proposalId;
            }
    }

    function getVoteCount(uint _proposalId) public constant returns (uint256) {
        require(_proposalId < proposals.length);
        return proposals[_proposalId];
    }

    function getProposals() public constant returns (uint256[16]) {
        return proposals;
    }

    function alreadyVoted() public constant returns (bool) {
        return voters[msg.sender].voted;
    }

}