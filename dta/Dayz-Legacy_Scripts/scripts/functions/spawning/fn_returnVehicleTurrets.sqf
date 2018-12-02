//scriptName "Functions\spawning\fn_returnVehicleTurrets.sqf";
/*
	File: fn_returnVehicleTurrets.sqf
	Author: Joris-Jan van 't Land

	Description:
	Function return the path to all turrets and sub-turrets in a vehicle.

	Parameter(s):
	_this select 0: vehicle config entry (Config)

	Returns:
	Array of Scalars and Arrays - path to all turrets
*/

//Validate parameter count
if ((count _this) < 1) exitWith {debugLog "Log: [returnVehicleTurrets] Function requires at least 1 parameter!"; []};

private ["_entry"];
_entry = _this select 0;

//Validate parameters
if ((typeName _entry) != (typeName configFile)) exitWith {debugLog "Log: [returnVehicleTurrets] Entry (0) must be a Config!"; []};

private ["_turrets", "_turretIndex"];
_turrets = [];
_turretIndex = 0;

//Explore all turrets and sub-turrets recursively.
for "_i" from 0 to ((count _entry) - 1) do
{
	private ["_subEntry"];
	_subEntry = _entry select _i;
	
	if (isClass _subEntry) then
	{
		private ["_hasGunner", "_gunnerNotSpawned"];
		_hasGunner = [_subEntry, "hasGunner"] call BIS_fnc_returnConfigEntry;
		_gunnerNotSpawned = [_subEntry, "gunnerNotSpawned"] call BIS_fnc_returnConfigEntry;
		if (isNil "_gunnerNotSpawned") then {_gunnerNotSpawned = 0;};

		//Make sure the entry was found.
		if (!(isNil "_hasGunner")) then 
		{
			if (_hasGunner == 1) then 
			{
				if (_gunnerNotSpawned == 0) then 
				{
					_turrets = _turrets + [_turretIndex];
					
					//Include sub-turrets, if present.
					if (isClass (_subEntry >> "Turrets")) then 
					{
						_turrets = _turrets + [[_subEntry >> "Turrets"] call BIS_fnc_returnVehicleTurrets];
					} 
					else 
					{
						_turrets = _turrets + [[]];
					};
				};
			};
		};

		_turretIndex = _turretIndex + 1;
	};
};

_turrets