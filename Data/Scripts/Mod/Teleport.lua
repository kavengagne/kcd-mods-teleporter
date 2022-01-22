Script.ReloadScript("Scripts/Utils/Util.lua")
Script.ReloadScript("Scripts/Utils/LogUtil.lua")
Script.ReloadScript("Scripts/Utils/Linq.lua")
Script.ReloadScript("Scripts/Utils/StringUtil.lua")
Script.ReloadScript("Scripts/Mod/TeleportHelp.lua")


local teleporterName = "Teleporter100"


local function makePlace(place, location, isExact)
    return {
        place = StringUtil.Upper(place.place),
        name = string.format("%s %s", place.name, StringUtil.Lower(location)),
        location = place.locations[location],
        locationName = location,
        isExact = isExact
    }
end


local function addPlace(places, keywords, position)
    local terms = StringUtil.Split(StringUtil.Upper(keywords))
    local place = terms[1]
    local location = terms[2]
    local exact = places[place]
    if exact ~= nil then
        if location == nil then
            location = "IN"
        end
        exact.locations[location] = position
    else
        places[place] = {
            place = StringUtil.Upper(place),
            name = StringUtil.Capitalize(place),
            locations = {
                IN = position
            }
        }
    end
end


local function findPlace(places, keywords)
    local terms = StringUtil.Split(StringUtil.Upper(keywords))
    local place = terms[1]
    local location = terms[2]
    local found = {}
    local exact = places[place]
    if exact ~= nil then -- exact match
        if location ~= nil then
            if exact.locations[location] ~= nil then
                table.insert(found, makePlace(exact, location, true))
            end
        elseif exact.locations["IN"] ~= nil then
            table.insert(found, makePlace(exact, "IN", true))
        end
    else -- starts with
        place = string.format("^%s", place) -- startswith matcher
        for key,value in pairs(places) do
            if StringUtil.Upper(key):find(place) ~= nil then
                if location ~= nil then
                    if value.locations[location] ~= nil then
                        table.insert(found, makePlace(value, location, false))
                    end
                elseif exact.locations["IN"] ~= nil then
                    table.insert(found, makePlace(value, "IN", false))
                end
            end
        end
    end
    return found
end


local function getTeleporterInstance()
    return System.GetEntityByName(teleporterName)
end


local function isTeleporterCreated()
    local entity = getTeleporterInstance()
    if entity ~= nil then
        return true
    end
    LogUtil.LogError("Teleporter is not initialized. Type 'tpinit' to proceed.")
    return false
end


