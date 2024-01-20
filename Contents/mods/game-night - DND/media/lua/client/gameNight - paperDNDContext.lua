local paperContext = {}

local dndPaper = require "gameNight - paperDND"

---@param context ISContextMenu
function paperContext.addInventoryItemContext(playerID, context, items)
    local playerObj = getSpecificPlayer(playerID)

    for _, v in ipairs(items) do

        ---@type InventoryItem
        local item = v
        local stack
        if not instanceof(v, "InventoryItem") then
            stack = v
            item = v.items[1]
        end

        local isDNDPaper = dndPaper.isValid(item:getType())
        if isDNDPaper then

            local readOption = context:getOptionFromName(getText("ContextMenu_CheckMap"))
            readOption.name = getText("ContextMenu_Read")
            --context:addOption(getText("ContextMenu_CheckMap"), map, ISInventoryPaneContextMenu.onCheckMap, player);

            local renameOption = context:getOptionFromName(getText("ContextMenu_RenameMap"))
            renameOption.name = getText("ContextMenu_RenameBag")
            --context:addOption(getText("ContextMenu_RenameMap"), map, ISInventoryPaneContextMenu.onRenameMap, player);
        end
        break
    end
end

Events.OnFillInventoryObjectContextMenu.Add(paperContext.addInventoryItemContext)