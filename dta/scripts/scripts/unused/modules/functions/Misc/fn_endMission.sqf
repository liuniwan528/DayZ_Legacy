/*
	Author: Karel Moricky

	Description:
	Ends mission with specific ending.

	Parameter(s):
	_this select 0: STRING - Next mission
	_this select 1 (Optional): NUMBER - end type
	_this select 2 (Optional): TEXT - completion text
	_this select 3 (Optional): BOOL - true to endmission, false to failmission
	_this select 4 (Optional): CODE - code executed right before mission ends successfuly

	Returns:
	NOTHING
*/

private ["_mission","_end","_text","_win","_code","_fnc_scriptName"];
_mission =	[_this,0,worldname,[""]] call bis_fnc_param;
_end =		[_this,1,1,[0]] call bis_fnc_param;
_text =		[_this,2,"",[""]] call bis_fnc_param;
_win =		[_this,3,true,[true]] call bis_fnc_param;
_code =		[_this,4,{},[{}]] call bis_fnc_param;

[_mission,_end,_text,_win,_code] spawn {
	_mission = _this select 0;
	_end = _this select 1;
	_text = _this select 2;
	_win = _this select 3;
	_code = _this select 4;

	bis_fnc_endmission_params = [_mission,_end];

	titleCut [_text,"BLACK out",4];
	4 fadeSound 0;
	4 fadeMusic 0;
	4 fadeSpeech 0;
	sleep 4;
	if (_win) then {
		_mission call _code;
		endmission format ["%1_%2",_mission,_end];
	} else {
		failmission format ["%1_%2",_mission,_end];
	};
};