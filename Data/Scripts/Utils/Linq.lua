Linq = {
    Select = function(tbl, selector)
        if selector == nil then
            error("The selector function must be provided.")
        end
        local result = {}
        for key,value in pairs(tbl) do
            local data = selector(key, value)
            if data ~= nil then
                result[key] = data
            end
        end
        return result
    end,

    Where = function(tbl, predicate)
        if predicate == nil then
            error("The predicate function must be provided.")
        end
        local result = {}
        for key,value in pairs(tbl) do
            if predicate(key, value) then
                table.insert(result, value)
            end
        end
        return result
    end,
}