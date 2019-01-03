# DayZ-Legacy
Client with Mono config, and scripts for DayZ Standalone "0.45 engine/0.59 addons"

These files are the base client, they are intended for use with DayZ Standalone 0.59 addons.
You must add your addons, and \dta\core.pbo,
 though removing all .cpp,.bin,.fsm,.csv,.sqf, and .sqs files
 from the .pbo's in the addons folder is recomended/most likely required.
 
Don't include/support ArmA2, ArmA3, or DayZ 0.60+ assets into this project "please fork"
 as this Project is for vanilla** "alpha" DayZ:SA. 
 **Basebuilding assets exist/will be supported.
 
!ALWAYS re-pbo, and TEST your work BEFORE COMITING!

 https://discord.gg/pEf7avS
Discord is currently quiet, stick around. 
I'm often offline currently, but I get more done when I don't have distractions.
 
 DOCUMENTATION/useful info
This project uses DayZ:SA (0.59) addons with a few exceptions.
ChernarusPlus.wrp is from version (0.58). -(0.59).wrp causes crash.
The character/zombie "skeleton (If I remember)" files are also from a previous version (0.45-0.58). -(0.59) version dosent crash but is broken/ugly. 
A few models of wood piles are from an older version as the LoD's aren't rendered properly.

To conform with Github <1GiB repo rule, and Bohemias policy against sharing graphical assets, those can't be in the repo at this time.

BUGs:
This is DayZ, if it isn't broke "hold my beer".
Most bugs will be on the scripting side, as the .exe is where I've spend the majority of my time.


As for those nasty .exe bugs in the order they'll likely be fixed, optimizations happen along the way.

zooming with right mouse button and moving can cause throwing item.
Getin/Getout of vehicle not playing animation on dedicated server.
 
When in vehicle player position isnt updated correctly, and player stays at the place of entry.

vehicles have a good bit of visual bugs with wheel animations, inventory items look duplicated sometimes but aren't without persistance/reloading the server making them persistant.

Server saves players, but I'm unsure how to parse the position, and inventory properly
 though once players are working world persistance "tent/barrel/car" should be good as done,
 and I may tie this into player connected/disconnected in the engine allowing the removal of related scripts "persistance will be a config value some don't want it".

With future versions I'll trim out some of the extra file clutter, and some of the logging as I've been debugging try "-nolog" if you need.
