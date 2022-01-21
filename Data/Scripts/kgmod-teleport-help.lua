Script.ReloadScript("Scripts/kgutil-main.lua")


local tpSyntax = "$3Syntax:\n" ..
                 "  $5teleport $1<$8place$1> $1[$8alternate$1]\n" ..
                 "  $5tp $1<$8place$1> $1[$8alternate$1]\n"
local tpdSyntax = "$3Syntax:\n" ..
                  "  $5tpdismount $1<$8place$1> $1[$8alternate$1]\n" ..
                  "  $5tpd $1<$8place$1> $1[$8alternate$1]\n"
local tpcSyntax = "$3Syntax:\n" ..
                  "  $5tpcreate $1<$8place$1> $1[$8alternate$1]\n" ..
                  "  $5tpc $1<$8place$1> $1[$8alternate$1]\n"
local tprSyntax = "$3Syntax:\n" ..
                  "  $5tpremove $1<$8place$1>\n" ..
                  "  $5tpr $1<$8place$1>\n"
local seeAlso = "$3See also:\n" ..
                "  $1location (loc), teleport (tp), tpdismount (tpd),\n" .. 
                "  $1tpcreate (tpc), tpremove (tpr), tplist (tpl)\n\n" ..
                "  $1tpinit, tpdestroy, tpstatus"


teleport_help = {
    generateTeleportPlaces = function(places)
        local nameLen = kgutil.max(kgutil.map(kgutil.values(places, "name"), string.len)) + 2
        local keyLen = kgutil.max(kgutil.map(kgutil.keys(places), string.len)) + 2
        local help = "$3Supported places (case insensitive).\n\n" ..
                     string.format("  $3%s%s%s", kgutil.padRight("Name", nameLen), kgutil.padRight("Place", keyLen), "Alternate\n")
        for key,value in pairs(places) do
            local altLocations = kgutil.filter(kgutil.keys(value.locations), function(item) return item.value ~= "IN" end)
            local altLocString = kgutil.lower(table.concat(altLocations, ", "))
            if #altLocations > 0 then
                altLocString = "$1[$8" .. altLocString .. "$1]"
            end
            help = help .. string.format(
                "  $1%s$8%s%s\n",
                kgutil.padRight(value.name, nameLen),
                kgutil.padRight(kgutil.lower(key), keyLen),
                altLocString)
        end
        return help
    end,
    
    generateTeleportHelp = function(places)
        return tpSyntax ..
               "$3Teleports the player to the given place.\n" ..
               "$3Type $1'tpl'$3 for the list of locations.\n\n" ..
               seeAlso
    end,
    
    generateDismountTeleportHelp = function(places)
        return tpdSyntax ..
               "$3Dismounts and Teleports the player to the given place.\n" ..
               "$3Type $1'tpl'$3 for the list of locations.\n\n" ..
               seeAlso
    end,
    
    generateCreateTeleportHelp = function()
        return tpcSyntax ..
               "$3Creates a new teleport location.\n" ..
               "$3Place name must be unique."
    end,

    generateRemoveTeleportHelp = function()
        return tprSyntax ..
               "$3Removes the given teleport place.\n" ..
               "$3Place name must be exact.\n\n" ..
               seeAlso
    end,
}
