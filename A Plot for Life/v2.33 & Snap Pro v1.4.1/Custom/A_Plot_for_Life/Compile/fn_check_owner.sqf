// Check Ownership by RimBlock (http://epochmod.com/forum/index.php?/user/12612-rimblock/)

private ["_player","_object","_playerUID","_ownerUID","_ObjectOwner","_owner","_friendlies","_friendly","_return"];

_player = _this select 0;
_Object = _this select 1;
_Owner = false;
_friendly = false;

_playerUID = [player] call FNC_GetPlayerUID;

if (DZE_APlotforLife) then {
	_ownerUID = _playerUID;
}else{
	_ownerUID = dayz_characterID;
};

_ObjectOwner = _object getVariable ["ownerPUID","0"];

if (_ownerUID == _ObjectOwner) then {
	_owner = true;
};

_friendlies	= player getVariable ["friendlyTo",[]];

if (_ownerUID in _friendlies) then {
	_friendly = true;
};

_return = [_owner, _friendly];

_return
