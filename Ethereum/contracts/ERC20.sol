// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract ERC20 {
    string private _name;
    string private _symbol;

    uint8 public decimals = 18; 

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    uint256 _totalSupply;


    /**
     * @notice MUST trigger when tokens are transferred, including zero value transfers.
     * @dev A token contract which creates new tokens SHOULD trigger a Transfer event with the _from address set to 0x0 when tokens are created.
    */
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);


    /**
     * @notice MUST trigger on any successful call to approve(address _spender, uint256 _value).   
     */
    event Transfer(address indexed from, address indexed to, uint tokens);


    /**
     * @dev Sets the values for {name} and {symbol} and {totalSupply}.
     * @dev Sets the balance of msg.sender to totalSupply    
     */
    constructor(string memory name_, string memory symbol_, uint256 totalSupply_) {
        _name = name_;
        _symbol = symbol_;
        _totalSupply = totalSupply_;
        balances[msg.sender] = totalSupply_;
    }  


    /**
     * @dev Returns the name of the token.
     */
    function name() public view  returns (string memory) {
        return _name;
    }


    /**
     * @dev Returns the symbol of the token, usually a shorter version of the name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }


    /**
     * @notice Returns the total token supply.
     * @return  uint256, totalSupply of the tokens in number.   
     */
    function totalSupply() public view returns (uint256) {
	    return _totalSupply;
    }


    /**
     * @notice Returns the account balance of another account with address _owner.
     * @param _owner,  address of the owner
     * @return uint2556, the balance of owner's account
     */
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }


    /**
     * @notice Allows _spender to withdraw from your account multiple times, up to the _value amount. 
     * @dev If this function is called again it overwrites the current allowance with _value.
     * @param _spender, address of spender account
     * @param _value, amount to token to transfer
     * @return bool, status if transfer is successful or not.
     */
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        
        emit Approval(msg.sender, _spender, _value);
        return true;
    }


    /**
     * @notice Returns the amount which _spender is still allowed to withdraw from _owner.
     * @param _owner, address of the owner account
     * @param _spender, address of the spender account.
     * @return uint256, remaining allowance remains.
     */
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }


    /**
     * @notice Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. 
     * @dev The function SHOULD amount to token to transferthrow if the message caller’s account balance does not have enough tokens to spend.
     * @dev Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.
     * @param _to, address of account to transfer tokens to
     * @param _value, number of tokens transferred to _to.
     * @return bool, status if transfer is successful or not.
    */
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_value <= balances[msg.sender], "Not enough balance");
        require(_value <= allowed[msg.sender][_to], "Not allowed to send any more tokens");
        
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
        
        emit Transfer(msg.sender, _to, _value);
        return true;
    }


    /**
     * @notice Transfers _value amount of tokens from address _from to address _to, and MUST fire the Transfer event.
     * @dev The transferFrom method is used for a withdraw workflow, allowing contracts to transfer tokens on your behalf. 
     * @dev This can be used for example to allow a contract to transfer tokens on your behalf and/or to charge fees in sub-currencies. 
     * @dev The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism.
     * @param _from, address of the account to send tokens from.
     * @param _to, address of the account to send tokens to.
     * @param _value, number of tokens transferred from _from to _to.
     * @return bool, status if transfer is successful or not. 
    */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_value <= balances[_from], "Not enough balance");    
        require(_value <= allowed[_from][msg.sender], "Not allowed to send any more tokens");
    
        balances[_from] = balances[_from] - _value;
        
        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
        
        balances[_to] = balances[_to] + _value;
        
        emit Transfer(_from, _to, _value);
        return true;
    }
     
}