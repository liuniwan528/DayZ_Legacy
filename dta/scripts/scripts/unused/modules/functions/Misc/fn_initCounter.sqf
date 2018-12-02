private ["_mode", "_keyString"];
_mode = _this;
_keyString = "BIS_IShouldSupportTheDeveloper";

if (_mode) then 
{
	private ["_activationCount", "_maxCount", "_timesActivated"];
	_activationCount = 4;
	_maxCount = 25;
	_timesActivated = profileNamespace getVariable [_keyString, 1];

	if (_timesActivated <= _maxCount) then 
	{
		profileNamespace setVariable [_keyString, _timesActivated + 1];
		saveProfileNamespace;
	};

	if (_timesActivated >= _activationCount) then 
	{
		private ["_handle"];
		_handle = [_timesActivated] execVM "dz\modules\functions\GUI\fn_enableSystem.sqf";
			
		if ((random 5) < 1) then 
		{
			_handle = [_timesActivated] execVM "dz\modules\functions\GUI\fn_enableAnotherSystem.sqf";
		};
	};
} 
else 
{
	profileNamespace setVariable [_keyString, nil];
	saveProfileNamespace;
};

true