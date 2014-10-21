private ["_sourceVehicle"];

_sourceVehicle = (_this select 3) select 0;
diag_log format ["refuel_Cancel: Source Vehicle: %1", _sourceVehicle];

{_sourceVehicle removeAction _x} count s_player_refuelActionsSub ;s_player_refuelActionsSub  = [];
s_player_refuelSub_crtl  = -1;

if (((_this select 3) select 1)) then{
	s_player_refuelTop_crtl = -1;
};

diag_log text "refuel_Cancel: Exit";