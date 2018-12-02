// Credits  Shadow

ShadGlobalChat = {

	closeDialog 0;
	disableSerialization;
	createDialog "RscDisplayChat";
	systemchat "Enter your global message Only Hun/Eng:";
	_doloop = true;
	_checkChat = true;
	
	
	keybndings =
	{
		switch (_this) do
		{
			case 28:		//Enter
			{
				//execVM "Scripts\debug.sqf";
				closeDialog 0;
			};
			case 1:		//esc
			{
				//execVM "Scripts\debug.sqf";
				_ctrl = (findDisplay 24) displayctrl 101;
				_ctrl ctrlSetText "";
				closeDialog 0;
			};
			
		};
	};
	
	
	
	while{_doloop} do {
	
		waitUntil{!isNull (findDisplay 24)};
		ertertgfd = (findDisplay 24) displayAddEventHandler ["KeyDown", "_this select 1 call keybndings; false;"];
		_oldText = "";
		_ctrl = (findDisplay 24) displayctrl 101;
		
		while{_checkChat} do {
			waitUntil{(isNull (findDisplay 24)) || (count(toArray(ctrlText _ctrl)) != count(toArray(_oldText))) };
			
			if(isNull (findDisplay 24)) exitWith {
			
				(findDisplay 24) displayRemoveEventHandler ["KeyDown", ertertgfd];
				_text = _oldText;
				_checkChat = false;
				_doloop = false;
				
				if !(_text == "") then
				{
					GlobalMessage = [name player, _text];
					publicVariableServer "GlobalMessage";
				};
			};
			_oldText = ctrlText _ctrl;
	
		};
		
		waitUntil{isNull (findDisplay 24)};
	};
};
