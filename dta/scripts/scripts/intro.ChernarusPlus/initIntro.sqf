titleCut ["","BLACK FADED",10e10];
call compile preprocessFileLineNumbers "\bin\scripts\modulesdayz\init.sqf";

// Assign desired values
/*
setViewDistance 3000;
setTerrainGrid 3.125;
*/
	setAperture -1;
	myCamera = objNull;
	demoUnit = objNull;
	demoDefDir = 159.331;
	changeScene = [false] spawn ui_newScene;
	waitUntil{scriptDone changeScene};
	/*
	_music = "";//"Track01_Proteus";
	0 fadeMusic 0;
	playMusic [_music,16];
	5 fadeMusic 0.5;
	*/

	//populate inventory
	_inventory = profileNamespace getVariable ["lastInventory",[]];
	{
		if !(_x isKindOf "DefaultMagazine") then {
			demoUnit createInInventory _x;
		};
	} forEach _inventory;
	
	//populate attachments
	_weapon = demoUnit itemInSlot "shoulder";
	_attachments = profileNamespace getVariable ["lastAttachments",[]];
	if (!isNull _weapon) then
	{
		{
			_weapon createInInventory _x;
			waitUntil {1 preloadObject _weapon};
		} forEach _attachments;
	};	
	
	demoUnit call ui_fnc_animateCharacter;

	if (daytime < 10) then
	{
		demoUnit call effect_createBreathFog;
	};

	titleCut ["","BLACK IN",3];
	/*
	while {true} do
	{
		skipTime - 0.00026;
		sleep 1;
	};
	*/