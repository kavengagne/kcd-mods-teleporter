require("Tests.Testicle")
require("Data.Scripts.Mod.TeleportHelp")
require("Data.Scripts.Mod.TeleportPlaces")
require("Data.Scripts.Mod.Teleport")


local help_teleport = TeleportHelp.generateTeleportHelp()
local help_teleport_dismount = TeleportHelp.generateDismountTeleportHelp()
local help_teleport_create = TeleportHelp.generateCreateTeleportHelp()
local help_teleport_remove = TeleportHelp.generateRemoveTeleportHelp()
local help_teleport_text = TeleportHelp.generateTeleportPlaces(TeleportPlaces)

print(help_teleport)
print(help_teleport_dismount)
print(help_teleport_create)
print(help_teleport_remove)
print(help_teleport_text)


---------------------------------------------
-- CmdTeleport
---------------------------------------------
-- Success
player.human.IsMountedValue = false
Teleport.CmdTeleport("")
Teleport.CmdTeleport("rattay")
Teleport.CmdTeleport("rattay east")
Teleport.CmdTeleport("rat")
Teleport.CmdTeleport("rat east")

-- Failure - Mounted
player.human.IsMountedValue = true
Teleport.CmdTeleport("rattay")
player.human.IsMountedValue = false

-- Failure
Teleport.CmdTeleport("rat west")
Teleport.CmdTeleport("rterr")

-- Ambiguity
Teleport.CmdTeleport("sa")


---------------------------------------------
-- CmdDismountAndTeleport
---------------------------------------------
player.human.IsMountedValue = false
Teleport.CmdDismountAndTeleport("rattay")
player.human.IsMountedValue = true
Teleport.CmdDismountAndTeleport("rattay")


---------------------------------------------
-- CmdCreateTeleport
---------------------------------------------
-- Success
Teleport.CmdCreateTeleport("rattay test")
Teleport.CmdCreateTeleport("kaven")
Teleport.CmdCreateTeleport("kaven test")
Teleport.CmdCreateTeleport("ratt")

-- Failure
Teleport.CmdCreateTeleport("")
Teleport.CmdCreateTeleport("rattay")
Teleport.CmdCreateTeleport("rattay in")
Teleport.CmdCreateTeleport("rattay east")

-- Failure - Mounted
player.human.IsMountedValue = true
Teleport.CmdCreateTeleport("henry")
player.human.IsMountedValue = false


---------------------------------------------
-- CmdListTeleport
---------------------------------------------
Teleport.CmdListTeleport()


---------------------------------------------
-- CmdLocation
---------------------------------------------
Teleport.CmdLocation()


---------------------------------------------
-- CmdGetStatusTeleporter
---------------------------------------------
Teleport.CmdGetStatusTeleporter()


---------------------------------------------
-- CmdRemoveTeleport
---------------------------------------------
-- Success
Teleport.CmdRemoveTeleport("rattay")
Teleport.CmdRemoveTeleport("kaven")

-- Failure
Teleport.CmdRemoveTeleport("")
Teleport.CmdRemoveTeleport("ra")
Teleport.CmdRemoveTeleport("sa")
Teleport.CmdRemoveTeleport("trerr")

Teleport.CmdListTeleport()
