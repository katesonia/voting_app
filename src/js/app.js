App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    // Load pets.
    $.getJSON('../pets.json', function(data) {
      var petsRow = $('#petsRow');
      var petTemplate = $('#petTemplate');

      for (i = 0; i < data.length; i ++) {
        petTemplate.find('.panel-title').text(data[i].name);
        petTemplate.find('img').attr('src', data[i].picture);
        petTemplate.find('.pet-breed').text(data[i].breed);
        petTemplate.find('.pet-age').text(data[i].age);
        petTemplate.find('.pet-location').text(data[i].location);
        petTemplate.find('.btn-adopt').attr('data-id', data[i].id);

        petsRow.append(petTemplate.html());
      }
    });

    return App.initWeb3();
  },

  initWeb3: function() {

    // Is there an injected web3 instance?
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
    } else {
      // If no injected web3 instance is detected, fall back to Ganache
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('VoteProposal.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var VotingArtifact = data;
      App.contracts.VoteProposal = TruffleContract(VotingArtifact);

      // Set the provider for our contract
      App.contracts.VoteProposal.setProvider(App.web3Provider);

      // Use our contract to retrieve and mark the adopted pets
      return App.showProposalVote();
    });

    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '.btn-adopt', App.voteProposal);
  },

  showProposalVote: function(proposals, account) {
    var voteInstance;

    App.contracts.VoteProposal.deployed().then(function(instance) {
      voteInstance = instance;

      return voteInstance.getProposalVotes.call();
    }).then(function(proposals) {
      for (i = 0; i < proposals.length; i++) {
        $('.panel-pet').eq(i).find('button').text('Success').attr('disabled', true);
      }
    }).catch(function(err) {
      console.log(err.message);
      console.log("Current provider is:");
      console.log(window.web3.currentProvider);
      console.log("Web3 network id is:");
      console.log(window.web3.version.getNetwork(function(err,res){console.log(res)}));
    });
  },

  voteProposal: function(event) {
    event.preventDefault();

    var proposalId = parseInt($(event.target).data('id'));

    var voteInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.VoteProposal.deployed().then(function(instance) {
        voteInstance = instance;

        // Execute adopt as a transaction by sending account
        // Default to vote 1
        return voteInstance.vote(proposalId, 1, {from: account});
      }).then(function(result) {
        return App.showProposalVote();
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
