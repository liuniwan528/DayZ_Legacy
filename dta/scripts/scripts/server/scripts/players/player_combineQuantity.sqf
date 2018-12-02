private["_person","_sender","_receiver","_max","_senderQty","_receiverQty","_exchanged","_config"];
/*
	Combine loose rounds
	
	Author: Rocket
*/
_person = _owner;
_sender = _tool1;
_receiver = _tool2;
_config = 	configFile >> "CfgVehicles" >> typeOf _receiver;
_name = 	getText (_config >> "displayName");
_max = 		getNumber (_config >> "stackedMax");
_senderQty = quantity _sender;
_receiverQty = quantity _receiver;

if ((typeOf _sender) != (typeOf _receiver)) exitWith
{	
	[_person,"You cannot combine different types of items",""] call fnc_playerMessage;
};

if ((damage _sender >= 1) or (damage _receiver >= 1)) exitWith
{	
	[_person,format["Some of the %1 is too badly damaged",displayname _receiver],""] call fnc_playerMessage;
	
	//[_person,format["Some of the %1 is too badly damaged",typeOf _receiver],""] call fnc_playerMessage;
};

//process changes
_exchanged = ((_receiverQty + _senderQty) min _max) - _receiverQty;
_receiverQty = _receiverQty + _exchanged;
_senderQty = _senderQty - _exchanged;

//check disease (these with transmission class - like Cholera)
[_receiver,_sender,"Direct"] call event_transferModifiers;
[_person,_receiver,"Direct"] call event_transferModifiers;

//check damage of combined piles and setDamage to the receiver
_senderDamage = damage _sender;
_receiverDamage = damage _receiver;
_condition = 0;
_dirty = false;
if (_senderDamage >= _receiverDamage) then
{
	_condition = _senderDamage;
}
else 
{
	_condition = _receiverDamage;
};
if (_condition >= 0.5) then
{
	_dirty = true;
};

//save results
if (_senderQty > 0) then
{
	_sender setQuantity _senderQty;
}
else
{
	deleteVehicle _sender;
};
_receiver setQuantity _receiverQty;
if (_dirty) then
{
	_receiver setDamage _condition;
};
_dirty = false;

//send response
[_person,"craft_rounds"] call event_saySound;
[_person,format["I have combined the %1",_name],"colorAction"] call fnc_playerMessage;