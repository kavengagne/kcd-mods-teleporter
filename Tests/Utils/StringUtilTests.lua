require("Tests.Testicle")
require("Data.Scripts.Utils.StringUtil")


StringUtilTests = {
    Test_Upper_Valid_String = function()
        local data = "test string"
        local expect = "TEST STRING"
        local result = StringUtil.Upper(data)
        assert(expect == result)
    end,
}
