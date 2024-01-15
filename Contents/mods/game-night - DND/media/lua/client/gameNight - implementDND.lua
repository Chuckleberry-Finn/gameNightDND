-- GAME PIECES
---First require this file so that the gamePieceAndBoardHandler module can be called on.
local gamePieceAndBoardHandler = require "gameNight - gamePieceAndBoardHandler"

---Register game pieces by type -- enables the system to display the items using custom textures found in:
--- `Item_InPlayTextures` and `Item_OutOfPlayTextures`
--- Note: In-Play defaults to Out of play textures. Out of play textures replaces the item's texture/icon.
gamePieceAndBoardHandler.registerTypes({"Base.StellaOcta","Base.Dice4", "Base.Dice6", "Base.Dice8", "Base.Dice10", "Base.Dice12", "Base.Dice20"})


---Because I hate copy pasted code - this iterates through the side values and registers their special actions.
local sides = {4,6,8,10,12,20}
for _,side in pairs(sides) do
    gamePieceAndBoardHandler.registerSpecial("Base.Dice"..side, { actions = { rollDie=side }, shiftAction = "rollDie", })
end

gamePieceAndBoardHandler.registerSpecial("Base.StellaOcta", { actions = { rollDie=1 }, shiftAction = "rollDie", })