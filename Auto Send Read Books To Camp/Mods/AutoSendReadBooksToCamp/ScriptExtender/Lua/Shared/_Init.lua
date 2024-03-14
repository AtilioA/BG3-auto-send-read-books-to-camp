setmetatable(Mods.AutoSendReadBooksToCamp, { __index = Mods.VolitionCabinet })

---Ext.Require files at the path
---@param path string
---@param files string[]
function RequireFiles(path, files)
    for _, file in pairs(files) do
        Ext.Require(string.format("%s%s.lua", path, file))
    end
end

RequireFiles("Shared/", {
    "Helpers/_Init",
    "EventHandlers",
    "SubscribedEvents",
})

local VCModuleUUID = "f97b43be-7398-4ea5-8fe2-be7eb3d4b5ca"
if (not Ext.Mod.IsModLoaded(VCModuleUUID)) then
    Ext.Utils.Print("VOLITION CABINET HAS NOT BEEN LOADED. PLEASE MAKE SURE IT IS ENABLED IN YOUR MOD MANAGER.")
end

Ext.Require("Server/Utils.lua")
Ext.Require("Server/Helpers/Ware.lua")
Ext.Require("Server/Helpers/Inventory.lua")
Ext.Require("Server/Config.lua")
Ext.Require("Server/BookDelivery.lua")
Ext.Require("Server/EventHandlers.lua")

local MODVERSION = Ext.Mod.GetMod(ModuleUUID).Info.ModVersion

if MODVERSION == nil then
    ASRBTCWarn(0, "Volitio's Auto Send Read Books To Camp loaded (version unknown)")
else
    -- Remove the last element (build/revision number) from the MODVERSION table
    table.remove(MODVERSION)

    local versionNumber = table.concat(MODVERSION, ".")
    ASRBTCPrint(0, "Volitio's Auto Send Read Books To Camp version " .. versionNumber .. " loaded")
end

SubscribedEvents.SubscribeToEvents()