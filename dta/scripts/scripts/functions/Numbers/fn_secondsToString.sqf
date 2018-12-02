/*
	Author: Joris-Jan van 't Land (based on work in fn_timeToString)

	Description:
	Convert amount of seconds to formatted string.

	Parameter(s):
	_this select 0: time in seconds (Scalar)
	_this select 1: format (String - optional)
		"HH"		- Hour
		"HH:MM"		- Hour:Minute
		"HH:MM:SS"	- Hour:Minute:Seconds (Default)
		"HH:MM:SS:MM"	- Hour:Minute:Seconds:Milliseconds
		"MM:SS:MM"	- Minute:Seconds:Milliseconds
	_this select 2: return as Array (Bool - optional)
		false (default)
		true

	Returns:
	String or Array of Strings
*/

private ["_sec", "_format", "_asArray", "_time", "_min", "_hour", "_sec", "_msec"];
_sec = [_this, 0, 0, [0]] call BIS_fnc_Param;
_format = [_this, 1, "HH:MM:SS", [""]] call BIS_fnc_Param;
_asArray = [_this, 2, false, [true]] call BIS_fnc_Param;
_time = "";

_hour = floor (_sec / 3600);
_sec = _sec % 3600;
_min =  floor (_sec / 60);
_sec = _sec % 60;
_msec = floor ((_sec % 1) * 1000);
_sec = floor (_sec);

_hour = (if (_hour <= 9) then {"0"} else {""}) + (str _hour);
_min = (if (_min <= 9) then {"0"} else {""}) + (str _min);
_sec = (if (_sec <= 9) then {"0"} else {""}) + (str _sec);
if (_msec <= 99) then 
{
	if (_msec <= 9) then 
	{
		_msec = "00" + (str _msec);
	} 
	else 
	{
		_msec = "0" + (str _msec);
	};
};

if (_asArray) then 
{
	switch _format do
	{
		case "HH": {_time = [_hour];};
		case "HH:MM": {_time = [_hour, _min];};
		case "HH:MM:SS": {_time = [_hour, _min, _sec];};
		case "HH:MM:SS.MS": {_time = [_hour, _min, _sec, _msec];};
		case "MM:SS.MS": {_time = [_min, _sec, _msec];};
	};
} 
else 
{
	switch _format do
	{
		case "HH": {_time = format ["%1", _hour];};
		case "HH:MM": {_time = format ["%1:%2", _hour, _min];};
		case "HH:MM:SS": {_time = format ["%1:%2:%3", _hour, _min, _sec];};
		case "HH:MM:SS.MS": {_time = format ["%1:%2:%3.%4", _hour, _min, _sec, _msec];};
		case "MM:SS.MS": {_time = format ["%1:%2.%3", _min, _sec, _msec];};
	};
};

_time