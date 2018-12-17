pragma solidity ^0.4.24;

contract VoteProposal {

    struct Voter {
        bool voted;
        uint8 vote;
    }

    mapping(address => Voter) public voters;
    uint256[16] public proposals;
    
    // Phase 1: Simple version, the voting is not associated with any tokens.
    // Each account can cast 1 vote, so vulnerable to Sybil attack.

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
