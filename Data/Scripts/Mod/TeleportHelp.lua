Script.ReloadScript("Scripts/Utils/TableUtil.lua")
Script.ReloadScript("Scripts/Utils/Linq.lua")
Script.ReloadScript("Scripts/Utils/StringUtil.lua")


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


TeleportHelp = {
    generateTeleportPlaces = function(places)
        local nameLen = TableUtil.Max(Linq.Select(TableUtil.Values(places, "name"), string.len)) + 2
        local keyLen = TableUtil.Max(Linq.Select(TableUtil.Keys(places), string.len)) + 2
        local help = "$3Supported places (case insensitive).\n\n" ..
                     string.format("  $3%s%s%s", StringUtil.PadRight("Name", nameLen), StringUtil.PadRight("Place", keyLen), "Alternate\n")
        for key,value in pairs(places) do
            local altLocations = Linq.Where(TableUtil.Keys(value.locations), function(key, value) return value ~= "IN" end)
            local altLocString = StringUtil.Lower(table.concat(altLocations, ", "))
            if #altLocations > 0 then
                altLocString = "$1[$8" .. altLocString .. "$1]"
            end
            help = help .. string.format(
                "  $1%s$8%s%s\n",
                StringUtil.PadRight(value.name, nameLen),
                StringUtil.PadRight(StringUtil.Lower(key), keyLen),
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
