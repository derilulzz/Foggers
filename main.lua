--Require the external librarys
Push = require "external librarys.push"
Lume = require "external librarys.lume"
Flux = require "external librarys.flux"
Patchy = require "external librarys.lovepatch"
utf8 = require "utf8"
Lovepatch = require "external librarys.lovepatch"


--Set the filter to make the textures not look blurry
love.graphics.setDefaultFilter("nearest", "nearest")


--Require all the other files in the project and the debugger
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end
require "effects"
require "cars"
require "animations"
require "ui_stuff"
require "forg"
require "fonts"
require "table_stuff"
require "backgrounds"
require "shaders"
require "mouse"
require "mainMenu"
require "pause"
require "save&load"
require "sounds"
require "musics"
require "startThing"
require "events"
require "colorStuff"
require "credits"
require "Tutorial.tutorial"
require "Bag.bag"
require "tips"
require "StartingOptions.startingOptions"
require "SourceCodeRoom.source"
require "CarStatsInstance.carStats"
require "Mods.mods"
require "FUCKINGMETH"


--All the game car instances
GameCarInstances = {}
--All the cars infos
GameCars = {
    createCar(
        "Common Car",
        "Carro Comum",
        "An common red car for your frog killing adventure. Kills 2 frogs, deals 1 damage",
        "Um carro vermelho comum para o seu assasinato de sapos. Mata 2 sapos, da 1 de dano",
        newAnimation(
            love.graphics.newImage("Sprs/Cars/Basic Car.png"),
            20,
            20,
            0,
            0,
            0
        ), {},
        4,
        400,
        1,
        1,
        4,
        100,
        1,
        1,
        128,
        {},
        carsCategorys.Common
    ),
    createCar(
        "Truck",
        "Caminhao",
        "One truck that for sure will run over an anime girl anytime. Kills 4 frogs, deals 2 damage",
        "Um caminhao que vai com certeza matar uma menina de anime em algum momento. Mata 4 sapos, da 2 de dano",
        newAnimation(
            love.graphics.newImage("Sprs/Cars/Truck.png"),
            20,
            20,
            0,
            0,
            0
        ), {},
        4.5,
        200,
        2,
        0.5,
        4,
        200,
        2,
        2,
        256,
        {},
        carsCategorys.Common
    ),
    createCar(
        "Sport Car",
        "Carro Esportivo",
        "One luxurious car for rich people or for broke people that want to look rich. Kills 10 frogs, deals 0.5 damage",
        "Um carro luxuoso para pessoas ricas ou para pessoas pobres que querem parecer ricas. Mata 10 sapos, da 0.5 de dano",
        newAnimation(
            love.graphics.newImage("Sprs/Cars/Sport Car.png"),
            21,
            20,
            0,
            0,
            0
        ), {},
        3,
        1000,
        0.5,
        2,
        20,
        400,
        1,
        1.5,
        64,
        {},
        carsCategorys.Common
    ),
    createCar(
        "Seller Car",
        "Carro Vendedor",
        "One seller car to enforce capitalism and inequality for everyone! After 5 seconds it gives you 20 for every frog you killed in that 5 seconds",
        "Um carro vendedor para enforcar o capitalismo e desigualdade para todos! Depois de 5 segundos te da 20 para cada sapo que você matou nesses 5 segundos",
        newAnimation(
            love.graphics.newImage("Sprs/Cars/Seller Car.png"),
            20,
            20,
            0,
            0,
            0
        ), {},
        3,
        50,
        0,
        1,
        1,
        400,
        1,
        1,
        64,
        {
            seller = true,
            recieveCooldownDef = 1,
            recieveCooldown = 1,
        },
        carsCategorys.MoneyGenerator
    ),
    createCar(
        "Dinamite Car",
        "Carro Dinamite",
        "One dinamite car that makes an big explosion. Where he got these dinamites? no one knows! :). Gives no damage",
        "Um carro dinamite que faz uma grande explosao. Aonde ele pegou essas dinamites? ninguem sabe! :). Não da dano",
        newAnimation(
            love.graphics.newImage("Sprs/Cars/Explosive Car.png"),
            20,
            20,
            0,
            0,
            0
        ), {},
        3,
        250,
        0,
        1,
        1,
        50,
        0.1,
        999,
        512,
        {
            explosive = true,
        },
        carsCategorys.Explosive
    ),
    createCar(
        "Cat Car",
        "Carro Gato",
        "One cat car that sometimes lets one cat escape. Cats chases 2 frogs before dying and the car kills only 2 frogs",
        "Um carro de gatos que deixa um gato escapar algumas vezes. Os gatos matam 2 sapos antes de morrerem e o carro mata apenas 2 sapos",
        newAnimation(
            love.graphics.newImage("Sprs/Cars/Cat Car.png"),
            32,
            20,
            0,
            0,
            0
        ), {},
        3,
        250,
        0.5,
        1,
        4,
        600,
        1,
        2,
        256,
        {
            cats = true,
            catCreateDelay = 1,
            catCreateDelayDef = 1,
        },
        carsCategorys.Special
    ),
    createCar(
        "Tank",
        "Tanque",
        "One military grade tank to you annihilate all frogs. Kills 16 frogs, deals 20 damage",
        "Um tanque militar para você aniquilar todos os sapos. Mata 16 sapos, da 20 de dano",
        newAnimation(
            love.graphics.newImage("Sprs/Cars/TankBottom.png"),
            128,
            128,
            0,
            0,
            0
        ),
        {
            love.graphics.newImage("Sprs/Cars/TankTop.png"),
        },
        1,
        85,
        20,
        0,
        16,
        1800,
        999999999,
        9999999,
        1080,
        {
            shoots = true,
            cooldown = 1,
            cooldownDef = 1,
            weaponRot = 0,
            isTank = true,
            bulletCreateFunction = createTankBullet,
            dir = 0,
            target = "Frogs",
        },
        carsCategorys.Military
    ),
}
--The propertys of the car selection box
upBoxStuff = { x = -1, y = 0, w = 802, h = 128, scrollX = 0, scrollVel = 1 }
--The last key pressed in the keyboard
lastKeyPressed = ""
--If the keyboard was pressed or not
keyboardWasPressed = false
--All the game ui stuff (buttons, text buttons, etc...)
UiStuff = {}
--The current mouse scroll value in the x and y
mouseScroll = { x = 0, y = 0 }
--The propertys for placing cars (the max x and the min x)
placingStuff = {
    minX = 0,
    maxX = 800,
}
--The game mouse pos passed thro "Push", it needs to be used to make the mouse pos be scaled with the game
--And the pos is affected by the camera, if you dont want that, use "PushsInGameMousePosNoTransform"
PushsInGameMousePos = { x = 0, y = 0 }
--The game pos scaled with "Push" but not transformed by the camera
PushsInGameMousePosNoTransform = { x = 0, y = 0 }
--If the mouse left button was pressed in the last frame, used to make someting like the "mouse_check_button_pressed" in game maker
--But instead you make "if LastLeftMouseButton == false and love.mouse.isDown(1) then"
LastLeftMouseButton = false
--The last main menu theme
oldMainMenuTheme = 0
--If the mouse right button was pressed in the last frame, used to make someting like the "mouse_check_button_pressed" in game maker
--But instead you make "if LastRightMouseButton == false and love.mouse.isDown(2) then"
LastRightMouseButton = false
--The car buttons that stay at the top of the screen, there is an special table for this just because
--It is problaby better to make it like this instead of doing some hacky shit
gameCarButtons = {}
--The table of cars buttons used for drawing them, it has an separated table because doing it in the same table makes some shit to happen
gameCarButtonsDraw = {}
--The car used to show inside the game as the example car, you know, that transparent thing that shows when you're placing a car
currentSelectedCar = nil
--The current car selected id, it is NOT the car showed in the game, this is an number, OK?
selectedCar = 1
--If the player is placing an car or not
placingCar = false
--All the frogs that are active rn. Dont ask me why they in various places are called "fogs"
Foggs = {}
--One global angle is used for "math.sin"s or "math.cos"s functions
--It is created to make the developing process faster by not creating an "angle"
--variable in every fucking instace i make
GlobalSinAngle = 0
--The distance between the grids to place the cars
carGridLockDist = 64
--The default value for the timer to create the frogs
foggCreateTimerDef = 5
--The timer for creating a new frog, when it reaches 0, resets to "foggCreateTimerDef"
foggCreateTimer = foggCreateTimerDef
--The propertys used for the "mega wave"
megaWave = {
    --The timer until the mega wave
    timer = 60,
    --The default value to reset the mega wave timer AKA "megaWave.timer" to
    timerDef = 60,
    --The force of the wave, AKA the number of frogs to create
    force = 16,
    --If the mega wave is running
    enabled = false,
}
--One table created to just dump in some shit that will be updated and drawed
gameInstances = {}
--The y position used to draw and place the car
yForCar = math.floor(PushsInGameMousePos.y / carGridLockDist) * carGridLockDist
--The global delta time, used to make timer decrease in seconds intead of frames
globalDt = 1
--One random number, used ONLY for the main menu theme, because apparently love.random and love.math.random dont works well in the main menu init funtion
randomNumber = math.random(1, 4)
--THIS VARIABLE IS NOT USED, IM JUST KEEPING IT BECAUSE OF THE JOKE THAT I DID IN THE "trans" PROPERTY OF THIS TABLE, i think it is funny
camera = {
    --The offset of the camera, in the game is just used for screen shake
    offset = { x = 0, y = 0 },
    --Besides it's woke asf name, it is the game camera tranformation
    trans = love.math.newTransform(),
}
--The current money the player has
money = 100

--All the game mods
modList = {
    {
        name = "No Mod",
        namePT = "Nenhum Mod",
        id = -1,
    },
    {
        name = "Half Screen",
        namePT = "Metade Da Tela",
        id = 0,
    },
    {
        name = "Half Car Speed",
        namePT = "Metade Da Velocidade dos carros",
        id = 1,
    },
    {
        name = "Times Two Car Speed",
        namePT = "x2 A Velocidade Dos carros",
        id = 2,
    },
    {
        name = "Half Money Gain",
        namePT = "Metade dos ganhos monetarios",
        id = 3,
    },
    {
        name = "Two Times Money Gain",
        namePT = "x2 Dos ganhos monetarios",
        id = 4,
    },
    {
        name = "Half Frogg Life",
        namePT = "Metade da vida dos sapos",
        id = 5,
    },
    {
        name = "Times Two Frogg Life",
        namePT = "x2 A Vida dos sapos",
        id = 6,
    },
    {
        name = "Half Car Life",
        namePT = "Metade da vida dos sapos",
        id = 7,
    },
    {
        name = "Times Two Car Life",
        namePT = "x2 A Vida Dos Carros",
        id = 8,
    },
    {
        name = "Times Two Car Size",
        namePT = "x2 O Tamanho Dos Carros",
        id = 9,
    },
    {
        name = "Times Two Everything",
        namePT = "x2 Tudo",
        id = 10,
    },
    {
        name = "Half Everything",
        namePT = "Metade de Tudo",
        id = 11,
    },
}


