
Private ["_monsterskin","_unitpos","_aiGroup","_aiunit"];

_monsterskin = "SurvivorWcombat_DZ";
_unitpos = [9267.12,13442.8,0.001];
_aiunit = nullobject;

_aiGroup = createGroup east;

_monsterskin createUnit [_unitpos, _aiGroup, "_aiunit=this;"];
uisleep 0.01; // give a slight pause for the init code to run.
_nil = [_aiunit] execVM "custom\test\monsterAOI.sqf";
