private["_greenhouse","_tool","_person","_playAnim","_animationLenght","_digToolsConfig","_greenhouseState","_toolParameters"];

//Define
_greenhouse	= _this select 0;
_inHandObject	= _this select 1;
_person		= _this select 2;

_digToolsConfig = 
[
	// values: tool, [0-toolEffectivity, 1-toolAnimation, 2-animationLength]
	"Tool_Shovel",[0.5, "GestureMeleeFarmHoe", 1.5],
	"FarmingHoe",[0.6, "GestureMeleeFarmHoe", 1.5]
];

_seedsConfig = 
[
	// values: seed name, [0-effectivity, 1-seed animation, 2-animationLength]
	"Fruit_TomatoFresh" ,[1, "GestureMeleeFarmHoe", 0.1]
];


// helper function: get parameters for tool based on tool name
fnc_getValue =
{
	private ["_table","_key","_ret","_i","_currentKey"];
	_table = _this select 0;  //source table
	_key = _this select 1;  //key to find
	_ret = []; //to be filled with return array
	
	//hint format["count: %1",(count _table)]; 
	
	for "_i" from 0 to (count _table - 1 ) step 2 do 
	{
		//[_person,format["variable i=%1",_i]] call fnc_playerMessage;
		_currentKey = (_table select _i);
		if (_currentKey == _key) exitWith
		{
			_ret = (_table select (_i+1));
		};
	};
	_ret;
};

// helper function: check if element is defined in table
fnc_isDefinedInTable =
{
	private ["_table","_key","_ret","_i","_currentKey"];
	_table = _this select 0;  //source table
	_key = _this select 1;  //key to find
	_ret = false;
	
	//hint format["count: %1",(count _table)]; 
	
	for "_i" from 0 to (count _table - 1 ) step 2 do 
	{
		//[_person,format["variable i=%1",_i]] call fnc_playerMessage;
		_currentKey = (_table select _i);
		if (_currentKey == _key) exitWith
		{
			_ret = true;
		};
	};
	_ret;
};

// reset STATE 
fnc_resetState =
{
	_this setVariable ['state', 0.0];
};

//player globalchat format["_inHandObject %1", (typeOf _inHandObject)];

// GET greenhouse STATE, if not defined SET state on 0
_greenhouseState = (_greenhouse getVariable ['state',objNull]);
if ( typeName _greenhouseState == "OBJECT" ) then
{
	_greenhouse setVariable ['state', 0.0];
	_greenhouseState = 0.0;
};

// FIND type of object in hands
_isTool = [_digToolsConfig, typeOf _inHandObject] call fnc_isDefinedInTable;
_isSeed = [_seedsConfig, typeOf _inHandObject] call fnc_isDefinedInTable;

// DIGGING
if ( _isTool ) then
{
	_toolParameters = [_digToolsConfig, typeOf _inHandObject] call fnc_getValue;

	// If greenhouse is not digged completely then DIG IT
	if ( _greenhouseState < 1 ) then
	{
		_greenhouseState = _greenhouseState + (_toolParameters select 0);
		_greenhouse setVariable ['state', _greenhouseState];
		
		// Play animation for digging
		_playAnim		= (_toolParameters select 1);
		_animationLenght	= (_toolParameters select 2);
		_person playAction [_playAnim, {}];

		//wait until animation finish
		sleep _animationLenght;
	};
	
	
	// FEEDBACK to player:
	if ( _greenhouseState < 1 ) exitWith
	{
		[_person,format["I have digged %1%% of a greenhouse with %2.",(_greenhouseState*100),displayName _inHandObject],"colorAction"] call fnc_playerMessage;
	};
	
	// digged and ready
	if ( _greenhouseState < 2 ) exitWith
	{
		[_person, "Greenhouse is digged and ready for planting.","colorAction"] call fnc_playerMessage;
	};

	// already planted
	if ( _greenhouseState < 3 ) exitWith
	{
		[_person, "There are already seeds planted in greenhouse.","colorAction"] call fnc_playerMessage;
	};

};

// PLANTING
if ( _isSeed ) then
{
	_seedParameters = [_seedsConfig, typeOf _inHandObject] call fnc_getValue;
	
	
	// If greenhouse is not digged completely feedback to player
	if ( _greenhouseState < 1 ) exitWith
	{
		[_person, format ["Greenhouse is not digged completely."],"colorAction"] call fnc_playerMessage;
	};

	// PLANT seeds
	if ( _greenhouseState < 2 ) exitWith
	{
		deleteVehicle _inHandObject;

		//seed 
		_greenhouseState = 2;
		_greenhouse setVariable ['state', _greenhouseState];
		
		// Play animation for seeding
		_playAnim		= (_seedParameters select 1);
		_animationLenght	= (_seedParameters select 2);
		//_person playAction [_playAnim, {}];

		//wait until animation finish
		sleep _animationLenght;
		
		[_person, format ["Seeds are planted."],"colorAction"] call fnc_playerMessage;
		
		 [_greenhouse, "fruit_TomatoFresh", [0,1,0], 0] call player_plantStages;
	};

	if ( _greenhouseState < 3 ) exitWith
	{
		[_person, "There are already seeds planted in greenhouse.","colorAction"] call fnc_playerMessage;
	};
	
};


/*
test console

_item = createVehicle ["Land_Misc_Greenhouse", position player, [], 0, "NONE"]; 
_poo1 = player createInInventory "FarmingHoe";
_poo1 = player createInInventory "Tool_Shovel";
_poo1 = player createInInventory "Fruit_TomatoFresh";
*/