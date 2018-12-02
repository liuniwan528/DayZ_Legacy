_this spawn {
	_objSoil = _this select 0;
	_plantType = _this select 1;
	_plantOffset = _this select 2;
	_plantSlot = [1,1,0.5];//_this select 3;
	_position = position _objSoil;
	_obj = objNull;
	_currentState = 0;
	
	
	//Table of plants and their states + times
	_growthStates = [];
	_fullMaturityTime = 0;
	_spoiledState = 0;
	_spoilTimer = 0;
	_spoilTimerDelete = 0;
	
	switch (_plantType) do
	{
		case ("fruit_TomatoFresh"):
		{
			_growthStates = ["", "tomatoPlant1", "tomatoPlant2", "tomatoPlant3"];
			_fullMaturityTime = 10 + random 3;
			_spoiledState = "tomatoPlantRotten";
			_spoilTimer = 30;
			_spoilTimerDelete = 30;
		};
	};
	
	while {_currentState < count _growthStates} do
	{
		_obj = _growthStates select _currentState createVehicle [0,0,0];
		_obj attachTo [_objSoil, _plantOffset];
		_currentState = _currentState + 1;
		_obj setVariable ["soil", _objSoil];
		_obj setVariable ["plantSlot", _plantSlot];
		
		sleep (_fullMaturityTime / count _growthStates);
		if ( _currentState < count _growthStates ) then {
			deleteVehicle _obj;
		}
	};
	
	sleep _spoilTimer;
	if (!isNull _obj) then 
	{
		deleteVehicle _obj;
		_obj = _spoiledState createVehicle [0,0,0];
		_obj attachTo [_objSoil, _plantSlot];
		_obj setVariable ["soil", _objSoil];
		_obj setVariable ["plantSlot", _plantSlot];
		hint "The plant was spoiled!";
		
		sleep _spoilTimerDelete;
		
		_objSoil call fnc_resetState;
		//[_objSource, _plantSlot] call fnc_resetState;
		deleteVehicle _obj;
	};
};