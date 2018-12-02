// doors events
event_openCloseDoors = {
	private ["_obj","_door1","_door2","_objToPhase","_person","_soundClass"];
	_obj = _this select 0;
	_door1 = _this select 1;
	_door2 = _this select 2;
	_objToPhase = _this select 3;
	_person = _this select 4;
	_soundClass = _this select 5;
	
	[_obj,_soundClass] call event_saySound;
	_obj animate [_door1, _objToPhase];
	if (_door2 != "") then {
		_obj animate [_door2, _objToPhase];
	};
};

event_LockCloseDoors = {
	private ["_obj","_lockMode","_person","_sound","_lockVar","_personState"];
	_obj = _this select 0;
	_lockMode = _this select 1;
	_soundClass = _this select 2;
	_person = _this select 3;
	_lockVar = _this select 4;
	
	//_personState = animationState _person;
	_person playAction "searchBerries";
	//_person playMove _personState;
	
	[_obj,_soundClass] call event_saySound;
	if (_lockMode == 1) then {
		_obj setVariable [_lockVar, 0];
		[_person,"You locked the door","colorFriendly"] call fnc_playerMessage;
	} else {
		_obj setVariable [_lockVar, 1];
		[_person,"You unlocked the door","colorFriendly"] call fnc_playerMessage;
	};
};

event_BreachDoors ={
	private ["_obj","_person","_lockVar","_action"];
	_obj = _this select 0;
	_person = _this select 1;
	_lockVar = _this select 2;
	
	[_person,"action_punch"] call event_saySound;
	_action = getText(configFile >> "cfgVehicles" >> typeOf (itemInHands _person) >> "melee" >> "action"); 
	_player playAction _action;

	_obj setVariable [_lockVar, 1];
	[_person,"You breached the door","colorFriendly"] call fnc_playerMessage;
};


// reLoad function and commands
// Was:  function/command param | object function/command param
// Will: param call functionNew | [object,param] call functionNew

cmd_dbDestroyCharacter = {};
cmd_ProfileStart = {};
cmd_ProfileStop = {};

fnc_surfaceTypeASL = {
	_param = _this;
};

fnc_surfaceHeightASL = {
// position ASL -> 
	_param = _this;
};