local function SubscribeToEvents()
  if JsonConfig.GENERAL.enabled then
    Utils.DebugPrint(2, "Subscribing to events with JSON config: " .. Ext.Json.Stringify(JsonConfig, { Beautify = true }))

    Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "before", EHandlers.OnLevelGameplayStarted)
    Ext.Osiris.RegisterListener("TimerFinished", 1, "after", EHandlers.OnTimerFinished)

    Ext.Osiris.RegisterListener("TeleportedToCamp", 1, "before", EHandlers.OnTeleportedToCamp)

    if JsonConfig.FEATURES.instantly.enabled or JsonConfig.FEATURES.instantly.mark_as_ware_instead.enabled then
      Ext.Osiris.RegisterListener("GameBookInterfaceClosed", 2, "after", EHandlers.OnGameBookInterfaceClosed)
    end
  end
end

return {
  SubscribeToEvents = SubscribeToEvents
}
