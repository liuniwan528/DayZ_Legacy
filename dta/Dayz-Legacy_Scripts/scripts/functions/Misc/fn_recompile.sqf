//scriptName "Functions\misc\fn_recompile.sqf";
/*
	File: fn_recompile.sqf
	Author: Karel Moricky

	Description:
	Recompiles all functions
*/
private ["_functionsInit"];
_functionsInit = gettext (configfile >> "CfgFunctions" >> "init");
if (_functionsInit != "") then {
	_this call compile preprocessfilelinenumbers _functionsInit;
	true
} else {
	debuglog ["Log: ERROR: Functions Init not found!"];
	false
};