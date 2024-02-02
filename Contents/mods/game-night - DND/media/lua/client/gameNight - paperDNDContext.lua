local paperContext = {}

local dndPaper = require "gameNight - paperDND"


function dndPaper:onPageSelect(pageChange)
    local map = self.mapObj
    local maxPage = map:getModData()["gameNight_paperPageMax"] or 1
    local page = math.min(maxPage, math.max(1,(map:getModData()["gameNight_paperPage"] or 1) + (pageChange or 0)))

    local texPath = "media/ui/"..map:getType()..page..".png"
    ---@type UIWorldMapV1
    local mapAPI = self.javaObject:getAPIv1()
    ---@type WorldMapStyleV1
    local styleAPI = mapAPI:getStyleAPI()
    ---@type WorldMapStyleV1.WorldMapTextureStyleLayerV1
    local layer = styleAPI:getLayerByName("paperDND")
    layer:removeAllTexture()
    layer:addTexture(0, texPath)

    local symbolsAPI = mapAPI:getSymbolsAPI()
    dndPaper.loadSymbols(map, symbolsAPI, page)

    map:getModData()["gameNight_paperPage"] = page
    dndPaper.updatePageButtons(self)
end


function dndPaper:updatePageButtons()
    local map = self.mapObj
    local page = map:getModData()["gameNight_paperPage"] or 1
    local maxPage = map:getModData()["gameNight_paperPageMax"] or 1
    self.prevPage.enable = not (page == 1)
    self.nextPage.enable = not (page == maxPage)
    self.pageLabel:setName(page.."/"..maxPage)
end
function dndPaper:onNextPage() dndPaper.onPageSelect(self,1) end
function dndPaper:onPrevPage() dndPaper.onPageSelect(self,-1) end


---@param symbolsAPI WorldMapSymbolsV1
function dndPaper.loadSymbols(map, symbolsAPI, newPage, noSave)

    local currentPage = map:getModData()["gameNight_paperPage"] or 1
    map:getModData()["gameNight_symbolsOnPage"] = map:getModData()["gameNight_symbolsOnPage"] or {}

    if noSave~=true then
        map:getModData()["gameNight_symbolsOnPage"][currentPage] = {}

        for i=0, symbolsAPI:getSymbolCount()-1 do
            ---@type WorldMapSymbolsV1.WorldMapBaseSymbolV1|WorldMapSymbolsV1.WorldMapTextSymbolV1|WorldMapSymbolsV1.WorldMapTextureSymbolV1
            local symbol = symbolsAPI:getSymbolByIndex(i)

            local symbolAdded = {
                r = symbol:getRed(),
                g = symbol:getGreen(),
                b = symbol:getBlue(),
                a = symbol:getAlpha(),
                x = symbol:getWorldX(),
                y = symbol:getWorldY()
            }

            if symbol:isTexture() then symbolAdded.symbolID = symbol:getSymbolID() end
            if symbol:isText() then symbolAdded.text = symbol:getTranslatedText() end

            table.insert(map:getModData()["gameNight_symbolsOnPage"][currentPage], symbolAdded)
        end
    end

    if newPage then
        symbolsAPI:clear()
        local newPageSymbols = map:getModData()["gameNight_symbolsOnPage"][newPage]
        if newPageSymbols then
            for _,symbol in ipairs(newPageSymbols) do

                local addedSymbol

                if symbol.symbolID then addedSymbol = symbolsAPI:addTexture(symbol.symbolID, symbol.x, symbol.y) end
                if symbol.text then addedSymbol = symbolsAPI:addTranslatedText(symbol.text, UIFont.Handwritten, symbol.x, symbol.y) end

                if addedSymbol then
                    addedSymbol:setRGBA(symbol.r, symbol.g, symbol.b, 1.0)
                    addedSymbol:setAnchor(0.5, 0.5)
                    addedSymbol:setScale(ISMap.SCALE)
                end
            end
        end
    end
end


