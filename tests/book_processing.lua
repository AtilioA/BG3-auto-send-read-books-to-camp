local luaRoot = "Auto Send Read Books To Camp/Mods/AutoSendReadBooksToCamp/ScriptExtender/Lua/"
local settings
local duplicate
local actions

MCM = {
    Get = function(id) return settings[id] end,
}

local function silent() end
ASRBTCPrint = silent
ASRBTCTest = silent
ASRBTCDebug = silent

-- Dependency fixtures cover routing only; no engine APIs are replaced.
VCHelpers = {
    Inventory = {
        IsItemInCampChest = function() return duplicate end,
        IsItemInPartyInventory = function() return true end,
    },
    Book = {
        GetBooksInInventory = function() return { "read-book" } end,
    },
    Ware = {
        MarkAsWare = function(_, item)
            actions[#actions + 1] = "ware:" .. item
        end,
    },
    Loca = {
        GetDisplayName = function(_, character) return character end,
    },
}

dofile(luaRoot .. "Server/Helpers/BookHandler.lua")
dofile(luaRoot .. "Server/EventHandlers.lua")

-- Engine-facing mod operations are outside this decision test.
BookHandler.IsBookItemRetainlisted = function() return false end
BookHandler.HasBeenRead = function() return true end
BookHandler.SendBookToChest = function(_, item)
    actions[#actions + 1] = "camp:" .. item
end

local function run(name, operation, expected)
    settings = {
        process_instantly = true,
        mark_as_ware_instead = true,
        mark_only_duplicates = true,
        ignore_nested = true,
    }
    duplicate = false
    actions = {}
    operation()
    local actual = table.concat(actions, ",")
    assert(actual == expected, name .. ": expected " .. expected .. ", got " .. actual)
    print("PASS " .. name)
end

run("camp inventory sends a unique read book", function()
    BookHandler.ProcessInventoryBooks("reader")
end, "camp:read-book")

local scenarios = {
    { wares = true, onlyDuplicates = true, duplicate = false, expected = "camp:read-book" },
    { wares = true, onlyDuplicates = true, duplicate = true, expected = "ware:read-book" },
    { wares = true, onlyDuplicates = false, duplicate = false, expected = "ware:read-book" },
    { wares = true, onlyDuplicates = false, duplicate = true, expected = "ware:read-book" },
    { wares = false, onlyDuplicates = true, duplicate = false, expected = "camp:read-book" },
    { wares = false, onlyDuplicates = true, duplicate = true, expected = "camp:read-book" },
    { wares = false, onlyDuplicates = false, duplicate = false, expected = "camp:read-book" },
    { wares = false, onlyDuplicates = false, duplicate = true, expected = "camp:read-book" },
}

for index, scenario in ipairs(scenarios) do
    local function configure()
        settings.mark_as_ware_instead = scenario.wares
        settings.mark_only_duplicates = scenario.onlyDuplicates
        duplicate = scenario.duplicate
    end
    run("camp inventory settings case " .. index, function()
        configure()
        BookHandler.ProcessInventoryBooks("reader")
    end, scenario.expected)
    run("book close settings case " .. index, function()
        configure()
        EHandlers.OnGameBookInterfaceClosed("read-book", "reader")
    end, scenario.expected)
end

run("book close leaves books alone when instant processing is disabled", function()
    settings.process_instantly = false
    EHandlers.OnGameBookInterfaceClosed("read-book", "reader")
end, "")

run("book close honors disabled wares with duplicate-only still enabled", function()
    settings.mark_as_ware_instead = false
    duplicate = true
    EHandlers.OnGameBookInterfaceClosed("read-book", "reader")
end, "camp:read-book")
