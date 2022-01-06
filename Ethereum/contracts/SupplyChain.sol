// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract SupplyChain {
    address public owner;
    uint public skuCount;

    enum State { 
        ForSale, 
        Sold, 
        Shipped, 
        Received 
    }

    // Item Structure
    struct Item {
        string name;
        uint sku;
        uint price;
        State state;
        address payable seller;
        address payable buyer;
    }
    
    mapping(uint => Item) public items;

    event LogForSale(uint sku);

    event LogSold(uint sku);

    event LogShipped(uint sku);

    event LogReceived(uint sku);

    /// @notice Modifier to check if the caller is the owner
    modifier isOwner(){
      require(msg.sender == owner, 'Not the owner');
      _;
    }

    /// @notice Modifier to verify the caller
    modifier verifyCaller (address _address) { 
      require (msg.sender == _address); 
      _; 
    }

    /// @notice Modifier to verify the if the caller has paid enough
    modifier paidEnough(uint _price) { 
      require(msg.value >= _price); 
      _;
    }

    /// @notice Modifier to verify the value for refund
    modifier checkValue(uint _sku) {
      _;
      uint _price = items[_sku].price;
      uint amountToRefund = msg.value - _price;
      items[_sku].buyer.transfer(amountToRefund);
    }

    /// @notice Modifier to verify if the item is for sale
    modifier forSale(uint _sku) {
      require(items[_sku].state == State.ForSale, 'Item is not for sale');
      _;
    }
    
    /// @notice Modifier to verify if the item is sold
    modifier sold(uint _sku) {
      require(items[_sku].state == State.Sold, 'Item is not sold');
      _;
    }
    
    /// @notice Modifier to verify if the item is shipped
    modifier shipped(uint _sku) {
      require(items[_sku].state == State.Shipped, 'Item is not shipped');
      _;
    }
    
    /// @notice Modifier to verify if the item is received
    modifier received(uint _sku) {
      require(items[_sku].state == State.Received, 'Item is not for received');
      _;
    }

    constructor() {
      owner = msg.sender;
    }

    /// @notice Add the information of the item to the supply chain and set it for sale
    /// @param _name The name of the item
    /// @param _price The price of the item 
    /// @return bool return true if the item is added to the supply chain for sale
    function addItem(string memory _name, uint _price) public returns (bool) {
        items[skuCount] = Item({
          name: _name, 
          sku: skuCount, 
          price: _price, 
          state: State.ForSale, 
          seller: payable(msg.sender),
          buyer: payable(address(0))
        });

        skuCount = skuCount + 1;

        emit LogForSale(skuCount);

        return true;
    }

    /// @notice Buy the item
    /// @dev The buyer must pay the seller the price of the item
    /// @dev The item should be in the for sale state
    /// @dev Put the item in the sold state
    /// @param sku The sku of the item
    function buyItem(uint sku) public payable 
        forSale(sku) 
        paidEnough(items[sku].price) 
        checkValue(sku) {
          
        items[sku].buyer = payable(msg.sender);

        items[sku].seller.transfer(items[sku].price);

        items[sku].state = State.Sold;

        emit LogSold(sku);
    }

    /// @notice Ship the item
    /// @dev The item should be in the sold state
    /// @dev Put the item in the shipped state
    /// @param sku The sku of the item
    function shipItem(uint sku) public 
        sold(sku) 
        verifyCaller(items[sku].seller) {
          
        items[sku].state = State.Shipped;

        emit LogShipped(sku);
    }

    /// @notice Receive the item
    /// @dev The item should be in the shipped state
    /// @dev Put the item in the received state
    /// @param sku The sku of the item
    function receiveItem(uint sku) public 
        shipped(sku) 
        verifyCaller(items[sku].buyer) {
          
        items[sku].state = State.Received;

        emit LogReceived(sku);
    }

    /// @notice Get the information of the item
    /// @param _sku The sku of the item
    /// @return The information of the item
    function fetchItem(uint _sku) public view 
        returns (string memory, uint, uint, uint, address, address) { 
          
        string memory name = items[_sku].name;
        uint sku = items[_sku].sku;
        uint price = items[_sku].price; 
        uint state = uint(items[_sku].state); 
        address seller = items[_sku].seller; 
        address buyer = items[_sku].buyer; 
        return (name, sku, price, state, seller, buyer); 
    } 
}