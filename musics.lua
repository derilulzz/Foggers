

musics = {
    love.audio.newSource("Musics/Musik1.mp3", "stream"),
    love.audio.newSource("Musics/Musik2.mp3", "stream"),
--    love.audio.newSource("Musics/Musik3.mp3", "stream"),
}
currentMusic = 1


function playMusic(whatMusic)
    currentMusic = whatMusic
    musics[currentMusic]:play()
end



function playRandomMusic()
    local oldCurrentMusic = currentMusic
    currentMusic = math.random(1, #musics)
    while currentMusic == oldCurrentMusic do
        currentMusic = math.random(1, #musics)
    end


    musics[currentMusic]:play()
end