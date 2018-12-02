setTimeForScripts 90;

call compile preprocessFileLineNumbers "\dz\\modulesDayZ\init.sqf";
call compile preprocessFileLineNumbers "\dz\\server\cfg\CfgLootSpawns\config.cpp";
//player
//call compile preprocessFileLineNumbers "\dz\\server\scripts\functions\fn_generateSpawnpoints.sqf";
//call fn_generateSpawnpoints;

DZ_MP_CONNECT = true;
DZ_MAX_ZOMBIES = 1000;
DZ_MAX_ANIMALS = 200;
dbSelectHost "http://localhost:9661/";

call dbLoadPlayer;

_humidity = random 1;
//setDate getSystemTime;
setDate [2016, 8, 8, 8, 0];
1 setOvercast 0;
1 setRain 1;
simulWeatherSync;
//setAccTime 60;
//skipTime 10.5;


//exportProxies [_position, 200000];
//call init_spawnZombies;

//testing the 2 spawns below
//call init_spawnWildAnimals;
//call init_spawnServerEvent;

sleep 1;
//importProxies;	
//spawnLoot [_position,15000,25000];

dbInitServer;

setTimeForScripts 0.03;
//todo proper car spawns
script = [] execVM "spawn.sqf"
