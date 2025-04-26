explosionSfx = love.audio.newSource("Sfxs/Explosion.wav", "static")
moneyGainSfx = love.audio.newSource("Sfxs/Gain.wav", "static")
interactSfx = love.audio.newSource("Sfxs/Int.mp3", "static")
modChangeSfx = love.audio.newSource("Sfxs/ModChange.wav", "static")
warningSfx = love.audio.newSource("Sfxs/Warning.wav", "static")


function playSound(whatSound)
    if whatSound:isPlaying() then
        whatSound:stop()
        whatSound:play()
    else
        whatSound:play()
    end
end