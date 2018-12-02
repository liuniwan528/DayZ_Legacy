_mode = _this select 0;
_params = _this select 1;
_class = _this select 2;

_this call bis_fnc_log;

switch _mode do {

	case "onLoad": {
		_dummy = [_params, "CA_SI_IslandSelected"] execVM "\DZ\ui\scripts\islandPicture.sqf";
	};
};