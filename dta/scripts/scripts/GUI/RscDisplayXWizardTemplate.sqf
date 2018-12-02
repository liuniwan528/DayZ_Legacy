disableSerialization;

_mode = _this select 0;
_params = _this select 1;
_class = _this select 2;

switch _mode do {

	case "onLoad": {

		_display = _params select 0;

		_ctrlMissions = _display displayctrl 101;
		_ctrlMissions ctrladdeventhandler ["lbselchanged","with uinamespace do {['onLBSelChanged', _this] call RscDisplayXWizardTemplate_script;}"];
	};
	
	case "onLBSelChanged": {
		with uinamespace do {
			_ctrl = _params select 0;
			_cursel = _params select 1;

			//--- Overview
			_config = if (_cursel < 0) then {
				configfile >> "RscDisplaySingleMission"
			} else {
				(configfile >> "cfgmissions" >> "templates") select _cursel;
			};

			//--- Display custom overview
			[ctrlParent _ctrl,_config,102] call bis_fnc_overviewMission;

			//--- Display author
			[ctrlParent _ctrl,_config] call bis_fnc_overviewAuthor;
		};
	};
	default {};
};