//scriptName "Functions\misc\fn_inTrigger.sqf";
/*
	File: inTrigger.sqf
	Author: Karel Moricky

	Description:
	Detects whether is position within trigger area.

	Parameter(s):
		_this select 0: OBJECT or ARRAY - Trigger or trigger area
		_this select 1: ARRAY or OBJECT - Position
		_this select 2 (Optional): BOOL - true for scalar result (distance from border)

	Returns:
	Boolean (true when position is in area, false if not).
*/
private ["_trig","_position","_scalarresult","_tPos","_tPosX","_tPosY","_tArea","_tX","_tY","_tDir","_tShape","_in"];

_trig =		[_this,0,objnull,[objnull,[],""]] call bis_fnc_param;
_position =	[_this,1,[0,0,0],[[],objnull]] call bis_fnc_param;
_scalarresult =	[_this,2,false,[false]] call bis_fnc_param;

if (typename _trig == typename objnull) then {_trig = [position _trig,triggerarea _trig]};
if (typename _trig == "") then {_trig = [markerpos _trig,markersize _trig + [markerdir _trig,markershape _trig == "rectangle"]]};

//--- Trigger position
_tPos = [_trig,0,[0,0,0],[[],objnull]] call bis_fnc_param;
if (typename _tPos == typename objnull) then {_tPos = position _tPos};
_tPosX = _tPos select 0;
_tPosY = _tPos select 1;

//--- Trigger area
_tArea = [_trig,1,0,[[],0]] call bis_fnc_param;
if (typename _tArea == typename 0) then {_tArea = [_tArea,_tArea,0,false]};
_tX = _tarea select 0; 
_tY = _tarea select 1;
_tDir = _tarea select 2;
_tShape = _tarea select 3;

_in = false;
if (_tshape) then {
	private ["_difX","_difY","_dir","_relativeDir","_adis","_bdis","_borderdis","_positiondis"];

	//--- RECTANGLE
	_difx = (_position select 0) - _tPosx;
	_dify = (_position select 1) - _tPosy;
	_dir = atan (_difx / _dify);
	if (_dify < 0) then {_dir = _dir + 180};
	_relativedir = _tdir - _dir;
	_adis = abs (_tx / cos (90 - _relativedir));
	_bdis = abs (_ty / cos _relativedir);
	_borderdis = _adis min _bdis;
	_positiondis = _position distance _tPos;

	_in = if (_scalarresult) then {
		_positiondis - _borderdis;
	} else {
		if (_positiondis < _borderdis) then {true} else {false};
	};

} else {
	private ["_e","_posF1","_posF2","_total","_dis1","_dis2"];

	//--- ELLIPSE
	_e = sqrt(_tx^2 - _ty^2);
	_posF1 = [_tPosx + (sin (_tdir+90) * _e),_tPosy + (cos (_tdir+90) * _e)];
	_posF2 = [_tPosx - (sin (_tdir+90) * _e),_tPosy - (cos (_tdir+90) * _e)];
	_total = 2 * _tx;

	_dis1 = _position distance _posF1;
	_dis2 = _position distance _posF2;
	_in = if (_scalarresult) then {
		(_dis1+_dis2) - _total;
	} else {
		if (_dis1+_dis2 < _total) then {true} else {false};
	};
};

_in