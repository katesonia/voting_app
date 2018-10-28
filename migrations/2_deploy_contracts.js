/*
var DotToken = artifacts.require("DotToken");

module.exports = function(deployer) {
  deployer.deploy(DotToken, 0x147D434e85e5D80552C8d5610C335e17ecAdCAa1);
};
*/

var VoteProposal = artifacts.require("VoteProposal");

module.exports = function(deployer) {
  deployer.deploy(VoteProposal);
};