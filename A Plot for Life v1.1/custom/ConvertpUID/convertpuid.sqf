scriptName "custom\ConvertpUID\convertpuid.sqf";

private["_number_string","_string_array","_result","_num", "_playertemp"];   // Setup the local variables 

_playertemp = _this select 0;  // Grab the first parameter sent to the function.
_number_string = getPlayerUID _playertemp; 
_string_array = toArray _number_string;  // Convert the PlayerUID string to a numberic unicode array.
_result = ""; 

for "_i" from 0 to ((count _string_array) - 1) step 1 do { // Step backwards through the array.
	_num = ((_string_array select _i) - 48); // Subtract 48 (HEX 30) from the unicode value in the element.

	if (_num > 9) then { // If the result is greater than 9 then change it to 9
		_num = 9;
	};

  _result = _result + str(_num); // convert the number to a string and concatenate it to the result.
};
_result // Return the result.