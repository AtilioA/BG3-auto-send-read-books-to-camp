Config = Helpers.Config:New({
    folderName = "AutoSendReadBooksToCamp",
    configFilePath = "auto_send_read_books_to_camp_config.json",
    defaultConfig = {
        GENERAL = {
            enabled = true, -- Toggle the mod on/off
        },
        FEATURES = {
            instantly = {
                enabled = false, -- Move books right after reading them (instead of waiting for teleport to camp)
            },
            mark_as_ware_instead = {
                enabled = true,         -- Mark books as wares after reading them. Will be ignored if `instantly.enabled` is set to true
                only_duplicates = true, -- Only mark duplicate books as wares
            },
            ignore = {
                quest = true, -- Ignore quest books
                wares = true, -- Ignore books marked as wares
                nested = true, -- Ignore books in containers
            },
        },
        DEBUG = {
            level = 0 -- 0 = no debug, 1 = minimal, 2 = verbose logs
        }
    }
})

Config:UpdateCurrentConfig()

Config:AddConfigReloadedCallback(function(configInstance)
    ASRBTCPrinter.DebugLevel = configInstance:GetCurrentDebugLevel()
    ASRBTCPrint(0, "Config reloaded: " .. Ext.Json.Stringify(configInstance:getCfg(), { Beautify = true }))
end)
Config:RegisterReloadConfigCommand("asrbtc")
