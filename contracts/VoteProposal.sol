pragma solidity ^0.4.24;

contract VoteProposal {

    struct Voter {
        bool voted;
        uint8 proposalId;
    }

    mapping(address => Voter) public voters;
    uint256[16] public proposals;
    
    // Phase 1: Simple version, the voting is not associated with any tokens.
    // Each account can cast 1 vote, so vulnerable to Sybil attack.

    constructor() public {}


    /// Give a single vote to proposal $(toProposal).
    function vote(uint8 toProposal) public {
        require(voters[msg.sender].voted || toProposal >= proposals.length);
        
        voters[msg.sender].voted = true;
        voters[msg.sender].proposalId = toProposal;
        proposals[toProposal] += 1;
    }

    function winningProposal() public view returns (uint8) {
        uint256 _maxVoteCount = 0;
        uint8 _winningProposalId = 0;
        for (uint8 _proposalId = 0; _proposalId < proposals.length; _proposalId++) {
            if (proposals[_proposalId] > _maxVoteCount) {
                _maxVoteCount = proposals[_proposalId];
                _winningProposalId = _proposalId;
            }
        }

        return _winningProposalId;
    }

    function getVoteCount(uint _proposalId) public view returns (uint256) {
        require(_proposalId < proposals.length);
        return proposals[_proposalId];
    }

    function getProposals() public view returns (uint256[16] memory) {
        return proposals;
    }

    function alreadyVoted() public view returns (bool) {
        return voters[msg.sender].voted;
    }

}
