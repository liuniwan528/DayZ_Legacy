private["_agent","_pos","_isSea","_isWater","_bones","_delta","_anim","_bodyPosition","_isSwim","_playerWet","_isDrying"];
_agent = _this;
_pos = position _agent;
_isSea = surfaceIsWater _pos;
_isWater = surfaceType _pos == "FreshWater";
_bones = [];
_delta = 0;
_playerWet = _agent getVariable ["wet",0];
_gettingWet = _agent getVariable ["gettingWet",false];
_isDrying = !_gettingWet;
	
//SeaWater or Water
if (_isWater or _isSea) then
{
	_anim = animationState _agent;
	_bodyPosition = getText(configFile >> "CfgMovesMaleSdr2" >> "states" >> _anim >> "bodyPosition");
	_isSwim = _bodyPosition == "swim";
	_delta = 0.5 * DZ_SCALE_SOAK * DZ_TICK;	//increase in wetness
	_isDrying = false;
	
	//Is the deep or shallow?
	if (_isSwim) then
	{
		//deep
		_bones = [
			["Head",1],
			["Chest",1],
			["Back",1],
			["Pelvis",1],
			["LeftFoot",1]
		];
	}
	else
	{
		//shallow
		switch (_bodyPosition) do
		{
			case "prone":
			{
				_bones = [
					["Head",0.7],
					["Chest",1],
					["Back",0.7],
					["Pelvis",1],					
					["LeftFoot",1]
				];
			};
			case "kneel":
			{
				_bones = [
					["Chest",0.2],
					["Back",0.05],
					["Pelvis",0.4],
					["LeftFoot",1]
				];
			};
			case "stand":
			{
				_bones = [
					["Pelvis",0.05],
					["LeftFoot",1]
				];
			};
		};
	};
}
else
{
	if (!_gettingWet) then
	{
		//probably drying
		_isDrying = true;
		//skin temp + temperature + sunshine
		_delta = -(
			(32 * 0.01)		//skin temperature
			+ (airTemperature * 0.01)	//air temperature 
			+ worldLightScale		//sunshine
			+ (windSpeed * 0.01)	//wind
		) * 0.0000000001 * DZ_SCALE_DRY * DZ_TICK; //reduce to small value
		
		_bones = [
			["Head",1],
			["Chest",0.6],
			["Pelvis",0.2],
			["LeftFoot",0.3]
		];
	}
	else
	{
		//getting rained on
		if((_agent itemInSlot "body") isKindOf "RaincoatBase" || (_agent itemInSlot "body") isKindOf "Gorka_up_Base")then{
			_delta = -((32 * 0.01) + (airTemperature * 0.01) + worldLightScale + (windSpeed * 0.01)) * 0.0000000001 * DZ_SCALE_DRY * DZ_TICK;
		}else{
			_delta = 0.00000019 * rain * DZ_SCALE_SOAK * DZ_TICK;
		};
		
		_bones = [
			["Head",1],
			["Chest",1],
			["Back",0.7],
			["Pelvis",0.7],					
			["LeftFoot",0.7]
		];
	};
};

_totalHeatIsolation = 0;
//check slots assigned to each bone
{
	private["_filledSlots"];
	_slots = getArray(configFile >> "cfgBody" >> (_x select 0) >> "inventorySlots");
	_scale = (_x select 1);
	_filledSlots = 0;
	{
		private["_item","_wetness","_slot"];
		//find out what is on the player
		_slot = _x;
		_item = _agent itemInSlot _x;
		true call fnc_processItemWetness;
		
		//process items inside
		_inside = itemsInCargo _item;
		{
			false call fnc_processItemWetness;
		} forEach _inside;
		/*
			CALCULATE TEMPERATURE ISOLATION
		*/
		if(_item isKindOf "ClothingBase")then{
			_totalHeatIsolation = _totalHeatIsolation + ((1-(damage _item)/2)*getNumber (configFile >> "cfgVehicles" >> typeOf _item >> "heatIsolation"));
		};
	} forEach _slots;
} forEach _bones;

//Process wetness of player
_agent setVariable ["wet",_playerWet];
_agent setVariable ["isdryingstate",_isDrying];
if (_playerWet > 0) then
{ 
	[0,_agent,"Wet"] call event_modifier;
};

/*

TEMPERATURE

*/
_playerTemperature = _agent getVariable ["bodytemperature",36.5];
_heatComfort = _totalHeatIsolation*(1-_playerWet)*2 - (_playerTemperature - (airTemperature + worldLightScale*2 - windSpeed*3 - (getPosASL _agent select 2)/100));
//hint format["%1",_heatComfort];
_agent setVariable ["heatcomfort",_heatComfort];
//[0,_agent,"FeelingCold"] call event_modifier;

