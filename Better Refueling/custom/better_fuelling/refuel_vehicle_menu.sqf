private ["_findNearestVehicles","_vehicleSrc","_DestVehicle","_destFuelAmount","_DestArrayData","_AllFull","_colour","_nameText","_string","_handle","_findNearestCount","_configSrcVeh","_vehicleSrcName","_destFuelPercent"];

diag_log text "=====================================================";
diag_log text "refuel_vehicle_menu: Start";

// Set basic variable starting values
_vehicleSrc = (_this select 3) select 0;
_configSrcVeh = configFile >> "cfgVehicles" >> TypeOf(_vehicleSrc);
_vehicleSrcName = getText(_configSrcVeh >> "displayName");

s_player_refuelSub_crtl = 1;

if ((_this select 3) select 1) then {
	cursorTarget removeAction s_player_refuelTop_crtl;
};

_handle = RefuelCursorTarget addAction [format["<t color='#FFCC99'>%1</t>","Refuelling Menu"], "",[], 0.36, false, true, "",""];
s_player_refuelActionsSub set [count s_player_refuelActionsSub,_handle];


diag_log format["Refuel_Vehicle_menu _vehicleSrc: %1", _vehicleSrc];

// Get all nearby vehicles within 30m

_findNearestVehicles = 	_vehicleSrc	nearEntities ["AllVehicles", DZE_RefuelRange];

// Count only nearest vehicles excluding source (refuelling) vehicle
_findNearestCount = 0;
{
	diag_log format ["Refuel_Vehicle_menu [Source Vehicle = %1]    [Destination vehicle = %2] ", str(_vehicleSrc), str(_x)];
	if (alive _x) then {
		diag_log text "refuel_vehicle_menu: Is alive.";
		if (!(_x isKindOf "CAManBase")) then {
			diag_log text "refuel_vehicle_menu: Not a player.";
			if (!(_x == _vehicleSrc)) then {
				diag_log text "refuel_vehicle_menu: Not the source vehicle.";

				// Get vehicle fuel state		
				_destFuelAmount = (fuel _x);	
		
				diag_log format ["Refuel_Vehicle_menu [Destination Vehicle fuel amount = %1]", _destFuelAmount];
		
				if (_destFuelAmount < 1) then {
					_AllFull = false;
			
					// Read vehicle base fuel information
					_DestVehicle = _x;
					_vehicleName = typeof _DestVehicle;
					
					if (_destFuelAmount > 0.994) then{
						_destFuelPercent = floor((_destFuelAmount)*100);
					}else{
						if (_destFuelAmount < 0.006) then{
							_destFuelPercent = ceil((_destFuelAmount)*100);
						}else{
							_destFuelPercent = round((_destFuelAmount)*100);
						};
					};
					
					diag_log format["Refuel_Vehicle_menu Destination fuel amount = %1 rounding to %2%",_destFuelAmount,_destFuelPercent]; 
					
					_colour = "color='#00C3FF'"; //Blue
					if (_destFuelAmount <= 0.8) then {_colour = "color='#ffff00'";}; //yellow
					if (_destFuelAmount <= 0.6) then {_colour = "color='#ff8800'";}; //orange
					if (_destFuelAmount <= 0.2) then {_colour = "color='#ff0000'";}; //red

					_string = format["<t %2> - Refuel %1 (%3 %4)</t>",_vehicleName,_colour,_destFuelPercent,"%"]; 
					_handle = _vehicleSrc addAction [_string, "custom\better_fuelling\Refuel_Vehicle.sqf",[_vehicleSrc,_DestVehicle], 0.35, false, true, "",""];
					s_player_refuelActionsSub set [count s_player_refuelActionsSub,_handle];
			
					// Add to counter.
					_findNearestCount = _findNearestCount + 1;
					diag_log format["Refuel_Vehicle_menu Refuel %1 (%2 %3) - %4",_vehicleName,_destFuelPercent,"%",_DestVehicle]; 	
				}else{
					if (_findNearestCount < 1) then{
						_AllFull = true;
					};
				};
			};
		};
	};
} count _findNearestVehicles;

if (_AllFull) then{
	// error, no vehicles in range need fuel
	cutText [format["No vehicles in range of %1 that need fuel.", _vehicleSrcName], "PLAIN DOWN"]; 
	_dummy = ["","","",[_vehicleSrc,true]] call RB_refuelSubMenuCancel;
	s_player_refuelTop_crtl = -1;	
}else{
	s_player_refuelSub_crtl = 1;
	_cancel = _vehicleSrc addAction [format["<t color='#FFCC99'>%1</t>","Cancel Refuelling"], "custom\better_fuelling\refuel_cancel.sqf",[_vehicleSrc,true], 0.34, true, false, "",""];
	s_player_refuelActionsSub set [count s_player_refuelActionsSub,_cancel];
};

diag_log text "refuel_vehicle_menu: Exit";
