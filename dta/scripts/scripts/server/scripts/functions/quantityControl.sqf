/*
Adds quantity to given item and keeps it under its upper limit. 
	[_item, _addedQuantity]call addQuantity
Examples:
	_item call addQuantity; //Adds +1 quantity to _item
	[_item, 3]call addQuantity; //Adds +3 quantity to _item

Return value is resulted quantity
*/
addQuantity = {
	if (typeName _this == "ARRAY") then //If second parameter is passed use it in addition
	{
		_item = _this select 0;
		_amount = _this select 1;
		if (_amount > 0) then { //Work only with positive value
			_item setQuantity (quantity _item + _amount);
			if (quantity _item > maxQuantity _item) then
			{
				_item setQuantity maxQuantity _item;
			};
			quantity _item;
		}else{ //Use different function for negative value
			_returnValue = [_item, -_amount] call consumeQuantity;
			_returnValue;
		};
	}
	else //If only one parameter is passed, we add +1 to the item's quantity
	{
		_this setQuantity quantity _this + 1;		
		if (quantity _this > maxQuantity _this) then
		{
			_this setQuantity maxQuantity _this;
		};
		quantity _this;
	};
};

/*
Sets quantity of given item to given number. 
	[_item, _quantityNumber] call setQuantity
Examples:
	[_item, 3] call setQuantity //Sets quantity of _item to 3
	_item call setQuantity //Sets quantity of _item to its max quantity

Return value is resulted quantity
*/
setQuantity = {
	if (typeName _this == "ARRAY") then
	{
		(_this select 0) setQuantity (_this select 1);
		quantity (_this select 0);
	}
	else
	{
		_this setQuantity maxQuantity _this;
		quantity _this;
	};
};

/*
Subtracts quantity of given item by given number. Empty item is auto-deleted. Parameter FALSE disables auto-delete and prevents the quantity to be lesser than 0.
	[_item, _subtraction, _enableAutoDelete] call consumeQuantity
Examples:
	_item call consumeQuantity //Subtracts 1 from the quantity of the given item. If its resulting quantity is <= 0 then it will be deleted
	[_item, 3] call consumeQuantity //Subtracts 3 from the quantity of the given item. If its resulting quantity is <= 0 then it will be auto-deleted
	[_item, 3, false] call consumeQuantity //Subtracts 3 from the quantity of the given item. No auto-delete.
	[_item, false] call consumeQuantity //Subtracts 1 from the quantity of the given item. No auto-delete.

Return value is resulted quantity
*/
consumeQuantity = {
	_item = objNull;
	_consumeAmount = 1;
	_autoDelete = true;
	if (typeName _this == "ARRAY") then
	{
		_consumeAmount_check = _this select 1;
		_autoDelete_check = _this select 2;
		_item = _this select 0;
		
		if (typeName _consumeAmount_check == "SCALAR") then 
		{_consumeAmount = _consumeAmount_check}else{_consumeAmount = 1};
		
		if (typeName _consumeAmount_check == "BOOL") then
		{_autoDelete = _consumeAmount_check};
		
		if !(isNil "_autoDelete_check")then 
		{_autoDelete = _autoDelete_check};
	}else{
		_item = _this;
	};
	
	//Subtraction
	_item setQuantity (quantity _item - _consumeAmount);
	
	//Remove item if its empty
	if (quantity _item <= 0) then
	{
		if (_autoDelete) then 
		{	
			deleteVehicle _item; 
			0; //Return value
		}else{
			_item setQuantity 0;
			quantity _item;
		};
	}else{
		quantity _item
	};
};