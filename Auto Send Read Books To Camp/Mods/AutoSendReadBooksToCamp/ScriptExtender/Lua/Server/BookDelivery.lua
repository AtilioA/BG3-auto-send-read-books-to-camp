BookDelivery = {}

BookDelivery.ignore_item = {
  item = nil,
  reason = nil
}

BookDelivery.retainlist = {
  quests = { ['Quest_CON_OwlBearEgg'] = '374111f7-6756-4f5f-b6e3-e45e8d25def0' },
  healing = {
    ['UNI_CONS_Goodberry'] = 'de6b186e-839e-41d0-87af-a1a9d9327785',
    ['GEN_CONS_Berry'] = 'b0943b65-5766-414a-903d-28de8790370a',
    ['QUEST_GOB_SuspiciousMeat'] = 'f57ad063-af4c-411c-9c91-9ca02cd57dd4',
    ['DEN_UNI_Thieflings_Gruel'] = 'f91f8f13-44d0-4fd0-8cc1-1ec08356f98a'
    -- ['CONS_Book_Fruit_Apple_A'] = 'e8bbe73a-e1dc-4d2e-910f-318db7aee382',
  },
  weapons = {
    ['WPN_HUM_Salami_A'] = 'e082f373-81ec-4f4b-818b-9ee86952e2fa'
  }
}

-- Don't move items that are in the retainlist according to settings
function BookDelivery.IsBookItemRetainlisted(bookItem)
  local bookItemGuid = Utils.GetUID(bookItem)
  if bookItemGuid == nil then
    Utils.DebugPrint(1, "[ERROR] Couldn't verify if item is retainlisted. bookItemGuid is nil.")
    return false
  end

  local isQuestItem = IsProbablyQuestItem(bookItem)

  if isQuestItem then
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

function BookDelivery.SendInventoryBookToChest(character)
  -- local campChestSack = GetCampChestSupplySack()
  local shallow = not JsonConfig.FEATURES.nested_containers

  local Book = GetBookInInventory(character, shallow)
  if Book ~= nil then
    for _, item in ipairs(Book) do
      Utils.DebugPrint(2, "Found Book in " .. character .. "'s inventory: " .. item)
      if not BookDelivery.IsBookItemRetainlisted(item) then
        BookDelivery.DeliverBook(item, character)
      end
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
  if FMBRVars.readBooks[bookID] then
    Utils.DebugPrint(1, "Book " .. object .. " has been read. Sending to camp chest.")
    BookDelivery.MoveToCampChest(object)
  else
    Utils.DebugPrint(2, "Book " .. object .. " has not been read. Not sending to camp chest.")
    return
  end
end

return BookDelivery
