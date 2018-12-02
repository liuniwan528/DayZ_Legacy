/*
	Author: Karel Moricky

	Description:
	IGUI position settings
*/
disableserialization;

#define CONTROL	(_display displayctrl _idc)
#define DIK_RETURN          0x1C    /* Enter on main keyboard */
#define DIK_NUMPADENTER     0x9C    /* Enter on numeric keypad */
#define DIK_DELETE          0xD3    /* Delete on arrow keypad */

#define COLOR_DEFAULT		[1,1,1,1]
#define COLOR_CUSTOM		[0,1,1,1]

_mode = _this select 0;
_params = _this select 1;
_class = _this select 2;
_listVars = ["X","Y","W","H"];

switch _mode do {

	//--- Display load
	case "onLoad": {
		//--- Functions are stored in uiNameSpace
		with uinamespace do {

			_display = _params select 0;
			_cfgDisplay = configfile >> _class;
			_cfgGrids = configfile >> "CfgUIDefault" >> "IGUI" >> "Grids";

			//--- Detect control groups
			RscDisplayOptionsIGUI_class = _class;
			RscDisplayOptionsIGUI_listGroups = [];
			_listIDCs = [_cfgDisplay,0,false] call bis_fnc_displayControls;
			_listIDCsResize = [];
			_listNames = [_cfgDisplay,"",false] call bis_fnc_displayControls;


			_textMove = "<br />" + "LMB - Move";  //localize "str_hsim_rscdisplayoptionsigui_LMB";  				---MUF-TODO - uncomment when string is in A3 locDB
			_textResize = _textMove + "<br />" + "RMB - Resize";  //localize "str_hsim_rscdisplayoptionsigui_RMB";	---MUF-TODO - uncomment when string is in A3 locDB
			RscDisplayOptionsIGUI_textMove = parsetext ("<t shadow='2'>" + _textMove + "</t>");
			RscDisplayOptionsIGUI_textResize = parsetext ("<t shadow='2'>" + _textResize + "</t>");

			{
				_idc = _x;
				if (_idc >= 2300) then {
					RscDisplayOptionsIGUI_listGroups set [count RscDisplayOptionsIGUI_listGroups,_idc];

					_configname = _listNames select _foreachindex;
					_position = getarray (_cfgGrids >> _configName >> "position");
					_pos = if (count _position > 0) then {
						_position select 0
					} else {
						ctrlposition CONTROL
					};
					_offsetY = (_position select 2) call bis_fnc_parsenumber;
					_pos = [
						(_pos select 0) call bis_fnc_parsenumber,
						(_pos select 1) call bis_fnc_parsenumber,
						(_pos select 2) call bis_fnc_parsenumber,
						((_pos select 3) call bis_fnc_parsenumber) + 0.5 * _offsetY
					];
					_saveToProfile = getarray (_cfgGrids >> _configName >> "saveToProfile");

					//--- Element height (hint has forced height)
					_hForced = getnumber (configfile >> _class >> "controls" >> _configname >> "hForced") > 0;
					_h = if (_hForced) then {
						_idc = _idc;
						_pos set [3,ctrlposition CONTROL select 3];
					};
					_posConfig = +_pos;

					//--- Can resize?
					_canResize = 2 in _saveToProfile || 3 in _saveToProfile;
					if (_canResize) then {
						_idcSave = if (2 in _saveToProfile && 3 in _saveToProfile) then {_idc} else {-_idc};
						_listIDCsResize set [count _listIDCsResize,_idcSave];
					};

					//--- Default size
					_var = /*"grid_" + */"IGUI_" + _configname + "_";

					//--- Profile size
					{
						_posValue = (profilenamespace getvariable [_var + (_listVars select _x),_pos select _x]) call bis_fnc_parsenumber;
						if (_x == 1) then {_posValue = _posValue - 0.5 * _offsetY};
						if (_x == 3) then {
							_posValue = if (_hForced) then {ctrlposition CONTROL select 3;} else {_posValue + 0.5 * _offsetY};
						};
						_pos set [
							_x,
							_posValue
						];
					} foreach _saveToProfile;

					//--- Apply controls group
					CONTROL ctrlsetposition _pos;
					CONTROL ctrlcommit 0;
					CONTROL ctrlenable false;

					//--- Modify frame
					_idc = _x * 10;
					_posXYConfig = [_posConfig select 0,(_posConfig select 1) - 0.5 * _offsetY];
					_posWHConfig = [_posConfig select 2,_posConfig select 3];
					_posXY = [_pos select 0,_pos select 1];
					_posWH = [_pos select 2,_pos select 3];
					_color = if (((_posXYConfig distance _posXY) + (_posWHConfig distance _posWH)) > 0.0001) then {COLOR_CUSTOM} else {COLOR_DEFAULT};
					CONTROL ctrlsettextcolor _color;
					CONTROL ctrlsetposition [0,0,_pos select 2,_pos select 3];
					CONTROL ctrlcommit 0;
				};
			} foreach _listIDCs;

			RscDisplayOptionsIGUI_listIDCs = _listIDCs;
			RscDisplayOptionsIGUI_listIDCsResize = _listIDCsResize;
			RscDisplayOptionsIGUI_listNames = _listnames;


			//--- On mouse moving
			RscDisplayOptionsIGUI_mouseArea_MouseMoving = {
				disableserialization;
				_control = _this select 0;
				_display = ctrlparent _control;
				_mouseX = _this select 1;
				_mouseY = _this select 2;

				//--- LMB - move
				if (RscDisplayOptionsIGUI_display_LMB && RscDisplayOptionsIGUI_display_idcActive >= 0) then {

					//--- Move active element
					_mouseXdef = RscDisplayOptionsIGUI_display_LMB_pos select 0;
					_mouseYdef = RscDisplayOptionsIGUI_display_LMB_pos select 1;

					_dx = _mouseX - _mouseXdef;
					_dy = _mouseY - _mouseYdef;

					_idc = RscDisplayOptionsIGUI_display_idcActive;
					_pos = RscDisplayOptionsIGUI_display_idcActivePos;
					_posX = (_pos select 0) + _dX,
					_posY = (_pos select 1) + _dY;
					_posW = (_pos select 2);
					_posH = (_pos select 3);

					//--- Lock to grid
					_gridSize = RscDisplayOptionsIGUI_GRID select 0;
					_gridSizeX = _gridSize select 0;
					_gridSizeY = _gridSize select 1;
					_gridSizeW = _gridSize select 2;
					_gridSizeH = _gridSize select 3;
					_gridX = (RscDisplayOptionsIGUI_GRID select 1) / 2;
					_gridY = (RscDisplayOptionsIGUI_GRID select 2) / 2;
					_posX = _posX - (_posX % _gridX) + (_gridSizeX % _gridX) + _gridX;
					_posY = _posY - (_posY % _gridY) + (_gridSizeY % _gridY);

					//--- Not out of bounds
					//_posX = _posX max safezoneXAbs min (safezoneXAbs + safezoneWAbs - _posW);
					//_posY = _posY max safezoneY min (safezoneY + safezoneH - _posH);

					CONTROL ctrlsetposition [_posX,_posY,_posW,_posH];
					CONTROL ctrlcommit 0;

					//--- Move mouse over effect
					RscDisplayOptionsIGUI_mouseOver ctrlsetposition [_posX,_posY,_posW,_posH];
					RscDisplayOptionsIGUI_mouseOver ctrlcommit 0;

					//--- Alter frame color
					_idc = _idc * 10;
					CONTROL ctrlsettextcolor COLOR_CUSTOM;
					CONTROL ctrlcommit 0;
				} else {

					//--- RMB - resize
					if (
						RscDisplayOptionsIGUI_display_RMB
						//&&
						//RscDisplayOptionsIGUI_display_idcActive >= 0
						&&
						(
							RscDisplayOptionsIGUI_display_idcActive in RscDisplayOptionsIGUI_listIDCsResize
							||
							-RscDisplayOptionsIGUI_display_idcActive in RscDisplayOptionsIGUI_listIDCsResize
						)
					) then {

						_mouseXdef = RscDisplayOptionsIGUI_display_RMB_pos select 0;
						_mouseYdef = RscDisplayOptionsIGUI_display_RMB_pos select 1;

						_dx = _mouseX - _mouseXdef;
						_dy = _mouseY - _mouseYdef;

						_idc = RscDisplayOptionsIGUI_display_idcActive;
						_pos = RscDisplayOptionsIGUI_display_idcActivePos;
						_posX = (_pos select 0),
						_posY = (_pos select 1);
						_posW = (_pos select 2) + _dX;
						_posH = (_pos select 3) + _dY;

						//--- Lock to grid
						_gridSize = RscDisplayOptionsIGUI_GRID select 0;
						_gridSizeX = _gridSize select 0;
						_gridSizeY = _gridSize select 1;
						_gridSizeW = _gridSize select 2;
						_gridSizeH = _gridSize select 3;
						_gridX = (RscDisplayOptionsIGUI_GRID select 1) / 2;
						_gridY = (RscDisplayOptionsIGUI_GRID select 2) / 2;
						_posW = _posW - (_posW % _gridX) + (_gridSizeX % _gridX) + _gridX;
						_posH = _posH - (_posH % _gridY) + (_gridSizeY % _gridY);

						//--- Keep aspect
						if !(RscDisplayOptionsIGUI_display_idcActive in RscDisplayOptionsIGUI_listIDCsResize) then {_posH = _posW * 3/4;};

						CONTROL ctrlsetposition [_posX,_posY,_posW,_posH];
						CONTROL ctrlcommit 0;

						_idc = RscDisplayOptionsIGUI_display_idcActive * 10;
						CONTROL ctrlsetposition [0,0,_posW,_posH];
						CONTROL ctrlsettextcolor COLOR_CUSTOM;
						CONTROL ctrlcommit 0;

						//--- Move mouse over effect
						RscDisplayOptionsIGUI_mouseOver ctrlsetposition [_posX,_posY,_posW,_posH];
						RscDisplayOptionsIGUI_mouseOver ctrlcommit 0;
					} else {
						_idcActive = -1;

						//--- Search for mouseover
						{
							_idc = _x;
							_pos = ctrlposition CONTROL;
							_posX = _pos select 0;
							_posY = _pos select 1;
							_posW = _pos select 2;
							_posH = _pos select 3;

							if (
								_mouseX > (_posX)
								&&
								_mouseX < (_posX + _posW)
								&&
								_mouseY > (_posY)
								&&
								_mouseY < (_posY + _posH)
							) then {
								_idcActive = _idc;

								_text = if (
									RscDisplayOptionsIGUI_display_idcActive in RscDisplayOptionsIGUI_listIDCsResize
									||
									-RscDisplayOptionsIGUI_display_idcActive in RscDisplayOptionsIGUI_listIDCsResize
								) then {
									RscDisplayOptionsIGUI_textResize
								} else {
									RscDisplayOptionsIGUI_textMove
								};
								RscDisplayOptionsIGUI_mouseOver ctrlsetstructuredtext _text;
								RscDisplayOptionsIGUI_mouseOver ctrlsetposition _pos;
								RscDisplayOptionsIGUI_mouseOver ctrlcommit 0;
							};					
						} foreach RscDisplayOptionsIGUI_listGroups;

						//--- Mouseover
						if (_idcActive >= 0) then {
							RscDisplayOptionsIGUI_display_idcActive = _idcActive;

						} else {
							RscDisplayOptionsIGUI_mouseOver ctrlsetposition [0,0,0,0];
							RscDisplayOptionsIGUI_mouseOver ctrlcommit 0;
							RscDisplayOptionsIGUI_display_idcActive = -1;
						};
					};
				};
			};


			//--- On mouse button
			RscDisplayOptionsIGUI_display_idcActive = -1;
			RscDisplayOptionsIGUI_display_LMB = false;
			RscDisplayOptionsIGUI_display_RMB = false;
			RscDisplayOptionsIGUI_display_mousebutton = {
				disableserialization;
				_mode = _this select 0;
				_modeBool = [false,true] select _mode;
				_input = _this select 1;

				_display = _input select 0;
				_button = _input select 1;
				_x = _input select 2;
				_y = _input select 3;
				_shift = _input select 4;
				_ctrl = _input select 5;
				_alt = _input select 6;

				switch _button do {

					//--- LMB
					case 0: {
						RscDisplayOptionsIGUI_display_LMB = _modeBool;
						RscDisplayOptionsIGUI_display_LMB_pos = [_x,_y];

/*
						if (_modeBool) then {
							_idc = RscDisplayOptionsIGUI_display_idcActive;
							RscDisplayOptionsIGUI_display_idcActivePos = ctrlposition CONTROL;
						} else {
							RscDisplayOptionsIGUI_display_idcActive = -1;
							RscDisplayOptionsIGUI_display_idcActivePos = [0,0,0,0];
						};
*/
					};

					//--- RMB
					case 1: {
						if (
							RscDisplayOptionsIGUI_display_idcActive in RscDisplayOptionsIGUI_listIDCsResize
							||
							-RscDisplayOptionsIGUI_display_idcActive in RscDisplayOptionsIGUI_listIDCsResize
						) then {
							RscDisplayOptionsIGUI_display_RMB = _modeBool;
							RscDisplayOptionsIGUI_display_RMB_pos = [_x,_y];
						};
					};
				};

				if (_modeBool) then {
					_idc = RscDisplayOptionsIGUI_display_idcActive;
					RscDisplayOptionsIGUI_display_idcActivePos = ctrlposition CONTROL;
				} else {
					RscDisplayOptionsIGUI_display_idcActive = -1;
					RscDisplayOptionsIGUI_display_idcActivePos = [0,0,0,0];
				};

			};

			//--- On key pressed
			RscDisplayOptionsIGUI_display_keydown = {
				disableserialization;
				_display = _this select 0;
				_key = _this select 1;

				//--- Enter
				if (_key in [DIK_RETURN,DIK_NUMPADENTER]) then {

					_this spawn {
						disableserialization;
						_display = _this select 0;
						_key = _this select 1;

						//--- Display warning about changes requiring game restart
						_warning = [localize "STR_MSG_RESTART_NEEDED",nil,nil,nil,_display] call bis_fnc_guiMessage;
						_display = _this select 0;

						//--- Save to profileNameSpace and exit when clicked on OK
						if (_warning) then {
							{
								_pos = getarray (configfile >> "CfgUIDefault" >> "IGUI" >> "Grids" >> _x >> "position");
								_saveToProfile = getarray (configfile >> "CfgUIDefault" >> "IGUI" >> "Grids" >> _x >> "saveToProfile");

								if (count _pos > 0) then {
									_offsetY = (_pos select 2) call bis_fnc_parsenumber;

									//--- Save config pos for later comparison
									_posConfig = _pos select 0;
									_posXYConfig = [(_posConfig select 0) call bis_fnc_parsenumber,(_posConfig select 1) call bis_fnc_parsenumber];
									_posWHConfig = [(_posConfig select 2) call bis_fnc_parsenumber,(_posConfig select 3) call bis_fnc_parsenumber];

									_var = /*"grid_" + */"IGUI_" + _x + "_";
									_idc = RscDisplayOptionsIGUI_listIDCs select _forEachIndex;
									_pos = ctrlposition CONTROL;

									_posX = (_pos select 0);
									_posY = (_pos select 1) + 0.5 * _offsetY;
									_posW = (_pos select 2);
									_posH = (_pos select 3) - 0.5 * _offsetY;

									_posXY = [_posX,_posY];
									_posWH = [_posW,_posH];

									if (((_posXYConfig distance _posXY) + (_posWHConfig distance _posWH)) > 0.0001) then {

										//--- Custom position
										_posX = (_posX - safezoneXAbs) / safezoneWAbs;
										_posY = (_posY - safezoneY) / safezoneH;
										_posW = (_posW) / safezoneWAbs;
										_posH = (_posH) / safezoneH;

										if (0 in _saveToProfile) then {profilenamespace setvariable [_var + "X",str (_posX) + " * safezoneWAbs + safezoneXAbs"];};
										if (1 in _saveToProfile) then {profilenamespace setvariable [_var + "Y",str (_posY) + " * safezoneH + safezoneY"];};
										if (2 in _saveToProfile) then {profilenamespace setvariable [_var + "W",str (_posW) + " * safezoneWAbs"];};
										if (3 in _saveToProfile) then {profilenamespace setvariable [_var + "H",str (_posH) + " * safezoneH"];};
									} else {

										//--- Default position
										if (0 in _saveToProfile) then {profilenamespace setvariable [_var + "X",_posConfig select 0];};
										if (1 in _saveToProfile) then {profilenamespace setvariable [_var + "Y",_posConfig select 1];};
										if (2 in _saveToProfile) then {profilenamespace setvariable [_var + "W",_posConfig select 2];};
										if (3 in _saveToProfile) then {profilenamespace setvariable [_var + "H",_posConfig select 3];};
									};
								};
							} foreach RscDisplayOptionsIGUI_listNames;
							_display closedisplay 2;
							saveprofilenamespace;
						};
					};
				};

				//--- Default
				if (_key in [DIK_DELETE]) then {
					true call bis_fnc_guiGridToProfile;
					{
						_pos = getarray (configfile >> "CfgUIDefault" >> "IGUI" >> "Grids" >> _x >> "position");
						if (count _pos > 0) then {
							_idc = RscDisplayOptionsIGUI_listIDCs select _forEachIndex;
							_offsetY = (_pos select 2) call bis_fnc_parsenumber;
							_area = _pos select 0;
							_h = if (getnumber (configfile >> RscDisplayOptionsIGUI_class >> "controls" >> _x >> "hForced") > 0) then {
								ctrlposition CONTROL select 3;
							} else {
								((_area select 3) call bis_fnc_parsenumber) + 0.5 * _offsetY
							};
							_area = [
								(_area select 0) call bis_fnc_parsenumber,
								((_area select 1) call bis_fnc_parsenumber) - 0.5 * _offsetY,
								(_area select 2) call bis_fnc_parsenumber,
								_h
							];
							CONTROL ctrlsetposition _area;
							CONTROL ctrlcommit 0;

							//--- Reset frame color
							_idc = _idc * 10;
							CONTROL ctrlsettextcolor COLOR_DEFAULT;
							CONTROL ctrlcommit 0;
						};
					} foreach RscDisplayOptionsIGUI_listNames;
				};
			};

			//--- Keys
			_display displayaddeventhandler ["mousebuttondown","with uinamespace do {[1,_this] call RscDisplayOptionsIGUI_display_mousebutton};"];
			_display displayaddeventhandler ["mousebuttonup","with uinamespace do {[0,_this] call RscDisplayOptionsIGUI_display_mousebutton};"];
			_display displayaddeventhandler ["keydown","with uinamespace do {_this call RscDisplayOptionsIGUI_display_keydown};"];

			//--- Mouse area
			_mouseArea = _display displayctrl ([_cfgDisplay,"mouseArea"] call bis_fnc_getIDC);
			_mouseArea ctrladdeventhandler ["mousemoving","with uinamespace do {_this call RscDisplayOptionsIGUI_mouseArea_MouseMoving};"];
			_mouseArea ctrlsettextcolor [1,1,1,0.7];
			//_mouseArea ctrlsetbackgroundcolor [0,0,0,0.9];
			_mouseArea ctrlsettext "\n\n\n\n\n" + "
				Drag & Drop user interface elements to change their position or size
				\n
				\n
				Press 'Enter' to save the changes
				\n
				Press 'Escape' to discard the changes
				\n
				Press 'Delete' to restore default layout
			"; //Todo: Localize

			//--- Mouse over
			RscDisplayOptionsIGUI_mouseOver = _display displayctrl ([_cfgDisplay,"mouseOver"] call bis_fnc_getIDC);
			RscDisplayOptionsIGUI_mouseOver ctrlsetbackgroundcolor [0,1,1,0.3];
			RscDisplayOptionsIGUI_mouseOver ctrlsetposition [0,0,0,0];
			RscDisplayOptionsIGUI_mouseOver ctrlcommit 0;
	
			//--- Load grid 
			RscDisplayOptionsIGUI_GRID = ["IGUI","GRID_OLD"] call bis_fnc_guigrid;

		};
	};

	//--- Display unload
	case "onLoad": {
		with uinamespace do {

			RscDisplayOptionsIGUI_class = nil;
			RscDisplayOptionsIGUI_display_idcActive = nil;
			RscDisplayOptionsIGUI_display_idcActivePos = nil;
			RscDisplayOptionsIGUI_display_keydown = nil;
			RscDisplayOptionsIGUI_display_LMB = nil;
			RscDisplayOptionsIGUI_display_LMB_pos = nil;
			RscDisplayOptionsIGUI_display_mousebutton = nil;
			RscDisplayOptionsIGUI_display_RMB = nil;
			RscDisplayOptionsIGUI_display_RMB_pos = nil;
			RscDisplayOptionsIGUI_GRID = nil;
			RscDisplayOptionsIGUI_listGroups = nil;
			RscDisplayOptionsIGUI_listIDCs = nil;
			RscDisplayOptionsIGUI_listIDCsResize = nil;
			RscDisplayOptionsIGUI_listNames = nil;
			RscDisplayOptionsIGUI_mouseArea_MouseMoving = nil;
			RscDisplayOptionsIGUI_mouseOver = nil;
			RscDisplayOptionsIGUI_textMove = nil;
			RscDisplayOptionsIGUI_textResize = nil;
		};
	};
};