Script.ReloadScript("Scripts/kgmod-teleport-places.lua")
Script.ReloadScript("Scripts/kgutil-main.lua")

Teleporter =
{
    Properties =
    {
        Places = teleport_places,
    },
}

function Teleporter:OnInit()
    kgutil.logInfo("Teleporter Initialized. Type 'tp ?' for information.")
end
