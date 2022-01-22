if (Script ~= nil) then
    Script.ReloadScript("Scripts/Utils/Util.lua")
else
    require("Data.Scripts.Utils.Util")
end


StringUtil = {
    Upper = function(str)
        if not Util.IsBlank(str) then
            -- string.upper fails if passed nil
            return string.upper(str)
        else
            return str
        end
    end,

    Lower = function(str)
        if not Util.IsBlank(str) then
            -- string.lower fails if passed nil
            return string.lower(str)
        else
            return str
        end
    end,

    Capitalize = function(str)
        return (StringUtil.Lower(str):gsub("^%l", StringUtil.Upper))
    end,

    Split = function(str, chr)
        local t = {}
        if chr == nil then
            chr = "%S+"
        end
        for v in string.gmatch(str, chr) do
            table.insert(t, v)
        end
        return t
    end,

    PadRight = function(str, len)
        local pad = str
        while (string.len(pad) < len) do
            pad = pad .. " "
        end
        return pad
    end,
}
