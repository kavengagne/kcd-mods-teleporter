kgutil = {
    print = function(message)
        local fn = print
        if System ~= nil then
            fn = System.LogAlways
        end
        fn(message)
    end,
    
    indexOf = function(array, value)
        for i, v in ipairs(array) do
            if v == value then
                return i
            end
        end
        return nil
    end,

    keys = function(tbl)
        local ks = {}
        for key,_ in pairs(tbl) do
            table.insert(ks, key)
        end
        return ks
    end,
    
    values = function(tbl, prop)
        local vals = {}
        for _,value in pairs(tbl) do
            table.insert(vals, value[prop])
        end
        return vals
    end,
    
    map = function(tbl, f)
        local t = {}
        for k,v in pairs(tbl) do
              t[k] = f(v)
        end
        return t
    end,
    
    filter = function(tbl, f)
        local t = {}
        for k,v in pairs(tbl) do
            if f({ key = k, value = v }) then
                table.insert(t, v)
            end
        end
        return t
    end,
    
    max = function(tbl)
        local maxx = 0
        for _,value in pairs(tbl) do
            if value > maxx then
                maxx = value
            end
        end
        return maxx
    end,
    
    isBlank = function(value)
        return value == nil or value == ''
    end,
    
    logDebug = function(message, ...)
        kgutil.print(string.format("$3[DEBUG] ".. message, ...))
    end,

    logWarning = function(message, ...)
        kgutil.print(string.format("$6[WARNING] ".. message, ...))
    end,
    
    logError = function(message, ...)
        kgutil.print(string.format("$4[ERROR] ".. message, ...))
    end,
    
    logInfo = function(message, ...)
        kgutil.print(string.format("$5[INFO] ".. message, ...))
    end,
    
    logTable = function(tbl, header)
        if header ~= nil then
            kgutil.print(header)
        end
        for k,v in pairs(tbl) do
            kgutil.print(string.format("%s = %s", tostring(k), tostring(v)))
        end
    end,
    
    upper = function(str)
        if not kgutil.isBlank(str) then
            -- string.upper fails if passed nil
            return string.upper(str)
        else
            return str
        end
    end,
    
    lower = function(str)
        if not kgutil.isBlank(str) then
            -- string.lower fails if passed nil
            return string.lower(str)
        else
            return str
        end
    end,
    
    capitalize = function(str)
        return (kgutil.lower(str):gsub("^%l", string.upper))
    end,
    
    split = function(str, chr)
        local t = {}
        if chr == nil then
            chr = "%S+"
        end
        for v in string.gmatch(str, chr) do
            table.insert(t, v)
        end
        return t
    end,
    
    padRight = function(str, len)
        local pad = str
        while (string.len(pad) < len) do
            pad = pad .. " "
        end
        return pad
    end,
    
    formatCoords = function(x, y, z)
        return string.format("X: %d, Y: %d, Z: %d", x, y, z)
    end,
    
    formatCoords2 = function(coords)
        return string.format("X: %d, Y: %d, Z: %d", coords.x, coords.y, coords.z)
    end,
}
