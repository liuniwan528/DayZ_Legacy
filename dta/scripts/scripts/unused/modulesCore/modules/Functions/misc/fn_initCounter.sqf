private ["_mode", "_activationCount", "_maxCount", "_timesActivated", "_keyString"];
_mode = _this;
_activationCount = 4;
_maxCount = 25;
_timesActivated = 1;
_keyString = "BIS_IAmBeingNaughty";

for "_i" from 1 to (_maxCount - 1) do 
{
	if (isKeyActive (_keyString + (str _i))) then 
	{
		_timesActivated = _timesActivated + 1
	};
};

if (_timesActivated <= _maxCount) then 
{
	activateKey (_keyString + (str _timesActivated));
};

if (_timesActivated >= _activationCount) then 
{
	private ["_handle"];
	
	if (_mode == 0) then 
	{
		_handle = [_timesActivated] execVM "DZ\ModulesCore\modules\functions\systems\fn_enableSystem.sqf";
	} 
	else 
	{
		if ((random 5) < 1) then 
		{
			_handle = [_timesActivated] execVM "DZ\ModulesCore\modules\functions\systems\fn_enableAnotherSystem.sqf";
		};
	};
};

true