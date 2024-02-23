BookDelivery = {}

-- Don't move items that are in the retainlist according to settings
function BookDelivery.IsBookItemRetainlisted(bookItem)
  local bookItemGuid = Utils.GetUID(bookItem)
  if bookItemGuid == nil then
    Utils.DebugPrint(1, "[ERROR] Couldn't verify if item is retainlisted. bookItemGuid is nil.")
    return false
  end

  local isQuestItem = IsProbablyQuestItem(bookItem)

  if JsonConfig.FEATURES.ignore.quest and isQuestItem then
    Utils.DebugPrint(2, "Item is a quest/story item. Not trying to send to chest.")
    return true
  else
    Utils.DebugPrint(2, "Item is not a quest/story item. May try to send to chest.")
  end

  return false
end

function BookDelivery.MoveToCampChest(item)
  if not BookDelivery.IsBookItemRetainlisted(item) then
    Utils.DebugPrint(1, "Moving " .. item .. " to camp chest.")
    return Osi.SendToCampChest(item, Osi.GetHostCharacter())
  end
end

function BookDelivery.SendOwnedBookToChest(character, item)
  if IsItemInPartyInventory(item) and not BookDelivery.IsBookItemRetainlisted(item) then
    BookDelivery.DeliverBook(item, character)
  end
end

function BookDelivery.SendInventoryBookToChest(character)
  -- local campChestSack = GetCampChestSupplySack()
  local shallow = not JsonConfig.FEATURES.nested_containers

  local Book = GetBookInInventory(character, shallow)
  if Book ~= nil then
    for _, item in ipairs(Book) do
      Utils.DebugPrint(2, "Found Book in " .. character .. "'s inventory: " .. item)
      BookDelivery.SendOwnedBookToChest(character, item)
    end
  end
end

--- Send Book to camp chest or supply sack.
---@param object any The item to deliver.
---@param from any The inventory to deliver from.
---@param campChestSack any The supply sack to deliver to.
function BookDelivery.DeliverBook(object, from, campChestSack)
  -- If object is in
  local bookID = Osi.GetBookID(object)
  if FMBRVars then
    if FMBRVars.readBooks[bookID] then
      Utils.DebugPrint(1, "Book " .. object .. " has been read. Sending to camp chest.")
      BookDelivery.MoveToCampChest(object)
    else
      Utils.DebugPrint(2, "Book " .. object .. " has not been read. Not sending to camp chest.")
      return
    end
  else
    Utils.DebugPrint(0, "MarkBookAsRead mod is not loaded. Not sending to camp chest.")
    return
  end
end

return BookDelivery