--The mofier propertys
modifier = {
    --The current modifier
    current = modList[1],
    --The name of the modifiers, just used for readability of the code.
    --The names of the mofiers are self explanatory, i think
    nameList = {
        NO_MOD = modList[1],
        MOD_HALF_CAR_LIFE = modList[9],
        MOD_HALF_CAR_SPEED = modList[3],
        MOD_HALF_EVERYTHING = modList[13],
        MOD_HALF_FOGG_LIFE = modList[7],
        MOD_HALF_MONEY_GAIN = modList[5],
        MOD_HALF_SCREEN = modList[2],
        MOD_TIMES_TWO_CAR_LIFE = modList[10],
        MOD_TIMES_TWO_CAR_SIZE = modList[11],
        MOD_TIMES_TWO_CAR_SPEED = modList[4],
        MOD_TIMES_TWO_EVERYTHING = modList[12],
        MOD_TIMES_TWO_FOGG_LIFE = modList[8],
        MOD_TWO_TIMES_MONEY_GAIN = modList[6],
    },
}
--The propertys of the screen shake
screenShake = {
    --The current force of the screen shake
    force = 0,
    --If the screen shake is currently enabled
    enabled = false,
}
--The. WTF IS THIS???? why there is 2 cameras for this mf game????????????
--I think this is the main camera, but im not sure, it is the most used at least
gameCam = {
    --The current position of the camera
    pos = { x = 0, y = 0 },
    --The current velocity of the camera
    vel = { x = 0, y = 0 },
    --The current transformation of the camera
    transform = love.math.newTransform(),
    --The current offset of the camera, used for screen shake
    offset = { x = 0, y = 0 },
    --The current zoom of the camera
    zoom = 1,
    --The current rotation of the camera
    rot = 0,
}
--Set the mouse invisible
love.mouse.setVisible(false)
--The game rooms, they are just numbers that are checked in the love.update and love.draw functions to make an room system
rooms = {
    --The room used for quitting the game, it is used to have an transition on game quit, i think it looks cool
    quit = -1,
    --The room for the starting options, if an save file exists the room is skipped automaticaly
    startingOptions = 0.1,
    --The room for source code info
    sourceCode = 0.3,
    --The credits room
    credits = 0.25,
    --The stating thing that shows the "Created by" and the "Created with" texts and icons
    start = 0.5,
    --The mods rooms
    mods = 0.85,
    --The main menu room
    mainMenu = 0,
    --The main room, used for the actual game
    game = 1,
}
--Some additional propertys for cars
carsStuff = {
    --The amount of walking sfx of the cars, used to make an limit for the walking car sfxs
    walkSfxAmnt = 0,
}
--The current room
currentRoom = rooms.startingOptions
--The mouse position on the last frame
oldMousePos = { x = 0, y = 0 }
--The timer to create an tip
tipCreateTimer = 16
--The propertys of the room transition
sceneTransition = {
    --The progress of the transition
    progress = 0,
    --If the room transition is active
    enabled = false,
    --The icon that gets shown in the transition
    coolIcon = nil,
}
--Permanent upgrade values
permaUpgrades = {
    --Permanent Money Mult
    moneyMult = 1,
    --Permanent Frog Mult
    frogAmnt = 1,
    --Permanent Car Amount
    carAmount = 1,
    --Permanent Car Damage
    carDamage = 1,
    --Permanent Car Speed
    carSpeed = 1,
}
--The global mouse position
globalMousePosition = {x = 0, y = 0}
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
    currentVersion = "0.1.0 Bug Fixes",
    --If the game should pause for an event or something like that
    eventPause = false,
    --If the game should use Push to scale it
    usePush = true,
}
--The size of the game
gameSize = {w = 800, h = 600}
--It is like the "gameInstances" var but they are rendered on top of most instances the game and arent affected by the camera
onTopGameInstaces = {}
--The divider of the money
moneyGainDiv = 1
--The multiplier (it is not markplier) of + gameplayStuff.moneyMult the money recieved
moneyGainMult = 1
--The time since start in the last frame
lastTime = 0
--Some debug related propertys
debugStuff = {
    --If the debug is enabled or not
    enabled = false,
}
--Some hp text propertys
healthTextStuff = {
    --The scale added to the hp text
    scaleAdd = 0,
    --The timer to make the text "beat" like an heart, (of course it will be like an heart)
    beatTimer = 1,
    --The value to reset the beat timer
    beatTimerDef = 1,
}
--If the player was placing cars in the last frame
oldPlacingCar = false
--The damage effect stuff
damageEffectStuff = {
    --The red rect alpha
    redRectRGBAdd = 0,
}
--The delay for automaticaly updataing "Push" window size in the love.update
pushUpdateDelayTimer = 0.1
--The x position of the car placed and drawed
xForCar = 0
--The variable to reference the speed up button
speedUpButton = nil
--If the game can peacefuly quit
canCloseGame = false
--An table to hold gameplay info
gameplayStuff = {
    --The real money multiplier (it is not markplier)
    moneyMult = 1,
    --The real money divider
    moneyDiv = 1,
}
--The target (maximum) fps
targetFps = 120
--The list of mods
mods = {}
--Some propertys of the mods
modsStuff = {
    updateFunctions = {},
    nonStopUpdateFunctions = {},
    behindDrawFunctions = {},
    frontDrawFunctions = {},
}
--If the game gonna use v-sync
useVSync = true
--The time that one frame stats
frameTime = 1 / targetFps
--Where is dump off the time related stuff
time = {
    ticks = 0,
    TIMES = {
        DAY = 0,
        AFTERNOON = 1,
        NIGHT = 2,
        SUNRISE = 3,
    },
    currentTime = 0,
    timeUntilPass = 30,
    colorToBlendIn = {1, 1, 1, 1},
    carLightsAlpha = 0,
    --The texture used for the car light
    carLightTexture = love.graphics.newImage("Sprs/Cars/CarLight.png"),
}
--Where i dump off the weather stuff
weather = {
    WEATHERS = {
        CLEAN = 0,
        RAIN = 1,
        FOG = 2,
        HEAVY_RAIN = 3,
    },
    currentWeather = 0,
    weatherAlpha = 0,
    ticks = 0,
    timeUntilPass = 60,
    rainSpr = love.graphics.newImage("Sprs/Weather/Rain.png"),
    fogTexture = love.graphics.newImage("Sprs/Weather/Fog.png"),
    --The quad used to make the fog scroll
    fogMovingQuad = nil,
    rainQuad = nil,
    --The scroll of the fog
    fogScroll = 0,
    rainScroll = 0,
    rainAlpha = 0,
    fogAlpha = 0,
}
--If the game should redraw, normally disabled when the window is occluded
redrawGame = true


--The game main loop function, it gonna update the game, draw the game and exit the game, this function dont need to actually exist, it is just here for customization
function love.run()
    --Intialize "Push"
    Push:setupScreen(gameSize.w, 600, gameSize.w, 600, {resizable = true})
    --Set the window title
    love.window.setTitle("Foggers")
    --Set game identity
    love.filesystem.setIdentity("Foggers")


    --Run the love.load function to load stuff, (it actually just inits other stuff)
    if love.load then love.load(love.arg.parseGameArguments(arg), arg) end


    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end


    local nextTime = love.timer.getTime() + frameTime


    --the delta time var
    local dt = 0


    -- Main loop
    return function()
        -- Process events.
        if love.event then
            love.event.pump()
            for name, a, b, c, d, e, f in love.event.poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        --If can close the game, just close it, else transition to the quit room to allow the game to close
                        if canCloseGame then
                            return a or 0
                        else
                            changeRoom(rooms.quit)
                            rm = rooms.quit
                        end
                    end
                end
                love.handlers[name](a, b, c, d, e, f)
            end
        end


        -- Update dt, as we'll be passing it to update
        if love.timer then dt = love.timer.step() end


        -- Call update
        if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled


        --Handle draw
        if redrawGame then
            if love.graphics and love.graphics.isActive() then
                --Reset the tranformation
                love.graphics.origin()
                --Clear the screen
                love.graphics.clear(love.graphics.getBackgroundColor())


                --Call the draw function
                if love.draw then love.draw() end


                --Show the drawed stuff to the screen
                love.graphics.present()
            end
        end


        --Make the game be limited to the target fps, if the fps cap is enabled
        if targetFps > 0 then
            local currentTime = love.timer.getTime()
            local remaining = nextTime - currentTime


            if remaining > 0 then
                love.timer.sleep(math.max(0, remaining - 0.001))
            else
                nextTime = currentTime
            end


            nextTime = nextTime + frameTime
        end
    end
end

