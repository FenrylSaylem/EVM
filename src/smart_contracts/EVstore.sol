pragma solidity ^0.5.0;

import './EVtoken.sol';

//Represents a charging point
contract EVstore {
    using SafeMath for uint;

	struct Flexibility {
		uint chargeID;
		address chargingPoint;
		address evtRecipient;
		uint startSOC;
		uint minSOC;
		uint maxSOC;
		uint power;
		uint startTime;
		uint endTime;
		bool flexibilityStarted;
		bool success;
	}
	EVtoken evToken;
	
	mapping (address => uint) public prices; //current price at each charging station in tokens per hour per kW
	mapping (address => address) public dsos; //charging station => responsible dso

	mapping (uint => Flexibility) public flexibilities;
	uint public nextID;
	
	modifier chargeIdExists(uint chargeID) {
	    if (chargeID < nextID)
	        _; 
	}

	constructor() public {
		nextID = 1;
		evToken = EVtoken(0x36BFc8cACa69c4C52f1274504f7d4144A26bE5Df);
	}
	
    /**
     * 
     * @return chargeID of created flexibility, 0 if not funded
     * 
     */
	function plugIn(address chargingPoint, uint startSOC, uint minSOC, uint maxSOC, uint power, uint startTime, uint endTime) public returns (uint chargeID) {
	    assert(dsos[chargingPoint] != address(0x0));
	    uint necessaryFunds = endTime.sub(startTime).mul(power).mul(prices[chargingPoint]).div(3600);
	    assert(evToken.allowance(dsos[chargingPoint], address(this)) >= necessaryFunds);
		Flexibility memory newCharge = Flexibility(nextID, chargingPoint, msg.sender, startSOC, minSOC, maxSOC, power, startTime, endTime, false, false);
		flexibilities[nextID] = newCharge;
		return nextID++;
	}
	
	function startFlexibility(uint chargeID, uint startTime, uint startSOC) public {
	    assert(flexibilities[chargeID].chargingPoint == msg.sender);
	    assert(startSOC >= flexibilities[chargeID].minSOC);
	    //check start soc in bounds
	    flexibilities[chargeID].startTime = startTime;
	    flexibilities[chargeID].startSOC = startSOC;
	    flexibilities[chargeID].flexibilityStarted = true;
	}

	function stopFlexibility(uint chargeID, uint endTime) public chargeIdExists(chargeID) {
	    if(flexibilities[chargeID].flexibilityStarted && endTime >= flexibilities[chargeID].endTime) {
	        flexibilities[chargeID].success = true;
    	    uint tokenAmount = flexibilities[chargeID].endTime
    	        .sub(flexibilities[chargeID].startTime)
    	        .mul(flexibilities[chargeID].power)
    	        .mul(prices[flexibilities[chargeID].chargingPoint]).div(3600);
    	    evToken.transferFrom(dsos[flexibilities[chargeID]], flexibilities[chargeID].evtRecipient, tokenAmount);
	    }
	}
	
	function setPrice(address chargingPoint, uint price) public {
	    assert(dsos[chargingPoint] == msg.sender);
	    prices[chargingPoint] = price;
	}
	
	function registerChargingPoint(address chargingPoint) public {
	    assert(dsos[chargingPoint] == address(0x0));
	    dsos[chargingPoint] = msg.sender;
	}

}