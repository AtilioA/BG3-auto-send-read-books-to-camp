Ext.Require("Server/Helpers/Book.lua")

EHandlers = {}

function EHandlers.OnTeleportedToCamp(character)
  if Osi.IsInPartyWith(character, Osi.GetHostCharacter()) == 1 then
    Utils.DebugPrint(2, "Sending existing Book to chest from " .. character)
    BookDelivery.SendInventoryBookToChest(character)
  end
end

function EHandlers.OnGameBookInterfaceClosed(item, character)
  Utils.DebugPrint(2, "GameBookInterfaceClosed event triggered.")
  BookDelivery.SendOwnedBookToChest(character, item)
end

return EHandlers
