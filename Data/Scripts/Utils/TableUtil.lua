TableUtil = {
    Index = function(tbl, value)
        for i, v in ipairs(tbl) do
            if v == value then
                return i
            end
        end
        return nil
    end,

    Keys = function(tbl)
        local ks = {}
        for key,_ in pairs(tbl) do
            table.insert(ks, key)
        end
        return ks
    end,

    Values = function(tbl, prop)
        local vals = {}
        for _,value in pairs(tbl) do
            table.insert(vals, value[prop])
        end
        return vals
    end,

    Max = function(tbl)
        local maxx = 0
        for _,value in pairs(tbl) do
            if value > maxx then
                maxx = value
            end
        end
        return maxx
    end,
}
