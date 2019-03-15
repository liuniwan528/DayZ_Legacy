# DayZ-Legacy
Client with Mono config, and scripts for DayZ Standalone "0.45 engine/0.59 addons"

These files are the base client, they are intended for use with DayZ Standalone 0.59 addons.
You must add your addons, and PBO the scripts folder in the dta directory,
 though removing all .cpp,.bin,.fsm,.csv,.sqf, and .sqs files
 from the .pbo's in the addons folder is recomended/most likely required.
 
Please don't include/support ArmA2,or ArmA3 assets into this project.
DayZ 0.60+ assets aren't renderable.
Epoch base building classes exist, scripting is a TODO.
 
!ALWAYS re-pbo, and TEST your work BEFORE COMITING!

 https://discord.gg/pEf7avS
Discord is currently quiet, but it's a good place to leave bug reports/crash dumps "with steps to reproduce when possible". 

To conform with Github <1GiB repo rule, and Bohemias policy against sharing graphical assets, those can't be in the repo at this time.

BUGs:
This is DayZ, if it isn't broke "hold my beer".
Most bugs will be on the scripting side, as the .exe is where I've spent the majority of my time.

As for those nasty .exe bugs in the order they'll likely be fixed, optimizations happen along the way.

zooming with right mouse button and moving can cause throwing item.
Getin/Getout of vehicle not playing animation on dedicated server.

vehicles have a good bit of visual bugs with wheel animations, inventory items look duplicated sometimes but aren't without persistance/reloading the server making them persistant.

Server saves players, but I'm unsure how to parse the position, and inventory properly
 though once players are working world persistance "tent/barrel/car" should be good as done,
 and I may tie this into player connected/disconnected in the engine allowing the removal of related scripts "persistance will be a config value for those who don't want it, as it does slow down debugging".

With future versions I'll trim out some of the extra file clutter, and some of the logging as I've been debugging try "-nolog" if you need.