--Inits some stuff
function love.load(args, unfilteredArgs)
    --Load the game save file
    loadGame()


    --Say that the game is loading stuff
    love.graphics.clear()
    love.graphics.setColor(1, 1, 1)
    drawOutlinedText("Initializing Game...", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, 4, 4, nil, nil, 4, {0, 0, 0})
    love.graphics.present()


    --Set the line style to "rough" to make it not blurry
    love.graphics.setLineStyle("rough")


    --Set the window icon
    love.window.setIcon(love.image.newImageData("Sprs/Fog/Idle.png"))


    --Draw the fucking backgrounds
    initBackgronds()


    --Insert the indexes of the car categorys
    for i=0, 4 do
        table.insert(carsCategorys.numbers, #carsCategorys.numbers + 1, i)
    end


    --Load game mods from the folder if it is not the first play
    if not gameStuff.firstPlay then
        loadMods()
    end


    --Update the music volume, AKA set the music volume to all the streams
    updateMusicVolume()


    time.currentTime = time.TIMES.DAY
    weather.currentWeather = weather.WEATHERS.CLEAN
    weather.fogMovingQuad = love.graphics.newQuad(0, 0, gameSize.w, gameSize.h, weather.fogTexture)
    weather.rainQuad = love.graphics.newQuad(0, 0, gameSize.w, gameSize.h, weather.rainSpr)
    weather.fogTexture:setWrap("repeat", "repeat", "clamp")
    weather.rainSpr:setWrap("repeat", "repeat", "clamp")


    --Create the example mod if it is the first play
    if gameStuff.firstPlay then
        local exampleCode =
        'function modDraw()\n\tif debugStuff.enabled then \n\t\tlove.graphics.setColor(1, 1, 1); drawOutlinedText("EXAMPLE MOD ENABLED", gameSize.w / 2, 8, 0.1 * math.cos(GlobalSinAngle), 2, 2, nil, 0, 4, {0, 0, 0})\n\tend\nend\n\n\ntable.insert(modsStuff.frontDrawFunctions, 1, modDraw)'
        love.filesystem.write("Mods/ExampleMod.lua", exampleCode)
        loadMods()
    end
end

--Update everything
function love.update(dt)
    --Get the mouse positon transformed by the camera and scaled by "Push"
    local mP = { gameCam.transform:inverseTransformPoint(Push:toGame(love.mouse.getX(), love.mouse.getY())) }
    --Get the mouse position scaled by "Push" but not transformed by the camera
    local realMPos = { Push:toGame(love.mouse.getX(), love.mouse.getY()) }


    if not gameStuff.usePush then
        --Get the mouse positon transformed by the camera and scaled by "Push"
        mP = { gameCam.transform:inverseTransformPoint(love.mouse.getX(), love.mouse.getY())}
        --Get the mouse position scaled by "Push" but not transformed by the camera
        realMPos = {love.mouse.getX(), love.mouse.getY()}
    end


    --Update the mouse position NOT transformed by the camera
    PushsInGameMousePosNoTransform = { x = realMPos[1], y = realMPos[2] }
    --Update the mouse position transformed by the camera
    PushsInGameMousePos = { x = mP[1], y = mP[2] }
    --Update the global delta time
    globalDt = dt
    --Create a new random number
    randomNumber = math.random(1, 4)
    --Update the global mouse position
    local gM = {love.mouse.getGlobalPosition()}
    globalMousePosition = {x = gM[1], y = gM[2]}


    if gameStuff.usePush then
        gameSize = {
            w = Push:getWidth(),
            h = Push:getHeight()
        }
    else
        gameSize = {
            w = love.graphics.getWidth(),
            h = love.graphics.getHeight()
        }
    end


    --Sort game instances
    sortGameInstances()


    --If the delay for updating the "Push" is less than 0
    if pushUpdateDelayTimer <= 0 then
        --Update "Push"s window size
        Push:resize(love.graphics.getWidth(), love.graphics.getHeight())
        --Reset the "Push"s update delay
        pushUpdateDelayTimer = 0.1
    end


    --Update the music
    musicUpdate()


    --If the current room is not the game
    if currentRoom ~= rooms.game then
        --Reset the camera pos and vel
        gameCam.pos.x = 0
        gameCam.pos.y = 0
        gameCam.vel.x = 0
        gameCam.vel.y = 0
        --Force that the player is not hovering the top box
        gameStuff.hoveringTopBox = false
    end


    --Update UI instances


    --If the game is not paused
    if not gameStuff.paused then
        --If the game should force the button to be not hovered
        local forceHoverdown = false
        local hoveredId = 1


        --Pass thro all the UI instances to get if one is hovered
        for b = 1, #UiStuff do
            --if this button is already hovered, then force all the other buttons to be not hovered
            if UiStuff[b].hovered then
                forceHoverdown = true; hoveredId = b
            end
        end


        --Pass thro all the UI instances
        for b = 1, #UiStuff do
            --Update the UI instances and force the button to be not hovered if another button is already hovered
            if b ~= hoveredId then
                UiStuff[b]:update(dt, forceHoverdown)
            else
                UiStuff[b]:update(dt, false)
            end
        end
    end


    --If the game is paused
    if gameStuff.paused then
        --Pause all the musics and sfxs
        explosionSfx:pause()
        moneyGainSfx:pause()
        interactSfx:pause()
        modChangeSfx:pause()
        warningSfx:pause()
        for c = 1, #GameCarInstances do
            if GameCarInstances[c] ~= nil then
                GameCarInstances[c].walkSfx:pause()
                if GameCarInstances[c].startSfx ~= nil then
                    GameCarInstances[c].startSfx:pause()
                end
            end
        end
    end
    --Pass thro all the cars and set the volume of their sfxs
    for c = 1, #GameCarInstances do
        if GameCarInstances[c] ~= nil then
            GameCarInstances[c].walkSfx:setVolume(gameStuff.sfxVolume)
            if GameCarInstances[c].startSfx ~= nil then
                GameCarInstances[c].startSfx:setVolume(gameStuff.sfxVolume)
            end
        end
    end


    --Update the music volumes
    updateMusicVolume()


    --Set that the music is looping or not
    musics[currentMusic]:setLooping(gameStuff.musicLooping)


    --Update non stop mods update functions
    for f = 1, #modsStuff.nonStopUpdateFunctions do
        if type(modsStuff.nonStopUpdateFunctions[f]) == "function" then
            modsStuff.nonStopUpdateFunctions[f](dt)
        end
    end


    --If the game is not paused
    if not gameStuff.paused and not gameStuff.eventPause then
        --Update mods update functions
        for f = 1, #modsStuff.updateFunctions do
            if type(modsStuff.updateFunctions[f]) == "function" then
                modsStuff.updateFunctions[f](dt)
            end
        end
        --Update the game instances
        for u = 1, #gameInstances do
            if gameInstances[u] ~= nil and gameInstances[u].update then
                gameInstances[u]:update()
            end
        end


        --Delete some special instances if they arent used anymore
        if currentRoom ~= rooms.start then startThingInstance = nil end
        if currentRoom ~= rooms.mainMenu then mainMenuInstance = nil end
        if currentRoom ~= rooms.startingOptions then startingOptionsInstance = nil end


        --Update stuff based in rooms
        --I know, very messy code BUT lua has no match or switch functions so it is either if and elseifs or nothing
        if currentRoom == rooms.quit then
            --Set that the game can close and call the close function again
            canCloseGame = true
            love.event.quit()
        elseif currentRoom == rooms.startingOptions then
            --Create the starting options instance if he is a null value, otherwise update it
            if startingOptionsInstance == nil then
                createStartingOptions()
            else
                startingOptionsInstance:update()
            end
        elseif currentRoom == rooms.credits then
            --Create the credits instance if he is a null value, otherwise update it
            if creditsInstance == nil then
                creditsInstance = createCredits()
            else
                creditsInstance:update()
            end
        elseif currentRoom == rooms.mods then
            --Create the mods instance instance if he is a null value, otherwise update it
            if modManagerInstance == nil then
                createModsManager()
            else
                modManagerInstance:update()
            end
        elseif currentRoom == rooms.sourceCode then
            --Create the source code instance if he is a null value, otherwise update it
            if sourceInfoInstance == nil then
                createSourceInfo()
            else
                sourceInfoInstance:update()
            end
        elseif currentRoom == rooms.start then
            --Create the start thing instance if he is a null value, otherwise update it
            if startThingInstance == nil then
                startThingInstance = createStartThing()
            else
                startThingInstance:update()
            end
        elseif currentRoom == rooms.mainMenu then
            --Delete all the frogs and gameInstances, reset the game speed to 1 and dont show the lmb icon and the rmb icon
            Foggs = {}
            gameInstances = {}
            gameStuff.speed = 1
            mouse.showLMBIcon = false
            mouse.showRMBIcon = false


            --Create the main menu instance if he is a null value, otherwise update it
            if mainMenuInstance == nil then
                mainMenuInstance = createMainMenu()
            else
                mainMenuInstance:update()


                --Update all the cars
                updateAllCars()


                --Make the player able to click on the cars to impulse them up or down
                for c = 1, #GameCarInstances do
                    if Lume.distance(GameCarInstances[c].pos.x, GameCarInstances[c].pos.y, PushsInGameMousePos.x, PushsInGameMousePos.y) <= 32 then
                        if love.mouse.isDown(1) and LastLeftMouseButton == false then
                            if GameCarInstances[c].pos.y < PushsInGameMousePos.y then
                                GameCarInstances[c].vel.y = -500
                            else
                                GameCarInstances[c].vel.y = 500
                            end
                        end
                    end
                end
            end
        elseif currentRoom == rooms.game then
            --Update the y for the car and the x for the car
            yForCar = transformToCarYPosGrid(PushsInGameMousePos.y)
            xForCar = Lume.clamp(PushsInGameMousePos.x, placingStuff.minX, placingStuff.maxX)


            --Let the player scroll the top bar
            if gameStuff.hoveringTopBox then
                --If the mouse position is at the right side of the screen, increase the scroll value
                if PushsInGameMousePosNoTransform.x > gameSize.w - 64 then
                    upBoxStuff.scrollX = upBoxStuff.scrollX + (25 * upBoxStuff.scrollVel) * dt
                    upBoxStuff.scrollVel = upBoxStuff.scrollVel + 1 * dt
                else
                    upBoxStuff.scrollVel = 1
                end


                --Add the mouse scroll to the box scroll
                upBoxStuff.scrollX = upBoxStuff.scrollX + mouseScroll.y + mouseScroll.x
                upBoxStuff.scrollX = Lume.clamp(upBoxStuff.scrollX, 0, 3.75 * #GameCars)
            end


            --Pass thro the game car buttons
            for b = 1, #gameCarButtons do
                --Set the buttons positions effected by the scroll value
                gameCarButtons[b].pos.x = Lume.lerp(gameCarButtons[b].pos.x, (0 + 128 * b) - 32 * upBoxStuff.scrollX, 6)


                --Decrease or increase the buttons alpha value if he is under the speed up button
                if gameCarButtons[b].pos.x > 110 then
                    gameCarButtons[b].alpha = Lume.lerp(gameCarButtons[b].alpha, 1, 6)
                else
                    gameCarButtons[b].alpha = Lume.lerp(gameCarButtons[b].alpha, 0, 6)
                end


                --Update buttons
                gameCarButtons[b]:update()
            end


            --#region Move the camera
            --The x direction of the input
            local inputDirX = 0
            --The y direction of the input
            local inputDirY = 0
            --The camera speed
            local mspd = 500


            --Get the inputs and make them actually set the direction
            if love.keyboard.isDown("a") then inputDirX = inputDirX - 1 end
            if love.keyboard.isDown("d") then inputDirX = inputDirX + 1 end
            if love.keyboard.isDown("w") then inputDirY = inputDirY - 1 end
            if love.keyboard.isDown("s") then inputDirY = inputDirY + 1 end


            --The player has pressed shift, increase the speed
            if love.keyboard.isDown("lctrl") then mspd = 850 end


            --Set the camera velocity to the input direction
            gameCam.vel.x = Lume.lerp(gameCam.vel.x, mspd * inputDirX, 6)
            gameCam.vel.y = Lume.lerp(gameCam.vel.y, mspd * inputDirY, 6)


            --Move the camera using the mouse movement
            if mouse.pressTimer > 0.1 and love.mouse.isDown(1) then
                gameCam.pos.x = gameCam.pos.x + mouse.mousePressedPos.x - PushsInGameMousePosNoTransform.x
                gameCam.pos.y = gameCam.pos.y + mouse.mousePressedPos.y - PushsInGameMousePosNoTransform.y
            end
            --#endregion


            --Pass thro the buttons to select the cars, and update if they gonna show the pt-br text or the english text
            for c = 1, #gameCarButtons do
                if gameStuff.lang == "pt-br" then
                    gameCarButtons[c].text = GameCars[c].namePT
                    gameCarButtons[c].addText = GameCars[c].descPT .. "\nTipo: " .. getCarCategory(GameCars[c].category)
                else
                    gameCarButtons[c].text = GameCars[c].name
                    gameCarButtons[c].addText = GameCars[c].desc .. "\nType: " .. getCarCategory(GameCars[c].category)
                end
            end


            --Update all the cars
            updateAllCars()
            --Update all the frogs
            for f = 1, #Foggs do
                if Foggs[f] ~= nil then
                    Foggs[f]:update()
                end
            end


            --If the player is hovering the top box
            if gameStuff.hoveringTopBox then
                --If the player is hovering one btn
                pressedAnyBtn = false
                --The currently selected car
                local currentBtnSelected = selectedCar


                --Pass thro the game car buttons to make it actually select an car by pressing it
                for b = 1, #gameCarButtons do
                    --Get if the player is hovering the current button, if yes, set what btn is currently selected
                    if gameCarButtons[b].hovered then
                        pressedAnyBtn = true
                        currentBtnSelected = b
                    end


                    --If the current button is pressed
                    if gameCarButtons[b].pressed then
                        --If the player is not placing cars, then start placing the current car
                        if placingCar == false then
                            startCarPlacing(b)
                            --else, if the current car is the same as the car of the button pressed, stop placing cars
                            --BUT if the player is placing cars and the current car selected is not equals to the car of the button pressed, start placing the car of the button pressed
                        else
                            if currentBtnSelected == selectedCar then
                                stopCarPlacing()
                            else
                                startCarPlacing(currentBtnSelected)
                            end
                        end


                        --Set the button has not pressed, because we already did our job here
                        gameCarButtons[b].pressed = false
                    end
                end


                --If the player was not placing cars but is placing now, give him a hint to what button to press
                if oldPlacingCar == false and placingCar then
                    mouse.showRMBIcon = true
                    mouse.showLMBIcon = true
                    mouse.RMBModulate = { 1, 0.85, 0.85 }
                    mouse.LMBModulate = { 0.85, 0.85, 1 }
                end
                --If the player was placing cars but is not placing now, hide the hint to what button to press
                if oldPlacingCar and placingCar == false then
                    mouse.showRMBIcon = false
                    mouse.showLMBIcon = false
                    mouse.RMBModulate = { 1, 1, 1 }
                    mouse.LMBModulate = { 1, 1, 1 }
                end
            end


            --Get if the player is hovering the car selection box
            gameStuff.hoveringTopBox = PushsInGameMousePosNoTransform.y < upBoxStuff.y + upBoxStuff.h


            --If the player is not hovering the top box
            if not gameStuff.hoveringTopBox then
                --If the rmb is pressed, stop placing cars, that's if you are placing cars
                if placingCar and love.mouse.isDown(2) then
                    stopCarPlacing()
                end


                --If the selected car is not nil and the player is placing cars
                if placingCar and currentSelectedCar ~= nil then
                    --If the player has pressed the lmb
                    if mouse.pressTimer <= 0.1 and love.mouse.isDown(1) == false and LastLeftMouseButton then
                        --If the player has the money to buy the car
                        if money >= GameCars[selectedCar].cost then
                            --Create the car, set that the game can place frogs and remove the car price from the current money
                            money = money - GameCars[selectedCar].cost


                            gameStuff.canPlaceFroggs = true
                            createCarInstance(GameCars[selectedCar], xForCar, yForCar)


                            --Play the main game music if it is the first car placed
                            if not gameStuff.canPlaceFroggs then
                                playMusic(7)
                            end
                        end
                    end
                end
            end


            --If the megawave is not enabled and the game can place frogs, if the frog create timer is less or equals to 0, create a new frog and reset the timer
            if not megaWave.enabled and gameStuff.canPlaceFroggs then
                if foggCreateTimer <= 0 then
                    for f=0, permaUpgrades.frogAmnt do
                        createANewFogg()
                    end


                    foggCreateTimer = foggCreateTimerDef
                end
            end


            --If the timer for the mega wave is less or equals to 0, start the mega wave
            if megaWave.timer <= 0 then
                if not megaWave.enabled then
                    megaWave.enabled = true
                    foggCreateTimerDef = foggCreateTimerDef - 0.5
                    createMegaWaveWarning()


                    --Create all the frogs for the wave
                    for f=0, permaUpgrades.frogAmnt do
                        for f = 0, megaWave.force * (gameStuff.currentFoggGaved + 1) do
                            local posToPut = math.random(0, 2)
                            local modX = 0
                            local modY = 0


                            if posToPut == 0 then
                                modX = 0
                                modY = math.random(gameSize.h / 2, 632)
                            end
                            if posToPut == 1 then
                                modX = math.random(0, gameSize.w * 1.5)
                                modY = 632 + math.random(-64, 64)
                            end
                            if posToPut == 2 then
                                modX = gameSize.w * 1.5
                                modY = math.random(gameSize.h / 2, 632)
                            end


                            createANewFogg(modX, modY)
                        end
                    end
                end
            end


            --If the player died, transition him to the main menu
            if gameStuff.hp <= 0 then
                changeRoom(rooms.mainMenu)
            end


            --If the timer to create an tip has ended, create a new tip and reset the timer
            if tipCreateTimer <= 0 then
                createTipRect()
                tipCreateTimer = math.random(10, 16)
            end


            --Get the amount of car walking sfxs
            --Reset the amount
            carsStuff.walkSfxAmnt = 0


            --pass thro all the gameCar instances to get the amount and to stop too
            for c = 1, #GameCarInstances do
                if GameCarInstances[c].walkSfx ~= nil then
                    carsStuff.walkSfxAmnt = carsStuff.walkSfxAmnt + 1
                end
                if carsStuff.walkSfxAmnt > 5 then
                    GameCarInstances[c].walkSfx:stop()
                else
                    if not GameCarInstances[c].walkSfx:isPlaying() then
                        GameCarInstances[c].walkSfx:play()
                    end
                end
            end


            if speedUpButton ~= nil then
                --If the speed up button is hovered and the left or right mouse button is pressed, modify the game speed
                if speedUpButton.hovered then
                    if love.mouse.isDown(2) then gameStuff.speed = gameStuff.speed + 5 * dt end
                    if love.mouse.isDown(1) then gameStuff.speed = gameStuff.speed - 5 * dt end
                end


                --THIS FUCKING CODE DOES NOT WORKS I DONT FUCKING KNOW WHY
                if speedUpButton.hovered == false and speedUpButton.hovered then
                    mouse.showLMBIcon = true
                    mouse.showRMBIcon = true
                    mouse.LMBModulate = { 1, 0.5, 0.5 }
                    mouse.RMBModulate = { 1, 0.5, 0.5 }
                end


                if speedUpButton.oldHovered and speedUpButton.hovered == false then
                    mouse.showLMBIcon = false
                    mouse.showRMBIcon = false
                    mouse.LMBModulate = { 1, 1, 1 }
                    mouse.RMBModulate = { 1, 1, 1 }
                end


                --Update the speed up button text
                speedUpButton.text = "x" .. tostring(math.floor(gameStuff.speed))
            end


            --Update the higest round
            if gameStuff.higestRound < gameStuff.currentFoggGaved then
                gameStuff.higestRound = gameStuff.currentFoggGaved
            end


            --Deactivate the mega wave if it has already ended
            if #Foggs <= 0 and megaWave.enabled then
                megaWave.enabled = false
                gameStuff.currentFoggGaved = gameStuff.currentFoggGaved + 1
                modifier.current = modList[math.random(1, #modList)]
                playSound(modChangeSfx)
                megaWave.timer = megaWave.timerDef


                --Maybe start an event
                local chance = math.random(0, 2)
                if chance == 0 then
                    startEvent()
                end
            end


            --Decrease the mega wave timer if the game can place frogs and the mega wave is not enabled
            if gameStuff.canPlaceFroggs and not megaWave.enabled then
                megaWave.timer = megaWave.timer - (1 * gameStuff.speed) * dt
            end


            --If the health beat timer has ended, increase the hp text scale and reset the timer
            if healthTextStuff.beatTimer <= 0 then
                healthTextStuff.scaleAdd = 3
                healthTextStuff.beatTimer = healthTextStuff.beatTimerDef * (10 / gameStuff.hp)
            end


            --Run the function to update time
            updateTime()
            --Run the function to update weather
            updateWeather()


            --Decrease the beat timer
            healthTextStuff.beatTimer = healthTextStuff.beatTimer - (1 * gameStuff.speed) * dt
            --Lerp the health text back to 0
            healthTextStuff.scaleAdd = Lume.lerp(healthTextStuff.scaleAdd, 0, 6)
            --Update if on the last frame the player was placing cars
            oldPlacingCar = placingCar
            --Decrease the tip create timer
            tipCreateTimer = tipCreateTimer - (1 * gameStuff.speed) * dt
            --Increase the ticks
            time.ticks = time.ticks + 1 * dt * gameStuff.speed


            --#region Make the modifiers work
            --MESSY ASF CODE BELOW, PROCEED WITH CAUTION


            if modifier.current == modifier.nameList.NO_MOD then
                moneyGainDiv = 1 + gameplayStuff.moneyDiv
                moneyGainMult = 1 + gameplayStuff.moneyMult + permaUpgrades.moneyMult
                for c = 1, #GameCarInstances do
                    GameCarInstances[c].hpDivCar = 1
                    GameCarInstances[c].spdDivCar = 1
                    GameCarInstances[c].hpMultCar = 1
                    GameCarInstances[c].spdMultCar = 1
                    GameCarInstances[c].scaleAdd = 0
                end
                placingStuff.minX = -128
                placingStuff.maxX = gameSize.w * 1.5
                for f = 1, #Foggs do
                    Foggs[f].spdDivFogg = 1
                    Foggs[f].hpDivFogg = 1
                    Foggs[f].spdMultFogg = 1
                    Foggs[f].hpMultFogg = 1
                end
            elseif modifier.current == modifier.nameList.MOD_HALF_CAR_LIFE then
                moneyGainDiv = 1 + gameplayStuff.moneyDiv
                moneyGainMult = 1 + gameplayStuff.moneyMult + permaUpgrades.moneyMult
                for c = 1, #GameCarInstances do
                    GameCarInstances[c].hpDivCar = 2
                    GameCarInstances[c].spdDivCar = 1
                    GameCarInstances[c].hpMultCar = 1
                    GameCarInstances[c].spdMultCar = 1
                    GameCarInstances[c].scaleAdd = 0
                end
                placingStuff.minX = -128
                placingStuff.maxX = gameSize.w * 1.5
                for f = 1, #Foggs do
                    Foggs[f].spdDivFogg = 1
                    Foggs[f].hpDivFogg = 1
                    Foggs[f].spdMultFogg = 1
                    Foggs[f].hpMultFogg = 1
                end
            elseif modifier.current == modifier.nameList.MOD_HALF_CAR_SPEED then
                moneyGainDiv = 1 + gameplayStuff.moneyDiv
                moneyGainMult = 1 + gameplayStuff.moneyMult + permaUpgrades.moneyMult
                for c = 1, #GameCarInstances do
                    GameCarInstances[c].hpDivCar = 1
                    GameCarInstances[c].spdDivCar = 2
                    GameCarInstances[c].hpMultCar = 1
                    GameCarInstances[c].spdMultCar = 1
                    GameCarInstances[c].scaleAdd = 0
                end
                placingStuff.minX = -128
                placingStuff.maxX = gameSize.w * 1.5
                for f = 1, #Foggs do
                    Foggs[f].spdDivFogg = 1
                    Foggs[f].hpDivFogg = 1
                    Foggs[f].spdMultFogg = 1
                    Foggs[f].hpMultFogg = 1
                end
            elseif modifier.current == modifier.nameList.MOD_HALF_EVERYTHING then
                moneyGainDiv = 2 + gameplayStuff.moneyDiv
                moneyGainMult = 1 + gameplayStuff.moneyMult + permaUpgrades.moneyMult
                for c = 1, #GameCarInstances do
                    GameCarInstances[c].hpDivCar = 2
                    GameCarInstances[c].spdDivCar = 2
                    GameCarInstances[c].hpMultCar = 1
                    GameCarInstances[c].spdMultCar = 1
                    GameCarInstances[c].scaleAdd = 0
                end
                placingStuff.minX = -128
                placingStuff.maxX = gameSize.w * 1.5
                for f = 1, #Foggs do
                    Foggs[f].spdDivFogg = 2
                    Foggs[f].hpDivFogg = 2
                    Foggs[f].spdMultFogg = 1
                    Foggs[f].hpMultFogg = 1
                end
            elseif modifier.current == modifier.nameList.MOD_HALF_FOGG_LIFE then
                moneyGainDiv = 1 + gameplayStuff.moneyDiv
                moneyGainMult = 1 + gameplayStuff.moneyMult + permaUpgrades.moneyMult
                for c = 1, #GameCarInstances do
                    GameCarInstances[c].hpDivCar = 1
                    GameCarInstances[c].spdDivCar = 1
                    GameCarInstances[c].hpMultCar = 1
                    GameCarInstances[c].spdMultCar = 1
                    GameCarInstances[c].scaleAdd = 0
                end
                placingStuff.minX = -128
                placingStuff.maxX = gameSize.w * 1.5
                for f = 1, #Foggs do
                    Foggs[f].spdDivFogg = 1
                    Foggs[f].hpDivFogg = 2
                    Foggs[f].spdMultFogg = 1
                    Foggs[f].hpMultFogg = 1
                end
            elseif modifier.current == modifier.nameList.MOD_HALF_MONEY_GAIN then
                moneyGainDiv = 2 + gameplayStuff.moneyDiv
                moneyGainMult = 1 + gameplayStuff.moneyMult + permaUpgrades.moneyMult
                for c = 1, #GameCarInstances do
                    GameCarInstances[c].hpDivCar = 1
                    GameCarInstances[c].spdDivCar = 1
                    GameCarInstances[c].hpMultCar = 1
                    GameCarInstances[c].spdMultCar = 1
                    GameCarInstances[c].scaleAdd = 0
                end
                placingStuff.minX = -128
                placingStuff.maxX = gameSize.w * 1.5
                for f = 1, #Foggs do
                    Foggs[f].spdDivFogg = 1
                    Foggs[f].hpDivFogg = 1
                    Foggs[f].spdMultFogg = 1
                    Foggs[f].hpMultFogg = 1
                end
            elseif modifier.current == modifier.nameList.MOD_HALF_SCREEN then
                moneyGainDiv = 1 + gameplayStuff.moneyDiv
                moneyGainMult = 1 + gameplayStuff.moneyMult + permaUpgrades.moneyMult
                for c = 1, #GameCarInstances do
                    GameCarInstances[c].hpDivCar = 1
                    GameCarInstances[c].spdDivCar = 1
                    GameCarInstances[c].hpMultCar = 2
                    GameCarInstances[c].spdMultCar = 1
                    GameCarInstances[c].scaleAdd = 0
                end
                placingStuff.minX = gameCam.pos.x + gameSize.w / 2
                placingStuff.maxX = gameCam.pos.x + gameSize.w * 1.5
                for f = 1, #Foggs do
                    Foggs[f].spdDivFogg = 1
                    Foggs[f].hpDivFogg = 1
                    Foggs[f].spdMultFogg = 1
                    Foggs[f].hpMultFogg = 1
                end
            elseif modifier.current == modifier.nameList.MOD_TIMES_TWO_CAR_LIFE then
                moneyGainDiv = 1 + gameplayStuff.moneyDiv
                moneyGainMult = 1 + gameplayStuff.moneyMult + permaUpgrades.moneyMult
                for c = 1, #GameCarInstances do
                    GameCarInstances[c].hpDivCar = 1
                    GameCarInstances[c].spdDivCar = 1
                    GameCarInstances[c].hpMultCar = 2
                    GameCarInstances[c].spdMultCar = 1
                    GameCarInstances[c].scaleAdd = 0
                end
                placingStuff.minX = -128
                placingStuff.maxX = gameSize.w * 1.5
                for f = 1, #Foggs do
                    Foggs[f].spdDivFogg = 1
                    Foggs[f].hpDivFogg = 1
                    Foggs[f].spdMultFogg = 1
                    Foggs[f].hpMultFogg = 1
                end
            elseif modifier.current == modifier.nameList.MOD_TIMES_TWO_CAR_SIZE then
                moneyGainDiv = 1 + gameplayStuff.moneyDiv
                moneyGainMult = 1 + gameplayStuff.moneyMult + permaUpgrades.moneyMult
                for c = 1, #GameCarInstances do
                    GameCarInstances[c].hpDivCar = 1
                    GameCarInstances[c].spdDivCar = 1
                    GameCarInstances[c].hpMultCar = 1
                    GameCarInstances[c].spdMultCar = 2
                    GameCarInstances[c].scaleAdd = GameCarInstances[c].fromCar.scale
                end
                placingStuff.minX = -128
                placingStuff.maxX = gameSize.w * 1.5
                for f = 1, #Foggs do
                    Foggs[f].spdDivFogg = 1
                    Foggs[f].hpDivFogg = 1
                    Foggs[f].spdMultFogg = 1
                    Foggs[f].hpMultFogg = 1
                end
            elseif modifier.current == modifier.nameList.MOD_TIMES_TWO_CAR_SPEED then
                moneyGainDiv = 1 + gameplayStuff.moneyDiv
                moneyGainMult = 1 + gameplayStuff.moneyMult + permaUpgrades.moneyMult
                for c = 1, #GameCarInstances do
                    GameCarInstances[c].hpDivCar = 1
                    GameCarInstances[c].spdDivCar = 1
                    GameCarInstances[c].hpMultCar = 1
                    GameCarInstances[c].spdMultCar = 2
                    GameCarInstances[c].scaleAdd = 0
                end
                placingStuff.minX = -128
                placingStuff.maxX = gameSize.w * 1.5
                for f = 1, #Foggs do
                    Foggs[f].spdDivFogg = 1
                    Foggs[f].hpDivFogg = 1
                    Foggs[f].spdMultFogg = 1
                    Foggs[f].hpMultFogg = 1
                end
            elseif modifier.current == modifier.nameList.MOD_TIMES_TWO_EVERYTHING then
                moneyGainDiv = 1 + gameplayStuff.moneyDiv
                moneyGainMult = 2 + gameplayStuff.moneyMult + permaUpgrades.moneyMult
                for c = 1, #GameCarInstances do
                    GameCarInstances[c].hpDivCar = 1
                    GameCarInstances[c].spdDivCar = 1
                    GameCarInstances[c].hpMultCar = 2
                    GameCarInstances[c].spdMultCar = 2
                    GameCarInstances[c].scaleAdd = 0
                end
                placingStuff.minX = -128
                placingStuff.maxX = gameSize.w * 1.5
                for f = 1, #Foggs do
                    Foggs[f].spdDivFogg = 1
                    Foggs[f].hpDivFogg = 1
                    Foggs[f].spdMultFogg = 2
                    Foggs[f].hpMultFogg = 2
                end
            elseif modifier.current == modifier.nameList.MOD_TIMES_TWO_FOGG_LIFE then
                moneyGainDiv = 1 + gameplayStuff.moneyDiv
                moneyGainMult = 1 + gameplayStuff.moneyMult + permaUpgrades.moneyMult
                for c = 1, #GameCarInstances do
                    GameCarInstances[c].hpDivCar = 1
                    GameCarInstances[c].spdDivCar = 1
                    GameCarInstances[c].hpMultCar = 1
                    GameCarInstances[c].spdMultCar = 1
                    GameCarInstances[c].scaleAdd = 0
                end
                placingStuff.minX = -128
                placingStuff.maxX = gameSize.w * 1.5
                for f = 1, #Foggs do
                    Foggs[f].spdDivFogg = 1
                    Foggs[f].hpDivFogg = 1
                    Foggs[f].spdMultFogg = 1
                    Foggs[f].hpMultFogg = 2
                end
            elseif modifier.current == modifier.nameList.MOD_TWO_TIMES_MONEY_GAIN then
                moneyGainDiv = 1 + gameplayStuff.moneyDiv
                moneyGainMult = 2 + gameplayStuff.moneyMult + permaUpgrades.moneyMult
                for c = 1, #GameCarInstances do
                    GameCarInstances[c].hpDivCar = 1
                    GameCarInstances[c].spdDivCar = 1
                    GameCarInstances[c].hpMultCar = 1
                    GameCarInstances[c].spdMultCar = 1
                    GameCarInstances[c].scaleAdd = 0
                end
                placingStuff.minX = -128
                placingStuff.maxX = gameSize.w * 1.5
                for f = 1, #Foggs do
                    Foggs[f].spdDivFogg = 1
                    Foggs[f].hpDivFogg = 1
                    Foggs[f].spdMultFogg = 1
                    Foggs[f].hpMultFogg = 1
                end
            end
            --#endregion
        end


        --If the number of cars is 0 and the player has no money to create one new car, give him the money to create a common car
        if #GameCarInstances <= 0 and money < 100 then
            money = 100
        end


        --Screen shake system
        if screenShake.enabled then
            --Set the camera offset to a random value
            gameCam.offset.x = math.random(-screenShake.force, screenShake.force)
            gameCam.offset.y = math.random(-screenShake.force, screenShake.force)


            --If the screen shake force has ended, disable the screen shake
            if screenShake.force <= 0 then
                screenShake.enabled = false
            end


            --Decrease the shake force
            screenShake.force = screenShake.force - (100 * gameStuff.speed) * dt
        else
            --Reset the offset back to 0
            gameCam.offset.x = Lume.lerp(gameCam.offset.x, 0, 6)
            gameCam.offset.y = Lume.lerp(gameCam.offset.y, 0, 6)
        end


        --Reset the game zoom
        gameCam.zoom = Lume.lerp(gameCam.zoom, 1, 6)


        --The zoom percentage
        local zoomPercent = 1
        --Get the zoom percentage
        if gameCam.zoom ~= 0 then
            zoomPercent = (1 / gameCam.zoom)
        end


        --Clamp the camera position
        gameCam.pos.x = Lume.clamp(gameCam.pos.x, -gameSize.w / 2, gameSize.w - gameSize.w / 2)
        gameCam.pos.y = Lume.clamp(gameCam.pos.y, -gameSize.h / 2, gameSize.h - gameSize.h / 2)


        --Update the game camera transformation
        gameCam.transform:setTransformation(
            -((gameCam.pos.x - gameCam.offset.x + Push:getWidth() / 2)) + ((Push:getWidth() * zoomPercent) / 2),
            -((gameCam.pos.y - gameCam.offset.y + Push:getHeight() / 2)) + ((Push:getHeight() * zoomPercent) / 2),
            gameCam.rot, gameCam.zoom, gameCam.zoom, 0, 0)
    end


    --Clamp the game speed inside 1 to 3
    gameStuff.speed = Lume.clamp(gameStuff.speed, 1, 3)
    --Lerp the red rect alpha back to 0
    damageEffectStuff.redRectRGBAdd = Lume.lerp(damageEffectStuff.redRectRGBAdd, 0, 6)


    --If the game is not paused
    if not gameStuff.paused then
        --Update the ontop game instances
        for t = 1, #onTopGameInstaces do
            if onTopGameInstaces[t] ~= nil and onTopGameInstaces[t].update ~= nil then
                onTopGameInstaces[t]:update()
            end
        end
    end


    if gameStuff.eventPause and currentRoom == rooms.quit then
        canCloseGame = true
        love.event.quit()
    end


    --If the pause menu exists, update it
    if pauseMenuInstance ~= nil then
        pauseMenuInstance:update()
    end


    --Clamp the sfx and music volume to 0 and 1
    gameStuff.sfxVolume = Lume.clamp(gameStuff.sfxVolume, 0, 1)
    gameStuff.musicVolume = Lume.clamp(gameStuff.musicVolume, 0, 1)


    --If the sceneTransition icon exists, update it
    if sceneTransition.coolIcon ~= nil then
        sceneTransition.coolIcon:update()
    end


    --If the timeSinceStart is more than 20000 frames, reset it
    if gameStuff.timeSinceStart > 2 then
        gameStuff.timeSinceStart = 0
    end


    --Add the camera velocity to the camera position
    gameCam.pos.x = gameCam.pos.x + gameCam.vel.x * dt
    gameCam.pos.y = gameCam.pos.y + gameCam.vel.y * dt


    --Clamp the camera position
    gameCam.pos.x = Lume.clamp(gameCam.pos.x, 0, (gameSize.w))
    gameCam.pos.y = Lume.clamp(gameCam.pos.y, 0, (gameSize.h * 1.5))


    --Reset the mouse scroll
    mouseScroll.x = 0
    mouseScroll.y = 0
    --Update the game mouse
    mouse:updateMouse()
    --Update if the lmb and rmb was pressed in the last frames
    LastLeftMouseButton = love.mouse.isDown(1)
    LastRightMouseButton = love.mouse.isDown(2)
    --Increase the global angle
    GlobalSinAngle = GlobalSinAngle + (1 * gameStuff.speed) * dt
    --Crease the frog create timer if the game has not paused the frog creation, else delete all these mfs
    if not gameStuff.pauseFroggCreation then
        foggCreateTimer = foggCreateTimer - (1 * gameStuff.speed) * dt
    else
        tableClear(Foggs)
    end
    --Decrease the timer to update "Push"s window size
    pushUpdateDelayTimer = pushUpdateDelayTimer - 1 * dt
    --Update the mouse position in the last frame
    oldMousePos = { x = PushsInGameMousePos.x, y = PushsInGameMousePos.y }
    --Update the flux library
    Flux.update(dt * gameStuff.speed)
    --Reset if the keyboard was pressed
    keyboardWasPressed = false
    --Increase the time since start
    gameStuff.timeSinceStart = gameStuff.timeSinceStart + 1
    --Set the random number seed
    if not gameStuff.useFixedSeed then
        math.randomseed((lastTime - love.timer.getTime()) * 1000)
        love.math.setRandomSeed((lastTime - love.timer.getTime()) * 1000)
    else
        math.randomseed(gameStuff.fixedSeed)
        love.math.setRandomSeed(gameStuff.fixedSeed)
    end
    --Set what time since start is
    lastTime = love.timer.getTime()
    saveGame(love.window.getFullscreen(), gameStuff.lang, gameStuff.sfxVolume, gameStuff.musicVolume,
        gameStuff.higestRound, gameStuff.drawOutlines, targetFps, useVSync)
end


--The function to draw the game
function love.draw()
    --Tell push to start doing his shit
    if gameStuff.usePush then
        Push:start()
    end
    --Apply the camera transform
    love.graphics.applyTransform(gameCam.transform)


    --Sort game instances
    sortGameInstances()


    if currentRoom == rooms.mainMenu then
        --Crear the game instances
        gameInstances = {}


        --If the main menu instance does not exists, then create it, else draw it
        if mainMenuInstance == nil then
            mainMenuInstance = createMainMenu()
        else
            mainMenuInstance:draw()
        end
    elseif currentRoom == rooms.startingOptions then
        --Create the starting options instance if he is a null value, otherwise update it
        if startingOptionsInstance == nil then
            startingOptionsInstance = createStartingOptions()
        else
            startingOptionsInstance:draw()
        end
    elseif currentRoom == rooms.credits then
        --If the credits instance does not exists, then create it, else draw it
        if creditsInstance == nil then
            creditsInstance = createCredits()
        else
            creditsInstance:draw()
        end
    elseif currentRoom == rooms.sourceCode then
        --Create the source code instance if he is a null value, otherwise draw it
        if sourceInfoInstance == nil then
            createSourceInfo()
        else
            sourceInfoInstance:draw()
        end
    elseif currentRoom == rooms.mods then
        --Create the mods instance instance if he is a null value, otherwise update it
        if modManagerInstance == nil then
            createModsManager()
        else
            modManagerInstance:draw()
        end
    elseif currentRoom == rooms.start then
        --If the start thing instance does not exists, then create it, else draw it
        if startThingInstance == nil then
            startThingInstance = createStartThing()
        else
            startThingInstance:draw()
        end
    elseif currentRoom == rooms.game then
        --Draw the backgrounds
        drawGrass()
        drawRoad()
        drawRoadSide()


        --If an game instance wants to get drawn behind, draw it behind everything
        for u = 1, #gameInstances do
            if gameInstances[u].drawBack then
                gameInstances[u]:draw()
            end
        end


        --Draw the cars
        drawAllCars()


        --Draw the car selected example
        if placingCar and GameCars[selectedCar] ~= nil and currentSelectedCar ~= nil then
            love.graphics.setColor(0.5, 0.5, 0.5, 0.85)
            for c=1, permaUpgrades.carAmount do
                currentSelectedCar.pos.x = xForCar
                currentSelectedCar.pos.y = yForCar
                currentSelectedCar.rot = 0.25 * math.cos(GlobalSinAngle * 2) + (c / 32)
                currentSelectedCar:draw()
            end
            love.graphics.setColor(1, 1, 1, 1)


            --Draw the car cost
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.setFont(secFnt)
            local txt = "Cost: " .. GameCars[selectedCar].cost

            if gameStuff.lang == "pt-br" then
                txt = "Custo: " .. GameCars[selectedCar].cost
            end

            drawOutlinedText(txt, xForCar, yForCar - 64,
                0.1 * math.cos(GlobalSinAngle), 4, 4, love.graphics.getFont():getWidth(txt) / 2,
                love.graphics.getFont():getHeight(txt) / 2, 4)
            love.graphics.setFont(mainFnt)
        end


        --Draw all the frogs
        for f = 1, #Foggs do
            Foggs[f]:draw()
        end


        --Draw all the game instances that dont want to be drawn behind everything
        for u = 1, #gameInstances do
            if not gameInstances[u].drawBack then
                gameInstances[u]:draw()
            end
        end


        --Reset the transform
        love.graphics.origin()


        --#region Draw time related stuff
        if time.currentTime == time.TIMES.DAY then
            time.colorToBlendIn = colorLerp(time.colorToBlendIn, {1, 1, 1, 1}, 6)
        elseif time.currentTime == time.TIMES.AFTERNOON then
            time.colorToBlendIn = colorLerp(time.colorToBlendIn, {0.85, 0.85, 0, 1}, 6)
        elseif time.currentTime == time.TIMES.NIGHT then
            time.colorToBlendIn = colorLerp(time.colorToBlendIn, {0.1, 0.1, 0.2, 0.9}, 6)
        elseif time.currentTime == time.TIMES.SUNRISE then
            time.colorToBlendIn = colorLerp(time.colorToBlendIn, {0.5, 0.5, 0.6, 1}, 6)
        end
        
        
        if time.currentTime == time.TIMES.NIGHT then time.carLightsAlpha = Lume.lerp(time.carLightsAlpha, 0.25, 6) else time.carLightsAlpha = Lume.lerp(time.carLightsAlpha, -0.1, 6) end
        

        love.graphics.setBlendMode("multiply", "premultiplied")
        love.graphics.setColor(time.colorToBlendIn)
        love.graphics.rectangle("fill", 0, 0, gameSize.w, gameSize.h)
        love.graphics.setBlendMode("alpha", "alphamultiply")


        for c=1, #GameCarInstances do
            love.graphics.setColor({1, 1, 1, time.carLightsAlpha + 0.1 * math.cos(GlobalSinAngle)})
            local inScrnPos = toScreen(GameCarInstances[c].pos.x, GameCarInstances[c].pos.y)
            local scaleAdd = 0.1 * math.cos(GlobalSinAngle)
            love.graphics.draw(time.carLightTexture, inScrnPos[1] - 32, inScrnPos[2], 0, 4 + scaleAdd, 4 + scaleAdd, time.carLightTexture:getWidth(), time.carLightTexture:getHeight() / 2)
        end
        --#endregion


        --#region Draw weather stuff
        if weather.currentWeather == weather.WEATHERS.CLEAN then
        elseif weather.currentWeather == weather.WEATHERS.RAIN then
            love.graphics.setColor(0.5, 0.5, 1, weather.weatherAlpha / 4)
            love.graphics.rectangle("fill", 0, 0, gameSize.w, gameSize.h)
            love.graphics.setColor(1, 1, 1, weather.weatherAlpha)


            weather.rainQuad = love.graphics.newQuad(weather.rainScroll, -weather.rainScroll, gameSize.w, gameSize.h, weather.rainSpr)


            love.graphics.draw(weather.rainSpr, weather.rainQuad, 0, 0, 0, 4, 4, 0, 0)


            weather.rainScroll = weather.rainScroll + (40 * gameStuff.speed) * globalDt
        elseif weather.currentWeather == weather.WEATHERS.FOG then
            love.graphics.setColor(1, 1, 1, weather.weatherAlpha / 2)


            weather.fogMovingQuad = love.graphics.newQuad(weather.fogScroll, weather.fogScroll, gameSize.w, gameSize.h, weather.fogTexture)


            love.graphics.draw(weather.fogTexture, weather.fogMovingQuad, 0, 0, 0, 16, 16, 0, 0)


            weather.fogScroll = weather.fogScroll + (8 * gameStuff.speed) * globalDt
        elseif weather.currentWeather == weather.WEATHERS.HEAVY_RAIN then
            love.graphics.setColor(0.25, 0.25, 0.75, weather.weatherAlpha / 2)
            love.graphics.rectangle("fill", 0, 0, gameSize.w, gameSize.h)
            love.graphics.setColor(1, 1, 1, weather.weatherAlpha)


            weather.rainQuad = love.graphics.newQuad(weather.rainScroll, -weather.rainScroll, gameSize.w, gameSize.h, weather.rainSpr)


            love.graphics.draw(weather.rainSpr, weather.rainQuad, 0, 0, 0, 8, 8, 0, 0)
            weather.rainScroll = weather.rainScroll + (80 * gameStuff.speed) * globalDt
        end
        --#endregion


        --Draw the up box
        love.graphics.setColor({ 0.8, 1, 0.8 })
        love.graphics.rectangle("fill", upBoxStuff.x, upBoxStuff.y, upBoxStuff.w, upBoxStuff.h)
        love.graphics.setColor({ 0, 0, 0 })
        love.graphics.rectangle("line", upBoxStuff.x, upBoxStuff.y, upBoxStuff.w, upBoxStuff.h)


        --Draw the current money
        love.graphics.setColor(0.1, 0.1, 0.1, 0.5)
        love.graphics.rectangle("fill", upBoxStuff.x + 8, upBoxStuff.y + upBoxStuff.h + 8,
            (love.graphics.getFont():getWidth(tostring(math.floor(money))) * 4) + 16,
            (love.graphics.getFont():getHeight(tostring(math.floor(money))) * 4) + 8)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("line", upBoxStuff.x + 8, upBoxStuff.y + upBoxStuff.h + 8,
            (love.graphics.getFont():getWidth(tostring(math.floor(money))) * 4) + 16,
            (love.graphics.getFont():getHeight(tostring(math.floor(money))) * 4) + 8)
        love.graphics.setColor(1, 1, 1, 1)
        drawOutlinedText(tostring(math.floor(money)), upBoxStuff.x + (love.graphics.getFont():getWidth(tostring(math.floor(money))) * 2) + 16,
            upBoxStuff.y + upBoxStuff.h + 32, 0, 4, 4, love.graphics.getFont():getWidth(tostring(math.floor(money))) / 2,
            love.graphics.getFont():getHeight(tostring(math.floor(money))) / 2, 8)


        --Draw the mega wave timer
        local txt = tostring(math.floor(megaWave.timer))
        drawOutlinedText(txt, gameSize.w - 8, upBoxStuff.y + upBoxStuff.h + 8, 0, 4, 4, love.graphics.getFont():getWidth(txt), 0,
            4, { 0, 0, 0 })


        --Draw the player hp
        local txt = tostring(math.floor(gameStuff.hp))
        love.graphics.setColor({ 1, 0, 0 })
        drawOutlinedText(txt, gameSize.w / 2, upBoxStuff.y + upBoxStuff.h + 8, 0, 4 + healthTextStuff.scaleAdd,
            4 + healthTextStuff.scaleAdd, love.graphics.getFont():getWidth(txt) / 2, 0, 4, { 0, 0, 0 })
        love.graphics.setColor({ 1, 1, 1 })


        --Draw the current modifier
        if modifier.current ~= nil then
            local txt = modifier.current.name
            if gameStuff.lang == "pt-br" then txt = modifier.current.namePT end
            drawOutlinedText(txt, 8, 600 - 4, 0, 4, 4, 0, love.graphics.getFont():getHeight(txt), 4, { 0, 0, 0 })
        end
    end


    --Reapply the camera transform
    love.graphics.applyTransform(gameCam.transform)


    --Draw mods draw functions that are in the back
    for f = 1, #modsStuff.behindDrawFunctions do
        if type(modsStuff.behindDrawFunctions[f]) == "function" then
            modsStuff.behindDrawFunctions[f]()
        end
    end


    --Reset the draw transform
    love.graphics.origin()


    --Order the buttons based in the z index of them
    table.sort(UiStuff, function (a, b) if a.zIndex == nil or b.zIndex == nil then return true end; if a.onTop then return false end if b.onTop then return true end return a.zIndex < b.zIndex end)
    --Draw all the game UI Instance
    for b = 1, #UiStuff do
        if UiStuff[b].visible and (UiStuff[b].alpha ~= nil and UiStuff[b].alpha > 0) then
            UiStuff[b]:draw()
        end
    end


    table.sort(gameCarButtonsDraw, function (a, b) return a.zIndex < b.zIndex end)
    --Draw the game car buttons if the player is in the game room
    if currentRoom == rooms.game then
        for b = 1, #gameCarButtonsDraw do
            gameCarButtonsDraw[b]:draw(false)


            if gameCarButtonsDraw[b].backColorOverride == nil then
                love.graphics.setColor({ 0, 0, 0, gameCarButtonsDraw[b].alpha })
            else
                love.graphics.setColor({ gameCarButtonsDraw[b].backColorOverride[1], gameCarButtonsDraw[b].backColorOverride[2],
                    gameCarButtonsDraw[b].backColorOverride[3],
                    gameCarButtonsDraw[b].alpha })
            end


            local sizeAdd = (gameCarButtonsDraw[b].size.w / gameCarButtonsDraw[b].wantedSize.w) +
                (gameCarButtonsDraw[b].size.h / gameCarButtonsDraw[b].wantedSize.h)
            drawOutlinedText("$" .. getCarByName(gameCarButtonsDraw[b].text).cost, gameCarButtonsDraw[b].pos.x,
                gameCarButtonsDraw[b].pos.y + (gameCarButtonsDraw[b].size.h / 2) - 16, gameCarButtonsDraw[b].rot, 1 * sizeAdd,
                1 * sizeAdd, nil, nil, 2,
                { (gameCarButtonsDraw[b].frontColorOverride or { 1, 1, 1 })[1], (gameCarButtonsDraw[b].frontColorOverride or { 1, 1, 1 })
                    [2], (gameCarButtonsDraw[b].frontColorOverride or { 1, 1, 1 })
                    [3], gameCarButtonsDraw[b].alpha })
            

            drawButtonDesc(gameCarButtonsDraw[b], love.graphics.getFont(), gameCarButtonsDraw[b].alpha)
        end
    end


    --Draw mods draw functions that are on front
    love.graphics.setColor({1, 1, 1})
    for f = 1, #modsStuff.frontDrawFunctions do
        if type(modsStuff.frontDrawFunctions[f]) == "function" then
            modsStuff.frontDrawFunctions[f]()
        end
    end


    --Draw the game instances that are on top of (almost) everything
    for t = 1, #onTopGameInstaces do
        if onTopGameInstaces[t] ~= nil then
            onTopGameInstaces[t]:draw()
        end
    end


    --Draw the pause menu instance, if it exists
    if pauseMenuInstance ~= nil then
        pauseMenuInstance:draw()
    end


    --Draw the red rect if the alpha for it is more than 0
    if damageEffectStuff.redRectRGBAdd > 0 then
        love.graphics.setColor(damageEffectStuff.redRectRGBAdd, 0, 0, damageEffectStuff.redRectRGBAdd)
        love.graphics.rectangle("fill", 0, 0, gameSize.w, gameSize.h)
    end


    --If the sceneTransition is enabled, draw it
    if sceneTransition.enabled then
        love.graphics.setColor({ 0, 0, 0 })
        love.graphics.rectangle("fill", 0, -1, love.graphics.getWidth() + 256,
            ((love.graphics.getHeight()) / 2) * sceneTransition.progress)
        love.graphics.rectangle("fill", 0,
            (love.graphics.getHeight() - 1) - (((love.graphics.getHeight() - 1) / 2) * (sceneTransition.progress)),
            love.graphics.getWidth() + 256, love.graphics.getHeight() / 2)
        love.graphics.setColor({ 1, 1, 1 })
        love.graphics.rectangle("line", -8, -1, love.graphics.getWidth() + 256,
            (love.graphics.getHeight() / 2) * sceneTransition.progress)
        love.graphics.rectangle("line", -8,
            (love.graphics.getHeight() + 1) - (((love.graphics.getHeight() - 1) / 2) * (sceneTransition.progress)),
            love.graphics.getWidth() + 256, love.graphics.getHeight() / 2)
    end


    --Draw the transition icon if it exists
    if sceneTransition.coolIcon ~= nil then
        sceneTransition.coolIcon:draw()
    end


    --Draw the mouse
    mouse:drawMouse()


    --Draw debug info
    if debugStuff.enabled then
        love.graphics.setColor({ 1, 1, 1 })
        drawOutlinedText("RedRect: " .. tostring(damageEffectStuff.redRectRGBAdd), 8, 8, 0, 1, 1, 0, 0)
        drawOutlinedText("FPS: " .. tostring(love.timer.getFPS()), 8, 16 + 4, 0, 1, 1, 0, 0)
        drawOutlinedText("gameCarsAmnt: " .. tostring(#GameCarInstances), 8, 16 + 8 + 4 + 4, 0, 1, 1, 0, 0)
        drawOutlinedText("FoggsAmnt: " .. tostring(#Foggs), 8, 16 + 8 + 8 + 4 + 4 + 4, 0, 1, 1, 0, 0)
        drawOutlinedText("gameInstancesAmnt: " .. tostring(#gameInstances), 8, 16 + 8 + 8 + 8 + 4 + 4 + 4 + 4, 0, 1, 1, 0, 0)
        drawOutlinedText("onTopGameInstancesAmnt: " .. tostring(#onTopGameInstaces), 8, 16 + 8 + 8 + 8 + 8 + 4 + 4 + 4 + 4 + 4, 0, 1, 1, 0, 0)
        drawOutlinedText("timeSinceStartLove2D: " .. tostring(love.timer.getTime()), 8, 16 + 8 + 8 + 8 + 4 + 4 + 4 + 4 + 16 + 4 + 4, 0, 1, 1, 0, 0)
        drawOutlinedText("timeSinceStartFromGame: " .. tostring(gameStuff.timeSinceStart), 8, 16 + 8 + 8 + 8 + 4 + 4 + 4 + 4 + 16 + 4 + 4 + 8 + 4, 0, 1, 1, 0, 0)
        drawOutlinedText("random Number: " .. tostring(love.math.random(1, 4)), 8, 16 + 8 + 8 + 8 + 4 + 4 + 4 + 4 + 16 + 4 + 4 + 8 + 4 + 8 + 4, 0, 1, 1, 0, 0)
        drawOutlinedText("random Number Lua: " .. tostring(math.random(1, 4)), 8, 16 + 8 + 8 + 8 + 4 + 4 + 4 + 4 + 16 + 4 + 4 + 8 + 4 + 8 + 4 + 8 + 4, 0, 1, 1, 0, 0)
        drawOutlinedText("global Random Number: " .. tostring(randomNumber), 8, 16 + 8 + 8 + 8 + 4 + 4 + 4 + 4 + 16 + 4 + 4 + 8 + 4 + 8 + 4 + 8 + 4 + 8 + 4, 0, 1, 1, 0, 0)
        drawOutlinedText("Ram used: " .. tostring(math.floor(collectgarbage("count") / 1024) .. " MB used"), 8, 16 + 8 + 8 + 8 + 4 + 4 + 4 + 4 + 16 + 4 + 4 + 8 + 4 + 8 + 4 + 8 + 4 + 8 + 4 + 8 + 4, 0, 1, 1, 0, 0)
        drawOutlinedText("Current frog gaved: " .. tostring(gameStuff.currentFoggGaved), 8, 16 + 8 + 8 + 8 + 4 + 4 + 4 + 4 + 16 + 4 + 4 + 8 + 4 + 8 + 4 + 8 + 4 + 8 + 4 + 8 + 4 + 4 + 8, 0, 1, 1, 0, 0)
        drawOutlinedText("Amount of UI Instances: " .. tostring(#UiStuff), 8, 16 + 8 + 8 + 8 + 4 + 4 + 4 + 4 + 16 + 4 + 4 + 8 + 4 + 8 + 4 + 8 + 4 + 8 + 4 + 8 + 4 + 4 + 8 + 4 + 8, 0, 1, 1, 0, 0)
        drawOutlinedText("Current starting round: " .. tostring(gameStuff.currentStartingRound), 8, 16 + 8 + 8 + 8 + 4 + 4 + 4 + 4 + 16 + 4 + 4 + 8 + 4 + 8 + 4 + 8 + 4 + 8 + 4 + 8 + 4 + 4 + 8 + 4 + 8 + 8 + 4, 0, 1, 1, 0, 0)
        drawOutlinedText("Target fps: " .. tostring(targetFps), 8, 16 + 8 + 8 + 8 + 4 + 4 + 4 + 4 + 16 + 4 + 4 + 8 + 4 + 8 + 4 + 8 + 4 + 8 + 4 + 8 + 4 + 4 + 8 + 4 + 8 + 8 + 4 + 8 + 4, 0, 1, 1, 0, 0)
        drawOutlinedText("Frog create timer: " .. tostring(foggCreateTimer), 8, 16 + 8 + 8 + 8 + 4 + 4 + 4 + 4 + 16 + 4 + 4 + 8 + 4 + 8 + 4 + 8 + 4 + 8 + 4 + 8 + 4 + 4 + 8 + 4 + 8 + 8 + 4 + 8 + 4 + 8 + 4, 0, 1, 1, 0, 0)
        drawOutlinedText("Weather change timer: " .. tostring(math.floor(weather.ticks)) .. "/" .. tostring(weather.timeUntilPass), 8, 16 + 8 + 8 + 8 + 4 + 4 + 4 + 4 + 16 + 4 + 4 + 8 + 4 + 8 + 4 + 8 + 4 + 8 + 4 + 8 + 4 + 4 + 8 + 4 + 8 + 8 + 4 + 8 + 4 + 8 + 4 + 8 + 4, 0, 1, 1, 0, 0)
    end


    --Tell "Push" to finish wtf he was doing
    if gameStuff.usePush then
        Push:finish()
    end
end

--Called when the window gets resized
function love.resize(w, h)
    --Update "Push"s, it is updated here and in love.update because my linux distro in making this function not run when i maximize the window
    Push:resize(w, h)


    if not gameStuff.usePush then
        grassCanvas = love.graphics.newCanvas(gameSize.w * 1.5, gameSize.h * 1.5)
        roadCanvas = love.graphics.newCanvas(gameSize.w * 1.5, gameSize.h * 1.5)
        roadSideCanvas = love.graphics.newCanvas(gameSize.w * 1.5, gameSize.h * 1.5)
        initBackgronds()
    end
end

--The function to create one new frog, just creates a new frog
function createANewFogg(altX, altY)
    local x = Lume.random(0, gameSize.w * 1.5)
    local y = 632 + Lume.random(-8, 256)
    local selectedFogg = gameStuff.currentFoggGaved


    if altX ~= nil then
        x = altX
    end
    if altY ~= nil then
        y = altY
    end


    createForg(x, y, selectedFogg, 2 + (selectedFogg * 0.5), 1.5 / (selectedFogg + 1))
end

--Called when one key gets pressed
function love.keypressed(key)
    --Update the key that was pressed and set that the keyboard was pressed in the current frame
    lastKeyPressed = key
    keyboardWasPressed = true


    --Do stuff based in the key pressed
    if key == "f11" then
        setFullscreen(not love.window.getFullscreen())
    end
    if key == "f2" then
        love.graphics.captureScreenshot(os.time() .. ".png")
        local suc = love.window.showMessageBox("screenShot", "screenshot captured succesfully", "info", false)
    end
    if key == "escape" then
        if currentRoom == rooms.mainMenu and currentRoom == rooms.start and currentRoom == rooms.startingOptions and currentRoom == rooms.credits and currentRoom == rooms.sourceCode then return end


        if pauseMenuInstance ~= nil then
            if pauseMenuInstance.bgAlpha >= 0.85 then
                gameStuff.paused = not gameStuff.paused


                if gameStuff.paused then
                    pauseMenuInstance = createPause()
                else
                    if pauseMenuInstance ~= nil and pauseMenuInstance.bgAlpha >= 0.85 then
                        pauseMenuInstance:die()
                    end
                end
            end
        else
            gameStuff.paused = not gameStuff.paused


            if gameStuff.paused then
                pauseMenuInstance = createPause()
            end
        end
    end
    if currentRoom == rooms.game then
        if tonumber(key) ~= nil and tonumber(key) <= #GameCars then
            gameCarButtons[tonumber(key)].hovered = true
            gameCarButtons[tonumber(key)].pressed = true
            gameStuff.hoveringTopBox = true
        end
    end
    if key == "lshift" then
        if gameStuff.speed == 1 then
            gameStuff.speed = 2
        elseif gameStuff.speed == 2 then
            gameStuff.speed = 3
        elseif gameStuff.speed == 3 then
            gameStuff.speed = 1
        end
    end
    if key == "f1" then
        debugStuff.enabled = not debugStuff.enabled
    end
    if key == "f5" then
        startEvent()
    end
end


--Gets text input
function love.textinput(text)
    --Update the key that was pressed and set that the keyboard was pressed in the current frame
    lastKeyPressed = text
    keyboardWasPressed = true
end


--Function to begin the car placing
function startCarPlacing(whatCar)
    selectedCar = whatCar
    placingCar = true
    currentSelectedCar = createCarInstance(GameCars[whatCar], PushsInGameMousePos.x, PushsInGameMousePos.y, false, true)
    table.remove(GameCarInstances, tableFind(GameCarInstances, currentSelectedCar))
end

--The function to stop car placing
function stopCarPlacing()
    selectedCar = nil
    placingCar = false
    currentSelectedCar = nil
    mouse.showRMBIcon = false
    mouse.showLMBIcon = false
    mouse.RMBModulate = { 1, 1, 1 }
    mouse.LMBModulate = { 1, 1, 1 }
end

--The function to enable screen shake
function enableScreenShake(force)
    screenShake.enabled = true
    screenShake.force = Lume.clamp(force, 0, 128)
end

--The function to change rooms
function changeRoom(toWhat)
    if sceneTransition.enabled or currentRoom == toWhat then return end


    sceneTransition.coolIcon = createCoolTransition()


    rm = toWhat
    sceneTransition.enabled = true
    Flux.to(sceneTransition, 0.5, { progress = 1 }):ease("expoin"):oncomplete(setRoom):after(sceneTransition, 0.5,
        { progress = 0 }):ease("expoout"):oncomplete(disableTransition)
end

--The function to disable the transition (set that the transition is not running)
function disableTransition()
    sceneTransition.enabled = false
end

--The function to set the current room, it needs to be run by the "changeScene" function
function setRoom()
    if currentRoom == rm then return end


    if currentRoom == rooms.mainMenu and mainMenuInstance ~= nil then mainMenuInstance.creditsButton = nil end
    if currentRoom == rooms.game then
        createCamMoveTutorial(); gameCarButtons = {}; speedUpButton = nil
    end


    currentRoom = rm


    while #GameCarInstances > 0 do
        tableClear(GameCarInstances)
    end
    megaWave.timer = 60
    startThingInstance = nil
    tableClear(Foggs)
    UiStuff = {}
    pauseMenuInstance = nil
    gameStuff.paused = false
    onTopGameInstaces = {}
    gameStuff.canPlaceFroggs = false
    gameStuff.eventPause = false
    foggCreateTimerDef = 5
    gameStuff.currentFoggGaved = 0
    gameStuff.hp = 10
    modifier.current = modifier.nameList.NO_MOD
    money = 100


    if rm == rooms.game then
        gameCarButtons = {}
        speedUpButton = createButton(35, 64, 50, 84, "1x", "LMB to speed down\nRMB to speed up")
        speedUpButton.disabled = true
        createCamMoveTutorial()
        bagStuff:initBag()
        if gameStuff.currentStartingRound ~= nil then
            gameStuff.currentFoggGaved = gameStuff.currentStartingRound
            money = money + (100 * gameStuff.currentStartingRound)
        end
        if gameStuff.currentStartingRound < gameStuff.currentFoggGaved then
            gameStuff.currentFoggGaved = 0
        end

        local orderedCars = GameCars
        table.sort(orderedCars, function(carA, carB)
            return carA.cost < carB.cost
        end)
        table.sort(orderedCars, function(carA, carB)
            if carA.category ~= carB.category then
                return carA.category < carB.category
            else
                return carA.cost < carB.cost
            end
        end)

        for c = 1, #orderedCars do
            local b = createButton(0 + 128 * c, 64, 108, 108, GameCars[c].name, GameCars[c].desc, true)


            if GameCars[c].category == carsCategorys.Common then
                b.frontColorOverride = HSV(0.6, 1, 1)
                b.backColorOverride = HSV(0.8, 1, 0.15)
            elseif GameCars[c].category == carsCategorys.Military then
                b.frontColorOverride = HSV(0.4, 1, 1)
                b.backColorOverride = HSV(0.6, 1, 0.15)
            elseif GameCars[c].category == carsCategorys.Special then
                b.frontColorOverride = HSV(0.8, 1, 1)
                b.backColorOverride = HSV(1, 1, 0.15)
            elseif GameCars[c].category == carsCategorys.Explosive then
                b.frontColorOverride = HSV(0, 1, 1)
                b.backColorOverride = HSV(0.8, 1, 0.15)
            elseif GameCars[c].category == carsCategorys.MoneyGenerator then
                b.frontColorOverride = HSV(0.15, 1, 1)
                b.backColorOverride = HSV(0, 1, 0.15)
            end


            table.remove(UiStuff, tableFind(UiStuff, b))


            table.insert(gameCarButtons, #gameCarButtons + 1, b)
            table.insert(gameCarButtonsDraw, #gameCarButtonsDraw + 1, b)
        end
    end
end

--The function to update all the cars
function updateAllCars()
    for c = 1, #GameCarInstances do
        if GameCarInstances[c] ~= nil then
            GameCarInstances[c]:update()
        end
    end
end

--The function to draw all cars
function drawAllCars()
    for c = 1, #GameCarInstances do
        love.graphics.setColor({ 1, 1, 1 })
        love.graphics.draw(GameCarInstances[c].driveParticle)


        --Draw drifting trails
        for t = 1, #GameCarInstances[c].trailPoses do
            if t >= #GameCarInstances[c].trailPoses then break end


            love.graphics.setLineWidth(32)
            love.graphics.setColor({ 0, 0, 0, Lume.clamp(1 * (t / #GameCarInstances[c].trailPoses), 0, 0.9) })


            if Lume.distance(GameCarInstances[c].trailPoses[t].x, GameCarInstances[c].trailPoses[t].y, GameCarInstances[c].trailPoses[t + 1].x, GameCarInstances[c].trailPoses[t + 1].y) <= 32 then
                love.graphics.line(GameCarInstances[c].trailPoses[t].x, GameCarInstances[c].trailPoses[t].y,
                    GameCarInstances[c].trailPoses[t + 1].x, GameCarInstances[c].trailPoses[t + 1].y)
            end


            love.graphics.setLineWidth(1)
        end


        if GameCarInstances[c] ~= nil then
            GameCarInstances[c]:draw()
        end
    end
end

--Function to get an car based in his name
function getCarByName(carName)
    for c = 1, #GameCars do
        if GameCars[c].name == carName or GameCars[c].namePT == carName then
            return GameCars[c]
        end
    end
end

--The function to make the playe recieve damage
function recieveDamage(dmg, x, y)
    gameStuff.hp = gameStuff.hp - dmg
    gameCam.zoom = 0.85
    damageEffectStuff.redRectRGBAdd = 1
    createDamageText(x, y)
end

--The function to update the music volume
function updateMusicVolume()
    explosionSfx:setVolume(gameStuff.sfxVolume)
    moneyGainSfx:setVolume(gameStuff.sfxVolume)
    interactSfx:setVolume(gameStuff.sfxVolume)
    modChangeSfx:setVolume(gameStuff.sfxVolume)
    warningSfx:setVolume(gameStuff.sfxVolume - 0.25)
    for c = 1, #GameCarInstances do
        if GameCarInstances[c] ~= nil then
            GameCarInstances[c].walkSfx:setVolume(gameStuff.sfxVolume - 0.1)
            if GameCarInstances[c].startSfx ~= nil then
                GameCarInstances[c].startSfx:setVolume(gameStuff.sfxVolume - 0.1)
            end
        end
    end


    for m = 1, #musics do
        musics[m]:setVolume(Lume.clamp(gameStuff.musicVolume + gameStuff.musicVolumeAdd, 0, 1))
    end
end


--Set if the game is on fullscreen
function setFullscreen(Yes)
    love.window.setFullscreen(Yes)
end


--Sets if the game gonna use vsync
function setVSyncUse(Use)
    if Use then
        useVSync = true
        love.window.setVSync(1)
    else
        useVSync = false
        love.window.setVSync(0)
    end
end

--Gets if one position is inside the camera
function isPointInsideCam(x, y)
    return x >= (gameCam.pos.x + gameCam.offset.x) - ((gameSize.w) * gameCam.zoom) and
        x <= (gameCam.pos.x + gameCam.offset.x) - ((gameSize.w / 2) * gameCam.zoom) + gameSize.w * 2 and
        y >= (gameCam.pos.y + gameCam.offset.y) - ((gameSize.h) * gameCam.zoom) and
        y <= (gameCam.pos.y + gameCam.offset.y) - ((gameSize.h / 2) * gameCam.zoom) + gameSize.h * 2
end

--Function to create the transition icon
function createCoolTransition()
    local c = {
        icons = {
            love.graphics.newImage("Sprs/Icons/Face1.png"),
            love.graphics.newImage("Sprs/Icons/Face2.png"),
            love.graphics.newImage("Sprs/Icons/Face3.png"),
            love.graphics.newImage("Sprs/Icons/Face4.png"),
            love.graphics.newImage("Sprs/Icons/Face5.png"),
        },
        currentIcon = love.math.random(1, 5),
        iconScale = 0,
        iconRot = -6,
        coolParticles = love.graphics.newParticleSystem(love.graphics.newImage("Sprs/Icons/ParticleCool.png"), 100),
    }


    function c:init()
        self.coolParticles:setParticleLifetime(2, 3)
        self.coolParticles:moveTo(gameSize.w / 2, gameSize.h / 2)
        self.coolParticles:setLinearAcceleration(-2000, -800, 2000, 600)
        self.coolParticles:setSizes(2, 4)
        self.coolParticles:setRotation(-3, 3)
        self.coolParticles:setColors({ 1, 1, 1, 1 }, { 1, 1, 1, 0 })
        self.coolParticles:setDirection(-1)
        self.coolParticles:setParticleLifetime(1, 2)
        self.coolParticles:emit(32)


        Flux.to(self, 0.25, { iconScale = 8, iconRot = 0 }):ease("expoout"):after(self, 0.25,
            { iconScale = 0, iconRot = 6 }):delay(0.5):ease("expoin"):oncomplete(c.deleteSelf)
    end

    function c:update()
        self.coolParticles:update(globalDt)
    end

    function c:draw()
        love.graphics.draw(self.coolParticles)


        drawOutlinedSprite(self.icons[self.currentIcon], gameSize.w / 2, gameSize.h / 2, self.iconRot, self.iconScale, self.iconScale,
            self.icons[self.currentIcon]:getWidth() / 2, self.icons[self.currentIcon]:getHeight() / 2, 8,
            HSV(0.5 + 0.5 * math.sin(GlobalSinAngle * 4), 1, 1))
    end

    function c:deleteSelf()
        sceneTransition.coolIcon = nil
    end

    c:init()


    return c
end

--Function to make an y pos translate to one car y position AKA fix one y pos to one grid
function transformToCarYPosGrid(posY)
    return Lume.clamp(math.floor(posY / carGridLockDist) * carGridLockDist, 0, 510)
end

--Function to use an bag item
function recieveBagItem(whatItem)
    createBagItemRecieveText(whatItem)
    table.insert(bagStuff.stored, #bagStuff.stored + 1, whatItem)
end

--Function that runs when the mouse gets scrolled
function love.wheelmoved(x, y)
    mouseScroll.x = x
    mouseScroll.y = y
end

--Function to delete UI Instances
function deleteUIInstance(whatInstance)
    table.remove(UiStuff, tableFind(UiStuff, whatInstance))
end

--Function to reload the mods
function loadMods()
    local modsFileInfo = love.filesystem.getInfo("Mods", "directory")
    if #modsFileInfo == 0 then love.filesystem.createDirectory("Mods") end
    local requireFolders = "?.lua;?/init.lua;/Mods/?.lua"
    local files = love.filesystem.getDirectoryItems("Mods")
    for f = 1, #files do
        local currentFileName = files[f]
        local extenType = string.find(currentFileName, ".lua")


        if extenType == nil then
            requireFolders = requireFolders .. ";" .. "/" .. currentFileName .. "/?.lua"
        end
    end


    love.filesystem.setRequirePath(requireFolders)


    for f = 1, #files do
        local currentFileName = files[f]
        local extenType = string.find(currentFileName, ".lua")


        if extenType ~= nil then
            currentFileName = string.sub(currentFileName, 0, extenType - 1)


            if currentFileName ~= "mods" then
                require("Mods." .. currentFileName)
                table.insert(mods, #mods + 1, currentFileName)
            end
        end
    end
end

--Function to sort game instances besed on zIndex
function sortGameInstances()
    table.sort(gameInstances, function(a, b)
        if a.zIndex == nil then a.zIndex = 0 end
        if b.zIndex == nil then b.zIndex = 0 end


        return a.zIndex < b.zIndex
    end)
    table.sort(GameCars, function(a, b)
        if a.zIndex == nil then a.zIndex = 0 end
        if b.zIndex == nil then b.zIndex = 0 end


        return a.zIndex < b.zIndex
    end)
    table.sort(Foggs, function(a, b)
        if a.zIndex == nil then a.zIndex = 0 end
        if b.zIndex == nil then b.zIndex = 0 end


        return a.zIndex < b.zIndex
    end)
end


--Function to update time stuff
function updateTime()
    if time.ticks >= time.timeUntilPass then
        time.currentTime = time.currentTime + 1


        if time.currentTime > time.TIMES.SUNRISE then
            time.currentTime = time.TIMES.DAY
        end


        time.ticks = 0
    end
end


--Function to update weather stuff
function updateWeather()
    if weather.ticks > weather.timeUntilPass then
        weather.weatherAlpha = Lume.lerp(weather.weatherAlpha, 0, 6)


        if weather.weatherAlpha <= 0.1 then
            local isClear = math.random(0, 2)
            if weather.currentWeather == weather.WEATHERS.CLEAN then
                isClear = math.random(0, 1)
            end


            if isClear == 0 then
                local newW = math.random(0, 3)
                while weather.currentWeather == newW do newW = math.random(0, 3) end
                weather.currentWeather = newW
            else
                weather.currentWeather = weather.WEATHERS.CLEAN
            end


            weather.ticks = 0
        end
    else
        weather.weatherAlpha = Lume.lerp(weather.weatherAlpha, 1, 6)
    end


    weather.ticks = weather.ticks + (1 * gameStuff.speed) * globalDt
end


--Converts an in world pos to a in screen pos
function toScreen(x, y)
    local p = {gameCam.transform:transformPoint(x, y)}
    return p
end


--Gets the name of an category using it index
function getCarCategory(id)
    local result = carsCategorys.numbers[id + 1]


    if result == 0 then
        return translateTextToPT("Common")
    elseif result == 1 then
        return translateTextToPT("Military")
    elseif result == 2 then
        return translateTextToPT("Special")
    elseif result == 3 then
        return translateTextToPT("Explosive")
    elseif result == 4 then
        return translateTextToPT("Money Generator")
    end
end


--Function that translates some strings
function translateTextToPT(text)
    text = text or ""
    if gameStuff.lang ~= "pt-br" then return text end


    if text == "Common" then
        return "Comum"
    elseif text == "Military" then
        return "Militar"
    elseif text == "Special" then
        return "Especial"
    elseif text == "Explosive" then
        return "Explosivo"
    elseif text == "Money Generator" then
        return "Gerador de dinheiro"
    end
end


--Do stuff if the window is occluded
function love.occluded()
    redrawGame = false
end


--Do stuff if the window was occluded but it is not anymore
function love.exposed()
    redrawGame = true
end