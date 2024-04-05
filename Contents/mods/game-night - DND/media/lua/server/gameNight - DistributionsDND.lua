require "Items/SuburbsDistributions"

local gameNightDistro = require "gameNight - Distributions"

gameNightDistro.proceduralDistGameNight.itemsToAdd["DNDBox"] = {}

gameNightDistro.gameNightBoxes["DNDBox"] = {
    rolls = 1,
    items = {
        "Dice4", 9999, "Dice6", 9999, "Dice8", 9999, "Dice10", 9999, "Dice12", 9999, "Dice20", 9999, "StellaOcta", 0.1,

        "Pencil", 9999, "Pencil", 9999, "Pencil", 9999, "Eraser", 9999, "Eraser", 9999, "Eraser", 9999,
        
        "CharacterSheet", 9999, "CharacterSheet", 9999, "CharacterSheet", 9999, "CharacterSheet", 9999, "CharacterSheet", 9999, "CharacterSheet", 9999,
        "CharacterSheet", 9999, "CharacterSheet", 9999, "CharacterSheet", 9999, "CharacterSheet", 9999, "CharacterSheet", 9999, "CharacterSheet", 9999,

        "DrawingPaper", 9999, "DrawingPaper", 9999, "DrawingPaper", 9999, "DrawingPaper", 9999, "DrawingPaper", 9999, "DrawingPaper", 9999,
        "DrawingPaper", 9999, "DrawingPaper", 9999, "DrawingPaper", 9999, "DrawingPaper", 9999, "DrawingPaper", 9999, "DrawingPaper", 9999,
        "DrawingPaper", 9999, "DrawingPaper", 9999, "DrawingPaper", 9999, "DrawingPaper", 9999, "DrawingPaper", 9999, "DrawingPaper", 9999,
        "DrawingPaper", 9999, "DrawingPaper", 9999, "DrawingPaper", 9999, "DrawingPaper", 9999, "DrawingPaper", 9999, "DrawingPaper", 9999,
    },
    junk = { rolls = 1, items = {} }, fillRand = 0,
}
