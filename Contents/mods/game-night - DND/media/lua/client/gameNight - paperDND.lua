local dndPaper = {}

require 'Maps/ISMapDefinitions'


dndPaper.types = {}
function dndPaper.isValid(itemType) return (dndPaper.types[itemType]) end


function dndPaper.applyPaperInit(itemType)
    
    local buffer = 10
    local x2, y2 = 1482+buffer, 2020+buffer

    LootMaps.Init["gameNight_"..itemType] = function(mapUI)
        local mapAPI = mapUI.javaObject:getAPIv1()
        MapUtils.initDirectoryMapData(mapUI, 'media/maps/Muldraugh, KY')
        mapAPI:setBoundsInSquares(buffer, buffer, x2, y2)
    end

    dndPaper.types[itemType] = true
end


return dndPaper