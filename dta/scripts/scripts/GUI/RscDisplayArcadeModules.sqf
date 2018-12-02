/*
//init copied from RscDisplayArcadeSites

disableserialization;
_mode = _this select 0;
_params = _this select 1;
_class = _this select 2;

switch _mode do {
	case "onLoad": {
		with uinamespace do {
			_display = _params select 0;

			//--- Disable description
			_DescriptionGroup = _display displayctrl 2300;
			_DescriptionGroup ctrlenable false;
			_DescriptionGroup ctrlshow false;

			//--- Vehicle selected
			_ValueVehicle = _display displayctrl 103;  //IDC_ARCUNIT_VEHICLE, was IDC_AS_SITETYPE 706
			_ValueVehicle ctrladdeventhandler ["lbselchanged","with uinamespace do {['lbselchanged',_this,''] spawn RscDisplayArcadeModules_script};"];
			["lbselchanged",[_ValueVehicle,lbcursel _ValueVehicle],""] call RscDisplayArcadeModules_script;

			//--- Info button
			_ctrlInfo = _display displayctrl 2402;
			_ctrlInfo ctrladdeventhandler ["buttonclick","with uinamespace do {['info',_this,''] call RscDisplayArcadeModules_script};"];

		
			//Sets all static texts toUpper---------------------------------------------------------------------------------------------
			_classInsideControls = configfile >> "RscDisplayArcadeModules" >> "controls";
				
			for "_i" from 0 to (count _classInsideControls - 1) do {   //go to all subclasses
				_current = _classInsideControls select _i;
				if (isclass _current) then { //do not toUpper vehicle class and vehicle name

					//if RscControlsGroup is found, search inside
					if ( configName(inheritsFrom(_current)) == "RscControlsGroup" ) then
					{
						//search inside ControlsGroup
						_controlsGroupControls = _current >> "controls";
						
						//go to all subclasses
						for "_k" from 0 to (count _controlsGroupControls - 1) do {
							_classInsideCGcontrols = _controlsGroupControls select _k;
							 //do not toUpper texts inserted by player
							if ( (isclass _classInsideCGcontrols) && (configName(inheritsFrom(_classInsideCGcontrols)) != "RscEdit")
											      && (configName(inheritsFrom(_classInsideCGcontrols)) != "CA_ValueSiteName")) then
							{
								_idc = getnumber (_classInsideCGcontrols >> "idc");
								_control = _display displayctrl _idc;
								_control ctrlSetText (toUpper (ctrlText _control));	
							};
						};
					}
					else
					{
						//do not toUpper texts inserted by player
						if ((configName(inheritsFrom(_current)) != "RscEdit") ) then
						{
							//search inside main controls class
							_idc = getnumber (_current >> "idc");
							_control = _display displayctrl _idc;
							_control ctrlSetText (toUpper (ctrlText _control));
						};
					};
				};
			};
			//Sets all static texts toUpper---------------------------------------------------------------------------------------------
		};
	};

	//--- Class listbox
	case "lbselchanged": {
		_ctrl = _params select 0;
		_id = _params select 1;
		_cursel = lbcursel _ctrl;
		_display = ctrlparent _ctrl;

		//--- (Detect side-OBSOLETE) DETECT MODULE TYPE
		_sideColor = sidelogic call bis_fnc_sideColor;

		//--- Detect vehicle
		_text = _ctrl lbtext _cursel;
		_class = _ctrl lbdata _cursel;
		_cfg = configfile >> "cfgvehicles" >> _class;
		_description = gettext (_cfg >> "armory" >> "description");

		_icon = gettext (_cfg >> "icon");
		if (_icon == "") then {_icon = "iconVehicle"};
		_icon = _icon call bis_fnc_textureVehicleIcon;

		_picture = gettext (_cfg >> "picture");
		_picture = _picture call bis_fnc_textureVehicleIcon;

		//--- Assign title
		_ctrlTitle = _display displayctrl 1022;
		_ctrlTitle ctrlsettext _text;

		//--- Assign class
		_ctrlClass = _display displayctrl 1023;
		_ctrlClass ctrlsettext _class;

		//--- Assign icon
		_ctrlPic = _display displayctrl 1201;
		_ctrlPic ctrlsettext _icon;
		_ctrlPic ctrlsettextcolor _sideColor;
		_ctrlPic ctrlsetbackgroundcolor [1,1,1,1];
		_ctrlPic ctrlcommit 0;

		//--- Assign description
		_ctrlDesc = _display displayctrl 1100;
		_ctrlDesc ctrlsetstructuredtext parsetext _description;

		//--- Assign picture
		_ctrlPreview = _display displayctrl 1202;
		_ctrlPreview ctrlsettext _picture;

		//--- Set author
		[_display,_cfg] call bis_fnc_overviewAuthor;

		//--- Scan arguments
		_cfgArguments = _cfg >> "Arguments";
		for "_i" from 0 to (count _cfgArguments - 1) do {
			_argument = _cfgArguments select _i;
			if (isclass _argument) then {
				_label = _display displayctrl ((_i + 1) * 2);
				_previewCode = gettext (_argument >> "preview");
				if (_previewCode != "") then {
					_color = ["GUI","BCG_RGB"] call bis_fnc_displaycolorget;
					_color set [3,0.2];
					_label ctrlsetbackgroundcolor _color;
					_label ctrlsetscale 1.01;
					_label ctrlcommit 0;
				} else {
				};
			};
		};
	};

	//--- Info button
	case "info": {

		_ctrl = _params select 0;
		_display = ctrlparent _ctrl;

		_DescriptionGroup = _display displayctrl 2300;
		_SettingsGroup = _display displayctrl 2301;
		_ArgumentsGroup = _display displayctrl 127; //2302;

		//--- Set control groups' visibility
		_visibleSettings = ctrlshown _SettingsGroup;

		_DescriptionGroup ctrlshow _visibleSettings;
		_SettingsGroup ctrlshow !_visibleSettings;
		_ArgumentsGroup ctrlshow !_visibleSettings;

		_DescriptionGroup ctrlenable _visibleSettings;
		_SettingsGroup ctrlenable !_visibleSettings;
		_ArgumentsGroup ctrlenable !_visibleSettings;

		//--- Modify Info button text
		_ButtonInfo = _display displayctrl 2402;
		_ButtonInfo ctrlsettext toUpper(localize (["str_disp_armory_show","str_disp_armory_hide"] select  _visibleSettings));
	};

	//--- Argument
	case "argument_mouseButtonClick": {
		_control = _params select 0;
		_display = ctrlparent _control;
		_module = _display displayctrl 103;
		_moduleType = _module lbdata (lbcursel _module);
		_idc = ctrlidc _control;

		_cfgModule = configfile >> "CfgVehicles" >> _moduleTYpe;
		_cfgModuleArguments = _cfgModule >> "Arguments";

		_cfgArgument = _cfgModuleArguments select ((_idc / 2) - 1);
		_previewCode = gettext (_cfgArgument >> "preview");

		_text = "";
		if (_previewCode != "") then {with uinamespace do {_text = [_cfgModule,_cfgArgument] call compile _previewCode;};};
		if !(isnil "_text") then {
			if (typename _text != typename "") then {_text = str _text;};

			_controlEdit = _display displayctrl (_idc + 1);
			_controlEdit ctrlsettext _text;
		};

	};
	case "argument_focus": {
		_control = _params select 0;
		if (ctrlscale _control == 1) exitwith {};
		_display = ctrlparent _control;
		_module = _display displayctrl 103;
		_moduleType = _module lbdata (lbcursel _module);

		_controlArray = toarray str _control;
		_numbers = toarray "0123456789";
		_idc = "";
		{
			if (_x in _numbers) then {_idc = _idc + tostring [_x]};	
		} foreach _controlArray;
		_idc = parsenumber _idc;

		_cfgModule = configfile >> "CfgVehicles" >> _moduleTYpe;
		_cfgModuleArguments = _cfgModule >> "Arguments";

		_cfgArgument = _cfgModuleArguments select ((_idc / 2) - 1);
		_previewCode = gettext (_cfgArgument >> "preview");

		_color = ["GUI","BCG_RGB"] call bis_fnc_displaycolorget;
		if (_params select 1) then {
			_color set [3,1];
		} else {
			_color set [3,0.2];
		};
		_control ctrlsetbackgroundcolor _color;
		_control ctrlcommit 0;
	};
};
*/