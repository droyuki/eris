contract Purchase
{
    uint public value;
    address public seller;
    address public buyer;
    uint balance;
    uint startTime;
    uint stopTime;
    enum State { Created, Locked, Inactive }
    State public state;

    function Purchase() {
        seller = msg.sender;
    }
    function init() constant returns (address addr){
        
    }

    function start(){

    }

    modifier require(bool _condition)
    {
        if (!_condition) throw;
        _
    }
    modifier onlyBuyer()
    {
        if (msg.sender != buyer) throw;
        _
    }
    modifier onlySeller()
    {
        if (msg.sender != seller) throw;
        _
    }
    modifier inState(State _state)
    {
        if (state != _state) throw;
        _
    }
    event aborted();
    event purchaseConfirmed();
    event itemReceived();
    function init(uint price) onlySeller {
        value = price;
    }
    /// Abort the purchase and reclaim the ether.
    /// Can only be called by the seller before
    /// the contract is locked.
    function abort()
        onlySeller
        inState(State.Created)
    {
        aborted();
        seller.send(this.balance);
        state = State.Inactive;
    }
    /// Confirm the purchase as buyer.
    /// Transaction has to include `2 * value` ether.
    /// The ether will be locked until confirmReceived
    /// is called.
    function confirmPurchase()
        inState(State.Created)
    {
        buyer = msg.sender;
        state = State.Locked;
        balance = msg.value;
    }
    /// Confirm that you (the buyer) received the item.
    /// This will release the locked ether.
    function confirmReceived()
        onlyBuyer
        inState(State.Locked)
    {
        buyer.send(value); // We ignore the return value on purpose
        seller.send(value);
        state = State.Inactive;
    }
    function() { throw; }
}