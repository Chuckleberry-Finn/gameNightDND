require "Items/SuburbsDistributions"

local gameNightDistro = require "gameNight - Distributions"

gameNightDistro.proceduralDistGameNight.itemsToAdd["DNDBox"] = {}

gameNightDistro.gameNightBoxes["DNDBox"] = {
    Dice_4 = 1, Dice_6 = 1, Dice_8 = 1, Dice_10 = 1, Dice_12 = 1, Dice_20 = 1, --StellaOcta = 0.1,
    Pencil = 3, Eraser = 3, CharacterSheet = 12, DrawingPaper = 24,
}
