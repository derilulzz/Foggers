require "external librarys.base64"


function saveGame(isFullscreen, lang, sfxVol, musVol, higestRound, drawOutlines, targetFps, useVSync, permaMoneyMult,
                  permaCarAmount, permaCarDamage, permaCarSpeed, permaFrogAmount)
    data = {}
    data.isFullscreen = isFullscreen
    data.lang = lang
    data.sfxVol = sfxVol
    data.musVol = musVol
    data.higestRound = higestRound
    data.drawOutlines = drawOutlines
    data.targetFps = targetFps
    data.useVSync = useVSync
    data.permaMoneyMult = permaMoneyMult
    data.permaCarAmount = permaCarAmount
    data.permaCarDamage = permaCarDamage
    data.permaCarSpeed = permaCarSpeed
    data.permaFrogAmount = permaFrogAmount


    local serialized = Lume.serialize(data)


    serialized = enc(serialized)


    love.filesystem.write("GameSave.FoggersSaveFile", serialized)
end


function loadGame()
    --read the data
    local file = love.filesystem.read("GameSave.FoggersSaveFile")


    if file == nil then
        data = {}; gameStuff.firstPlay = true
    else
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
        if data.targetFps ~= nil then
            targetFps = data.targetFps
            frameTime = 1 / targetFps
        end
        if data.useVSync ~= nil then
            setVSyncUse(data.useVSync)
        end
        if data.permaMoneyMult ~= nil then
            permaUpgrades.permaMoneyMult = data.permaMoneyMult
        end
        if data.permaCarAmount ~= nil then
            permaUpgrades.permaCarAmount = data.permaCarAmount
        end
        if data.permaCarDamage ~= nil then
            permaUpgrades.permaCarDamage = data.permaCarDamage
        end
        if data.permaCarSpeed ~= nil then
            permaUpgrades.permaCarSpeed = data.permaCarSpeed
        end
        if data.permaFrogAmount ~= nil then
            permaUpgrades.permaFrogAmount = data.permaFrogAmount
        end
    end
end
