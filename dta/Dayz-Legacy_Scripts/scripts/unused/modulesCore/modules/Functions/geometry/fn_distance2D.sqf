//scriptName "Functions\geometry\fn_distance2D.sqf";
/************************************************************
	Distance 2D
	By Andrew Barron

Parameters: [object or position 1, object or position 2]

Returns the distance between the two objects or positions
"as the crow flies" (ignoring elevation)
Example: [player, getpos dude] call BIS_fnc_distance2D
************************************************************/

_pos1 = _this select 0;
_pos2 = _this select 1;

//if objects, not positions, were passed in, then get their positions
if (typename _pos1 == "OBJECT") then {_pos1 = position _pos1};
if (typename _pos2 == "OBJECT") then {_pos2 = position _pos2};

//return 2D distance between _pos1 and _pos2
[_pos1 select 0,_pos1 select 1] distance [_pos2 select 0,_pos2 select 1]