SubscribedEvents = {}

function SubscribedEvents.SubscribeToEvents()
    local function conditionalWrapper(handler)
        return function(...)
            if MCMGet("mod_enabled") then
                handler(...)
            else
                ASRBTCDebug(1, "Event handling is disabled.")
            end
        end
    end

    ASRBTCDebug(2,
        "Subscribing to events with JSON config: " ..
        Ext.Json.Stringify(Mods.BG3MCM.MCMAPI:GetAllModSettings(ModuleUUID), { Beautify = true }))

    -- Load Fallen vars when game is loaded
    Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "before", conditionalWrapper(EHandlers.OnLevelGameplayStarted))
    -- Ext.Osiris.RegisterListener("TimerFinished", 1, "after", conditionalWrapper(EHandlers.OnTimerFinished))

    -- Keep Fallen vars loaded after a reset
    Ext.Events.ResetCompleted:Subscribe(conditionalWrapper(EHandlers.TryToLoadFallenVars))

    Ext.Osiris.RegisterListener("TeleportedToCamp", 1, "before", conditionalWrapper(EHandlers.OnTeleportedToCamp))

    Ext.Osiris.RegisterListener("GameBookInterfaceClosed", 2, "after", conditionalWrapper(EHandlers.OnGameBookInterfaceClosed))

    Ext.ModEvents.BG3MCM['MCM_Setting_Saved']:Subscribe(conditionalWrapper(EHandlers.OnMCMSettingSaved))
end

return SubscribedEvents
