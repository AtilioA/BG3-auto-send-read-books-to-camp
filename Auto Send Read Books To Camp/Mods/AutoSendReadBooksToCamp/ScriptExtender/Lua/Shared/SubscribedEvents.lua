SubscribedEvents = {}

function SubscribedEvents.SubscribeToEvents()
  if Config:getCfg().GENERAL.enabled then
    ASRBTCPrint(2,
      "Subscribing to events with JSON config: " .. Ext.Json.Stringify(Config:getCfg(), { Beautify = true }))

    -- Load Fallen vars when game is loaded
    Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "before", EHandlers.OnLevelGameplayStarted)
    Ext.Osiris.RegisterListener("TimerFinished", 1, "after", EHandlers.OnTimerFinished)

    -- Keep Fallen vars loaded after a reset
    Ext.Events.ResetCompleted:Subscribe(EHandlers.TryToLoadFallenVars)

    Ext.Osiris.RegisterListener("TeleportedToCamp", 1, "before", EHandlers.OnTeleportedToCamp)

    Ext.Osiris.RegisterListener("GameBookInterfaceClosed", 2, "after", EHandlers.OnGameBookInterfaceClosed)
  end
end

return SubscribedEvents
