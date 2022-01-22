Script.ReloadScript("Scripts/Utils/LogUtil.lua")
Script.ReloadScript("Scripts/Mod/QuickSave.lua")
Script.ReloadScript("Scripts/Mod/TeleportPlaces.lua")
Script.ReloadScript("Scripts/Mod/Teleport.lua")
Script.ReloadScript("Scripts/Mod/TeleportHelp.lua")


local help_teleport = TeleportHelp.generateTeleportHelp(TeleportPlaces)
local help_teleport_dismount = TeleportHelp.generateDismountTeleportHelp(TeleportPlaces)
local help_teleport_create = TeleportHelp.generateCreateTeleportHelp()
local help_teleport_remove = TeleportHelp.generateRemoveTeleportHelp()

System.AddCCommand("quicksave", "QuickSave.CmdQuicksave()", "Saves the game from anywhere.")
System.AddCCommand("qs", "QuickSave.CmdQuicksave()", "Saves the game from anywhere.")

System.AddCCommand("teleport", "Teleport.CmdTeleport(%line)", help_teleport)
System.AddCCommand("tp", "Teleport.CmdTeleport(%line)", help_teleport)

System.AddCCommand("tpinit", "Teleport.CmdSpawnTeleporter()", "Spawns the Teleporter entity. This must be called first and then save the game.")
System.AddCCommand("tpdestroy", "Teleport.CmdDestroyTeleporter()", "Destroys the Teleporter entity. This will disable the teleport mod.")
System.AddCCommand("tpstatus", "Teleport.CmdGetStatusTeleporter()", "Displays the status of the Teleporter entity.")

System.AddCCommand("tpdismount", "Teleport.CmdDismountAndTeleport(%line)", help_teleport_dismount)
System.AddCCommand("tpd", "Teleport.CmdDismountAndTeleport(%line)", help_teleport_dismount)
System.AddCCommand("tpcreate", "Teleport.CmdCreateTeleport(%line)", help_teleport_create)
System.AddCCommand("tpc", "Teleport.CmdCreateTeleport(%line)", help_teleport_create)
System.AddCCommand("tpremove", "Teleport.CmdRemoveTeleport(%line)", help_teleport_remove)
System.AddCCommand("tpr", "Teleport.CmdRemoveTeleport(%line)", help_teleport_remove)
System.AddCCommand("tplist", "Teleport.CmdListTeleport()", "Shows teleport places.")
System.AddCCommand("tpl", "Teleport.CmdListTeleport()", "Shows teleport places.")
System.AddCCommand("location", "Teleport.CmdLocation()", "Displays the player's location.")
System.AddCCommand("loc", "Teleport.CmdLocation()", "Displays the player's location.")

LogUtil.LogInfo("Teleporter Mod loaded. Type 'tp ?' for help.")
