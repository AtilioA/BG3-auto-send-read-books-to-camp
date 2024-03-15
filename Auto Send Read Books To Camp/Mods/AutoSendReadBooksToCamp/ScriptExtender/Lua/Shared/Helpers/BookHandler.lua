BookHandler = {}

-- Don't move items that are in the retainlist according to settings
function BookHandler.IsBookItemRetainlisted(bookItem)
  if bookItem == nil then
    ASRBTCPrint(1, "[ERROR] Couldn't verify if item is retainlisted. bookItemGuid is nil.")
    return false
  end

  ASRBTCPrint(2,
    "Checking if item is a quest/story item: " ..
    bookItem .. " (" .. type(bookItem) .. ")" .. " - " .. Osi.IsStoryItem(bookItem))
  local isQuestItem = Helpers.Inventory:IsProbablyQuestItem(bookItem)
  local isMarkedAsWare = Helpers.Ware:IsWare(bookItem)

  if Config:getCfg().FEATURES.ignore.quest and isQuestItem then
    ASRBTCPrint(2, "Item is a quest/story item. Not trying to send to chest.")
    return true
  elseif Config:getCfg().FEATURES.ignore.wares and isMarkedAsWare then
    ASRBTCPrint(2, "Item is marked as ware. Not trying to send to chest.")
    return true
  else
    ASRBTCPrint(2, "Item is not a quest/story item. May try to send to chest.")
  end

  return false
end

function BookHandler.ProcessBook(item)
  if not BookHandler.IsBookItemRetainlisted(item) then
    ASRBTCPrint(1, "Moving " .. item .. " to camp chest.")
    return Osi.SendToCampChest(item, Osi.GetHostCharacter())
  end
end

function BookHandler.SendOwnedBookToChest(character, item)
  if Helpers.Inventory:IsItemInPartyInventory(item) and not BookHandler.IsBookItemRetainlisted(item) then
    BookHandler.DeliverBook(item, character)
  end
end

function BookHandler.SendInventoryBookToChest(character)
  -- local campChestSack = GetCampChestSupplySack()
  local shallow = not Config:getCfg().FEATURES.nested_containers

  local Book = Helpers.Book:GetBookInInventory(character, shallow)
  if Book ~= nil then
    for _, item in ipairs(Book) do
      ASRBTCPrint(2, "Found book in " .. character .. "'s inventory: " .. item)
      BookHandler.SendOwnedBookToChest(character, item)
    end
  end
end

function BookHandler.MarkInventoryBookAsWare(character)
  -- local campChestSack = GetCampChestSupplySack()
  local shallow = not Config:getCfg().FEATURES.nested_containers

  local Book = Helpers.Book:GetBookInInventory(character, shallow)
  if Book ~= nil then
    for _, item in ipairs(Book) do
      ASRBTCPrint(2, "Found book in " .. character .. "'s inventory: " .. item)
      if Config:getCfg().FEATURES.mark_as_ware_instead.only_duplicates and not Helpers.Inventory:IsItemInCampChest(item) then
        ASRBTCPrint(2, "Item is not a duplicate. Not marking as ware.")
        return
      end
      Helpers.Ware:MarkAsWare(item)
    end
  end
end

--- Send Book to camp chest or supply sack.
---@param object any The item to deliver.
---@param from any The inventory to deliver from.
function BookHandler.DeliverBook(object, from)
  local bookID = Osi.GetBookID(object)
  if FMBRVars then
    if FMBRVars.readBooks[bookID] then
      ASRBTCPrint(1, "Book " .. object .. " has been read. Sending to camp chest.")
      BookHandler.ProcessBook(object)
    else
      ASRBTCPrint(2, "Book " .. object .. " has not been read. Not sending to camp chest.")
      return
    end
  else
    ASRBTCPrint(0, "MarkBookAsRead mod is not loaded. Not sending to camp chest.")
    return
  end
end

return BookHandler
