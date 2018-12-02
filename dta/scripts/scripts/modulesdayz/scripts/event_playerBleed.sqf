private["_agent","_source","_effects"];
_agent = _this;
_coords = call compile (_agent getVariable ["bleedingsources","[]"]);

if (isServer) then {
	_agent setVariable ["bleedingLevel",(count _coords)];
};
if (isDedicated) exitWith {};

_effects = _agent getVariable ["bleedingEffects",[]];
_toDo = (count _coords) - (count _effects);

//diag_log format["CLIENT DAMAGE: %1 has %2 coords and %3 effects",_agent,(count _coords),(count _effects)];
//statusChat [format["Client Damage! %1 todo (_coords %3, _effects %4)",_toDo,_agent,(count _coords),(count _effects)],"colorImportant"];

if (_toDo > 0) then
{
	_end = ((count _coords) - 1);
	_start = (count _effects);
	//statusChat [format["Creating Bleeding from _coord %1 to %2",_start,_end],""];
	for "_i" from _start to _end do {		
		private["_thisCoord"];
		_thisCoord = _coords select _i;
		_source = "#particlesource" createVehicleLocal getPosATL _agent;
		_source setParticleParams
		/*Sprite*/		[["\dz\data\data\ParticleEffects\Universal\Universal", 16, 13, 1],"",// File,Ntieth,Index,Count,Loop(Bool)
		/*Type*/			"Billboard",
		/*TimmerPer*/		1,
		/*Lifetime*/		0.7,
		/*Position*/		[0,0,0],
		/*MoveVelocity*/	[0,0,0.6],
		/*Simulation*/		0,0.1,0.05,0.05,//rotationVel,weight,volume,rubbing
		/*Scale*/			[0.03,0.05,0.13,0.11,0.085,0.06,0.05],
		/*Color*/			[[1,0.01,0.01,0.5],[1,0.01,0.01,1],[0.7,0.01,0.01,0.9],[0.7,0.01,0.01,0.9],[0.7,0.01,0.01,0.8],[0.3,0.01,0.01,0]],
		/*AnimSpeed*/		[0],
		/*randDirPeriod*/	0,
		/*randDirIntesity*/	0,
		/*onTimerScript*/	"",
		/*DestroyScript*/	"",
		/*Follow*/			[_agent, _thisCoord]];
		//[lifeTime, position, moveVelocity, rotationVelocity, size, color, randomDirectionPeriod, randomDirectionIntensity, {angle}, bounceOnSurface]
		_source setParticleRandom [0, [0, 0, 0], [0.0, 0.0, 0.0], 0, 0, [0, 0, 0, 0], 0, 0, 0];
		_source setDropInterval 0.3;		
		
		//save to array on player for removal later
		_effects set [count _effects,_source];
	};
	_agent setVariable ["bleedingEffects",_effects];
}
else
{
	if ((count _coords) == 0) then
	{
		{
			deleteVehicle _x;
		} forEach _effects;
		_agent setVariable ["bleedingEffects",[]];
	};
};