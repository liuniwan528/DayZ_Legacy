/*
	Author: Karel Moricky

	Description:
	Returns type of animation

	Parameter(s):
	_this: STRING - animation name

	Returns:
	ARRAY
*/

private ["_anim","_animArray","_animArray4","_animArrayTemp","_animType"];

_anim = [_this,0,"",[""]] call bis_fnc_param;
_animArray = toarray _anim;
_animArray4 = [];
_animArrayTemp = [];

for "_a" from 0 to (count _animArray - 1) do {
	private ["_char"];

	_char = _animArray select _a;
	if (_char in [95]) exitwith {};

	_animArrayTemp = _animArrayTemp + [_char];
	if ((_a % 4) == 3 || (_a == count _animArray - 1)) then {
		_animArray4 = _animArray4 + [_animArrayTemp];
		_animArrayTemp = [];
	};
};

_animType = [];
	private ["_prefix","_type"];
{
	_prefix = toupper tostring [_x select 0];
	_type = tolower tostring [
		[_x,1,""] call bis_fnc_param,
		[_x,2,""] call bis_fnc_param,
		[_x,3,""] call bis_fnc_param
	];

	switch _prefix do {

		//--- Action class
		case "A": {
			_animType = _animType + [
				[
					"Action",
					switch _type do {
						case "mov": {"Move"};
						case "idl": {"Idle"};
						case "ldr": {"Ladder"};
						case "mel": {"Melee"};
						case "crg": {"Cargo"};
						case "inj": {"Injury"};
						case "cin": {"Carry injured"};
						case "dth": {"Death"};
						case "inv": {"Inventory"};
						case "cts": {"Cutscene"};
						case "swm": {"Swim"};
						case "sig": {"Signal"};
						case "wop": {"Operate a weapon"};
						case "ddg": {"Dodge"};
						default {"N/A"};
					}
				]
			];
		};

		//--- Pose
		case "P": {
			_animType = _animType + [
				[
					"Pose",
					switch _type do {
						case "erc": {"Erect"};
						case "knl": {"Kneel"};
						case "pne": {"Prone"};
						case "sit": {"Sit"};
						case "fal": {"Fall"};
						case "sqt": {"Squat"};
						default {"N/A"};
					}
				]
			];
		};

		//--- Movement
		case "M": {
			_animType = _animType + [
				[
					"Movement",
					switch _type do {
						case "stp": {"Stop"};
						case "wlk": {"Walk"};
						case "run": {"Run"};
						case "spr": {"Sprint"};
						case "len": {"Lean"};
						case "trn": {"Turn"};
						case "jmp": {"Jump"};
						case "wtl": {"Water level"};
						case "uwt": {"Under water"};
						case "eva": {"Evasive"};
						case "mnt": {"Mount"};
						case "dnt": {"Dismount"};
						case "crg": {"Cargo"};
						default {"N/A"};
					}
				]
			];
		};

		//--- Stance
		case "S": {
			_animType = _animType + [
				[
					"Stance",
					switch _type do {
						case "ras": {"Raised"};
						case "low": {"Lowered"};
						case "opt": {"Optics"};
						case "sur": {"Surrender"};
						case "sig": {"Hand signal"};
						case "pat": {"Patrol position"};
						case "non": {"No weapon"};
						case "lay": {"Lay weapon"};
						case "car": {"Carry weapon"};
						case "obk": {"Weapon on back"};
						case "rld": {"Reload"};
						case "gth": {"Grenade throw"};
						case "grl": {"Grenade roll"};
						default {"N/A"};
					}
				]
			];
		};

		//--- Hand item
		case "W": {
			_animType = _animType + [
				[
					"Hand item",
					switch _type do {
						case "una": {"Unarmed"};
						case "pst": {"Pistol"};
						case "rfl": {"Rifle"};
						case "mag": {"Machinegun"};
						case "lnr": {"Launcher"};
						case "knf": {"Knife"};
						case "dog": {"Dog handler"};
						case "non": {"Nothing"};
						case "cwo": {"Carry wounded"};
						case "bin": {"Binocular"};
						default {"N/A"};
					}
				]
			];
		};

		//--- Direction
		case "D": {
			_animType = _animType + [
				[
					"Direction",
					switch _type do {
						case "f": {"Forward"};
						case "fl": {"Forward Left"};
						case "l": {"Left"};
						case "bl": {"Backward Left"};
						case "b": {"Backward"};
						case "br": {"Backward Right"};
						case "r": {"Right"};
						case "fr": {"Forward Right"};
						case "dn": {"Down"};
						case "up": {"Up"};
						case "mul": {"Multiple"};
						case "non": {"Not specified"};
						default {"N/A"};
					}
				]
			];
		};
	};
} foreach _animArray4;

_animType