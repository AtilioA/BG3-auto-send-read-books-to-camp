EHandlers = {}

FALLENS_MARK_BOOK_AS_READ = "c72d9f6a-a6e4-48b1-98c0-0ecdc7c31cf7"

-- TODO: mark duplicates as wares
function EHandlers.OnTeleportedToCamp(character)
  if Osi.IsInPartyWith(character, Osi.GetHostCharacter()) == 1 then
    if Config:getCfg().FEATURES.mark_as_ware_instead.enabled then
      ASRBTCPrint(2, "Marking existing books from " .. VCHelpers.Loca:GetDisplayName(character) .. " as wares")
      BookHandler.MarkInventoryBooksAsWare(character)
    else
      ASRBTCPrint(2, "Sending existing books from " .. VCHelpers.Loca:GetDisplayName(character) .. " to camp chest")
      BookHandler.SendInventoryBookToChest(character)
    end
  end
end

function EHandlers.OnTimerFinished(timer)
  if timer == "FMBR_LoadTimer" then
    EHandlers.TryToLoadFallenVars()
  end
end

function EHandlers.OnGameBookInterfaceClosed(item, character)
  ASRBTCPrint(2, "GameBookInterfaceClosed event triggered: " .. item .. " by " .. character)
  if Config:getCfg().FEATURES.instantly.enabled then
    if not Config:getCfg().FEATURES.mark_as_ware_instead.enabled then
      return BookHandler.SendOwnedBookToChest(character, item)
    else
      if Config:getCfg().FEATURES.mark_as_ware_instead.only_duplicates and not VCHelpers.Inventory:IsItemInCampChest(item) then
        ASRBTCDebug(1, "Item " .. item .. " is not a duplicate, not marking as ware.")
        return
      end
      return VCHelpers.Ware:MarkAsWare(item)
    end
  end
end

function EHandlers.TryToLoadFallenVars()
  if (Ext.Mod.IsModLoaded(FALLENS_MARK_BOOK_AS_READ)) then
    FMBRVars = Ext.Vars.GetModVariables(FALLENS_MARK_BOOK_AS_READ)
    ASRBTCPrint(2, "MarkBookAsRead has been loaded successfully.")
  else
    ASRBTCWarn(0, "MarkBookAsRead mod is not loaded, mayhem will ensue.")
    -- Probably unnecessary, but just in case
    Osi.TimerLaunch("FMBR_LoadTimer", 10000)
  end
end

function EHandlers.OnLevelGameplayStarted()
  EHandlers.TryToLoadFallenVars()
end

return EHandlers
