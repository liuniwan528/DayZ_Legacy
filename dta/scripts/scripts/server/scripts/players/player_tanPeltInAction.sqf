private["_person","_sender","_receiver","_max","_senderQty","_receiverQty","_exchanged","_config","_tannedCount"];

_tannedCount = _this select 0;

if ( quantity _tool1 < 0.1*_tannedCount ) exitwith
{
	_config = configFile >> "CfgVehicles" >> typeOf _tool1;
	_lime_name = 	getText (_config >> "displayName");
	
	_config = configFile >> "CfgVehicles" >> typeOf _tool2;
	_pelt_name = 	getText (_config >> "displayName");
	[_owner,format["I don't have enough of %1 for tan of %2",_lime_name, _pelt_name],""] call fnc_playerMessage;
};

deleteVehicle _tool2;
_item = ['Consumable_TannedLeather', _owner] call player_addInventory;
[_item, _tannedCount] call fnc_addQuantity;
[_tool1, -0.1*_tannedCount] call fnc_addQuantity;