Ext.Require("Server/Helpers/Book.lua")

EHandlers = {}

FALLENS_MARK_BOOK_AS_READ = "c72d9f6a-a6e4-48b1-98c0-0ecdc7c31cf7"

function EHandlers.OnTeleportedToCamp(character)
  if Osi.IsInPartyWith(character, Osi.GetHostCharacter()) == 1 then
    ASRBTCPrint(2, "Sending existing Book to chest from " .. character)
    BookDelivery.SendInventoryBookToChest(character)
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
    BookDelivery.SendOwnedBookToChest(character, item)
  elseif Config:getCfg().FEATURES.instantly.mark_as_ware_instead.enabled then
    -- if Config:getCfg().FEATURES.instantly.mark_as_ware_instead.only_duplicates then
    --   ASRBTCPrint(2, "[NOT IMPLEMENTED] Checking if " .. item .. " is a duplicate.")
    -- end
    Ware.MarkAsWare(item)
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
