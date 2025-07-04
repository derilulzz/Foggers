

musics = {
    love.audio.newSource("Musics/Musik1.mp3", "stream"),
    love.audio.newSource("Musics/TutMusPart1.mp3", "stream"),
    love.audio.newSource("Musics/Transitions/TutMusPart1To2.mp3", "stream"),
    love.audio.newSource("Musics/TutMusPart2.mp3", "stream"),
    love.audio.newSource("Musics/Transitions/TutMusPart2To3.mp3", "stream"),
    love.audio.newSource("Musics/TutMusPart3.mp3", "stream"),
    love.audio.newSource("Musics/Game/MainGameMus.mp3", "stream"),
}
currentMusic = 1
transitioningMusic = false
musicToSet = 0


function playMusic(whatMusic)
    musics[currentMusic]:stop()
    currentMusic = whatMusic
    musics[currentMusic]:play()
end


function musicUpdate()
    if transitioningMusic then
        if not musics[currentMusic]:isPlaying() then
            gameStuff.musicLooping = true
            playMusic(musicToSet)
            transitioningMusic = false
        end
    end
end


function stopMusic()
    musics[currentMusic]:stop()
end


function playRandomMusic()
    local oldCurrentMusic = currentMusic
    currentMusic = math.random(1, #musics)
    while currentMusic == oldCurrentMusic do
        currentMusic = math.random(1, #musics)
    end


    musics[currentMusic]:play()
end