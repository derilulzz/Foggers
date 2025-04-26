require "external librarys.base64"


function saveGame(isFullscreen, lang, sfxVol, musVol)
    data = {}
    data.isFullscreen = isFullscreen
    data.lang = lang
    data.sfxVol = sfxVol
    data.musVol = musVol
    serialized = Lume.serialize(data)


--    serialized = enc(serialized)


    love.filesystem.write("GameSave.FOGGSAVE", serialized)
end


function loadGame()
    --read the data
    file = love.filesystem.read("GameSave.FOGGSAVE")
    
    
    if file == nil then data = {} else
--        file = dec(file)
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
    end
end