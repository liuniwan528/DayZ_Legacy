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

			//--- Side selected
			_valueSide = _display displayctrl 102;
			_valueSide ctrladdeventhandler ["lbselchanged","with uinamespace do {['lbselchanged_side',_this,''] spawn RscDisplayArcadeUnit_script};"];
			["lbselchanged_Side",[_ValueSide,lbcursel _ValueSide],""] call RscDisplayArcadeUnit_script;
			for "_l" from 0 to (lbsize _valueSide - 1) do {
				_sideColor = (_valueSide lbvalue _l) call bis_fnc_sideColor;
				_valueSide lbsetpicture [_l,_sideColor call BIS_fnc_colorRGBAtoTexture];
				_valueSide lbsetcolor [_l,[1,0,1,1]];
			};

			//--- Faction selected
			_valueFaction = _display displayctrl 123;
			_valueFaction ctrladdeventhandler ["lbselchanged","with uinamespace do {['lbselchanged_faction',_this,''] spawn RscDisplayArcadeUnit_script};"];
			["lbselchanged_faction",[_ValueFaction,lbcursel _ValueFaction],""] call RscDisplayArcadeUnit_script;

			//--- Class selected
			_ValueClass = _display displayctrl 107;
			_ValueClass ctrladdeventhandler ["lbselchanged","with uinamespace do {['lbselchanged_class',_this,''] spawn RscDisplayArcadeUnit_script};"];
			["lbselchanged_class",[_ValueClass,lbcursel _ValueClass],""] call RscDisplayArcadeUnit_script;

			//--- Vehicle selected
			_ValueVehicle = _display displayctrl 103;
			_ValueVehicle ctrladdeventhandler ["lbselchanged","with uinamespace do {['lbselchanged_unit',_this,''] spawn RscDisplayArcadeUnit_script};"];
			["lbselchanged_unit",[_ValueVehicle,lbcursel _ValueVehicle],""] call RscDisplayArcadeUnit_script;

			//--- Info button
			_ctrlInfo = _display displayctrl 2402;
			_ctrlInfo ctrladdeventhandler ["buttonclick","with uinamespace do {['info',_this,''] call RscDisplayArcadeUnit_script};"];


			//Sets all static texts toUpper---------------------------------------------------------------------------------------------
			_classInsideControls = configfile >> "RscDisplayArcadeUnit" >> "controls";
				
			for "_i" from 0 to (count _classInsideControls - 1) do {   //go to all subclasses
				_current = _classInsideControls select _i;
				if ( (isclass _current) && (configName(_current) != "CA_VehicleText")
							&& (configName(_current) != "CA_VehicleClass")
				    ) then { //do not toUpper vehicle class and vehicle name

					//if RscControlsGroup is found, search inside
					if ( configName(inheritsFrom(_current)) == "RscControlsGroup" ) then
					{
						//search inside ControlsGroup
						_controlsGroupControls = _current >> "controls";
						
						//go to all subclasses
						for "_k" from 0 to (count _controlsGroupControls - 1) do {
							_classInsideCGcontrols = _controlsGroupControls select _k;
							 //do not toUpper texts inserted by player
							if ( (isclass _classInsideCGcontrols) && (configName(inheritsFrom(_classInsideCGcontrols)) != "RscEdit") ) then {
							
								_idc = getnumber (_classInsideCGcontrols >> "idc");
								_control = _display displayctrl _idc;
								_control ctrlSetText (toUpper (ctrlText _control));	
							};
						};
					}
					else
					{
						//do not toUpper texts inserted by player
						if (configName(inheritsFrom(_current)) != "RscEdit") then
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

	//--- Side listbox
	case "lbselchanged_side": {
		_ctrl = _params select 0;
		_display = ctrlparent _ctrl;
		_ValueClass = _display displayctrl 107;
		_dataDef = _valueClass lbdata (lbcursel _valueClass);
		lbsort _ValueClass;
		for "_d" from 0 to (lbsize _ValueClass - 1) do {
			_data = _valueClass lbdata _d;
			if (_data == _dataDef) then {
				_valueClass lbsetcursel _d;
			};
		};
	};

	//--- Faction listbox
	case "lbselchanged_faction": {
		_ctrl = _params select 0;
		_display = ctrlparent _ctrl;
		_ValueClass = _display displayctrl 107;
		_dataDef = _valueClass lbdata (lbcursel _valueClass);
		lbsort _ValueClass;
		for "_d" from 0 to (lbsize _ValueClass - 1) do {
			_data = _valueClass lbdata _d;
			if (_data == _dataDef) then {
				_valueClass lbsetcursel _d;
			};
		};
	};

	//--- Class listbox
	case "lbselchanged_class": {
		_ctrl = _params select 0;
		_id = _params select 1;
		_cursel = lbcursel _ctrl;
		_display = ctrlparent _ctrl;

		_ctrlVehicles = _display displayctrl 103;
		for "_l" from 0 to (lbsize _ctrlVehicles - 1) do {
			_class = _ctrlVehicles lbdata _l;
			_icon = gettext (configfile >> "cfgvehicles" >> _class >> "icon");
			_iconVehicle = gettext (configfile >> "cfgvehicleicons" >> _icon);
			if (_iconVehicle != "") then {_icon = _iconVehicle;};
			if (_icon == "") then {_icon = "#(argb,8,8,3)color(0,0,0,0)"};
			_ctrlVehicles lbsetpicture [_l,_icon];

			_model = gettext (configfile >> "cfgvehicles" >> _class >> "model");
			if (_model == "\A3\Weapons_f\empty") then {
				_ctrlVehicles lbsetcolor [_l,[1,0,1,1]];
				_ctrlVehicles lbsetpicture [_l,"#(argb,8,8,3)color(1,0.25,0,1)"];
			};
		};
	};

	//--- Unit listbox
	case "lbselchanged_unit": {
		_ctrl = _params select 0;
		_id = _params select 1;
		_cursel = lbcursel _ctrl;
		_display = ctrlparent _ctrl;

		//--- Detect side
		_valueSide = _display displayctrl 102;
		_sideColor = (_valueSide lbvalue (lbcursel _valueSide)) call bis_fnc_sideColor;

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


		//--- Add player/playable icons
		/*
			0	Non playable

			1	Player as commander
			2	Player as driver
			3	Player as gunner

			4	Playable as commander
			5	Playable as driver
			6	Playable as gunner
			7	Playable as commander, driver
			8	Playable as commander, gunner
			9	Playable as driver, gunner
			10	Playable as EVERYTHING
		*/
		_ctrlPlayable = _display displayctrl 105;
		_colorEmpty = [1,1,1,0.25] call BIS_fnc_colorRGBAtoTexture;
		_colorMe = (getarray (configfile >> "cfgingameui" >> "islandmap" >> "colorMe")) call BIS_fnc_colorRGBAtoTexture;
		_colorPlayable = (getarray (configfile >> "cfgingameui" >> "islandmap" >> "colorPlayable")) call BIS_fnc_colorRGBAtoTexture;

		for "_l" from 0 to (lbsize _ctrlPlayable - 1) do {
			_value = _ctrlPlayable lbvalue _l;
			_color = switch _value do {
				case 0: {_colorEmpty};

				case 1;
				case 2;
				case 3: {_colorMe};

				case 4;
				case 5;
				case 6;
				case 7;
				case 8;
				case 9;
				case 10: {_colorPlayable};
			};
			_ctrlPlayable lbsetpicture [_l,_color];
		};
	};

	//--- Info button
	case "info": {

		_ctrl = _params select 0;
		_display = ctrlparent _ctrl;

		_DescriptionGroup = _display displayctrl 2300;
		_SettingsGroup = _display displayctrl 2301;

		//--- Set control groups' visibility
		_visibleSettings = ctrlshown _SettingsGroup;

		_DescriptionGroup ctrlshow _visibleSettings;
		_SettingsGroup ctrlshow !_visibleSettings;

		_DescriptionGroup ctrlenable _visibleSettings;
		_SettingsGroup ctrlenable !_visibleSettings;

		//--- Modify Info button text
		_ButtonInfo = _display displayctrl 2402;
		_ButtonInfo ctrlsettext toUpper(localize (["str_disp_armory_show","str_disp_armory_hide"] select  _visibleSettings));
	};
};