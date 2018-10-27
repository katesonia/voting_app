pragma solidity ^0.4.24;

// ----------------------------------------------------------------------------
// DOT token contract
//
// Symbol      : DOT
// Name        : DOT Token
// Decimals    : 18
//
//
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}
// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------
contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


contract DotToken is ERC20Interface{
    using SafeMath for uint;

    string public symbol;
    string public name;
    uint8 public decimals;
    uint public _totalSupply;

    mapping(address => uint) balances;

    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor() public payable{
        symbol = 'DOT';
        name = 'DOT Token';
    }

    // ------------------------------------------------------------------------
    // Total supply
    // ------------------------------------------------------------------------
    function totalSupply() public constant returns (uint) {
        return _totalSupply  - balances[address(0)];
    }


    // ------------------------------------------------------------------------
    // Get the token balance for account `tokenOwner`
    // ------------------------------------------------------------------------
    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }

    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to `to` account
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    // ------------------------------------------------------------------------
    // Transfer `tokens` from the `from` account to the `to` account
    //
    // The calling account must already have sufficient tokens approve(...)-d
    // for spending from the `from` account and
    // - From account must have sufficient balance to transfer
    // - Spender must have sufficient allowance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = balances[from].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        return true;
    }


    // People cannot transfer ETH to the smart contract address.
    // No ether for now.
    function () public payable {
        revert();
    }

    // Implement these 2 just to avoid this contract to be abstract, do NOT use.
    function approve(address spender, uint tokens) public returns (bool success) {
        return true;
    }
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return 0;
    }
    ///////////
    // Generate and destory tokens
    ///////////

    // Generates `amount` tokens and assign them to `receiver`
    // @param receiver address
    // @param amount the quantity of tokens generated
    // @return True if tokens are generated correctly
    function generateTokens(address receiver, uint amount) public returns (bool) {
        _totalSupply.add(amount);
        balances[receiver] = balances[receiver].add(amount);
        emit Transfer(0, receiver, amount);
        return true;
    }

    // Burns `amount` tokens from `owner`
    // @param owner the address that will lose tokens
    // @param amount the quantity of tokens to burn
    // @return True if tokens are burned correctly
    function destroyTokens(address owner, uint amount) public returns (bool) {
        require(balances[owner] >= amount);
        _totalSupply.sub(amount);
        balances[owner] = balances[owner].sub(amount);
        emit Transfer(owner, 0, amount);
        return true;
    }
    
}