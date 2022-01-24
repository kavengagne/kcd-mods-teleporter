require("Data.Scripts.Mod.TeleportPlaces")

Script = {
    ReloadScript = function(script)
        local scriptPath = script:gsub("/", "."):gsub(".lua", "")
        require(string.format("Data.%s", scriptPath))
    end,
}

System = {
    GetEntityByName = function(name)
        return {
            Properties = {
                Places = TeleportPlaces
            },
            GetName = function()
                return name
            end,
            GetRawId = function()
                return 1234
            end,
        }
    end,
    LogAlways = print
}

player = {
    human = {
        IsMountedValue = false,
        IsMounted = function()
            return player.human.IsMountedValue
        end,
        ForceDismount = function()
            player.human.IsMountedValue = false
            print("Fake ForceDismount Executed.")
        end,
    },
    SetWorldPos = function(player, coords)
        print(string.format("Fake Teleported player to X: %d, Y: %d, Z: %d.", coords.x, coords.y, coords.z))
    end,
    GetWorldPos = function()
        return { x = 10, y = 20, z = 30 }
    end,
}