Teleport = {
    CmdTeleport = function(keywords)
        if not isTeleporterCreated() then return end
        local places = getTeleporterInstance().Properties.Places
        if Util.IsBlank(keywords) then
            LogUtil.LogError("Place name cannot be empty.")
            return
        end
        local found = findPlace(places, keywords)
        if #found > 1 then
            LogUtil.LogError("Too many locations found: %s.", table.concat(Linq.Select(found, function(item) return item.name end), ", "))
        elseif #found < 1 then
            LogUtil.LogError("Place not found. Type 'tpl' for the list of supported places.")
        elseif player.human:IsMounted() then
            LogUtil.LogError("Player is Mounted. Use 'tpd %s' to Dismount and Teleport.", keywords)
        else
            local nplace = found[1]
            player:SetWorldPos({ x = nplace.location.x, y = nplace.location.y, z = nplace.location.z })
            LogUtil.LogInfo("Teleported player to %s (%s).", nplace.name, Util.FormatCoords(nplace.location.x, nplace.location.y, nplace.location.z))
        end
    end,
    
    CmdDismountAndTeleport = function(keywords)
        if not isTeleporterCreated() then return end
        if player.human:IsMounted() then
            player.human:ForceDismount()
        end
        Teleport.CmdTeleport(keywords)
    end,
    
    CmdCreateTeleport = function(keywords)
        if not isTeleporterCreated() then return end
        local places = getTeleporterInstance().Properties.Places
        if Util.IsBlank(keywords) then
            LogUtil.LogError("Place name cannot be empty.")
            return
        end
        local found = findPlace(places, keywords)
        if #found > 0 and found[1].isExact then
            LogUtil.LogError("Place name already exists: %s.", keywords)
        elseif player.human:IsMounted() then
            LogUtil.LogError("Player is Mounted. Please Dismount before creating Teleport.")
        else
            local pos = player:GetWorldPos()
            addPlace(places, keywords, pos)
            LogUtil.LogInfo("Teleport place created: %s (%s)", StringUtil.Capitalize(keywords), Util.FormatCoords(pos.x, pos.y, pos.z))
        end
    end,

    CmdRemoveTeleport = function(keywords)
        if not isTeleporterCreated() then return end
        local places = getTeleporterInstance().Properties.Places
        if Util.IsBlank(keywords) then
            LogUtil.LogError("Place name cannot be empty.")
            return
        end
        local found = findPlace(places, keywords)
        if #found > 1 then
            LogUtil.LogError("Too many locations found: %s.", table.concat(Linq.Select(found, function(item) return item.name end), ", "))
        elseif #found < 1 then
            LogUtil.LogError("Place not found. Type 'tpl' for the list of supported places.")
        elseif not found[1].isExact then
            LogUtil.LogError("Place name must be exact. Type 'tpl' for the list of supported places.")
        else
            places[found[1].place] = nil
            LogUtil.LogInfo("Teleport place removed: %s", StringUtil.Capitalize(keywords))
            Dump(getTeleporterInstance().Properties.Places)
        end
    end,
    
    CmdListTeleport = function()
        if not isTeleporterCreated() then return end
        local places = getTeleporterInstance().Properties.Places
        local help = TeleportHelp.generateTeleportPlaces(places)
        local tokens = StringUtil.Split(help, "[^\n]+")
        for k,v in pairs(tokens) do
            LogUtil.Print(v)
        end
    end,
    
    CmdLocation = function()
        local loc = player:GetWorldPos()
        LogUtil.LogInfo("Player's location (%s)", Util.FormatCoords(loc.x, loc.y, loc.z))
    end,
    
    CmdGetStatusTeleporter = function()
        local entity = getTeleporterInstance()
        if entity == nil then
            LogUtil.LogError("Teleporter not found. Type 'tpinit' to create it.")
            return
        end
        LogUtil.LogInfo("---------------------------------------------")
        LogUtil.LogInfo("Teleporter Entity")
        LogUtil.LogInfo("Name: %s (%d)", entity:GetName(), tostring(entity:GetRawId()))
        LogUtil.LogInfo("Locations:")
        for place,tbl in pairs(entity.Properties.Places) do
            local coords = Linq.Select(tbl.locations, function(loc)
                return Util.FormatCoords(loc.x, loc.y, loc.z)
            end)
            local locations = {}
            for k,v in pairs(coords) do
                table.insert(locations, string.format("%s = %s", k, v))
            end
            local locs = table.concat(locations, ", ")
            LogUtil.LogInfo("%s = (%s)", tostring(place), locs)
        end
    end,
    
    CmdDestroyTeleporter = function()
        local entity = getTeleporterInstance()
        if entity ~= nil then
            LogUtil.LogInfo("Teleporter Found. Destroying...")
            System.RemoveEntity(entity.id)
            LogUtil.LogInfo("Teleporter destroyed.")
        else
            LogUtil.LogError("Teleporter not found.")
        end
    end,

    CmdSpawnTeleporter = function()
        local entity = getTeleporterInstance()
        if entity ~= nil then
            LogUtil.LogWarning("Teleporter already exists.")
            Teleport.CmdGetStatusTeleporter()
        else
            LogUtil.LogWarning("Teleporter not found. Creating...")
            local params = {
                class = "Teleporter",
                position = { x = 0, y = 0, z = 0 },
                orientation = player:GetWorldDir(),
                name = teleporterName
            }
            entity = System.SpawnEntity(params)
            LogUtil.LogInfo("Teleporter created.")
        end
        return entity
    end,
}
