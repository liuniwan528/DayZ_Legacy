//scriptName "Functions\geometry\fn_dirTo.sqf";
/************************************************************
	Direction To
	By Andrew Barron

Parameters: [object or position 1, object or position 2]

Returns the compass direction from object/position 1 to
object/position 2. Return is always >=0 <360.

Example: [player, getpos dude] call BIS_fnc_dirTo
************************************************************/

private ["_pos1","_pos2","_ret"];

_pos1 = [_this,0,objnull] call bis_fnc_param;
_pos2 = [_this,1,objnull] call bis_fnc_param;

//--- Convert to position
_pos1 = _pos1 call bis_fnc_position;
_pos2 = _pos2 call bis_fnc_position;

//get compass heading from _pos1 to _pos2
_ret = ((_pos2 select 0) - (_pos1 select 0)) atan2 ((_pos2 select 1) - (_pos1 select 1));

//ensure return is 0-360
_ret = _ret % 360;
if (_ret < 0) then {_ret = _ret + 360};

_ret