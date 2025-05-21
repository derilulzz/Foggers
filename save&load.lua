require "external librarys.base64"


function saveGame(isFullscreen, lang, sfxVol, musVol, higestRound, useGameOST, drawOutlines)
    data = {}
    data.isFullscreen = isFullscreen
    data.lang = lang
    data.sfxVol = sfxVol
    data.musVol = musVol
    data.higestRound = higestRound
    data.useGameOST = useGameOST
    data.drawOutlines = drawOutlines


    serialized = Lume.serialize(data)


    serialized = enc(serialized)


    love.filesystem.write("GameSave.FoggersSaveFile", serialized)
end


function loadGame()
    --read the data
    file = love.filesystem.read("GameSave.FoggersSaveFile")


    if file == nil then data = {}; gameStuff.firstPlay = true else
        file = dec(file)
        print("Save stats:\n" .. file)
        data = Lume.deserialize(file)
    end


    if data then
        if data.isFullscreen ~= nil then
            love.window.setFullscreen(data.isFullscreen)
        end
        if data.lang ~= nil then
            gameStuff.lang = data.lang
        end
        if data.sfxVol ~= nil then
            gameStuff.sfxVolume = data.sfxVol
        end
        if data.musVol ~= nil then
            gameStuff.musicVolume = data.musVol
        end
        if data.higestRound ~= nil then
            gameStuff.higestRound = data.higestRound
        end
        if data.drawOutlines ~= nil then
            gameStuff.drawOutlines = data.drawOutlines
        end
        if data.useGameOST ~= nil then
            gameStuff.useOST = data.useGameOST
        end
    end
end