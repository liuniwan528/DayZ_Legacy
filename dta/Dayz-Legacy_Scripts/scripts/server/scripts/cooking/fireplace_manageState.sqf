private ["_state","_params","_item","_type"];

/*
	Manage fireplace states.
	
	Usage:
	[X, _params] call fireplace_manageState
	X =  0 -> init
	X =  1 -> on item attached
	X =  2 -> on item detached
	
	Author: Lubos Kovac
*/

//input
_state = _this select 0;
_params = _this select 1;

switch _state do
{	
	//on item attached
	case 1: 
	{
		private["_item","_fireplace"];
		_fireplace = _params select 0; 	//fireplace
		_item = _params select 1; //attached item
		
		//
		//check fuel
		//
		if (_item isKindOf "Consumable_Firewood" or
			_item isKindOf "Crafting_WoodenStick" or 
			_item isKindOf "Consumable_Rags" or 
			_item isKindOf "Medical_BandageDressing" or 
			_item isKindOf "Consumable_Paper" or 
			_item isKindOf "ItemBook") exitWith
		{
			//add to fuel
			[1, _fireplace, _item] call fireplace_manageFuel;
			
			//refresh visual
			[_fireplace] call event_fnc_fireplaceState;
		};
		
		//
		//check cooking equipment
		//
		if (_item isKindOf "Cookware_Pot") exitWith
		{
			//set Cooking equipment
			_fireplace setVariable ["cooking_equipment", _item]; 
			_item setVariable ["cooking_ready", true];
			
			
			//rotate cookware handle
			if (_fireplace animationPhase 'Oven' == 1) then
			{
				_item animate['handleRotate', 0];
			};
		};
		
		//
		//check fireplace attachments
		//
		//fireplace with stones
		if (_item isKindOf "Consumable_Stone") exitWith
		{
			private ["_item_quantity"];
			_item_quantity = quantity _item;
			
			//Stones
			if (_item_quantity >= 4 and _item_quantity < 8) then
			{
				_fireplace animate['Oven',1];
				_fireplace animate['Stones',0];
				
				//set parameters
				_fireplace setVariable ["temperature_loss_mp", 1]; 
				_fireplace setVariable ["fuel_burn_rate_mp", 0.8]; 
				_fireplace setVariable ["fuel_max_capacity_mp", 1.5];
			};
			
			//Oven
			if (_item_quantity >= 8) then 
			{
				_fireplace animate['Stones',1];
				_fireplace animate['Oven',0];
				
				//set parameters
				_fireplace setVariable ["temperature_loss_mp", 0.5]; 
				_fireplace setVariable ["fuel_burn_rate_mp", 0.5]; 
				_fireplace setVariable ["fuel_max_capacity_mp", 0.8];
			};
		};
		
		//fireplace with tripod
		if (_item isKindOf "Cooking_Tripod") exitWith
		{
			_fireplace animate['Tripod',0];
		};
	};
	
	//on item detached
	case 2: 
	{
		//debug
		//[player, format["OnDetached %1 (%2)", displayName _item, quantity _item], "colorStatusChannel"] call fnc_playerMessage;
		
		private ["_fireplace","_item_quantity"];
		_fireplace = _params select 0; 	//fireplace
		_item = _params select 1; //attached item

		//		
		//check fuel
		//
		if (_item isKindOf "Consumable_Firewood" or
			_item isKindOf "Crafting_WoodenStick" or 
			_item isKindOf "Consumable_Rags" or 
			_item isKindOf "ItemBook" or 
			_item isKindOf "Consumable_Paper") exitWith
		{
			//remove from fuel
			[2, _fireplace, _item] call fireplace_manageFuel;
			
			//check for empty 
			_fuel_items_count = [4, _fireplace, _item, ['fuel_items']] call fireplace_manageFuel;
			_kinidling_items_count = [4, _fireplace, _item, ['kindling_items']] call fireplace_manageFuel;
			if (_fuel_items_count == 0 and
				_kinidling_items_count == 0 and
				!(_fireplace getVariable ['is_fireplace', false])) then
			{
				//destroy fireplace item
				deleteVehicle _fireplace;
			}
			else
			{
				//refresh visual
				[_fireplace] call event_fnc_fireplaceState;
			};
		};

		//		
		//check cooking equipment
		//		
		if (_item isKindOf "Cookware_Pot") exitWith
		{
			//set Cooking equipment
			_fireplace setVariable ["cooking_equipment", objNull]; 
			_item setVariable ["cooking_ready", false];
			
			//rotate cookware handle
			if (_fireplace animationPhase 'Oven' == 1) then
			{
				_item animate['handleRotate', 1];
			};
		};

		//		
		//check fireplace attachments
		//		
		//fireplace with stones
		if (_item isKindOf "Consumable_Stone") exitWith
		{
			_fireplace animate['Stones',1];
			_fireplace animate['Oven',1];
			
			//set parameters
			_fireplace setVariable ["temperature_loss_mp", 1]; 
			_fireplace setVariable ["fuel_burn_rate_mp", 1]; 
			_fireplace setVariable ["fuel_max_capacity_mp", 1];
		};

		//fireplace with tripod
		if (_item isKindOf "Cooking_Tripod") exitWith
		{
			_fireplace animate['Tripod',1];
		};
	};
	
	default {};
};
