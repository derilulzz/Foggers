--Some global game propertys
gameStuff = {
    --If the game is paused
    paused = false,
    --If the game needs to pause the frog creation
    pauseFroggCreation = false,
    --If the game can place frogs, used in the mega wave
    canPlaceFroggs = false,
    --If the player is hovering the top box
    hoveringTopBox = false,
    --The current game speed
    speed = 1,
    --If the player is playing for the first time AKA an save file dint existed in game start
    firstPlay = false,
    --The current language of the game
    lang = "eng",
    --The higest round of the game
    higestRound = 0,
    --The current starting round
    currentStartingRound = 0,
    --The current frog gaved, it is more used as an current round var
    currentFoggGaved = 0,
    --The current hp
    hp = 10,
    --If the game is using an fixed seed
    useFixedSeed = false,
    --The fixed seed to the game to use
    fixedSeed = 0,
    --If the music is looping
    musicLooping = false,
    --If the game should draw outlines
    drawOutlines = true,
    --The time since the game started
    timeSinceStart = 0,
    --The current sfx volume
    sfxVolume = 0.1,
    --The current music volume
    musicVolume = 0.25,
    --One value added to the music volume, used to make the music transition
    musicVolumeAdd = 0,
    --The current game version
    currentVersion = "0.0.1 Alpha",
    --If the game should pause for an event or something like that
    eventPause = false,
}