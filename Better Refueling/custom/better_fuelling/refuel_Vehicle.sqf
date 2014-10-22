private ["_vehicle","_newFuel","_started","_finished","_animState","_isMedic","_abort","_canSize","_configVeh","_capacity","_nameText","_findNearestVehicles","_findNearestVehicle","_IsNearVehicle","_isVehicle","_configSrcVeh","_capacitySrc","_nameTextSrc","_moreToFill","_curFuelamountsrc","_newFuelSrc","_vehicleSrc","_newFuelamountsrc","_pumpspeed_fixed","_pumpspeed_truck","_fuelCapArray","_Realfuelcapvehicles","_Realfuelcapacity","_floodfill","_vehicleName","_vehicleSrcName","_destFuelAmount","_destFuelNeeded","_srcfuelAmountCheck","_pumpspeed_flood","_DestArrayData","_AllFull","_colour","_dummy","_percent"];

if(DZE_ActionInProgress) exitWith { cutText [(localize "str_epoch_player_24") , "PLAIN DOWN"] };
DZE_ActionInProgress = true;

// Set basic variable starting values
_isVehicle = false; 
_abort = false;
_moreToFill = true;
_isFillok = true;

// Source Vehicle
_vehicleSrc = (_this select 3) select 0;

// Destination Vehicle
_vehicle = (_this select 3) select 1;
	
_cansize = 0;

diag_log format["Refuel_Vehicle Source Vehicle: %1", _vehicleSrc];
diag_log format["Refuel_Vehicle Destination Vehicle: %1", _vehicle];

// Fuel truck pump speed
_pumpspeed_truck = DZE_RB_pumpspeed_truck;

// Fixed pump speed 
_pumpspeed_fixed = DZE_RB_pumpspeed_fixed;

// Flood Fill pump speed.
_pumpspeed_flood = DZE_RB_pumpspeed_flood;

// Realistic fuel capacity values.
_Realfuelcapvehicles = DZE_RB_FuelCapArray select 0;
_Realfuelcapacity = DZE_RB_FuelCapArray select 1;

// Read vehicle base fuel information
_configVeh = configFile >> "cfgVehicles" >> TypeOf(_vehicle);
_vehicleName = typeof _vehicle;
_nameText = getText(_configVeh >> "displayName");
	
// Override vehicle fuel capacity figures check here.
If (_vehicleName in _Realfuelcapvehicles) then {
	// Find vehicle position
	_fc_position = _Realfuelcapvehicles find _vehicleName;
	//Read capacity figure from capnumber array
	_capacity = _Realfuelcapacity select _fc_position;
	diag_log text "Refuel_Vehicle real capacities being used.";
}else{
	_capacity = 	getNumber(_configVeh >> "fuelCapacity");
};
	
diag_log format["Refuel_Vehicle [Name: %1] [Class: %2] [Capacity: %3]", _nameText, _vehicleName, _capacity];

// Work out source vehicle details.
if (str(_vehicleSrc) == "FuelPumpArray") then{
	_capacitySrc = 	1000000;
	_nameTextSrc = str("Fuel Pump");
	_configSrcVeh = str("FuelPump_DZ");	
	_srcfuelleft = 1;
}else{
	_isVehicle = ((_vehicleSrc isKindOf "AllVehicles") and !(_vehicleSrc isKindOf "Man"));

	// If fuel source is vehicle get actual capacity
	_configSrcVeh = configFile >> "cfgVehicles" >> TypeOf(_vehicleSrc);
	_vehicleSrcName = typeof _vehicleSrc;
	_capacitySrc = 	getNumber(_configSrcVeh >> "fuelCapacity");
	_nameTextSrc = 	getText(_configSrcVeh >> "displayName");
};

// Work out refuel per cycle size.
if (!(_vehicleSrcName in DZE_fueltruckarray)) then{
	diag_log format["Refuel_Vehicle Source in fuel pump array: %1", _vehicleSrcName];
	diag_log text "Refuel_Vehicle source vehicle not flood fill capable";
	_canSize = DZE_RB_pumpspeed_fixed;
} else {
	diag_log format["Refuel_Vehicle source vehicle can flood fill: %1", _vehiclesrcName];
	if (DZE_RB_AllowFloodRefuel) then{
		diag_log text "Refuel_Vehicle flood fill variable true";
		if (_vehicleName in DZE_RB_floodfill) then{
			diag_log format["Refuel_Vehicle Destination vehicle can flood fill: %1", _vehicleName];
			_cansize = DZE_RB_pumpspeed_flood;
			_canflood = true;
		}else{
			diag_log format["Refuel_Vehicle Destination vehicle cannot flood fill: %1", _vehicleName];
			_canSize = DZE_RB_pumpspeed_truck;
		};
	}else{	
		diag_log text "Refuel_Vehicle flood fill variable false";
		_canSize = DZE_RB_pumpspeed_truck;
	};
};

