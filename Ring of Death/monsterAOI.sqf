Private ["_monster","_nearbyunits","_aliveNearbyPlayer","_playerUnit","_warningRange","_deathRange","_light","_colourGreen"];

waitUntil{initialized};

_warningRange = 15;
_deathRange = 5;
_monster = _this select 0;

_Light = "Sign_sphere100cm_EP1" createVehicle (position _monster);
_light attachto [_monster, [0,0,1]];
_Light setobjecttexture [0,"#(argb,8,8,3)color(0,0.6,0.1,1)"];

While {True} Do
{
    _nearbyunits = playableunits;    
    _aliveNearbyPlayer = [];    
    _playerUnit = "";
	
    {
        if (isplayer _x) then {
            _aliveNearbyPlayer set [(count _aliveNearbyPlayer),_x];
        };     
    }count _nearbyunits;

    if ((count _aliveNearbyPlayer) >= 1) then{
        {
            _playerUnit = vehicle (_aliveNearbyPlayer select 0);
			_playerDistance = _playerUnit Distance _monster;
            If (_playerDistance < _deathRange) Then {_light attachto [_monster, [0,0,3]];}; 
            If ((_playerDistance  >= _deathRange) && (_playerDistance  < _warningRange)) Then {_light attachto [_monster, [0,0,2]];};
			if (_playerDistance > _warningRange) Then {_light attachto [_monster, [0,0,1]];}; 
        }count _aliveNearbyPlayer;
    };
    UISleep 0.05;
};
