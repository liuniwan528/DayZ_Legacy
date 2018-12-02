_mode = _this select 0;
_params = _this select 1;
_class = _this select 2;

switch _mode do {
	case "onLoad": {
		with uinamespace do {
			_display = _params select 0;

			//--- Listbox colors (marker textures are white, wee need to set darker background)
			_color = ["GUI","BCG_RGB"] call bis_fnc_displaycolorget;
			{_color set [_foreachindex,_x];} foreach _color;
			_color set [3,1];

			//--- Icon
			_ValueIcon = _display displayctrl 104;
			_ValueIcon ctrladdeventhandler [
				"lbselchanged",
				"
					with uinamespace do {
						[_this,104] call RscDisplayArcadeUnit_lbselchanged;
						[_this,105] call RscDisplayArcadeUnit_lbselchanged;
					};
				"
			];
			//lbsort _ValueIcon;
			//_ValueIcon ctrlsetbackgroundcolor _color;	//done in rscCommon.inc
			_ValueIcon ctrlsettextcolor [1,1,1,1];

			for "_i" from 0 to (lbsize _ValueIcon - 1) do {
				_class = _ValueIcon lbdata _i;
				_type = gettext (configfile >> "cfgmarkers" >> _class >> "icon");
				_ValueIcon lbsetpicture [_i,_type];
				_ValueIcon lbsetcolor [_i,[0,0,0,1]];
			};

			//--- Fill
			_ValueFill = _display displayctrl 110;
			_ValueFill ctrladdeventhandler [
				"lbselchanged",
				"
					with uinamespace do {
						[_this,110] call RscDisplayArcadeUnit_lbselchanged;
						[_this,105] call RscDisplayArcadeUnit_lbselchanged;
					};
				"
			];
			//_ValueFill ctrlsetbackgroundcolor _color;	//done in rscCommon.inc
			_ValueFill ctrlsettextcolor [1,1,1,1];

			for "_i" from 0 to (lbsize _ValueFill - 1) do {
				_class = _ValueFill lbdata _i;
				_brush = gettext (configfile >> "cfgmarkerbrushes" >> _class >> "texture");
				if (_brush == "") then {_brush = "#(argb,8,8,3)color(1,1,1,0.5)";};
				_ValueFill lbsetpicture [_i,_brush];
				_ValueFill lbsetcolor [_i,[0,0,0,1]];
			};

			//--- Color
			_ValueColorName = _display displayctrl 105;
			_ValueColorName ctrladdeventhandler [
				"lbselchanged",
				"
					with uinamespace do {
						[_this,105] call RscDisplayArcadeUnit_lbselchanged;
					};
				"
			];
			for "_i" from 0 to (lbsize _ValueColorName - 1) do {
				_class = _ValueColorName lbdata _i;
				_color = getarray (configfile >> "cfgmarkercolors" >> _class >> "color");
				_ValueColorName lbsetpicture [_i,format ["#(argb,8,8,3)color(%1,%2,%3,%4)",_color select 0,_color select 1,_color select 2,_color select 3]];
			};

			//--- Type
			_Marker = _display displayctrl 103;
			_Marker ctrladdeventhandler ["toolboxSelChanged",
				"
					_id = _this select 1;
					with uinamespace do {
						if (_id == 0) then {
							[_this,104] call RscDisplayArcadeUnit_lbselchanged;
						} else {
							[_this,110] call RscDisplayArcadeUnit_lbselchanged;
						};
						[_this,105,true] call RscDisplayArcadeUnit_lbselchanged;
					};
				"
			];

			RscDisplayArcadeUnit_lbselchanged = {
				_params = _this select 0;
				_idc = _this select 1;
				_display = ctrlparent (_params select 0);
				_ctrl = _display displayctrl _idc;

				_id = lbcursel _ctrl;
				_cursel = lbcursel _ctrl;
				_class = _ctrl lbdata _cursel;
				_Preview = _display displayctrl 1200;

				switch _idc do {
					case 104: {
						_type = gettext (configfile >> "cfgmarkers" >> _class >> "icon");
						_Preview ctrlsettext _type;
					};
					case 110: {
						_brush = if (_class == "solid") then {
							"#(argb,8,8,3)color(1,1,1,0.5)"
						} else {
							gettext (configfile >> "cfgmarkerbrushes" >> _class >> "texture");
						};
						_Preview ctrlsettext _brush;
					};
					case 105: {
						_color = if (_class == "default") then {
							_colorForce = if (count _this > 2) then {_this select 2} else {false};
							if (_colorForce) then {
								[]
							} else {
								_ValueIcon = _display displayctrl 104;
								getarray (configfile >> "cfgmarkers" >> (_ValueIcon lbdata (lbcursel _ValueIcon)) >> "color");
							};
						} else {
							getarray (configfile >> "cfgmarkercolors" >> _class >> "color");
						};
						if (count _color == 0) then {_color = [0,0,0,1];};
						_Preview ctrlsettextcolor _color;
					};
				};

			};

			//--- Initial icon set (after delay to distinguish icon/brush)
			[_ValueIcon,_ValueColorName] spawn {
				disableserialization;
				with uinamespace do {
					_ValueIcon = _this select 0;
					_ValueColorName = _this select 1;

					[[_ValueIcon],if (ctrlshown _ValueIcon) then {104} else {110}] call RscDisplayArcadeUnit_lbselchanged;
					[[_ValueColorName],105] call RscDisplayArcadeUnit_lbselchanged;
				};
			};
			
			
			//Sets all static texts toUpper---------------------------------------------------------------------------------------------
			_classInsideControls = configfile >> "RscDisplayArcadeMarker" >> "controls";
				
			for "_i" from 0 to (count _classInsideControls - 1) do {   //go to all subclasses
				_current = _classInsideControls select _i;
				
				//do not toUpper texts inserted by player
				if ( (configName(inheritsFrom(_current)) != "RscEdit") 
					&& (configName(inheritsFrom(_current)) != "CA_ValueName") ) then
				{
					//search inside main controls class
					_idc = getnumber (_current >> "idc");
					_control = _display displayctrl _idc;
					_control ctrlSetText (toUpper (ctrlText _control));
				};	
			};
			//Sets all static texts toUpper---------------------------------------------------------------------------------------------
		};
	};
};