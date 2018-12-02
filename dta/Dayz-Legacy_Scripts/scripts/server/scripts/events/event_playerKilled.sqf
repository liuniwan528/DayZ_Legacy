private["_agent","_uid"];
_agent = _this select 0;
_killer = _this select 1;
_uid = getClientUID (owner _agent);

_agent setVariable ["bleedingsources","[]"];
_agent setVariable ["timeOfDeath",diag_tickTime];

if (_uid == "") exitWith
{
	diag_log format["Disconnected player %1 was killed by %2",typeOf _agent, name _killer];
};

diag_log format["Player %1 was killed by %2 at %3",name _agent, name _killer,diag_tickTime];

if (DZ_MP_CONNECT) then
{
	_agent call dbSavePlayerPrep;
	dbServerSaveCharacter _agent;
	dbKillCharacter _uid;
};
