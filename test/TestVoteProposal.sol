pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/VoteProposal.sol";

contract TestVoteProposal {
	// The address of the contract to be tested  
	VoteProposal voting = VoteProposal(DeployedAddresses.VoteProposal());

	function testVote() public {
		//Vote for proposal 1.
		voting.vote(1);
		uint256[16] memory proposals = voting.getProposals();

		Assert.equal(proposals[1], 1, "Failed to vote for proposal 1.");
	}

}
