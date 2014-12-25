Private ["_n","_nearbyHeliEmpty","_aliveNearbyHeliEmpty","_vehiclePlayer","_nearestHeliEmpty","_warningRange","_deathRange"];

_n = 0;
_warningRange = 20;
_deathRange = 7;
_classnameProtected = "Wooden_shed_DZ";

While {True} Do 
{
	_nearbyProtected = [];	
	_aliveNearbyProtected = [];	
	_nearestProtected = "";	
	_vehiclePlayer = (Vehicle Player);	
	
	_nearbyProtected = nearestObjects [_vehiclePlayer, [_classnameProtected], _warningRange];

	if ((count _nearbyProtected) >= 1) then {
		{
			if (alive _x) then { 
				_aliveNearbyProtected set [(count _aliveNearbyProtected),_x]; 
			}; 
		}count _nearbyProtected;
		if ((count _aliveNearbyProtected) >= 1) then{
			_nearestProtected = _aliveNearbyProtected select 0;
			If ((_vehiclePlayer Distance _nearestProtected) < _deathRange) Then {Player Setdamage 1;};
			If ((_n == 0) && {_vehiclePlayer Distance _nearestProtected  >= _deathRange}) Then {
				TitleText ["[WARNING]: Entering restricted area.  Continuing will result in death.","PLAIN"];
			};
			_n = _n + 0.05;
		};
	};
	Sleep 0.05;
	If ( _n > 1 ) Then {
		_n = 0;
	};
};
