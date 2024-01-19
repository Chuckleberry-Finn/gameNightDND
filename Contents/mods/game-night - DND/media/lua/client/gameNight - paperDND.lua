local dndPaper = {}

require 'Maps/ISMapDefinitions'

function dndPaper.overlayPNG(mapUI, x, y, scale, layerName, tex, alpha)
    local texture = getTexture(tex)
    if not texture then return end
    local mapAPI = mapUI.javaObject:getAPIv1()
    local styleAPI = mapAPI:getStyleAPI()
    local layer = styleAPI:newTextureLayer(layerName)
    layer:setMinZoom(25)
    layer:addFill(0, 255, 255, 255, (alpha or 1.0) * 255)
    layer:addTexture(0, tex)
    layer:setBoundsInSquares(x, y, x + texture:getWidth() * scale, y + texture:getHeight() * scale)
end


function dndPaper.applyPaperInit(itemType)

    local paperX1, paperY1 = 10, 10
    local texture = getTexture("media/ui/"..itemType..".png")
    local paperX2, paperY2 = texture:getWidth()+10, texture:getHeight()+10

    LootMaps.Init["gameNight_"..itemType] = function(mapUI)
        local mapAPI = mapUI.javaObject:getAPIv1()
        MapUtils.initDirectoryMapData(mapUI, 'media/maps/Muldraugh, KY')
        mapAPI:setBoundsInSquares(paperX1, paperY1, paperX2, paperY2)
        dndPaper.overlayPNG(mapUI, paperX1, paperY1, 1.0, "lootMapPNG", "media/ui/"..itemType..".png", 1.0)
    end
end


return dndPaper