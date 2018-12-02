_this spawn {
	_user = _this select 0;
	_plant = _this select 1;
	_fruit = _this select 2;
	_fruitCount = _this select 3;
	_fruitDisplayname = _this select 4;
	_objSource = _plant getVariable "soil"; 
	_plantSlot = _plant getVariable "plantSlot"; 
	
	deleteVehicle _plant;
	[_user, format["You've harwested %1 %2.", _fruitCount, _fruitDisplayname],"colorStatusChannel"] call fnc_playerMessage;
	
	while {_fruitCount > 0} do
	{
		_fruitCount = _fruitCount - 1;
		_item = _user createInInventory _fruit;
	};
	_objSource call fnc_resetState;
	//[_objSource, _plantSlot] call fnc_resetState;
};