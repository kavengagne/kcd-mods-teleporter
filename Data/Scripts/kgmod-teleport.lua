Script.ReloadScript("Scripts/kgutil-main.lua")
Script.ReloadScript("Scripts/kgmod-teleport-help.lua")


local teleporterName = "Teleporter100"

local function makePlace(place, location, isExact)
    return {
        place = kgutil.toUpper(place.place),
        name = string.format("%s %s", place.name, kgutil.toLower(location)),
        location = place.locations[location],
        locationName = location,
        isExact = isExact
    }
end


local function addPlace(places, keywords, position)
    local terms = kgutil.split(kgutil.toUpper(keywords))
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
            place = kgutil.toUpper(place),
            name = kgutil.capitalize(place),
            locations = {
                IN = position
            }
        }
    end
end


local function findPlace(places, keywords)
    local terms = kgutil.split(kgutil.toUpper(keywords))
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
            if kgutil.toUpper(key):find(place) ~= nil then
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
    kgutil.logError("Teleporter is not initialized. Type 'tpinit' to proceed.")
    return false
end


teleport = {
    cmdTeleport = function(keywords)
        if not isTeleporterCreated() then return end
        local places = getTeleporterInstance().Properties.Places
        if kgutil.isBlank(keywords) then
            kgutil.logError("Place name cannot be empty.")
            return
        end
        local found = findPlace(places, keywords)
        if table.getn(found) > 1 then
            kgutil.logError("Too many locations found: %s.", table.concat(kgutil.map(found, function(item) return item.name end), ", "))
        elseif table.getn(found) < 1 then
            kgutil.logError("Place not found. Type 'tpl' for the list of supported places.")
        elseif player.human:IsMounted() then
            kgutil.logError("Player is Mounted. Use 'tpd %s' to Dismount and Teleport.", keywords)
        else
            local nplace = found[1]
            player:SetWorldPos({ x = nplace.location.x, y = nplace.location.y, z = nplace.location.z })
            kgutil.logInfo("Teleported player to %s (%s).", nplace.name, kgutil.formatCoords(nplace.location.x, nplace.location.y, nplace.location.z))
        end
    end,
    
    cmdDismountAndTeleport = function(keywords)
        if not isTeleporterCreated() then return end
        if player.human:IsMounted() then
            player.human:ForceDismount()
        end
        teleport.cmdTeleport(keywords)
    end,
    
    cmdCreateTeleport = function(keywords)
        if not isTeleporterCreated() then return end
        local places = getTeleporterInstance().Properties.Places
        if kgutil.isBlank(keywords) then
            kgutil.logError("Place name cannot be empty.")
            return
        end
        local found = findPlace(places, keywords)
        if table.getn(found) > 0 and found[1].isExact then
            kgutil.logError("Place name already exists: %s.", keywords)
        elseif player.human:IsMounted() then
            kgutil.logError("Player is Mounted. Please Dismount before creating Teleport.")
        else
            local pos = player:GetWorldPos()
            addPlace(places, keywords, pos)
            kgutil.logInfo("Teleport place created: %s (%s)", kgutil.capitalize(keywords), kgutil.formatCoords(pos.x, pos.y, pos.z))
        end
    end,

    cmdRemoveTeleport = function(keywords)
        if not isTeleporterCreated() then return end
        local places = getTeleporterInstance().Properties.Places
        if kgutil.isBlank(keywords) then
            kgutil.logError("Place name cannot be empty.")
            return
        end
        local found = findPlace(places, keywords)
        if table.getn(found) > 1 then
            kgutil.logError("Too many locations found: %s.", table.concat(kgutil.map(found, function(item) return item.name end), ", "))
        elseif table.getn(found) < 1 then
            kgutil.logError("Place not found. Type 'tpl' for the list of supported places.")
        elseif not found[1].isExact then
            kgutil.logError("Place name must be exact. Type 'tpl' for the list of supported places.")
        -- elseif table.getn(kgutil.getKeys(places[found[1].place].locations)) > 1 then
        --     places[found[1].place].locations[found[1].locationName] = nil
        --     kgutil.logInfo("Teleport location removed: %s", kgutil.capitalize(keywords))
        else
            -- TODO: Effacer item pour vrai
            places[found[1].place] = nil
            kgutil.logInfo("Teleport place removed: %s", kgutil.capitalize(keywords))
        end
    end,
    
    cmdListTeleport = function()
        if not isTeleporterCreated() then return end
        local places = getTeleporterInstance().Properties.Places
        local help = teleport_help.generateTeleportPlaces(places)
        local tokens = kgutil.split(help, "[^\n]+")
        for k,v in pairs(tokens) do
            kgutil.print(v)
        end
    end,
    
    cmdLocation = function()
        local loc = player:GetWorldPos()
        kgutil.logInfo("Player's location (%s)", kgutil.formatCoords(loc.x, loc.y, loc.z))
    end,
    
    cmdGetStatusTeleporter = function()
        local entity = getTeleporterInstance()
        if entity == nil then
            kgutil.logError("Teleporter not found. Type 'tpinit' to create it.")
            return
        end
        kgutil.logInfo("---------------------------------------------")
        kgutil.logInfo("Teleporter Entity")
        kgutil.logInfo("Name: %s (%d)", entity:GetName(), tostring(entity:GetRawId()))
        kgutil.logInfo("Locations:")
        for place,tbl in pairs(entity.Properties.Places) do
            local coords = kgutil.map(tbl.locations, kgutil.formatCoords2)
            local locations = {}
            for k,v in pairs(coords) do
                table.insert(locations, string.format("%s = %s", k, v))
            end
            local locs = table.concat(locations, ", ")
            kgutil.logInfo("%s = (%s)", tostring(place), locs)
        end
    end,
    
    cmdDestroyTeleporter = function()
        local entity = getTeleporterInstance()
        if entity ~= nil then
            kgutil.logInfo("Teleporter Found. Destroying...")
            System.RemoveEntity(entity.id)
            kgutil.logInfo("Teleporter destroyed.")
        else
            kgutil.logError("Teleporter not found.")
        end
    end,

    cmdSpawnTeleporter = function()
        local entity = getTeleporterInstance()
        if entity ~= nil then
            kgutil.logWarning("Teleporter already exists.")
            teleport.cmdGetStatusTeleporter()
        else
            kgutil.logWarning("Teleporter not found. Creating...")
            local params = {
                class = "Teleporter",
                position = { x = 0, y = 0, z = 0 },
                orientation = player:GetWorldDir(),
                name = teleporterName
            }
            entity = System.SpawnEntity(params)
            kgutil.logInfo("Teleporter created.")
        end
        return entity
    end,
}
