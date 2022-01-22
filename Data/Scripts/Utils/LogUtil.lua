LogUtil = {
    Print = function(message)
        local fn = print
        if System ~= nil then
            fn = System.LogAlways
        end
        fn(message)
    end,

    LogDebug = function(message, ...)
        LogUtil.Print(string.format("$3[DEBUG] ".. message, ...))
    end,

    LogWarning = function(message, ...)
        LogUtil.Print(string.format("$6[WARNING] ".. message, ...))
    end,

    LogError = function(message, ...)
        LogUtil.Print(string.format("$4[ERROR] ".. message, ...))
    end,

    LogInfo = function(message, ...)
        LogUtil.Print(string.format("$5[INFO] ".. message, ...))
    end,

    LogTable = function(tbl, header)
        if header ~= nil then
            LogUtil.Print(header)
        end
        for k,v in pairs(tbl) do
            LogUtil.Print(string.format("%s = %s", tostring(k), tostring(v)))
        end
    end,
}
