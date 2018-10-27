pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/VoteProposal.sol";

contract TestVoteProposal {
	VoteProposal vote = VoteProposal(DeployedAddresses.VoteProposal());

	// Testing the adopt() function
	function testAssert() public {
	  Assert.equal(true, true, "Place holder for a test.");
	}

}