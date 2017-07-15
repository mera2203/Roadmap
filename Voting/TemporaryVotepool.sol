pragma solidity ^0.4.11;

contract ERC223Basic {
    uint public totalSupply;
    function balanceOf(address who) constant returns (uint);
    function transfer(address to, uint value);
    function transfer(address to, uint value, bytes data);
    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
}


contract Temporary_Votepool
{
    
    mapping (address => bool) public muted;
    
    address public owner = msg.sender;
    address public token = 0x7DF6e544E090418f2ad76DE3C424467be52f4203;
    
    string public name;
    
    mapping (address => uint256) public deposited;
    
    function Vote_Name() constant returns (string _name) { return name; }
    
    function tokenFallback(address _from, uint256 _value, bytes _data)
    {
        if(msg.sender == token)
        {
            deposited[_from] += _value;
        }
        else 
        {
            throw;
        }
    }
    
    function Refund(address _who) only_owner
    {
        ERC223Basic Token = ERC223Basic(token);
        Token.transfer(_who, deposited[_who]);
        deposited[_who] = 0; 
    }
    
    function Update_Proposal(string _proposal) only_owner
    {
        name = _proposal;
    }
    
    function Withdraw()
    {
        ERC223Basic Token = ERC223Basic(token);
        Token.transfer(msg.sender, deposited[msg.sender]);
        deposited[msg.sender] = 0; 
    }
    
    function Total_Score() constant returns (uint256)
    {
        ERC223Basic Token = ERC223Basic(token);
        return Token.balanceOf(this);
    }
    
    modifier only_owner
    {
        if(msg.sender != owner)
        {
            throw;
        }
        _;
    }
    
    modifier mutex
    {
        if( muted[msg.sender] )
        {
            throw;
        }
        
        muted[msg.sender] = true;
        _;
        
        muted[msg.sender] = false;
    }
}
