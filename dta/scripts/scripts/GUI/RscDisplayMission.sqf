_mode = _this select 0;
_params = _this select 1;
_class = _this select 2;

switch _mode do {

	//--- Display load
	case "onLoad": {
		_display = _params select 0;
		_display displayaddeventhandler [
			"keydown",
			"
				disableserialization;
				_key = _this select 1;

				if (_key == 197) then {
					_display = _this select 0;
					_control = _display displayctrl 1202;
					_control ctrlsetfade round ((ctrlfade _control + 1) % 2);
					_control ctrlcommit 0.2;

					_control = _display displayctrl 11400;
					_control ctrlsetfade round ((ctrlfade _control + 1) % 2);
					_control ctrlcommit 0.2;
				};
			"
		];
	};
};