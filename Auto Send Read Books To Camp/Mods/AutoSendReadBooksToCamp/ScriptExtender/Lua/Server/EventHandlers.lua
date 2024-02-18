Ext.Require("Server/Helpers/Book.lua")

EHandlers = {}

function EHandlers.OnLevelGameplayStarted()
  if JsonConfig.FEATURES.send_existing_Book.enabled and JsonConfig.FEATURES.send_existing_Book.create_supply_sack then
    Osi.TimerLaunch("CreateSupplySackTimer", 1500)
  end
end

function CreateSupplySack()
  Utils.DebugPrint(2, "CreateSupplySackTimer: creating supply sack.")
  AddSupplySackToCampChestIfMissing()
end

function EHandlers.OnTeleportedToCamp(character)
  if Osi.IsInPartyWith(character, Osi.GetHostCharacter()) == 1 then
    Utils.DebugPrint(2, "Sending existing Book to chest from " .. character)
    BookDelivery.SendInventoryBookToChest(character)
  end
end

return EHandlers
