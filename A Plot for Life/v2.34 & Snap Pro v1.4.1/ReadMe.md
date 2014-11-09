# A Plot for Life
by Rimblock<br>
[@ EpochMod.com](http://epochmod.com/forum/index.php?/user/12612-rimblock/)<br>
[On GitHub](https://github.com/RimBlock)

If this mod was not downloaded from my GitHub or my thread on EpochMod.com then please let me know by PMing me on Epoch Mod.

#Overview

A Plot for Life allows you to keep your ownership of you plot poles and items you have built after your character dies.  This means you no longer have to get the money needed for a new plot pole after death and replace your old plot pole with a new one in order to get building rights on your base again.

Features include
* When you die, your old building rights carry over to your new character.
* The whole system is switchable between the original characterID and the new PlayerUID systems by setting a variable.
* All items built after the mod is installed with have the PlayerUID and the characterID stored for ownership checking (locked buildables will only have the PlayerUID stored as the characterID field is used for the lock code).
* Includes the Epoch 1.0.6 code to allow either SteamID or BIS PUID (written by [icomrade](https://github.com/icomrade)).
* You can turn on the plot boundary from the plot pole and remove it.  Currently I am using the road cones with lights on top which are also visible at night.  They can be changed.
* Take Ownership is available from the plot pole to the plot poles owner and allows them to take ownership of all buildables in range excluding locked storage (safes / lockboxes), tents, locked doors.  THis allows old bases to be aligned to this system for ownership.  It can be turned on and off via a init.sqf variable.
* New function to check ownership or friendly status of a given object.
* Merged with Snap Pro and Modular build framework (both included) with permission from [Raymix](https://github.com/raymix) (Please show you appreciation to Raymix as well).

#Install Instructions

1. Copy the `custom` folder in to your mpmissions/[map] folder.
2. Create a `custom` folder in the server root directory (the one you have the @mod files in) and copy the contents of the Server folder in to it (you can merge them in to the dayz_server.pbo but need to change the default references).

#Instructions for linking in to your mission

1. Open your mpmissions/[map]/init.sqf file

Search for
```cpp
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\variables.sqf";
```
Replace with
```cpp
call compile preprocessFileLineNumbers "Custom\A_Plot_for_Life\init\variables.sqf";
```

--

Search for
```cpp
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\publicEH.sqf";
```

Replace with
```cpp
call compile preprocessFileLineNumbers "Custom\A_Plot_for_Life\init\publicEH.sqf";
```

--

Search for
```cpp
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\compiles.sqf";
```

Replace with
```cpp
call compile preprocessFileLineNumbers "Custom\A_Plot_for_Life\init\compiles.sqf";
```

--

Search for
```cpp
_serverMonitor = [] execVM "\z\addons\dayz_code\system\server_monitor.sqf";
```

Replace with (you may need to change this depending on where you put the server files).
```cpp
_serverMonitor = [] execVM "custom\system\server_monitor.sqf";
```

--

Add the following line to the bottom of your description.ext located in your MPMissions\[Map] folder
```cpp
#include "custom\snap_pro\snappoints.hpp"
```

# Options

Turn on A plot for Life (check ownership against SteamID).
```cpp
DZE_APlotforLife = true;
```

Turn on Take Plot Ownership (take ownership of all items on a plot except locked items).  This can be used to realign old bases to the A Plot of Life ownership system or for raiding and taking over bases.
```cpp
DZE_PlotOwnership = true;
```

Turn on Snap Build Pro and the modular player build framework.
```cpp
DZE_modularBuild = true;
```

#References


* [APfL Epochmod.com thread](http://epochmod.com/forum/index.php?/topic/11042-release-a-plot-for-life-v232-keep-your-buildables-on-death-take-plot-ownership/)
* [APfL Git](https://github.com/RimBlock/Epoch/tree/master/A%20Plot%20for%20Life)
* [Snap Pro epochmod.com thread](http://epochmod.com/forum/index.php?/topic/13886-141-snap-building-pro/)
* [Snap Pro Git](https://github.com/raymix/SnapPro)

#Thanks

* [Raymix](https://github.com/raymix) - For allowing the merge of Snap Build Pro and the modular building system.
* [F3cuk] (https://github.com/f3cuk) - For reformatting this readme in GitHub md.