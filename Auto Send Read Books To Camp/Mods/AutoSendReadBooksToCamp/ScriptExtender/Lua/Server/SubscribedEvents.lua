SubscribedEvents = {}

function SubscribedEvents.SubscribeToEvents()
    local function conditionalWrapper(handler)
        return function(...)
            if MCM.Get("mod_enabled") then
                handler(...)
            else
                ASRBTCDebug(1, "Event handling is disabled.")
            end
        end
    end

    ASRBTCDebug(2,
        "Subscribing to events with JSON config: " ..
        Ext.Json.Stringify({
            mod_enabled = MCM.Get("mod_enabled"),
            debug_level = MCM.Get("debug_level"),
            process_now = MCM.Get("process_now"),
            process_instantly = MCM.Get("process_instantly"),
            mark_as_ware_instead = MCM.Get("mark_as_ware_instead"),
            mark_only_duplicates = MCM.Get("mark_only_duplicates"),
            ignore_quest = MCM.Get("ignore_quest"),
            ignore_wares = MCM.Get("ignore_wares"),
            ignore_nested = MCM.Get("ignore_nested"),
        }, { Beautify = true }))

    -- Load Fallen vars when game is loaded
    Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", conditionalWrapper(EHandlers.OnLevelGameplayStarted))
    -- Ext.Osiris.RegisterListener("TimerFinished", 1, "after", conditionalWrapper(EHandlers.OnTimerFinished))

    -- Keep Fallen vars loaded after a reset
    Ext.Events.ResetCompleted:Subscribe(conditionalWrapper(EHandlers.TryToLoadFallenVars))

    Ext.Osiris.RegisterListener("TeleportedToCamp", 1, "after", conditionalWrapper(EHandlers.OnTeleportedToCamp))

    Ext.Osiris.RegisterListener("GameBookInterfaceClosed", 2, "after", conditionalWrapper(EHandlers.OnGameBookInterfaceClosed))

    Ext.ModEvents.BG3MCM['MCM_Setting_Saved']:Subscribe(conditionalWrapper(EHandlers.OnMCMSettingSaved))
end

return SubscribedEvents
