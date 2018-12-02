disableserialization;

_mode = _this select 0;
_params = _this select 1;
_class = _this select 2;

switch _mode do {

	case "onLoad": {
		_display = _params select 0;

		//count maps
		_size = lbSize (_display displayctrl 101);
		(_display displayctrl 1013) ctrlSetText (str _size);
		
		//works but can be done better (wait until ListBox is filled, than count)
		_display displayaddeventhandler
		[
			"mousemoving",
			"
				_display = _this select 0;
				(_display displayctrl 1014) ctrlsettext str (lbsize (_display displayctrl 102) - 2);	
			"
		];
		
		//count missions
		//_vel = lbSize (_display displayctrl 102);
		
		//debuglog _vel;

		//don't count New-Editor and New-Wizard
		//_size = _size - 2;
		//if(_size < 0) then {_size = 0;};
		//(_display displayctrl 1014) ctrlSetText (str _vel);
		
		//(_display displayctrl 101) ctrladdeventhandler ["lbselchanged","with uinamespace do {['mapChanged',_this,''] call RscDisplayRemoteMissions_script};"];
	};
	
	/*
	case "mapChanged": {
		[] spawn
		{
			//_ctrl = _params select 0;
			_display = ctrlparent (_params select 0);
			
			sleep 0.2;
			
			//count missions
			_size = lbSize (_display displayctrl 102);
			//don't count New-Editor and New-Wizard
			_size = _size - 2;
			if(_size < 0) then {_size = 0;};
			(_display displayctrl 1014) ctrlSetText (str _size);
		};
	};
	*/
	
};