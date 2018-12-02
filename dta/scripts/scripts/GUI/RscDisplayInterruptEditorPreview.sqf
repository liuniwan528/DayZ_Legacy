_mode = _this select 0;
_params = _this select 1;
_class = _this select 2;

switch _mode do {

	case "onLoad": {
/*
		private ['_dummy'];
		_dummy = _params call compile preprocessFile 'pauseOnload.sqf';
		_dummy = [_params,'onload'] call compile preprocessFile '\DZ\ui\scripts\pauseCutScene.sqf';
		_dummy = ['Init', _params] call compile preprocessFile '\DZ\ui\scripts\pauseLoadinit.sqf';
*/
	};

	case "onUnload": {
		private ["_dummy"];
		_dummy = [_params,'unload'] call compile preprocessFile '\DZ\ui\scripts\pauseCutScene.sqf';
	};

	default {};
};