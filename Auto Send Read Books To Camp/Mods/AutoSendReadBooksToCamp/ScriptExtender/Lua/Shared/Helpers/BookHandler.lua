BookHandler = {}

-- add user-defined retainlist?

-- Check if item is in retainlist according to settings
---@param bookItem string
---@return boolean
function BookHandler.IsBookItemRetainlisted(bookItem)
    if bookItem == nil then
        ASRBTCWarn(1, "[ERROR] Couldn't verify if item is retainlisted. bookItemGuid is nil.")
        return false
    end

    ASRBTCDebug(2,
        "Checking if item is a quest/story item: " ..
        bookItem .. " (" .. type(bookItem) .. ")" .. " - " .. Osi.IsStoryItem(bookItem))
    local isQuestItem = VCHelpers.Inventory:IsProbablyQuestItem(bookItem)
    local isMarkedAsWare = VCHelpers.Ware:IsWare(bookItem)

    if MCMGet("ignore_quest") and isQuestItem then
        ASRBTCPrint(2, "Item is a quest/story item. Not trying to send to chest.")
        return true
    elseif MCMGet("ignore_wares") and isMarkedAsWare then
        ASRBTCPrint(2, "Item is marked as ware. Not trying to send to chest.")
        return true
    else
        ASRBTCPrint(2, "Item is not a quest/story item. May try to send to chest.")
    end

    return false
end

--- Check if the item (book) has been read.
---@param object any The item to check
function BookHandler.HasBeenRead(object)
    local bookID = Osi.GetBookID(object)

    if FMBRVars then
        if FMBRVars.readBooks[bookID] then
            ASRBTCPrint(1, "Book " .. object .. " has been read and ready for processing.")
            return true
        else
            ASRBTCPrint(2, "Book " .. object .. " has not been read, should not be processed.")
            return false
        end
    else
        ASRBTCWarn(0, "'MarkBookAsRead' mod is not loaded. Not processing book. Mayhem will ensue.")
        return false
    end
end

--- Check if the item (book) should be processed: not retainlisted and has been read.
---@param item any The item to check
---@return boolean
function BookHandler.ShouldBeProcessed(item)
    if BookHandler.IsBookItemRetainlisted(item) then
        ASRBTCPrint(2, "Item is retainlisted. Not processing.")
        return false
    elseif not BookHandler.HasBeenRead(item) then
        ASRBTCPrint(2, "Item has not been read. Not processing.")
        return false
    end

    return true
end

function BookHandler.SendBookToChest(character, item)
    return Osi.SendToCampChest(item, Osi.GetHostCharacter())
end

---@param character GUIDSTRING
function BookHandler.ProcessInventoryBooks(character)
    local shallow = MCMGet("ignore_nested")
    local books = VCHelpers.Book:GetBooksInInventory(character, shallow)

    if books ~= nil then
        for _, item in ipairs(books) do
            ASRBTCPrint(2, "Found book in " .. VCHelpers.Loca:GetDisplayName(character) .. "'s inventory: " .. item)
            BookHandler.ProcessBook(character, item)
        end
    end
end

---@param character GUIDSTRING
---@param item EntityHandle
function BookHandler.ProcessBook(character, item)
    if VCHelpers.Inventory:IsItemInPartyInventory(item) and BookHandler.ShouldBeProcessed(item) then
        BookHandler.ProcessPotentialMarkAsWare(character, item)
    end
end

---@param character GUIDSTRING
---@param item EntityHandle
function BookHandler.ProcessPotentialMarkAsWare(character, item)
    local markAllAsWare = not MCMGet('mark_only_duplicates')
    local isDuplicate = VCHelpers.Inventory:IsItemInCampChest(item) ~= nil
    local markAsWareInstead = MCMGet('mark_as_ware_instead')

    if markAsWareInstead and (markAllAsWare or isDuplicate) then
        VCHelpers.Ware:MarkAsWare(item)
        if markAllAsWare then
            ASRBTCTest(1, "Marking as ware without checking for duplicates.")
        elseif isDuplicate then
            ASRBTCTest(1, "Book is a duplicate. Marking as ware.")
        else
            ASRBTCTest(1, "Book is not a duplicate; marking it as ware instead of sending to chest.")
        end
    else
        ASRBTCPrint(2, "Book is not a duplicate; sending it to chest.")
        BookHandler.SendBookToChest(character, item)
    end
end

return BookHandler
