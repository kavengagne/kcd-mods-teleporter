Script.ReloadScript("Scripts/Utils/Util.lua")
Script.ReloadScript("Scripts/Utils/LogUtil.lua")
Script.ReloadScript("Scripts/Utils/Linq.lua")
Script.ReloadScript("Scripts/Utils/StringUtil.lua")
Script.ReloadScript("Scripts/Mod/TeleportHelp.lua")
Script.ReloadScript("Scripts/Mod/TeleportPlaces.lua")


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
    local exact = Linq.First(places, function(k, v) return v.place == place end)
    if exact ~= nil then
        if location == nil then
            location = "IN"
        end
        exact.locations[location] = position
    else
        table.insert(places, {
            place = StringUtil.Upper(place),
            name = StringUtil.Capitalize(place),
            locations = {
                IN = position
            }
        })
    end
end


local function findPlace(places, keywords)
    local terms = StringUtil.Split(StringUtil.Upper(keywords))
    local place = terms[1]
    local location = terms[2]
    local found = {}
    local exact = Linq.First(places, function(k, v) return v.place == place end)
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
        for index,value in ipairs(places) do
            if StringUtil.Upper(value.place):find(place) ~= nil then
                if location ~= nil then
                    if value.locations[location] ~= nil then
                        table.insert(found, makePlace(value, location, false))
                    end
                elseif value.locations["IN"] ~= nil then
                    table.insert(found, makePlace(value, "IN", false))
                end
            end
        end
    end
    return found
end


Teleport = {
    CmdTeleport = function(keywords)
        if Util.IsBlank(keywords) then
            LogUtil.LogError("Place name cannot be empty.")
            return
        end
        local found = findPlace(TeleportPlaces, keywords)
        if #found > 1 then
            LogUtil.LogError("Too many locations found: %s.", table.concat(Linq.Select(found, function(k, v) return v.name end), ", "))
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
        if player.human:IsMounted() then
            player.human:ForceDismount()
        end
        Teleport.CmdTeleport(keywords)
    end,
    
    CmdCreateTeleport = function(keywords)
        if Util.IsBlank(keywords) then
            LogUtil.LogError("Place name cannot be empty.")
            return
        end
        local found = findPlace(TeleportPlaces, keywords)
        if #found > 0 and found[1].isExact then
            LogUtil.LogError("Place name already exists: %s.", keywords)
        elseif player.human:IsMounted() then
            LogUtil.LogError("Player is Mounted. Please Dismount before creating Teleport.")
        else
            local pos = player:GetWorldPos()
            addPlace(TeleportPlaces, keywords, pos)
            LogUtil.LogInfo("Teleport place created: %s (%s)", StringUtil.Capitalize(keywords), Util.FormatCoords(pos.x, pos.y, pos.z))
        end
    end,

    CmdRemoveTeleport = function(keywords)
        if Util.IsBlank(keywords) then
            LogUtil.LogError("Place name cannot be empty.")
            return
        end
        local found = findPlace(TeleportPlaces, keywords)
        if #found > 1 then
            LogUtil.LogError("Too many locations found: %s.", table.concat(Linq.Select(found, function(k, v) return v.place end), ", "))
        elseif #found < 1 then
            LogUtil.LogError("Place not found. Type 'tpl' for the list of supported places.")
        elseif not found[1].isExact then
            LogUtil.LogError("Place name must be exact. Type 'tpl' for the list of supported places.")
        else
            local place = found[1].place
            local index = TableUtil.Index(Linq.Select(TeleportPlaces, function(k, v) return v.place end), place)
            table.remove(TeleportPlaces, index)
            LogUtil.LogInfo("Teleport place removed: %s", StringUtil.Capitalize(keywords))
        end
    end,
    
    CmdListTeleport = function()
        local help = TeleportHelp.generateTeleportPlaces(TeleportPlaces)
        local tokens = StringUtil.Split(help, "[^\n]+")
        for i,v in ipairs(tokens) do
            LogUtil.Print(v)
        end
    end,
    
    CmdLocation = function()
        local loc = player:GetWorldPos()
        LogUtil.LogInfo("Player's location (%s)", Util.FormatCoords(loc.x, loc.y, loc.z))
    end,
}
