private["_person","_sender","_receiver","_max","_senderQty","_receiverQty","_exchanged","_config","_tannedCount"];

_needQuantity = _this select 0;
_result_class_name = _this select 1;

if ( quantity _tool2 >= _needQuantity ) then
{
	_tool_new_damage = (damage _tool1 + (0.05*_needQuantity));
	
	if ( _tool_new_damage <= 1 ) then
	{
		// Decrese quantity of Tanned Leathers
		[_tool2, -_needQuantity] call fnc_addQuantity;
		
		// Add damage to Sewing Kit
		_tool1 setDamage ((damage _tool1 + (0.05*_needQuantity)) min 1);
		
		_item = [_result_class_name, _owner] call player_addInventory;
	}
	else
	{
		_config			= configFile >> "CfgVehicles" >> typeOf _tool1;
		_sewingkit_name	= getText (_config >> "displayName");
		
		_config			= configFile >> "CfgVehicles" >> _result_class_name;
		_result_name		= getText (_config >> "displayName");
		
		[_owner,format["%1 is too damaged for sew %2 ", _sewingkit_name, _result_name],""] call fnc_playerMessage;
	}
};