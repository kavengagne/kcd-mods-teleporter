Script.ReloadScript("Scripts/kgmod-quicksave.lua")
Script.ReloadScript("Scripts/kgmod-teleport-places.lua")
Script.ReloadScript("Scripts/kgmod-teleport.lua")
Script.ReloadScript("Scripts/kgmod-teleport-help.lua")
Script.ReloadScript("Scripts/kgutil-main.lua")


local help_teleport = teleport_help.generateTeleportHelp(teleport_places)
local help_teleport_dismount = teleport_help.generateDismountTeleportHelp(teleport_places)
local help_teleport_create = teleport_help.generateCreateTeleportHelp()
local help_teleport_remove = teleport_help.generateRemoveTeleportHelp()

System.AddCCommand("quicksave", "quicksave.cmdQuicksave()", "Saves the game from anywhere.")
System.AddCCommand("qs", "quicksave.cmdQuicksave()", "Saves the game from anywhere.")

System.AddCCommand("teleport", "teleport.cmdTeleport(%line)", help_teleport)
System.AddCCommand("tp", "teleport.cmdTeleport(%line)", help_teleport)

System.AddCCommand("tpinit", "teleport.cmdSpawnTeleporter()", "Spawns the Teleporter entity. This must be called first and then save the game.")
System.AddCCommand("tpdestroy", "teleport.cmdDestroyTeleporter()", "Destroys the Teleporter entity. This will disable the teleport mod.")
System.AddCCommand("tpstatus", "teleport.cmdGetStatusTeleporter()", "Displays the status of the Teleporter entity.")

System.AddCCommand("tpdismount", "teleport.cmdDismountAndTeleport(%line)", help_teleport_dismount)
System.AddCCommand("tpd", "teleport.cmdDismountAndTeleport(%line)", help_teleport_dismount)
System.AddCCommand("tpcreate", "teleport.cmdCreateTeleport(%line)", help_teleport_create)
System.AddCCommand("tpc", "teleport.cmdCreateTeleport(%line)", help_teleport_create)
System.AddCCommand("tpremove", "teleport.cmdRemoveTeleport(%line)", help_teleport_remove)
System.AddCCommand("tpr", "teleport.cmdRemoveTeleport(%line)", help_teleport_remove)
System.AddCCommand("tplist", "teleport.cmdListTeleport()", "Shows teleport places.")
System.AddCCommand("tpl", "teleport.cmdListTeleport()", "Shows teleport places.")
System.AddCCommand("location", "teleport.cmdLocation()", "Displays the player's location.")
System.AddCCommand("loc", "teleport.cmdLocation()", "Displays the player's location.")

kgutil.logInfo("Teleporter Mod loaded. Type 'tp ?' for help.")