diag_log format["Refuel_Vehicle Source [Name: %1] [Class: %2] [Capacity: %3]", _nameTextSrc, _vehicleSrcName, _capacitySrc];
diag_log format["Refuel_Vehicle Destination [Name: %1] [Class: %2] [Capacity: %3]", _nameText, _vehicleName, _capacity];
diag_log format["Refuel_Vehicle [_cansize: %1]", _cansize];

// perform fuel up
while {_moreToFill} do {

	diag_log text "Calculate source fuel";
		
	// add checks for fuel level
	if (str(_configSrcVeh) == "FuelPump_DZ") then{
		diag_log text "Refuel_Vehicle Source is FuelPump_DZ.  Capacity is static 1000000";
		_curFuelamountsrc = 1000000;
	}else{
					
		// Find current capacity (full = 1)
		_curFuelamountsrc = ((fuel _vehicleSrc) * _capacitySrc);
		diag_log format["Refuel_Vehicle [_curFuelamountsrc: %1]", _curFuelamountsrc];
	};
		
	// Resets cansize if there is not enough fuel to fill a whole can.	
	if (_cansize > _curFuelamountsrc) then {
		diag_log format["Refuel_Vehicle [_curFuelamountsrc: %1]", _curFuelamountsrc];
		_cansize = _curFuelamountsrc;
	};
	
	//checks if the cansize is empty (i.e. no fuel left in source vehicle to refuel with).
	if (_cansize <= 0 ) then {
		cutText [format["Refuel_Vehicle Not enough fuel left in %1.",_nameTextSrc], "PLAIN DOWN"]; 
		_moreToFill = false;
		_abort = true;
	};	
		
	// Check Add fuel to destination
	if (_moreToFill) then {
			
		// Get vehicle fuel levels.
		_destFuelAmount = ((fuel _vehicle) * _capacity);
		diag_log format["Refuel_Vehicle [_destFuelAmount: %1]", _destFuelAmount];
		_destFuelNeeded = (_capacity - _destFuelAmount);
		diag_log format["Refuel_Vehicle [_destFuelNeeded: %1]", _destFuelNeeded];
		
		// Resets cansize if a whole can is not required.	
		If (_destFuelNeeded < _cansize) then{
			diag_log text "Refuel_Vehicle Cansize less than fuel needed.";
			_cansize = _destFuelNeeded;
		};
				
		// If the cansize is positive then calculate the new fuel level for the destination vehicle.	
		If (_cansize > 0)then {
 
			// subtract 1 round of fuel from src and calculate new.
			_newFuelsrc = ((1 / _capacitySrc)*(_curFuelamountsrc - _canSize));

			diag_log format["Refuel_Vehicle Source [Fuel Left: %1] [Capacity: %2] [Current fuel capacity: %3] [New fuel Left: %4] ", _curFuelamountsrc, _capacitySrc, (_capacitySrc * _newFuelsrc), _newFuelsrc];
				
			// Recalculate the destination fuel amount after adding 1 cansize.
			_newFuel = ((1/_capacity)*(_destFuelAmount + _canSize));
				
			diag_log format["Refuel_Vehicle Destination [Fuel Left: %1] [Needed: %2] [Current fuel capacity: %3] [New fuel capacity: %4]", _destFuelAmount, _destFuelNeeded, (_capacity * _newFuel), _newFuel];
		}else{
			diag_log text "Refuel_Vehicle No more fuel needed.";
			cutText [format["No more fuel needed in %1",_nameText], "PLAIN DOWN"]; 
			_moreToFill = false;
			_abort = true;
		};
	};
		
	if !(_abort) then{
		// "Filling up %1, move to cancel."
		cutText [format[(localize "str_epoch_player_131"),_nameText], "PLAIN DOWN"]; 
	
		// alert zombies
		[player,20,true,(getPosATL player)] spawn player_alertZombies;

		// use drink / food for action
		[1,1] call dayz_HungerThirst;

		diag_log text "Refuel_Vehicle Play sound";

		// Play sound
		[player,"refuel",0,false] call dayz_zombieSpeak;

		diag_log text "Refuel_Vehicle Play action";
			
		// force animation 
		player playActionNow "Medic";

		// Set loop variables
		r_interrupt = false;
		r_doLoop = true;
		_started = false;
		_finished = false;

		// Start fill loop
		while {r_doLoop} do {

			diag_log text "Refuel_Vehicle Animation check loop";

			// check animation state is still medic
			_animState = animationState player;
			_isMedic = ["medic",_animState] call fnc_inString;
			if (_isMedic) then {
				_started = true;
			};

			// Check if started and medic animation is finished.
			if (_started and !_isMedic) then {
				r_doLoop = false;
				_finished = true;
			};
			
			// Check for interruption to fill process.
			if (r_interrupt) then {
				r_doLoop = false;
				_finished = false;
			};
			sleep 0.5;
		};
		
		diag_log text "Refuel_Vehicle Out of anim loop";
	
		// Medic animation complete.

		// Check for interrupt
		if (!_finished) then {
			r_interrupt = false;
		
			// Cancel animation
			if (vehicle player == player) then {
				[objNull, player, rSwitchMove,""] call RE;
				player playActionNow "stop";
			};

			// set abort fill variable
			_abort = true;
			_moreToFill = false;
		};

		// Continue if no interrupt. 
		if (_finished) then {
			diag_log text "Refuel_Vehicle Post animation checks for fuel level and save if passed.";

			// Post animation checks for fuel level and save if passed.
			if (str(_configSrcVeh) == "FuelPump_DZ") then{
				diag_log text "Refuel_Vehicle Source is FuelPump_DZ.  Capacity is static 1000000";
				_srcfuelAmountCheck = 1000000;
			}else{
				_srcfuelAmountCheck = ((fuel _vehicleSrc) * _capacitySrc);
			};
				
			_destFuelAmountCheck = ((fuel _vehicle) * _capacity);
							
			diag_log format["Refuel_Vehicle Source [_curFuelamountsrc: %1] [_srcfuelAmountCheck: %2] [_destFuelAmount: %3] [_destFuelAmountCheck: %4] ", _curFuelamountsrc, _srcfuelAmountCheck, _destFuelAmount, _destFuelAmountCheck];
			
			//	Verify the fuel states have not change on source and destination vehicles.		
			if ((_curFuelamountsrc == _srcfuelAmountCheck) and (_destFuelAmount == _destFuelAmountCheck)) then{
				diag_log format["Refuel_Vehicle Source [Capacity: %1] [Current fuel capacity: %2] [New fuel capacity: %3] ",  _capacitySrc, _curFuelamountsrc , _newFuelSrc];

				diag_log format["Refuel_Vehicle Destination [Capacity: %1] [Current fuel capacity: %2] [New fuel capacity: %3] ",  _capacity, _destFuelAmount  , _destFuelNeeded ];

				// Save fuel to worldspace.
				if (str(_configSrcVeh) == "FuelPump_DZ") then{
					diag_log text "Refuel_Vehicle save fuel pump";
					// Only save destination for fuel pumps.
					if (local _vehicle) then {
						diag_log text "Refuel_Vehicle local save";
						[_vehicle,_newFuel] call local_setFuel;
					} else {
						diag_log text "Refuel_Vehicle remote save";
						// PVS/PVC - Skaronator 
						PVDZE_send = [_vehicle,"SFuel",[_vehicle,_newFuel]];
						publicVariableServer "PVDZE_send";
					};
				}else{
					// Save source and destination for other fuel sources.
					diag_log text "Refuel_Vehicle save fuel vehicle";
					if (local _vehicle) then {
						diag_log text "Refuel_Vehicle local save";
						[_vehicleSrc,_newFuelSrc] call local_setFuel;
						[_vehicle,_newFuel] call local_setFuel;
					} else {
						diag_log text "Refuel_Vehicle remote save";
						// PVS/PVC - Skaronator //
						PVDZE_send = [_vehicleSrc,"SFuel",[_vehicleSrc,_newFuelSrc]];
						publicVariableServer "PVDZE_send";
				
						PVDZE_send = [_vehicle,"SFuel",[_vehicle,_newFuel]];
						publicVariableServer "PVDZE_send";
					};
				};

				if (_newFuel > 0.994) then{
					if (_newFuel < 1) then{
						diag_log text "Refuel_Vehicle_menu Destination fuel amount = 0.994 = 100% with rounding.  Adjusting to 99%"; 
						_percent = 99;
					else
						diag_log text "Refuel_Vehicle_menu Destination fuel amount = 1 (full)"; 
						_percent = 100;
					};
				}else{
					_percent = round((_newFuel)*100);
				};
				
				cutText [format[(localize "str_epoch_player_132"),_nameText,_percent], "PLAIN DOWN"];
			} else {
				
				// Abort on error.
				cutText ["Fuel quantity changed in source or destination.  Aborting.", "PLAIN DOWN"];
					
				_moreToFill = false;
				_abort = true;
			};
		};
		if(_abort) exitWith {};
		sleep 1;
	};
};

// Save source vehicle fuel to Hive
diag_log text "Refuel_Vehicle Saving Source vehicle data.";
PVDZE_veh_Update = [_vehicleSrc,"all"];
publicVariableServer "PVDZE_veh_Update";

// Save destination vehicle fuel to Hive
diag_log text "Refuel_Vehicle Saving Destination vehicle data.";
PVDZE_veh_Update = [_vehicle,"all"];
publicVariableServer "PVDZE_veh_Update";

// Reset menus
diag_log text "refuel_Vehicle: Calling refuel_cancel.sqf";
_dummy = ["","","",[_vehicleSrc,false]] call RB_refuelSubMenuCancel;
_dummy = ["","","",[_vehicleSrc,false]] call RB_refuelmenu;

DZE_ActionInProgress = false;

diag_log text "refuel_Vehicle: Exit";