player_queued_isrunning = true;

_id = _this select 0;
_alive = _this select 1;

0 fadeSound 0;
0 fadeSpeech 0;
0 fadeMusic 0;

//create camera
_position = _this select 2;
_wait = _this select 6;

// parameter _isOnline is not used

if (!(_this select 5)) then
{
	statusChat ["WARNING! The server has not been able to contact the central server to load a character, so it has loaded a default character that may overwrite your existing character if the server regains connection. We recommend you disconnect immediately and try another server.","ColorImportant"];
};

0 setOvercast (_this select 3);
0 setRain (_this select 4);
simulWeatherSync;

setAperture 10000;

if (_wait < 0) then
{
	while {_wait < 0} do
	{
		titleText [format[localize "STR_MD_PQUEUED_SPAWNTIMER",-_wait],"BLACK FADED",10e10];
		_wait = _wait + 1;
		sleep 1;
	};
};

titleText [localize "STR_MD_PQUEUED_SCRLOAD","BLACK FADED",10e10];
/*
myCamera = "camera" camCreate _position;
myCamera cameraEffect ["internal","back"];
myCamera camPrepareDir 120;
myCamera camPreparePos _position;
myCamera camCommitPrepared 0;
*/
//waitUntil {preloadCamera _position};

if (!_alive) then
{	
	//load data
	_top = getArray(configFile >> "cfgCharacterCreation" >> "top");
	_bottom = getArray(configFile >> "cfgCharacterCreation" >> "bottom");
	_shoe = getArray(configFile >> "cfgCharacterCreation" >> "shoe");
	_format = getText(configFile >> "cfgCharacterCreation" >> "format");

	//find selected skin
	_charType = profileNamespace getVariable ["defaultCharacter",""];
	_charTypeN = DZ_SkinsArray find _charType;
	if (_charTypeN < 0) then {_charTypeN = floor random (count DZ_SkinsArray)};

	//generate inventory array
	_topN = floor random (count _top);
	_bottomN = floor random (count _bottom);
	_shoeN = floor random (count _shoe);
	_array = profileNamespace getVariable ["defaultInventory",[]];
	{
		switch true do
		{
			case (_x isKindOf "TopwearBase"): {
				_topN = (_top find _x);
			};
			case (_x isKindOf "BottomwearBase"): {
				_bottomN = (_bottom find _x);
			};
			case (_x isKindOf "FootwearBase"): {
				_shoeN = (_shoe find _x);
			};
		};
	} forEach _array;
	clientNew = [_charTypeN,[_topN,_bottomN,_shoeN],_id];
	publicVariableServer "clientNew";	
	statusChat [localize "STR_MD_PQUEUED_NEWPL"];
	waitUntil {isSceneReady};
	statusChat [localize "STR_MD_PQUEUED_NEWSC"];
}
else
{
	clientReady = _id;
	publicVariableServer "clientReady";		
	statusChat [localize "STR_MD_PQUEUED_READY" + "..."];
};

player_queued_isrunning = false;

5 fadeSound 0;
5 fadeSpeech 0;
5 fadeMusic 0;