function dndPaper.onCheckPaper(map, player)

    if dndPaper.instance and dndPaper.instance:isVisible() then return end

    local playerObj = getSpecificPlayer(player)
    if luautils.haveToBeTransfered(playerObj, map) then
        local action = ISInventoryTransferAction:new(playerObj, map, map:getContainer(), playerObj:getInventory())
        action:setOnComplete(dndPaper.onCheckPaper, map, player)
        ISTimedActionQueue.add(action)
        return
    end

    if JoypadState.players[player+1] then
        local inv = getPlayerInventory(player)
        local loot = getPlayerLoot(player)
        inv:setVisible(false)
        loot:setVisible(false)
    end

    local titleBarHgt = ISCollapsableWindow.TitleBarHeight()

    map:getModData()["gameNight_paperPage"] = map:getModData()["gameNight_paperPage"] or 1
    local paperPage = map:getModData()["gameNight_paperPage"]
    local maxPage = map:getModData()["gameNight_paperPageMax"] or 1

    local texPath = "media/ui/"..map:getType()..paperPage..".png"
    local texture = getTexture(texPath)
    if not texture then return end

    local paperX2, paperY2 = texture:getWidth()+10, texture:getHeight()+10+titleBarHgt
    local ratio = paperX2/paperY2
    local height = getPlayerScreenHeight(player)*0.66
    local width = (height * ratio)

    local centerX, centerY = (getPlayerScreenWidth(player)/2)-(width/2), (getPlayerScreenHeight(player)/2)-(height/2)

    local mapUI = ISMap:new(centerX, centerY, width+40, height+40, map, player)
    mapUI:initialise()

    dndPaper.instance = mapUI

    mapUI.pageLabel = ISLabel:new(mapUI:getWidth()-35, mapUI.ok.y-20, 16, paperPage.."/"..maxPage, 0, 0, 0, 0.8, UIFont.Small, true)
    mapUI.pageLabel:initialise()
    mapUI.pageLabel:instantiate()
    mapUI:addChild(mapUI.pageLabel)

    mapUI.nextPage = ISButton:new(mapUI:getWidth()-35, mapUI.ok.y, 25, mapUI.ok.height, getText(">"), mapUI, dndPaper.onNextPage)
    mapUI.nextPage:initialise()
    mapUI.nextPage:instantiate()
    mapUI.nextPage.borderColor = {r=1, g=1, b=1, a=0.4}
    mapUI:addChild(mapUI.nextPage)

    mapUI.prevPage = ISButton:new(mapUI.nextPage.x-29, mapUI.ok.y, 25, mapUI.ok.height, getText("<"), mapUI, dndPaper.onPrevPage)
    mapUI.prevPage:initialise()
    mapUI.prevPage:instantiate()
    mapUI.prevPage.borderColor = {r=1, g=1, b=1, a=0.4}
    mapUI:addChild(mapUI.prevPage)

    local wrap = mapUI:wrapInCollapsableWindow(map:getName(), false, ISMapWrapper)
    wrap:setInfo(getText("IGUI_Map_Info"))
    wrap:setWantKeyEvents(true)
    mapUI.wrap = wrap
    wrap.mapUI = mapUI

    wrap:setVisible(true)
    wrap:addToUIManager()
    wrap.infoButton:setVisible(false)

    ---@type UIWorldMapV1
    local mapAPI = mapUI.javaObject:getAPIv1()
    ---@type WorldMapStyleV1
    local styleAPI = mapAPI:getStyleAPI()

    local symbolsAPI = mapAPI:getSymbolsAPI()
    dndPaper.loadSymbols(map, symbolsAPI, paperPage, true)

    local layer = styleAPI:newTextureLayer("paperDND")
    layer:setMinZoom(25)
    layer:addFill(0, 255, 255, 255, 255)
    layer:addTexture(0, texPath)
    layer:setBoundsInSquares(10, 10, 10 + paperX2, 10 + paperY2)

    dndPaper.updatePageButtons(mapUI)

    if JoypadState.players[player+1] then setJoypadFocus(player, mapUI) end
end



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
            readOption.onSelect = dndPaper.onCheckPaper
            --context:addOption(getText("ContextMenu_CheckMap"), map, ISInventoryPaneContextMenu.onCheckMap, player)

            local renameOption = context:getOptionFromName(getText("ContextMenu_RenameMap"))
            renameOption.name = getText("ContextMenu_RenameBag")
            readOption.onSelect = dndPaper.onCheckPaper
            --context:addOption(getText("ContextMenu_RenameMap"), map, ISInventoryPaneContextMenu.onRenameMap, player)
        end
        break
    end
end

Events.OnFillInventoryObjectContextMenu.Add(paperContext.addInventoryItemContext)