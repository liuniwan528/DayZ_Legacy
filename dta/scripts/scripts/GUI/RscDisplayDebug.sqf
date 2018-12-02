#define CONTROL	(_display displayctrl _idc)

_mode = _this select 0;
_params = _this select 1;
_class = _this select 2;

switch _mode do {

	case "onLoad": {

		disableserialization;
		_display = _params select 0;

		//--- Mission ID
		_idc = 1009;
		CONTROL ctrlsettext (missionname + "." + worldname);

		//--- Mission author (for bug reporting)
		_author = gettext (missionconfigfile >> "author");
		if (_author != "") then {_author = "Author: " + _author};
		_idc = 1010;
		CONTROL ctrlsettext _author;

		//--- Game version (copied from main menu display)
		_idc = 1411;
		CONTROL ctrlsettext ctrltext ((finddisplay 0) displayctrl 118);

		//--- Player
		if (!isnull player) then {
			_idc = 1410;
			CONTROL ctrlsettext str position vehicle player;
		};

		//--- Simulation is not running
		if (isnull ([] call (uinamespace getvariable "BIS_fnc_displayMission"))) then {
			{
				_idc = _x;
				CONTROL ctrlenable false;
			} foreach [
				1705,
				1706,
				1709,
				//1710,
				//1719,
				1720
			];
		};

		//--- Mission HTML
		_idc = 1007;
		CONTROL htmlload "design.html";

		//--- Delete log
		_idc = 103;
		CONTROL ctrladdeventhandler ["LBDblClick","ctrlactivate ((ctrlparent (_this select 0)) displayctrl 151)"];

		//--- Diag functions
		_addList = {
			if (typename _x == typename []) then {
				_add = CONTROL lbadd (_x select 0);
				CONTROL lbsetdata [_add,(_x select 1)];
			} else {
				_add = CONTROL lbadd _x;
				if (_idc == 1501) then {
					CONTROL lbsetdata [_add,format ["diag_toggle '%1'",_x]];
				} else {
					CONTROL lbsetdata [_add,format ["diag_drawmode '%1'",_x]];
				};
			};
		};
		_addButton = "
			_display = ctrlparent (_this select 0);
			_list = _display displayctrl %1;
			_data = _list lbdata lbcursel _list;
			call compile _data;
		";

		//--- Diag lists
		_idc = 1501;
		_addList foreach [
			["<None>","'all' diag_enable false"],
			"Ambient",
			"AmbLife",
			"Animation",
			"AnimSrcTarget",
			"AnimSrcUnit",
			"AutoAction",
			"BBox",
			"BBTree",
			"Buoyancy",
			"Cars",
			"Collision",
			"Combat",
			"ContactJoints",
			"CostMap",
			"Damage",
			"DamageSimulator",
			"EAX",
			"Effects",
			"Fatigue",
			"Force",
			"FSM",
			"HDR",
			"Head",
			"Hitpoints",
			"ID",
			"Impact",
			"Impulse",
			"Keyboard",
			"Light",
			"LockMap",
			"LogAnimPaths",
			"ManCollision",
			"MapScale",
			"MatLOD",
			"Mines",
			"Model",
			"MouseSensitivity",
			"MoveForces",
			"Navmesh",
			"NMPathAgent",
			"NewAIRaycast",
			"VisualizeBones",
			"Network",
			"ObjNames",
			"ParticleNames",
			"Particles",
			"Path",
			"PermanentJoints",
			"Phys",
			"PP",
			"ProtocolExpressions",
			"Prune",
			"Radius",
			"RagDollMP",
			"Resource",
			"Roads",
			"Rumble",
			"Shots",
			"Sound",
			"SoundControllers",
			"SoundMap",
			"Speed",
			"Streaming",
			"Surface",
			"Suspension",
			"Transparent",
			"UIControls",
			"Updates",
			"WaterSplash",
			"Waypoints",
			"Wind",
			"WingVortices",
			"Zombie"
		];
		lbsort CONTROL;
		CONTROL lbsetcursel (profilenamespace getvariable ["RscDisplayDebug_listDiag_lbCurSel",0]);
		CONTROL ctrladdeventhandler ["LBDblClick",format [_addButton,1501]];
		
		_idc = 1502;
		_addList foreach [
			["<Normal>","diag_drawmode 'Normal'"],
			"Roadway",
			"Geometry",
			"ViewGeometry",
			"FireGeometry",
			"Paths",
			"ShadowVolume",
			"ShadowBuffer"
		];
		lbsort CONTROL;
		CONTROL lbsetcursel (profilenamespace getvariable ["RscDisplayDebug_listDraw_lbCurSel",0]);
		CONTROL ctrladdeventhandler ["LBDblClick",format [_addButton,1502]];

		//--- Diag buttons
		_idc = 1703;
		CONTROL ctrladdeventhandler ["buttondown",format [_addButton,1501]];
		_idc = 1704;
		CONTROL ctrladdeventhandler ["buttondown",format [_addButton,1502]];

		_idc = 1710;
		CONTROL ctrladdeventhandler [
			"mousebuttondown",
			"
				_ctrl = _this select 5;
				if (_ctrl) then {
					1 call (uinamespace getvariable 'bis_fnc_recompile');
				};
			"
		];
	};


	case "onUnload": {
		_idc = 1501;
		profilenamespace setvariable ["RscDisplayDebug_listDiag_lbCurSel",lbcursel CONTROL];
		_idc = 1502;
		profilenamespace setvariable ["RscDisplayDebug_listDraw_lbCurSel",lbcursel CONTROL];
		saveprofilenamespace;
	};

	default {};
};