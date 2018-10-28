pragma solidity ^0.4.24;

//import "./DotToken.sol";


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
    

    /*
    // Phase 2: Advanced version, the voting is associated with DotToken balance.
    // Each vote will cost 1 DotToken, so we can avoid Sybil attack.
    // We need to deploy another contract DotToken (ERC 20 tokens), and pass the 
    // contract address to VoteProposal constructor.

    DotToken public dotTokenContract;

    constructor() public {
        dotTokenContract = DotToken(0x192948e5b93a1d9b1cd7bf92556b1c274e9ff6ae);
    }


    /// Give a single vote to proposal $(toProposal).
    function vote(uint8 toProposal) public {
        
        uint256 balance = dotTokenContract.balanceOf(msg.sender);
        // You should have at lease 1 DotToken to be able to vote.
        require(balance >= 1);

        Voter storage sender = voters[msg.sender];
        if (sender.voted || toProposal >= proposals.length) return;
        
        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal] += 1;
        // Destroy 1 token since it's used in one vote.
        dotTokenContract.destroyTokens(msg.sender, 1);
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
    */

}