/*
	Author: Karel Moricky

	Description:
	GUI Color settings
*/

_mode = _this select 0;
_params = _this select 1;
_class = _this select 2;
disableserialization;

switch _mode do {

	//--- Display load
	case "onLoad": {
		//--- Functions are stored in uiNameSpace
		with uinamespace do {

			_display = _params select 0;
			RscDisplayOptionsGUI_display = _display;

			//--- Load color preset
			_presetName = profileNameSpace getvariable ["GUI_BCG_RGB_preset",""];

			//--- Backup current values
/*
			RscDisplayOptionsGUI_current = [
				profilenamespace getvariable "GUI_BCG_RGB_R",
				profilenamespace getvariable "GUI_BCG_RGB_G",
				profilenamespace getvariable "GUI_BCG_RGB_B",
				profilenamespace getvariable "GUI_BCG_RGB_A",
				_presetName
			];
*/

			//--- Get IDCs
			_cfgDisplay = configfile >> _class;
			RscDisplayOptionsGUI_listTags =			_display displayctrl ([_cfgDisplay,"ListTags"] call bis_fnc_getIDC);
			RscDisplayOptionsGUI_listVariables =		_display displayctrl ([_cfgDisplay,"ListVariables"] call bis_fnc_getIDC);
			RscDisplayOptionsGUI_listPresets =		_display displayctrl ([_cfgDisplay,"ListPresets"] call bis_fnc_getIDC);
			RscDisplayOptionsGUI_buttonCancel =		_display displayctrl ([_cfgDisplay,"CA_ButtonCancel"] call bis_fnc_getIDC);
			RscDisplayOptionsGUI_buttonOK =			_display displayctrl ([_cfgDisplay,"CA_ButtonContinue"] call bis_fnc_getIDC);
			RscDisplayOptionsGUI_sliderColorR =		_display displayctrl ([_cfgDisplay,"sliderColorR"] call bis_fnc_getIDC);
			RscDisplayOptionsGUI_sliderColorG =		_display displayctrl ([_cfgDisplay,"sliderColorG"] call bis_fnc_getIDC);
			RscDisplayOptionsGUI_sliderColorB =		_display displayctrl ([_cfgDisplay,"sliderColorB"] call bis_fnc_getIDC);
			RscDisplayOptionsGUI_sliderColorA =		_display displayctrl ([_cfgDisplay,"sliderColorA"] call bis_fnc_getIDC);
			RscDisplayOptionsGUI_valueColorR =		_display displayctrl ([_cfgDisplay,"valueColorR"] call bis_fnc_getIDC);
			RscDisplayOptionsGUI_valueColorG =		_display displayctrl ([_cfgDisplay,"valueColorG"] call bis_fnc_getIDC);
			RscDisplayOptionsGUI_valueColorB =		_display displayctrl ([_cfgDisplay,"valueColorB"] call bis_fnc_getIDC);
			RscDisplayOptionsGUI_valueColorA =		_display displayctrl ([_cfgDisplay,"valueColorA"] call bis_fnc_getIDC);
			RscDisplayOptionsGUI_preview =			_display displayctrl ([_cfgDisplay,"preview"] call bis_fnc_getIDC);
			RscDisplayOptionsGUI_previewBackground =	_display displayctrl ([_cfgDisplay,"previewBackground"] call bis_fnc_getIDC);

			//--- Button OK - save changes
			RscDisplayOptionsGUI_buttonOK_activated = false;
			RscDisplayOptionsGUI_buttonOK_action = {
					_warning = [localize 'STR_MSG_RESTART_NEEDED',nil,nil,[localize 'STR_DISP_OK',nil],uinamespace getvariable 'RscDisplayOptionsGUI_display'] call bis_fnc_guiMessage;

					startloadingscreen [""];
					if (_warning select 0) then {
						RscDisplayOptionsGUI_buttonOK_activated = true;

						(uinamespace getvariable 'RscDisplayOptionsGUI_display') closedisplay 3000;

						{
							[configfile >> (GUI_classes select _foreachindex),_x] call bis_fnc_displayColorSet;
						} foreach GUI_displays;
		
						saveProfileNamespace;
					};//--- ToDo: Do not change display colors always (only for BCG_RGB)
					endloadingscreen;
			};


			//--- On slider moving (executed in uiNameSpace)
			RscDisplayOptionsGUI_SliderPosChanged = {
				_params = _this select 0;
				_display = _params select 0;
				_sliderPos = _params select 1;
				_sliderPos = _sliderPos / 10;
				_sliderId = _this select 1;
				_manual = _this select 2;

				_tag = RscDisplayOptionsGUI_listTags lbdata (lbcursel RscDisplayOptionsGUI_listTags);
				_varName = RscDisplayOptionsGUI_listVariables lbdata (lbcursel RscDisplayOptionsGUI_listVariables);
				_var = _tag + "_" + _varName + "_";

				_varList = [
					(_var + "R"),
					(_var + "G"),
					(_var + "B"),
					(_var + "A")
				];
				_valueList = [
					RscDisplayOptionsGUI_valueColorR,
					RscDisplayOptionsGUI_valueColorG,
					RscDisplayOptionsGUI_valueColorB,
					RscDisplayOptionsGUI_valueColorA
				];

				//--- No longer preset - set listbox to first item ("<Custom>")
				if (_manual) then {RscDisplayOptionsGUI_listPresets lbsetcursel 0;};

				//--- Show value
				_valueText = (round (_sliderPos * 100));
				_value = _valueList select _sliderId;
				_value ctrlsettext (str _valueText + "%");

				//--- Save into profile and preview
				profilenamespace setvariable [_varList select _sliderId,_sliderPos];

				//--- Preview
				_preview = RscDisplayOptionsGUI_previewPath;
				if (_preview != "") then {
					if (_preview == "bcg") then {
						[configfile >> "RscDisplayOptionsGUI",ctrlparent _display] call bis_fnc_displayColorSet;
					} else {
						RscDisplayOptionsGUI_preview ctrlsettextcolor [
							profilenamespace getvariable (_varList select 0),
							profilenamespace getvariable (_varList select 1),
							profilenamespace getvariable (_varList select 2),
							profilenamespace getvariable (_varList select 3)
						];
						RscDisplayOptionsGUI_preview ctrlcommit 0;
					};
				};

				//--- Change listbox preview picture
				RscDisplayOptionsGUI_listVariables lbsetpicture [
					lbcursel RscDisplayOptionsGUI_listVariables,
					format [
						"#(argb,8,8,3)color(%1,%2,%3,%4)",
						profilenamespace getvariable (_varList select 0),
						profilenamespace getvariable (_varList select 1),
						profilenamespace getvariable (_varList select 2),
						profilenamespace getvariable (_varList select 3)
					]
				];
			};
			{
				_x ctrladdeventhandler [
					"SliderPosChanged",
					format ["with uinamespace do {[_this,%1,true] call RscDisplayOptionsGUI_SliderPosChanged};",_forEachIndex]
				];
			} foreach [
				RscDisplayOptionsGUI_sliderColorR,
				RscDisplayOptionsGUI_sliderColorG,
				RscDisplayOptionsGUI_sliderColorB,
				RscDisplayOptionsGUI_sliderColorA
			];

			//--- On tag selected
			RscDisplayOptionsGUI_listTags_LBSelChanged = {
				lbclear RscDisplayOptionsGUI_listVariables;

				_tag = RscDisplayOptionsGUI_listTags lbdata (lbcursel RscDisplayOptionsGUI_listTags);
				_cfgVariables = configfile >> "CfgUIDefault" >> _tag >> "Variables";
				for "_i" from 0 to (count _cfgVariables - 1) do {
					_current = _cfgVariables select _i;

					if (isclass _current) then {
						_currentName = configname _current;

						//--- Add preset name to the list
						_displayName = _current call bis_fnc_displayName;
						_lbAdd = RscDisplayOptionsGUI_listVariables lbadd _displayName;
						RscDisplayOptionsGUI_listVariables lbsetdata [_lbAdd,_currentName];

						//--- Show color preview
						_colorVar = _tag + "_" + _currentName + "_";
						_color = format [
							"#(argb,8,8,3)color(%1,%2,%3,%4)",
							profilenamespace getvariable (_colorVar + "R"),
							profilenamespace getvariable (_colorVar + "G"),
							profilenamespace getvariable (_colorVar + "B"),
							profilenamespace getvariable (_colorVar + "A")
						];
						RscDisplayOptionsGUI_listVariables lbsetpicture [_lbAdd,_color];
					};
				};
				RscDisplayOptionsGUI_listVariables lbsetcursel 0;
				//RscDisplayOptionsGUI_listPresets lbsetcursel 0;
			};

			//--- On variable selected
			RscDisplayOptionsGUI_listVariables_LBSelChanged = {
				lbclear RscDisplayOptionsGUI_listPresets;

				_tag = RscDisplayOptionsGUI_listTags lbdata (lbcursel RscDisplayOptionsGUI_listTags);
				_varName = RscDisplayOptionsGUI_listVariables lbdata (lbcursel RscDisplayOptionsGUI_listVariables);
				_var = _tag + "_" + _varName + "_";
				_presetName = profileNameSpace getvariable [_var + "preset",""];
				_cfgVariable = configfile >> "CfgUIDefault" >> _tag >> "Variables" >> _varName;

				//--- Preview background
				_previewBackground = [_cfgVariable,"previewBackground"] call BIS_fnc_returnConfigEntry;
				RscDisplayOptionsGUI_previewBackground ctrlsettext "";
				switch (typename _previewBackground) do {
					case (typename 1): {
						
					};
					case (typename ""): {
						RscDisplayOptionsGUI_previewBackground ctrlsettext _previewBackground;
					};
				};

				//--- Preview
				_preview = [_cfgVariable,"preview"] call BIS_fnc_returnConfigEntry;
				RscDisplayOptionsGUI_preview ctrlsettext "";
				RscDisplayOptionsGUI_previewPath = switch (typename _preview) do {
					case (typename 1): {
						if (_preview == 1) then {"bcg"} else {""};
					};
					case (typename ""): {

						_w = [_cfgVariable >> "previewW"] call bis_fnc_parsenumber;
						_h = [_cfgVariable >> "previewH"] call bis_fnc_parsenumber;
						if (_w > 0 && _h > 0) then {
							_posBcg = ctrlposition RscDisplayOptionsGUI_previewBackground;
							_x = (_posBcg select 0) + (_posBcg select 2) / 2;
							_y = (_posBcg select 1) + (_posBcg select 3) / 2;
							RscDisplayOptionsGUI_preview ctrlsetposition [
								_x - (_w / 2),
								_y - (_h / 2),
								_w,
								_h
							];	
						};

						RscDisplayOptionsGUI_preview ctrlsettext _preview;
						_preview
					};
					default {""};
				};

				//--- Load presets
				_lbAdd = RscDisplayOptionsGUI_listPresets lbadd "<Custom>"; //ToDo: Localize
				RscDisplayOptionsGUI_listPresets lbsetdata [_lbAdd,""];
				RscDisplayOptionsGUI_listPresets lbsetcursel 0;

				_cfgUIDefault = configfile >> "CfgUIDefault" >> _tag >> "Presets";
				for "_i" from 0 to (count _cfgUIDefault - 1) do {
					_current = _cfgUIDefault select _i;
					if (isclass _current) then {
						_currentVar = _current >> "Variables" >> _varName;
						if (isarray _currentVar) then {

							_currentName = configname _current;

							//--- Add preset name to the list
							_displayName = _current call bis_fnc_displayName;
							_lbAdd = RscDisplayOptionsGUI_listPresets lbadd _displayName;
							RscDisplayOptionsGUI_listPresets lbsetdata [_lbAdd,_currentName];

							//--- Current preset - set as selected
							if (_currentName == _presetName) then {RscDisplayOptionsGUI_listPresets lbsetcursel _lbAdd};
						};
					};
				};
				if (lbcursel RscDisplayOptionsGUI_listPresets < 0) then {RscDisplayOptionsGUI_listPresets lbsetcursel 0};
			};


			//--- On preset selected (executed in uiNameSpace)
			RscDisplayOptionsGUI_listPresets_LBSelChanged = {
				private ["_display","_lbId","_lbData","_cfgPreset","_colorBackground","_colorR","_colorG","_colorB","_colorA","_sliderList","_valueList"];
				_display = _this select 0;
				_lbId = _this select 1;
				_lbData = _display lbdata _lbId;

				_tag = RscDisplayOptionsGUI_listTags lbdata (lbcursel RscDisplayOptionsGUI_listTags);
				_varName = RscDisplayOptionsGUI_listVariables lbdata (lbcursel RscDisplayOptionsGUI_listVariables);
				_var = _tag + "_" + _varName + "_";

				_cfgPresetVariables = configfile >> "CfgUIDefault" >> _tag >> "Presets" >> _lbData >> "Variables";
				_colorBackground = getarray (_cfgPresetVariables >> _varName);
				if (count _colorBackground == 4) then {

					_colorR = _colorBackground select 0;
					_colorG = _colorBackground select 1;
					_colorB = _colorBackground select 2;
					_colorA = _colorBackground select 3;
				} else {
					_colorR = profilenamespace getvariable (_var + "R");
					_colorG = profilenamespace getvariable (_var + "G");
					_colorB = profilenamespace getvariable (_var + "B");
					_colorA = profilenamespace getvariable (_var + "A");
				};

				if (typename _colorR == typename "") then {_colorR = call compile _colorR};
				if (typename _colorG == typename "") then {_colorG = call compile _colorG};
				if (typename _colorB == typename "") then {_colorB = call compile _colorB};
				if (typename _colorA == typename "") then {_colorA = call compile _colorA};

				RscDisplayOptionsGUI_sliderColorR slidersetposition (_colorR)*10;
				RscDisplayOptionsGUI_sliderColorG slidersetposition (_colorG)*10;
				RscDisplayOptionsGUI_sliderColorB slidersetposition (_colorB)*10;
				RscDisplayOptionsGUI_sliderColorA slidersetposition (_colorA)*10;

				//--- Set slider positions (handler is not doing it automatically)
				_sliderList = [RscDisplayOptionsGUI_sliderColorR,RscDisplayOptionsGUI_sliderColorG,RscDisplayOptionsGUI_sliderColorB,RscDisplayOptionsGUI_sliderColorA];
				_valueList = [_colorR,_colorG,_colorB,_colorA];
				{
					[
						[_sliderList select _forEachIndex,_x * 10],
						_forEachIndex,
						false
					] call RscDisplayOptionsGUI_SliderPosChanged;
				} foreach _valueList;

				//--- Modify related variables
				_cfgVariables = configfile >> "CfgUIDefault" >> _tag >> "Variables";
				_n = 0;
				for "_v" from 0 to (count _cfgVariables - 1) do {
					_relatedVarClass = _cfgVariables select _v;
					if (isclass _relatedVarClass) then {
						_relatedVarName = configname _relatedVarClass;
						_relatedVar = _tag + "_" + _relatedVarName + "_";
						_relatedVarColor = getarray (_cfgPresetVariables >> _relatedVarName);
						if (count _relatedVarColor == 4) then {
							_colorR = _relatedVarColor select 0;
							_colorG = _relatedVarColor select 1;
							_colorB = _relatedVarColor select 2;
							_colorA = _relatedVarColor select 3;
							if (typename _colorR == typename "") then {_colorR = call compile _colorR};
							if (typename _colorG == typename "") then {_colorG = call compile _colorG};
							if (typename _colorB == typename "") then {_colorB = call compile _colorB};
							if (typename _colorA == typename "") then {_colorA = call compile _colorA};
							profileNameSpace setvariable [_relatedVar + "R",_colorR];
							profileNameSpace setvariable [_relatedVar + "G",_colorG];
							profileNameSpace setvariable [_relatedVar + "B",_colorB];
							profileNameSpace setvariable [_relatedVar + "A",_colorA];

							//--- Change listbox preview picture
							RscDisplayOptionsGUI_listVariables lbsetpicture [
								_n,
								format ["#(argb,8,8,3)color(%1,%2,%3,%4)",_colorR,_colorG,_colorB,_colorA]
							];
						};
						profileNameSpace setvariable [_relatedVar + "preset",_lbData];
						_n = _n + 1;
					};
				};

				//--- Save preset into profileNameSpace
				profileNameSpace setvariable [_var + "preset",_lbData];
				//saveProfileNamespace;
			};
			RscDisplayOptionsGUI_listTags ctrladdeventhandler [
				"LBSelChanged",
				"with uinamespace do {_this call RscDisplayOptionsGUI_listTags_LBSelChanged};"
			];
			RscDisplayOptionsGUI_listVariables ctrladdeventhandler [
				"LBSelChanged",
				"with uinamespace do {_this call RscDisplayOptionsGUI_listVariables_LBSelChanged};"
			];
			RscDisplayOptionsGUI_listPresets ctrladdeventhandler [
				"LBSelChanged",
				"with uinamespace do {_this call RscDisplayOptionsGUI_listPresets_LBSelChanged};"
			];
			RscDisplayOptionsGUI_buttonOK buttonsetaction "with uinamespace do {[] spawn RscDisplayOptionsGUI_buttonOK_action;};";

			//--- Load Tags
			RscDisplayOptionsGUI_currentNames = [];
			RscDisplayOptionsGUI_currentValues = [];
			_cfgUIDefault = configfile >> "CfgUIDefault";
			for "_i" from 0 to (count _cfgUIDefault - 1) do {
				_current = _cfgUIDefault select _i;
				if (isclass _current) then {
					_currentName = configname _current;

					//--- Add tag name to the list
					_displayName = _current call bis_fnc_displayName;
					_lbAdd = RscDisplayOptionsGUI_listTags lbadd _displayName;
					RscDisplayOptionsGUI_listTags lbsetdata [_lbAdd,_currentName];

					//--- Backup
					_cfgVariables = _current >> "variables";
					for "_v" from 0 to (count _cfgVariables - 1) do {
						_varName = _cfgVariables select _v;
						if (isclass _varName) then {
							_var = _currentName + "_" + configname _varName;
							_varR = _var + "_R";
							_varG = _var + "_G";
							_varB = _var + "_B";
							_varA = _var + "_A";
							_varPreset = _var + "_preset";

							RscDisplayOptionsGUI_currentNames set [count RscDisplayOptionsGUI_currentNames,_varR];
							RscDisplayOptionsGUI_currentNames set [count RscDisplayOptionsGUI_currentNames,_varG];
							RscDisplayOptionsGUI_currentNames set [count RscDisplayOptionsGUI_currentNames,_varB];
							RscDisplayOptionsGUI_currentNames set [count RscDisplayOptionsGUI_currentNames,_varA];
							RscDisplayOptionsGUI_currentNames set [count RscDisplayOptionsGUI_currentNames,_varPreset];

							RscDisplayOptionsGUI_currentValues set [count RscDisplayOptionsGUI_currentValues,profilenamespace getvariable [_varR,0]];
							RscDisplayOptionsGUI_currentValues set [count RscDisplayOptionsGUI_currentValues,profilenamespace getvariable [_varG,0]];
							RscDisplayOptionsGUI_currentValues set [count RscDisplayOptionsGUI_currentValues,profilenamespace getvariable [_varB,0]];
							RscDisplayOptionsGUI_currentValues set [count RscDisplayOptionsGUI_currentValues,profilenamespace getvariable [_varA,1]];
							RscDisplayOptionsGUI_currentValues set [count RscDisplayOptionsGUI_currentValues,profilenamespace getvariable [_varPreset,""]];
						};
					};
				};
			};
			if (lbcursel RscDisplayOptionsGUI_listTags < 0) then {RscDisplayOptionsGUI_listTags lbsetcursel 0};
		};
	};

	case "onUnload": {
		with uinamespace do {

			//--- Reset Defaults
			if !(RscDisplayOptionsGUI_buttonOK_activated) then {

				{
					profilenamespace setvariable [_x,RscDisplayOptionsGUI_currentValues select _foreachindex];
				} foreach RscDisplayOptionsGUI_currentNames;
			};

			//--- Nil variable
			RscDisplayOptionsGUI_display = nil;
			RscDisplayOptionsGUI_SliderPosChanged = nil;
			RscDisplayOptionsGUI_listTags_LBSelChanged = nil;
			RscDisplayOptionsGUI_listVariables_LBSelChanged = nil;
			RscDisplayOptionsGUI_listPresets_LBSelChanged = nil;
			RscDisplayOptionsGUI_listTags = nil;
			RscDisplayOptionsGUI_listVariables = nil;
			RscDisplayOptionsGUI_listPresets = nil;
			RscDisplayOptionsGUI_buttonCancel = nil;
			RscDisplayOptionsGUI_buttonOK = nil;
			RscDisplayOptionsGUI_buttonOK_action = nil;
			RscDisplayOptionsGUI_buttonOK_activated = nil;
			RscDisplayOptionsGUI_sliderColorR = nil;
			RscDisplayOptionsGUI_sliderColorG = nil;
			RscDisplayOptionsGUI_sliderColorB = nil;
			RscDisplayOptionsGUI_sliderColorA = nil;
			RscDisplayOptionsGUI_valueColorR = nil;
			RscDisplayOptionsGUI_valueColorG = nil;
			RscDisplayOptionsGUI_valueColorB = nil;
			RscDisplayOptionsGUI_valueColorA = nil;
			RscDisplayOptionsGUI_currentNames = nil;
			RscDisplayOptionsGUI_currentValues = nil;
		};
	};
};