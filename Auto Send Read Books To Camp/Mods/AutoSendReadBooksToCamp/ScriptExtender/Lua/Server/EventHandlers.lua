EHandlers = {}

---@param character GUIDSTRING
function EHandlers.OnTeleportedToCamp(character)
    if Osi.IsInPartyWith(character, Osi.GetHostCharacter()) == 1 then
        BookHandler.ProcessInventoryBooks(character)
    end
end

function EHandlers.OnGameBookInterfaceClosed(item, character)
    ASRBTCPrint(2, "GameBookInterfaceClosed event triggered: " .. item .. " by " .. character)

    if not MCMGet("process_instantly") then
        return
    end

    if BookHandler.IsBookItemRetainlisted(item) then
        ASRBTCPrint(2, "Item is retainlisted. Not processing.")
        return
    end

    local markBooksAsWaresInstead = MCMGet("mark_as_ware_instead")
    local markOnlyDuplicateBooks = MCMGet("mark_only_duplicates")

    if markOnlyDuplicateBooks then
        local isBookDuplicate = VCHelpers.Inventory:IsItemInCampChest(item)
        if isBookDuplicate then
            ASRBTCPrint(1, "Book is a duplicate. Marking as ware.")
            return VCHelpers.Ware:MarkAsWare(item)
        else
            ASRBTCDebug(1, "Item " .. item .. " is not a duplicate; sending to chest.")
            return BookHandler.SendBookToChest(character, item)
        end
    elseif markBooksAsWaresInstead then
        ASRBTCPrint(1, "Marking read book as ware.")
        return VCHelpers.Ware:MarkAsWare(item)
    else
        return BookHandler.SendBookToChest(character, item)
    end
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
