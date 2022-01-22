Util = {
    IsBlank = function(value)
        return value == nil or value == ''
    end,

    FormatCoords = function(x, y, z)
        return string.format("X: %d, Y: %d, Z: %d", x, y, z)
    end,
}
