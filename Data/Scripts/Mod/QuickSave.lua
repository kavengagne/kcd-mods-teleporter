QuickSave = {
    CmdQuicksave = function()
        Game.RemoveSaveLock()
        if not Game.IsLoadingEngineSaveGame() then
            Game.SaveGameViaResting()
        end
    end,
}
