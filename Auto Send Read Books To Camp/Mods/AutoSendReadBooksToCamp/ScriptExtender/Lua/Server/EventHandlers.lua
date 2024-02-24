Ext.Require("Server/Helpers/Book.lua")

EHandlers = {}

FALLENS_MARK_BOOK_AS_READ = "c72d9f6a-a6e4-48b1-98c0-0ecdc7c31cf7"

function EHandlers.OnTeleportedToCamp(character)
  if Osi.IsInPartyWith(character, Osi.GetHostCharacter()) == 1 then
    Utils.DebugPrint(2, "Sending existing Book to chest from " .. character)
    BookDelivery.SendInventoryBookToChest(character)
  end
end

function EHandlers.OnTimerFinished(timer)
  if timer == "FMBR_LoadTimer" then
    EHandlers.TryToLoadFallenVars()
  end
end

function EHandlers.OnGameBookInterfaceClosed(item, character)
  Utils.DebugPrint(2, "GameBookInterfaceClosed event triggered.")
  BookDelivery.SendOwnedBookToChest(character, item)
end

function EHandlers.TryToLoadFallenVars()
  if (Ext.Mod.IsModLoaded(FALLENS_MARK_BOOK_AS_READ)) then
    FMBRVars = Ext.Vars.GetModVariables(FALLENS_MARK_BOOK_AS_READ)
    Utils.DebugPrint(2, "MarkBookAsRead has been loaded successfully.")
  else
    _D("[Auto Send Read Books To Camp][ERROR]: MarkBookAsRead mod is not loaded, mayhem will ensue.")
-- Probably unnecessary, but just in case
    Osi.TimerLaunch("FMBR_LoadTimer", 5000)
  end
end

function EHandlers.OnLevelGameplayStarted()
  EHandlers.TryToLoadFallenVars()
end

return EHandlers
