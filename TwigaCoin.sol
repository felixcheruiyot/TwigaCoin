
pragma solidity ^0.4.18;

/**
 * @title TwigaCoin
 * @dev A ERC20 compliant coin
 * @author Felix Cheruiyot <felix.cheruiyot@kenyaapps.net>
 */
contract ERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    function allowance(address owner, address spender) public view returns (uint256);
    function transferFrom(address from, address to, uint256 value) public returns (bool);
    function approve(address spender, uint256 value) public returns (bool);
}

contract TwigaCoin is ERC20 {
    string public constant name = "TwigaCoin";
    string public constant symbol = "TC";
    uint256 public constant smallestUnit = 2;
    uint256 supply;
    mapping (address => uint) public balances;
    mapping (address => mapping (address => uint256)) internal allowed;
    
    /*
     * Initialize coin with name, symbol and initial supply
     * Fund the creator with all the coins
     */
    function TwigaCoin(uint256 _supply) public {
        supply = _supply * (10**smallestUnit);
        balances[msg.sender] = _supply;
    }
    
    
    /*
     * Show total number of coins initially supplied
     */
    function totalSupply()  public view returns (uint256) {
        return supply;
    }
    
    /*
     * Display address balance
     */
    function balanceOf(address who) public view returns (uint256) {
        return balances[who];
    }
    
    /*
     * Show total number of coins initially supplied
     */
    function transfer(address to, uint256 value) public returns (bool) {
        require(balances[msg.sender] > value);
        balances[msg.sender] -= value;
        balances[to] += value;
        Transfer(msg.sender, to, value);
        return true;
    }
    
    /*
     * Display how much a spender is allowed to access
     */
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }
    
    /*
     * Transfer fund from the owner to the approved spender
     */
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(to != address(0));
        require(value <= balances[from]);
        require(value <= allowed[from][msg.sender]);
        
        balances[from] -= value;
        balances[to] += value;
        allowed[from][msg.sender] = allowed[from][msg.sender] - value;
        Transfer(from, to, value);
        return true;
    }
    
    /*
     * The token owner allocate some to a known spender and 
     * and decide the limit of how much can be spent.
     */
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
}

