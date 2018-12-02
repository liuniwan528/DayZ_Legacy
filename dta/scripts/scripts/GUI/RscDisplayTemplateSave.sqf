_mode = _this select 0;
_params = _this select 1;
_class = _this select 2;

switch _mode do {

	case "onLoad": {
		_display = _params select 0;

		_ctrlName = _display displayctrl 101;

		if (
			//--- 'Save As' was not triggered
			!(uinamespace getvariable ["RscDisplayArcadeMap_saveAs",false])
			&&
			//--- Mission name is not empty (cannot save non-existing mission)
			ctrltext _ctrlName != ""
		) then {
			ctrlactivate (_display displayctrl 1);
		};
		uinamespace setvariable ["RscDisplayArcadeMap_saveAs",nil];
		
		
		//Sets all static texts toUpper---------------------------------------------------------------------------------------------
		_classInsideControls = configfile >> "RscDisplayTemplateSave" >> "controls";
			
		for "_i" from 0 to (count _classInsideControls - 1) do {   //go to all subclasses
			_current = _classInsideControls select _i;
			if ((isclass _current) && (configName(inheritsFrom(_current)) != "RscEdit")) then {
			
				//search inside main controls class
				_idc = getnumber (_current >> "idc");
				_control = _display displayctrl _idc;
				_control ctrlSetText (toUpper (ctrlText _control));	
			};
		};
		//Sets all static texts toUpper---------------------------------------------------------------------------------------------
	
	};
};