require("Tests.Testicle")
require("Data.Scripts.Utils.Linq")


LinqTests = {
    -- Select
    Test_Select_Property_Exists_Table = function()
        local data = {
            { name = "Paul", age = 72 },
            { name = "Jean-Marie", age = 46 },
            { name = "Victorien", age = 86 },
            { name = "Henry", age = 64 },
            { name = "Gratien", age = 68     },
        }
        local expect = { "Paul", "Jean-Marie", "Victorien", "Henry", "Gratien" }
        local result = Linq.Select(data, function(k, v) return v.name end)
        assert(Testicle.EqualsTable(expect, result))
    end,

    Test_Select_Property_Exists_Dictionary = function()
        local data = {
            Paul = { name = "Paul", age = 72 },
            JeanMarie = { name = "Jean-Marie", age = 46 },
            Victorien = { name = "Victorien", age = 86 },
            Henry = { name = "Henry", age = 64 },
            Gratien = { name = "Gratien", age = 68     },
        }
        local expect = {
            Paul = "Paul",
            JeanMarie = "Jean-Marie",
            Victorien = "Victorien",
            Henry = "Henry",
            Gratien = "Gratien"
        }
        local result = Linq.Select(data, function(k, v) return v.name end)
        assert(Testicle.EqualsTable(expect, result))
    end,

    Test_Select_Property_NotExists = function()
        local data = {
            { name = "Paul", age = 72 },
            { name = "Jean-Marie", age = 46 },
            { name = "Victorien", age = 86 },
            { name = "Henry", age = 64 },
            { name = "Gratien", age = 68     },
        }
        local expect = {}
        local result = Linq.Select(data, function(k, v) return v.tttt end)
        assert(#expect == #result)
    end,

    Test_Select_Table_Empty = function()
        local data = {}
        local expect = {}
        local result = Linq.Select(data, function(k, v) return v.name end)
        assert(#expect == #result)
    end,

    Test_Select_Table_Nil = function()
        local data = nil
        local expect = false
        local result, err = pcall(function() return Linq.Select(data, function(k, v) return v.name end) end)
        assert(expect == result)
        assert(err ~= nil)
    end,


    -- Where
    Test_Where_Property_Exists_Table = function()
        local data = {
            { name = "Paul", age = 72 },
            { name = "Jean-Marie", age = 46 },
            { name = "Victorien", age = 86 },
            { name = "Henry", age = 64 },
            { name = "Gratien", age = 68     },
        }
        local expect = {
            { name = "Paul", age = 72 },
            { name = "Victorien", age = 86 },
        }
        local result = Linq.Where(data, function(k, v) return v.age > 70 end)
        local paulAndVic = result[1].name == "Paul" and result[2].name == "Victorien"
        local vicAndPaul = result[2].name == "Paul" and result[1].name == "Victorien"
        assert(result ~= nil)
        assert(#result == 2)
        assert(paulAndVic or vicAndPaul)
    end,
}
