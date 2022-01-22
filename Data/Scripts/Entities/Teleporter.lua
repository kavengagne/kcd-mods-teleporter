Script.ReloadScript("Scripts/Utils/LogUtil.lua")
Script.ReloadScript("Scripts/Mod/TeleportPlaces.lua")


Teleporter =
{
    Properties =
    {
        Places = TeleportPlaces,
    },
}

function Teleporter:OnInit()
    LogUtil.LogInfo("Teleporter Initialized. Type 'tp ?' for information.")
end
