require("Tests.TesticlePolyfills")

local function Bind(fn, ...)
    local args = {...}
    return function()
        return fn(table.unpack(args))
    end
end

local function Iif(cond, trueval, falseval)
    local eval = function(value)
        if type(value) == "function" then
            return value()
        else
            return value
        end
    end
    if cond then
        return eval(trueval)
    else
        return eval(falseval)
    end
end

local function Plural(condOrCount)
    local condition = condOrCount
    if type(condOrCount) == "number" then
        condition = condition ~= 1
    end
    return Iif(condition, "s", "")
end

local FgColors = { Black=30, Red=31, Green=32, Yellow=33, Blue=34, Magenta=35, Cyan=36, White=37 }
local BgColors = { Black=40, Red=41, Green=42, Yellow=43, Blue=44, Magenta=45, Cyan=46, White=47 }
local function Color(str, fg, bg)
    bg = Iif(bg ~= nil, Bind(string.format, ";%d", bg), "")
    return string.format("\27[%d%sm%s%s", fg, bg, str, "\27[0m")
end

local function GetLoadedModules(moduleNameExpression)
    local modules = {}
    for name,loaded in pairs(package.loaded) do
        local moduleName = string.match(name, moduleNameExpression)
        if moduleName ~= nil and loaded == true then
            local module = package.loaded._G[moduleName]
            if module ~= nil then
                table.insert(modules, { name = name, module = module })
            end
        end
    end
    table.sort(modules, function(a, b) return a.name < b.name end)
    return modules
end

local function RunTests_ShowHeader(modules)
    print("-----------------------------")
    print("Testicle Unit Testing Library")
    print("-----------------------------")

    local testsCount = 0
    for _,module in ipairs(modules) do
        testsCount = testsCount + #module.tests
    end
    local testsPart = Color(string.format("%d Test%s", testsCount, Plural(testsCount)), FgColors.Yellow)
    local modulesPart = Color(string.format("%d Module%s", #modules, Plural(#modules)), FgColors.Cyan)
    print(string.format("Found %s in %s.", testsPart, modulesPart))
end

local function RunTests_ShowFooter(results)
    print()
    local succeededPart = Color("Succeeded", FgColors.Green)
    local failedPart = Color("Failed", FgColors.Red)
    print(string.format("Results [%s: %d, %s: %d]", succeededPart, results.succeeded, failedPart, results.failed))
    print()
end

local function RunTests_Discover(moduleNameExpression, testNameExpression)
    local functions = {}
    local modules = GetLoadedModules(moduleNameExpression)
    for _,value in ipairs(modules) do
        local moduleTests = {}
        for memberName,member in pairs(value.module) do
            local isTestMember = string.match(memberName, testNameExpression)
            if isTestMember ~= nil and type(member) == "function" then
                table.insert(moduleTests, { name = memberName, test = member })
            end
        end
        table.sort(moduleTests, function(a, b) return a.name < b.name end)
        table.insert(functions, { name = value.name, tests = moduleTests })
    end
    return functions
end

local function RunTests_Execute(test, testName)
    local testPart = Color(testName, FgColors.Yellow)
    io.write(string.format("    %s. Running... ", testPart))
    local success, err = pcall(test)
    if success then
        print(Color("Succeeded", FgColors.Green) .. ".")
    else
        print(Color("Failed", FgColors.Red) .. ".")
        print(Color("        " .. err, FgColors.Red))
    end
    return success
end

local function RunTests_RunModule(module)
    local results = { succeeded = 0, failed = 0 }
    local modulePart = Color(module.name, FgColors.Cyan)
    print()
    print(string.format("%s (%d Test%s)", modulePart, #module.tests, Plural(#module.tests)))
    for _,test in ipairs(module.tests) do
        if RunTests_Execute(test.test, test.name) then
            results.succeeded = results.succeeded + 1
        else
            results.failed = results.failed + 1
        end
    end
    return results
end

local function RunTests(moduleNameRegex, memberNameRegex)
    local modules = RunTests_Discover(moduleNameRegex, memberNameRegex)
    RunTests_ShowHeader(modules)
    local results = { succeeded = 0, failed = 0 }
    for _,module in ipairs(modules) do
        local moduleResult = RunTests_RunModule(module)
        results.succeeded = results.succeeded + moduleResult.succeeded
        results.failed = results.failed + moduleResult.failed
    end
    RunTests_ShowFooter(results)
end

local function EqualsTable(tbl1, tbl2)
    if (#tbl1 ~= #tbl2) then
        return false
    end
    for key,value in pairs(tbl1) do
        local value2 = tbl2[key]
        if value ~= value2 then
            return false
        end
    end
    return true
end


Testicle = {
    RunTests = RunTests,
    EqualsTable = EqualsTable
}
