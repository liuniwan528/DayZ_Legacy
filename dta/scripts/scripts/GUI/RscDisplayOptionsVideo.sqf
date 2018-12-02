disableSerialization;

_mode = _this select 0;
_params = _this select 1;
_class = _this select 2;

switch _mode do
{
	case "onLoad":
	{
		//--- Remove blur (for better scene preview)
		'dynamicBlur' ppEffectAdjust [0];
		'dynamicBlur' ppEffectCommit 0.0;
		'dynamicBlur' ppEffectEnable false;

		_display = _params select 0;

		//--- Action when Resolution or Aspect ratio listboxes changed
		{
			_ctrlListbox = _display displayctrl _x;
			_ctrlListbox ctrladdeventhandler ["lbselchanged","with uinamespace do {['reset',ctrlparent (_this select 0),'RscDisplayOptionsVideo'] spawn RscDisplayOptionsVideo_script};"];
		} foreach [134,136];
	};

	case "reset":
	{
		startloadingscreen [""];

		//--- Resize the display accoridng to selected values
		_display = _params;

		_cfgControls = configfile >> _class >> "controls";
		_cfgControlsBackground = configfile >> _class >> "controlsbackground";

		with (uinamespace) do
		{
			{
				_cfg = _x;
				for "_i" from 0 to (count _cfg - 1) do
				{
					_current = _cfg select _i;
					if (isclass _current) then
					{
						_idc = getnumber (_current >> "idc");
						_sizeEx = (_current >> "sizeEx") call bis_fnc_parsenumber;
						_control = _display displayctrl _idc;
						_control ctrlsetfontheight _sizeEx;
						_x = (_current >> "x") call bis_fnc_parsenumber;
						_y = (_current >> "y") call bis_fnc_parsenumber;
						_w = (_current >> "w") call bis_fnc_parsenumber;
						_h = (_current >> "h") call bis_fnc_parsenumber;
						_control ctrlsetposition [_x,_y,_w,_h];
						_control ctrlcommit 0;
					};
				};
			} foreach [_cfgControls,_cfgControlsBackground];

			//if resetting keep accordion expanded (i.e. move certain buttons up) in Main Menu, Pause Menu, MP Pause Menu, Video Pause Menu
			_GRID = ["gui","grid"] call bis_fnc_guigrid;
			_GUI_GRID_W = _GRID select 1;
			_GUI_GRID_H = _GRID select 2;
			_GUI_GRID_X = (_GRID select 0) select 0;
			_GUI_GRID_Y = (_GRID select 0) select 1;

			//Reset of accordion in Main Menu
			if((_this select 2) == "RscDisplayMain") then
			{
				debuglog "Resetting Main menu. Expanding options in accordion again.";

				//If Options were expanded before reset, expand it again
				if(uiNamespace getvariable "BIS_MainMenu_isOptionsExpanded") then
				{
					uiNamespace setVariable ["BIS_MainMenu_isOptionsExpanded", false];			//set it to false to tell the script the current state. It will expand the options.
					['optionsButton', [(findDisplay 0) displayctrl 102], ''] call RscDisplayMain_script; 	//simulate click on Options button
				};

				//If Play was expanded before reset, expand it again
				if(uiNamespace getvariable "BIS_MainMenu_isPlayExpanded") then
				{
					uiNamespace setVariable ["BIS_MainMenu_isPlayExpanded", false];				//set it to false to tell the script the current state. It will expand play.
					['playButton', [(findDisplay 0) displayctrl 138], ''] call RscDisplayMain_script; 	//simulate click on Play button
				};
			};

			//Reset of Pause Menu
			if((_this select 2) == "RscDisplayInterrupt") then
			{
				debuglog "Resetting Pause Menu. Expanding options in accordion again.";

				//If Options in the Pause Menu were expanded before reset, expand it again
				if(uiNamespace getvariable "BIS_DisplayInterrupt_isOptionsExpanded") then
				{
					uiNamespace setVariable ["BIS_DisplayInterrupt_isOptionsExpanded", false];			//set it to false to tell the script the current state. It will expand the options.
					['optionsButton', [(findDisplay 49) displayctrl 101], ''] call RscDisplayInterrupt_script; 	//simulate click on Options button
				};
			};

			//Reset of MP Pause Menu
			if((_this select 2) == "RscDisplayMPInterrupt") then
			{
				debuglog "Resetting MP Pause Menu. Expanding options in accordion again.";

				//If Options in the MP Pause Menu were expanded before reset, expand it again
				if(uiNamespace getvariable "BIS_DisplayInterrupt_isOptionsExpanded") then
				{
					uiNamespace setVariable ["BIS_DisplayInterrupt_isOptionsExpanded", false];			//set it to false to tell the script the current state. It will expand the options.
					['optionsButton', [(findDisplay 49) displayctrl 101], ''] call RscDisplayMPInterrupt_script; 	//simulate click on Options button
				};
			};

			//Reset of Video Pause Menu
			//Pause menu, MP pause menu and Video pause menu - all have IDD_INTERRUPT 49
			if( (_this select 2) == "RscDisplayMovieInterrupt" ) then
			{
				debuglog "Resetting Video Pause Menu. Expanding options in accordion again.";

				//If Options in the MP Pause Menu were expanded before reset, expand it again
				if(uiNamespace getvariable "BIS_DisplayInterrupt_isOptionsExpanded") then
				{
					uiNamespace setVariable ["BIS_DisplayInterrupt_isOptionsExpanded", false];			//set it to false to tell the script the current state. It will expand the options.
					['optionsButton', [(findDisplay 49) displayctrl 101], ''] call RscDisplayMovieInterrupt_script; 	//simulate click on Options button
				};
			};
		};
		endloadingscreen;
	};


	case "onUnload":
	{
		startloadingscreen [""];

		_display = _params select 0;
		_button = _params select 1;

		//if UI size changed and user clicked OK, resize displays
		if ( (_button == 1) && (lbCurSel(_display displayctrl 136) != (uinamespace getvariable "RscDisplayOptionsVideoUIsize")) ) then
		{
			//Remember new state of UI size ComboBox
			uinamespace setvariable ["RscDisplayOptionsVideoUIsize", lbCurSel (_display displayctrl 136)];

			//--- Resize all opened displays
			{
				['reset',_x,gui_classes select _foreachindex] spawn RscDisplayOptionsVideo_script;
			} foreach gui_displays;

			//--- Apply blur again (not in main menu)
			if !(isNull player) then
			{
				'dynamicBlur' ppEffectEnable true;
				'dynamicBlur' ppEffectAdjust [1.6];
				'dynamicBlur' ppEffectCommit 0;
			};
		};
		endloadingscreen;
	};
};
