Book = {}

function IsBook(object)
  return Osi.GetBookID(object) ~= nil
end

--- Gets all Book items in a character's inventory.
---@param character any character to check.
---@param shallow boolean If true, recursively checks inside bags and containers.
---@return table | nil - table of Book items in the character's inventory, or nil if none found.
function GetBookInInventory(character, shallow)
  local inventory = GetInventory(character, false, shallow)
  local matchedItems = {}

  for _, item in ipairs(inventory) do
    local itemObject = item.TemplateName .. item.Guid
    if IsBook(itemObject) then
      table.insert(matchedItems, itemObject)
    end
  end

  if #matchedItems > 0 then
    return matchedItems
  else
    return nil
  end
end

return Book
