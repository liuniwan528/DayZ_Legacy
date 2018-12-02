private ["_this","_mode","_params","_class","_zeroPos","_characterPos","_characterDir","_females","_males","_cameraPos","_targetPos","_cameraFOV","_camera","_display","_idc","_sexCtrl","_skinCtrl","_faceCtrl"];

/*
	UIscreen: New Survivor
	
	To check it run from debug console as: _uiScreen = createDialog "RscDisplayNewSurvivor";
	
	author: Peter Nespesny
*/

_mode = _this select 0;
_params = _this select 1;
_class = _this select 2;

_zeroPos = [0,0,0];
_characterPos = [2500,2500,0];
_characterDir = 210;
_females = ["SurvivorPartsFemaleAfrican","SurvivorPartsFemaleAsian","SurvivorPartsFemaleWhite"];
_males = ["SurvivorPartsMaleAfrican","SurvivorPartsMaleAsian","SurvivorPartsMaleWhite"];

switch _mode do {
		case "onLoad": {
		_cameraPos = [2499,2495,1.5];
		_targetPos = [2499.25,2500,0.9];
		_cameraFOV = 0.362;
		
		_camera = "camera" camCreate _cameraPos;
		_camera cameraEffect ["internal","back"];
		_camera camPrepareTarget _targetPos;
		_camera camPreparePos _cameraPos;
		_camera camPrepareFOV _cameraFOV;
		_camera camCommitPrepared 0;
		
		_display = _params select 0;
		//_listBox displayAddEventHandler ["LBSelChanged","with uinamespace do {['listBoxChanged',_this,''] call RscDisplayNewSurvivor_script};"];
		
		_idc = 1410;
		_sexCtrl = _display displayCtrl _idc;	
		_sexCtrl lbAdd "Female";
		_sexCtrl lbAdd "Male";
		_sexCtrl lbSetCurSel 0;
		_sexCtrl ctrlAddEventHandler ["LBSelChanged","with uinamespace do {['sexLBchanged',_this,''] call RscDisplayNewSurvivor_script};"];
		DZ_selectedSex = 0;
		_sexCtrl ctrlCommit 0;
				
		_idc = 1420;
		_skinCtrl = _display displayCtrl _idc;	
		_skinCtrl lbAdd "Dark";
		_skinCtrl lbAdd "Medium";
		_skinCtrl lbAdd "Light";
		_skinCtrl lbSetCurSel 0;
		_skinCtrl ctrlAddEventHandler ["LBSelChanged","with uinamespace do {['skinLBchanged',_this,''] call RscDisplayNewSurvivor_script};"];
		DZ_selectedSkin = 0;
		_skinCtrl ctrlCommit 0;

		_idc = 1430;
		_faceCtrl = _display displayCtrl _idc;	
		_faceCtrl lbAdd "Oval";
		_faceCtrl lbAdd "Round";
		_faceCtrl lbAdd "Square";
		_faceCtrl lbAdd "Rectangle";
		_faceCtrl lbAdd "Triangle";
		_faceCtrl lbAdd "Diamond";	
		_faceCtrl lbSetCurSel 0;
		_faceCtrl ctrlAddEventHandler ["LBSelChanged","with uinamespace do {['faceLBchanged',_this,''] call RscDisplayNewSurvivor_script};"];
		DZ_selectedFace = 0;
		_faceCtrl ctrlCommit 0;
		
		if (DZ_selectedSex == 0) then 
		{	
			DZ_survivorBody = _females select DZ_selectedSkin;
		}
		else 
		{
			DZ_survivorBody = _males select DZ_selectedSkin;
		};
	};
	case "onUnload": {
	
	};
	case "sexLBchanged": {	
		//hint str(_this); //debug
		DZ_newlySelectedSex = (_this select 1) select 1;
		if (DZ_newlySelectedSex != DZ_selectedSex) then
		{
			deleteVehicle DZ_newSurvivor;
			DZ_selectedSex = DZ_newlySelectedSex;
			if (DZ_selectedSex == 0) then 
			{
				DZ_survivorBody = _females select DZ_selectedSkin;
			}
			else 
			{
				DZ_survivorBody = _males select DZ_selectedSkin;
			};
			demoUnit = DZ_survivorBody createVehicleLocal demoPos;
			demoUnit setPos demoPos;
			demoUnit setDir demoDir;
		};
	};
	case "skinLBchanged": {
		//hint str(_this); //debug
		DZ_newlySelectedSkin = (_this select 1) select 1;
		if (DZ_newlySelectedSkin != DZ_selectedSkin) then
		{
			deleteVehicle DZ_newSurvivor;
			DZ_selectedSkin = DZ_newlySelectedSkin;
			if (DZ_selectedSex == 0) then 
			{
				DZ_survivorBody = _females select DZ_selectedSkin;
			}
			else 
			{
				DZ_survivorBody = _males select DZ_selectedSkin;
			};
			demoUnit = DZ_survivorBody createVehicleLocal demoPos;
			demoUnit setPos demoPos;
			demoUnit setDir demoDir;
		};
	};
	case "faceLBchanged": {
		//hint str(_this); //debug
		DZ_newlySelectedFace = (_this select 1) select 1;
	};
};