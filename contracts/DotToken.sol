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
    
    uint256 constant private MAX_UINT256 = 2**256 - 1;

    string public symbol;
    string public name;
    uint8 public decimals;
    uint public _totalSupply;

    address admin;

    mapping(address => uint256) balances;
    mapping (address => mapping (address => uint256)) public allowed;

    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor() public payable{
        symbol = 'DOT';
        name = 'DOT Token';   //How many decimals to show.
        decimals = 3;
        admin = 0x147D434e85e5D80552C8d5610C335e17ecAdCAa1;
    }

    // ------------------------------------------------------------------------
    // Total supply
    // ------------------------------------------------------------------------
    function totalSupply() public constant returns (uint) {
        return _totalSupply;
    }


    // ------------------------------------------------------------------------
    // Get the token balance for account `tokenOwner`
    // ------------------------------------------------------------------------
    function balanceOf(address _owner) public constant returns (uint balance) {
        return balances[_owner];
    }

    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to `to` account
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
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
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        if (allowance < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }


    // People cannot transfer ETH to the smart contract address.
    // No ether for now.
    function () public payable {
        revert();
    }

    // Implement these 2 just to avoid this contract to be abstract, do NOT use.
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    ///////////
    // Generate and destory tokens
    ///////////

    // Generates `amount` tokens and assign them to `receiver`
    // @param receiver address
    // @param amount the quantity of tokens generated
    // @return True if tokens are generated correctly
    function generateTokens(address _receiver, uint256 _value) public returns (bool) {
        // Only admin user can generate and destory tokens.
        require(msg.sender == admin);
        _totalSupply.add(_value);
        balances[_receiver] = balances[_receiver].add(_value);
        emit Transfer(0, _receiver, _value);
        return true;
    }

    // Burns `amount` tokens from `owner`
    // @param owner the address that will lose tokens
    // @param amount the quantity of tokens to burn
    // @return True if tokens are burned correctly
    function destroyTokens(address _owner, uint256 _value) public returns (bool) {
        // Only admin user can generate and destory tokens.
        require(msg.sender == admin);
        require(balances[_owner] >= _value);
        _totalSupply.sub(_value);
        balances[_owner] = balances[_owner].sub(_value);
        emit Transfer(_owner, 0, _value);
        return true;
    }
    
}