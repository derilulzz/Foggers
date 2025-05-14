require "external librarys.base64"


function saveGame(isFullscreen, lang, sfxVol, musVol, higestRound)
    data = {}
    data.isFullscreen = isFullscreen
    data.lang = lang
    data.sfxVol = sfxVol
    data.musVol = musVol
    data.higestRound = higestRound
    serialized = Lume.serialize(data)


    --serialized = enc(serialized)


    love.filesystem.write("GameSave.FoggersSaveFile", serialized)
end


function loadGame()
    --read the data
    file = love.filesystem.read("GameSave.FoggersSaveFile")


    if file == nil then data = {} else
        --file = dec(file)
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
    end
end