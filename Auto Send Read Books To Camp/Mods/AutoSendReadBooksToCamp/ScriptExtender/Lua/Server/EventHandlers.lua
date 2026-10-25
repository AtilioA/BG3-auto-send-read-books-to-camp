EHandlers = {}

---@param character GUIDSTRING
function EHandlers.OnTeleportedToCamp(character)
    if Osi.IsInPartyWith(character, Osi.GetHostCharacter()) == 1 then
        BookHandler.ProcessInventoryBooks(character)
    end
end

function EHandlers.OnGameBookInterfaceClosed(item, character)
    ASRBTCPrint(2, "GameBookInterfaceClosed event triggered: " .. item .. " by " .. character)

    if not MCM.Get("process_instantly") then
        return
    end

    if BookHandler.IsBookItemRetainlisted(item) then
        ASRBTCPrint(2, "Item is retainlisted. Not processing.")
        return
    end

    BookHandler.ProcessPotentialMarkAsWare(character, item)
end

--- Fallen's MBAR compatibility

function EHandlers.OnTimerFinished(timer)
    if timer == "FMBR_LoadTimer" then
        EHandlers.TryToLoadFallenVars()
    end
end

function EHandlers.TryToLoadFallenVars()
    if (Ext.Mod.IsModLoaded(deps.FallensMBARModuleUUID)) then
        FMBRVars = Ext.Vars.GetModVariables(deps.FallensMBARModuleUUID)
        ASRBTCPrint(2, "MarkBookAsRead has been loaded successfully.")
    else
        ASRBTCWarn(0, "MarkBookAsRead mod is not loaded, mayhem will ensue.")
        -- Probably unnecessary, but just in case
        -- Osi.TimerLaunch("FMBR_LoadTimer", 10000)
    end
end

function EHandlers.OnLevelGameplayStarted()
    EHandlers.TryToLoadFallenVars()
end

function EHandlers.OnMCMSettingSaved(payload)
    if payload.modUUID == ModuleUUID and payload.settingId == "process_now" then
        BookHandler.ProcessInventoryBooks(Osi.GetHostCharacter())
    end
end

return EHandlers
