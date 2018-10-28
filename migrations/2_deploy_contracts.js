/*
var DotToken = artifacts.require("DotToken");
var VoteProposal = artifacts.require("VoteProposal");

module.exports = function(deployer) {
  deployer.deploy(DotToken).then(function(){
    deployer.deploy(VoteProposal, DotToken.address)});
};
*/

var VoteProposal = artifacts.require("VoteProposal");

module.exports = function(deployer) {
  deployer.deploy(VoteProposal);
};