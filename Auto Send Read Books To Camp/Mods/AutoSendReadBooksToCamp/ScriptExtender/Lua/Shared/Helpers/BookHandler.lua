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
  local isQuestItem = VCHelpers.Inventory:IsProbablyQuestItem(bookItem)
  local isMarkedAsWare = VCHelpers.Ware:IsWare(bookItem)

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
  if VCHelpers.Inventory:IsItemInPartyInventory(item) and not BookHandler.IsBookItemRetainlisted(item) then
    BookHandler.DeliverBook(item)
  end
end

function BookHandler.SendInventoryBookToChest(character)
  -- NOTE: unused (not present in config options)
  local shallow = Config:getCfg().FEATURES.ignore.nested

  local books = VCHelpers.Book:GetBooksInInventory(character, shallow)
  if books ~= nil then
    for _, item in ipairs(books) do
      ASRBTCPrint(2, "Found book in " .. VCHelpers.Loca:GetDisplayName(character) .. "'s inventory: " .. item)
      BookHandler.SendOwnedBookToChest(character, item)
    end
  end
end

function BookHandler.MarkInventoryBooksAsWare(character)
  -- NOTE: unused (not present in config options)
  local shallow = Config:getCfg().FEATURES.ignore.nested

  local books = VCHelpers.Book:GetBooksInInventory(character, shallow)
  if books ~= nil then
    for _, item in ipairs(books) do
      ASRBTCPrint(2, "Found book in " .. VCHelpers.Loca:GetDisplayName(character) .. "'s inventory: " .. item)
      if not Config:getCfg().FEATURES.mark_as_ware_instead.only_duplicates or (Config:getCfg().FEATURES.mark_as_ware_instead.only_duplicates and VCHelpers.Inventory:IsItemInCampChest(item)) then
        VCHelpers.Ware:MarkAsWare(item)
        ASRBTCPrint(1, "Item is a duplicate. Marking as ware.")
      else
        ASRBTCPrint(2, "Item is not a duplicate. Not marking as ware.")
      end
    end
  end
end

--- Send book to camp chest
---@param object any The item to deliver.
function BookHandler.DeliverBook(object)
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
    ASRBTCWarn(0, "'MarkBookAsRead' mod is not loaded. Not sending to camp chest.")
    return
  end
end

return BookHandler
