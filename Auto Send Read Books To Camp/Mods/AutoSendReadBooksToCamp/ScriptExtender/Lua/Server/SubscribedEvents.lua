local function SubscribeToEvents()
  if JsonConfig.GENERAL.enabled == true then
    Utils.DebugPrint(2, "Subscribing to events with JSON config: " .. Ext.Json.Stringify(JsonConfig, { Beautify = true }))

    Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "before", EHandlers.OnLevelGameplayStarted)
    Ext.Osiris.RegisterListener("TimerFinished", 1, "after", EHandlers.OnTimerFinished)

    Ext.Osiris.RegisterListener("TeleportedToCamp", 1, "before", EHandlers.OnTeleportedToCamp)

    if JsonConfig.FEATURES.instantly == true then
      Ext.Osiris.RegisterListener("GameBookInterfaceClosed", 2, "after", EHandlers.OnGameBookInterfaceClosed)
    end
  end
end

return {
  SubscribeToEvents = SubscribeToEvents
}
