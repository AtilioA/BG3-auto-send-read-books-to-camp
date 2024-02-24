Ware = {}

function Ware.IsWare(object)
  if type(object) == "string" then
    local objectEntity = Ext.Entity.Get(object)
    if objectEntity ~= nil then
      return objectEntity.ServerItem and objectEntity.ServerItem.DontAddToHotbar == true
    end
  elseif type(object) == "userdata" then
    return object.ServerItem and object.ServerItem.DontAddToHotbar == true
  end

  return false
end

function Ware.MarkAsWare(item)
  if not IsProbablyQuestItem(item) then
    if type(item) == "string" then
      Utils.DebugPrint(2, "Marking " .. item .. " as ware")
      local itemEntity = Ext.Entity.Get(item)
      if itemEntity and itemEntity.ServerItem then
        itemEntity.ServerItem.DontAddToHotbar = true
      end
    elseif type(item) == "userdata" then
      Utils.DebugPrint(2, "Marking item entity as ware")
      if item.ServerItem then
        item.ServerItem.DontAddToHotbar = true
      end
    end
  else
    Utils.DebugPrint(2, "Not marking " .. item .. " as ware because it is a quest item")
  end
end

return Ware
