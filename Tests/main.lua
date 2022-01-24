require("Tests.Testicle")
require("Tests.Utils.LinqTests")
require("Tests.Utils.LogUtilTests")
require("Tests.Utils.StringUtilTests")
require("Tests.Utils.TableUtilTests")
require("Tests.Utils.UtilTests")

local moduleNameRegex = "^Tests[\\.].*[\\.](.*Tests)"
local memberNameRegex = "^Test.*"
Testicle.RunTests(moduleNameRegex, memberNameRegex)
