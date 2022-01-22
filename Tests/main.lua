require("Tests.Testicle")
require("Tests.Utils.LinqTests")
require("Tests.Utils.LogUtilTests")
require("Tests.Utils.StringUtilTests")
require("Tests.Utils.TableUtilTests")
require("Tests.Utils.UtilTests")

-- Add Colors
local moduleNameRegex = "^Tests[\\.].*[\\.](.*Tests)"
local memberNameRegex = "^Test.*"
local testModules = Testicle.DiscoverTests(moduleNameRegex, memberNameRegex)
Testicle.RunTests(testModules)
