disableserialization;

_mode = _this select 0;
_params = _this select 1;
_class = _this select 2;

switch _mode do
{
	case "onLoad":
	{
		with uinamespace do
		{
			disableserialization;
			_display = _params select 0;
			_display displayaddeventhandler
			[
				"mousemoving",
				"
					_display = _this select 0;
					(_display displayctrl 1024) ctrlsettext format
					[
						'Number of servers: %1',
						lbsize (_display displayctrl 102)
					];
				"
			];
		};
	};
};
