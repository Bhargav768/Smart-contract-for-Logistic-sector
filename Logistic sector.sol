pragma solidity >=0.4.16 <0.6.0;

contract logistics{
    address Owner;
    
    ///////////Declaration /////////////
    
    struct package{
        bool isuidgenerated;     //every time order is generated new uid is generated
        uint itemid;
        string itemname;
        string transitstatus;       // updated everytime order is ordered
        uint orderstatus;           //1=ordered   2=in-transit   3=delivered   4=canceled
        
        address customer;
        uint ordertime;
        
        address carrier1;
        uint carrier1_time;
        
        address carrier2;
        uint carrier2_time;
        
        address carrier3;
        uint carrier3_time;
    }
    
    mapping (address => package) public packagemapping;
    mapping (address => bool) public carriers;
    
    /////////Declaration end//////////
     



    ////////modifier ///////////
    
    constructor(){
        Owner = msg.sender;
    }
    
    modifier onlyOwner(){
        require(Owner == msg.sender);
        _;
    }
    ////////modifier end/////////////
    
    ////////manage carriers////////////
    
    function manageCarriers(address _carrierAddress) onlyOwner public returns (string){
        if(!carriers[_carrierAddress]){
            carriers[_carrierAddress] = true;
        }else{
            carriers[_carrierAddress] = false;
        }
        return "carrier status is updated";
        
    }
    
    ////////manage carriers end////////////
    
    
    /////order item function //////////
    function OrderItem(uint _itemid, string _itemname) public returns (address){
        address uniqueId = address(sha256(msg.sender,now));
        
        packagemapping[uniqueId].isuidgenerated = true;
        packagemapping[uniqueId].itemid = _itemid;
        packagemapping[uniqueId].itemname = _itemname;
        packagemapping[uniqueId].transitstatus="Your package is ordered and is under processing";
        packagemapping[uniqueId].orderstatus=1;
        


        packagemapping[uniqueId].customer = msg.sender;
        packagemapping[uniqueId].ordertime = now;
        
        return uniqueId;
    }
    
    /////order item function end //////////

    ////cancel order function ////////////
    
    function CancelOrder(address _uniqueId) public returns (string){
        require(packagemapping[_uniqueId].isuidgenerated);
        require(packagemapping[_uniqueId].customer == msg.sender);//Because the same person who has order should cancel the order
        
        packagemapping[_uniqueId].orderstatus = 4;
        packagemapping[_uniqueId].transitstatus = "Your order has been canceled";
        
        return "Your order has been canceled successfully";
    }
    
    ////cancel order function end////////////
    


    ///////////////carriers ///////////////
    
    function Carrier1Report(address _uniqueId, string _transitStatus){
        require(packagemapping[_uniqueId].isuidgenerated);
        require(carriers[msg.sender]);
        require(packagemapping[_uniqueId].orderstatus == 1);
        
        packagemapping[_uniqueId].transitstatus = _transitStatus;
        packagemapping[_uniqueId].carrier1 = msg.sender;
        packagemapping[_uniqueId].carrier1_time = now;
        packagemapping[_uniqueId].orderstatus = 1;
    }
    



    function Carrier2Report(address _uniqueId, string _transitStatus){
        require(packagemapping[_uniqueId].isuidgenerated);
        require(carriers[msg.sender]);
        require(packagemapping[_uniqueId].orderstatus == 2);
        
        packagemapping[_uniqueId].transitstatus = _transitStatus;
        packagemapping[_uniqueId].carrier2 = msg.sender;
        packagemapping[_uniqueId].carrier2_time = now;
        //packagemapping[_uniqueId].orderstatus = 3;
    }
    
    function Carrier3Report(address _uniqueId, string _transitStatus){
        require(packagemapping[_uniqueId].isuidgenerated);
        require(carriers[msg.sender]);
        require(packagemapping[_uniqueId].orderstatus == 2);
        
        packagemapping[_uniqueId].transitstatus = _transitStatus;
        packagemapping[_uniqueId].carrier3 = msg.sender;
        packagemapping[_uniqueId].carrier3_time = now;
        packagemapping[_uniqueId].orderstatus = 3;
    }
    
    ///////////////carriers end ///////////////
   
