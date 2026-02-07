// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;


interface IERC20 {
    // --- Events ---
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // --- Read-only functions ---
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    // --- State-changing functions ---
    function transfer(address to, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}


contract ERC20 is IERC20{
    uint public totalSupply;
    mapping (address => uint) public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;
    
    address public immutable dev;

    constructor(uint amount) {
        _mint(amount);
        dev = msg.sender;
    }

    modifier onlyDev() {
        require(msg.sender == dev, "Not authorized");
        _;
    }

    string public name = "Test";
    string public symbol = "TEST";
    uint8 public decimals = 18;

    function transfer(address to, uint256 amount) external returns (bool) {
        require(to != address(0), "Zero address");
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        require(spender != address(0), "Zero address");
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool) {
        require(from != address(0), "Zero address");
        require(balanceOf[from] >= amount, "Insufficient balance");
        require(
    allowance[from][msg.sender] >= amount,
    "Allowance exceeded"
);

        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function _mint(uint amount) internal  {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function mint(uint amount) external onlyDev{
        _mint(amount);
    }

    function burn(uint amount) external onlyDev{
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}