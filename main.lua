Push = require "external librarys.push"
Lume = require "external librarys.lume"
Flux = require "external librarys.flux"
utf8 = require "utf8"


love.graphics.setDefaultFilter("nearest", "nearest")


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


GameCarInstances = {}
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
			0
		),
		4,
		400,
		1,
		1,
		4
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
			0
		),
		4.5,
		200,
		2,
		0.5,
		4,
		200,
		2,
		2,
		256
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
			0
		),
		3,
		1000,
		0.5,
		2,
		20,
		400,
		1,
		1.5,
		64
	),
	createCar(
		"Seller Car",
		"Carro Vendedor",
		"One seller car to enforce capitalism and inequality for everyone! Produces 20% of the money you generated in the last 5 seconds, has 1 hp and deals 0 damage",
		"Um carro vendedor para enforcar o capitalismo e desigualdade para todos! Produz 20% do dinheiro que voce gerou nos ultimos 5 segundos, tem 1 de vida e da 0 de dano",
		newAnimation(
			love.graphics.newImage("Sprs/Cars/Seller Car.png"),
			20,
			20,
			0,
			0
		),
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
			recieveCooldownDef = 5,
			recieveCooldown = 5,
		}
	),
}
upBoxStuff = {x = -1, y = 0, w = 802, h = 128}
UiStuff = {}
placingStuff = {
	minX = 0,
	maxX = 800,
}
PushsInGameMousePos = {x = 0, y = 0}
LastLeftMouseButton = false
LastRightMouseButton = false
gameCarButtons = {}
selectedCar = 1
placingCar = false
Foggs = {}
GlobalSinAngle = 0
carGridLockDist = 64
foggCreateTimerDef = 5
foggCreateTimer = foggCreateTimerDef
megaWave = {
	timer = 60,
	timerDef = 60,
	force = 16,
	enabled = false,
}
gameInstances = {}
yForCar = math.floor(PushsInGameMousePos.y / carGridLockDist) * carGridLockDist
globalDt = 1
camera = {
	offset = {x = 0, y = 0},
	trans = love.math.newTransform(),
}
money = 100

--Game Mods
modList = {
	{
		name = "No Mod",
		id = -1,
	},
	{
		name = "Half Screen",
		id = 0,
	},
	{
		name = "Half Car Speed",
		id = 1,
	},
	{
		name = "Times Two Car Speed",
		id = 2,
	},
	{
		name = "Half Money Gain",
		id = 3,
	},
	{
		name = "Two Times Money Gain",
		id = 4,
	},
	{
		name = "Half Fogg Life",
		id = 5,
	},
	{
		name = "Times Two Fogg Life",
		id = 6,
	},
	{
		name = "Half Car Life",
		id = 7,
	},
	{
		name = "Times Two Car Life",
		id = 8,
	},
	{
		name = "Times Two Car Size",
		id = 9,
	},
	{
		name = "Times Two Everything",
		id = 10,
	},
	{
		name = "Half Everything",
		id = 11,
	},
}


--The modifiers vars
modifier = {
	current = modList[1],
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
screenShake = {
	force = 0,
	enabled = false,
}
gameCam = {
	pos = {x = 0, y = 0},
	transform = love.math.newTransform(),
	offset = {x = 0, y = 0},
	zoom = 1,
	rot = 0,
}
love.mouse.setVisible(false)
rooms = {
	quit = -1,
	start = 0.5,
	mainMenu = 0,
	game = 1,
}
carsStuff = {
	walkSfxAmnt = 0,
}
currentRoom = rooms.start
oldMousePos = {x = 0, y = 0}
sceneTransition = {
	progress = 0,
	enabled = false,
}
gameStuff = {
	paused = false,
	speed = 1,
	lang = "eng",
	currentFoggGaved = 0,
	hp = 10,
	timeSinceStart = 0,
	sfxVolume = 0.25,
	musicVolume = 0.5,
	musicVolumeAdd = 0,
	currentVersion = "0.0.1 Alpha",
}
onTopGameInstaces = {}
moneyGainDiv = 1
moneyGainMult = 1
debugStuff = {
	enabled = false,
}
healthTextStuff = {
	scaleAdd = 0,
	beatTimer = 1,
	beatTimerDef = 1,
}
oldPlacingCar = false
damageEffectStuff = {
	redRectRGBAdd = 0,
}


for c=1, #GameCars do
	table.insert(gameCarButtons, #gameCarButtons + 1, createButton(0 + 128 * c, 64, 108, 108, GameCars[c].name, GameCars[c].desc, false))
end
speedUpButton = createButton(35, 64, 50, 84, "1x", "LMB to speed down\nRMB to speed up")
speedUpButton.disabled = true


function love.run()
	Push:setupScreen(800, 600, 800, 600)
	love.window.setTitle("Foggers")


	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end


function love.load(args, unfilteredArgs)
	love.graphics.setLineStyle("rough")


	updateMusicVolume()


	playMusic(1)


	loadGame()
end


function love.update(dt)
	local mP = {gameCam.transform:inverseTransformPoint(Push:toGame(love.mouse.getX(), love.mouse.getY()))}
	PushsInGameMousePos = {x = mP[1], y = mP[2]}
	globalDt = dt


	if gameStuff.paused then
		explosionSfx:pause()
		moneyGainSfx:pause()
		interactSfx:pause()
		modChangeSfx:pause()
		warningSfx:pause()
		for c=1, #GameCarInstances do
			if GameCarInstances[c] ~= nil then
				GameCarInstances[c].walkSfx:pause()
				if GameCarInstances[c].startSfx ~= nil then
					GameCarInstances[c].startSfx:pause()
				end
			end
		end
	end
	updateMusicVolume()
	


	if musics[currentMusic]:tell() >= musics[currentMusic]:getDuration() - 1 then
		if gameStuff.musicVolumeAdd == 0 then
			Flux.to(gameStuff, 1, {musicVolumeAdd = -1}):oncomplete(playRandomMusic):after(gameStuff, 1, {musicVolumeAdd = 0})
		end
	end


	if not gameStuff.paused then
		for u=1, #gameInstances do
			if gameInstances[u] ~= nil then
				gameInstances[u]:update()
			end
		end


		if currentRoom ~= rooms.start then startThingInstance = nil end
		if currentRoom ~= rooms.mainMenu then mainMenuInstance = nil end


		if currentRoom == rooms.quit then
			love.event.quit()
		elseif currentRoom == rooms.start then
			if startThingInstance == nil then
				startThingInstance = createStartThing()
			else
				startThingInstance:update()
			end
		elseif currentRoom == rooms.mainMenu then
			Foggs = {}
			gameInstances = {}
			gameStuff.speed = 1


			if mainMenuInstance == nil then
				mainMenuInstance = createMainMenu()
			else
				mainMenuInstance:update()


				updateAllCars()


				for c=1, #GameCarInstances do
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
			yForCar = Lume.clamp(math.floor(PushsInGameMousePos.y / carGridLockDist) * carGridLockDist, upBoxStuff.h, 510)


			for c=1, #gameCarButtons do
				if gameStuff.lang == "pt-br" then
					gameCarButtons[c].text = GameCars[c].namePT
				else
					gameCarButtons[c].text = GameCars[c].name
				end
			end


			for b=1, #UiStuff do
				UiStuff[b]:update(dt)
			end
			updateAllCars()
			for f=1, #Foggs do
				if Foggs[f] ~= nil then
					Foggs[f]:update()
				end
			end


			local pressedAnyBtn = false
			local currentBtnSelected = selectedCar


			for b=1, #gameCarButtons do
				if gameCarButtons[b].hovered then
					pressedAnyBtn = true
					currentBtnSelected = b
				end


				if gameCarButtons[b].pressed then
					if placingCar == false then
						startCarPlacing(b)
					else
						if currentBtnSelected == selectedCar then
							stopCarPlacing()
						else
							selectedCar = currentBtnSelected
							placingCar = true
						end
					end


					gameCarButtons[b].pressed = false
				end
			end


			if placingCar and love.mouse.isDown(2) then
				stopCarPlacing()
			end


			if oldPlacingCar == false and placingCar then
				mouse.showRMBIcon = true
				mouse.showLMBIcon = true
				mouse.RMBModulate = {1, 0.85, 0.85}
				mouse.LMBModulate = {0.85, 0.85, 1}
			end
			if oldPlacingCar and placingCar == false then
				mouse.showRMBIcon = false
				mouse.showLMBIcon = false
				mouse.RMBModulate = {1, 1, 1}
				mouse.LMBModulate = {1, 1, 1}
			end


			if pressedAnyBtn == false then
				if placingCar then
					if love.mouse.isDown(1) and LastLeftMouseButton == false then
						if money >= GameCars[selectedCar].cost then
							money = money - GameCars[selectedCar].cost
							createCarInstance(GameCars[selectedCar], Lume.clamp(PushsInGameMousePos.x, placingStuff.minX, placingStuff.maxX), yForCar)
						end
					end
				end
			end


			if not megaWave.enabled then
				if foggCreateTimer <= 0 then
					createANewFogg()
					foggCreateTimer = foggCreateTimerDef
				end
			end


			if megaWave.timer <= 0 then
				if not megaWave.enabled then
					megaWave.enabled = true
					foggCreateTimerDef = foggCreateTimerDef - 0.5
					createMegaWaveWarning()


					for f=0, megaWave.force * Lume.clamp(gameStuff.currentFoggGaved, 1, 99999) do
						local posToPut = math.random(0, 2)
						local modX = 0
						local modY = 0


						if posToPut == 0 then
							modX = 0
							modY = math.random(600 / 2, 632)
						end
						if posToPut == 1 then
							modX = math.random(0, 800)
							modY = 632
						end
						if posToPut == 2 then
							modX = 800
							modY = math.random(600 / 2, 632)
						end


						createANewFogg(modX, modY)
					end
				end
			end


			if gameStuff.hp <= 0 then
				changeRoom(rooms.mainMenu)
			end


			carsStuff.walkSfxAmnt = 0


			for c=1, #GameCarInstances do
				if GameCarInstances[c].walkSfx ~= nil then
					carsStuff.walkSfxAmnt = carsStuff.walkSfxAmnt + 1
				end
				if carsStuff.walkSfxAmnt > 10 then
					GameCarInstances[c].walkSfx:stop()
				else
					if not GameCarInstances[c].walkSfx:isPlaying() then
						GameCarInstances[c].walkSfx:play()
					end
				end
			end


			if speedUpButton.hovered then
				if love.mouse.isDown(2) then gameStuff.speed = gameStuff.speed + 5 * dt end
				if love.mouse.isDown(1) then gameStuff.speed = gameStuff.speed - 5 * dt end
			end
			if speedUpButton.oldHovered == false and speedUpButton.hovered then
				mouse.showLMBIcon = true
				mouse.showRMBIcon = true
				mouse.LMBModulate = {1, 0.5, 0.5}
				mouse.RMBModulate = {1, 0.5, 0.5}
			end
			if speedUpButton.oldHovered and speedUpButton.hovered == false then
				mouse.showLMBIcon = false
				mouse.showRMBIcon = false
				mouse.LMBModulate = {1, 1, 1}
				mouse.RMBModulate = {1, 1, 1}
			end
			speedUpButton.text = "x" .. tostring(math.floor(gameStuff.speed))


			if #Foggs <= 0 and megaWave.enabled then
				megaWave.enabled = false
				gameStuff.currentFoggGaved = gameStuff.currentFoggGaved + 1
				modifier.current = modList[math.random(1, #modList)]
				playSound(modChangeSfx)
				megaWave.timer = megaWave.timerDef
			end


			megaWave.timer = megaWave.timer - (1 * gameStuff.speed) * dt


			if not megaWave.enabled then
				foggCreateTimerDef = foggCreateTimerDef - (0.01 * gameStuff.speed) * dt
			end
			if healthTextStuff.beatTimer <= 0 then
				healthTextStuff.scaleAdd = 3
				healthTextStuff.beatTimer = healthTextStuff.beatTimerDef
			end
			

			healthTextStuff.beatTimer = healthTextStuff.beatTimer - (1 * gameStuff.speed) * dt
			healthTextStuff.scaleAdd = Lume.lerp(healthTextStuff.scaleAdd, 0, 0.1)
			oldPlacingCar = placingCar


			--#region Make the modifiers work
				if modifier.current == modifier.nameList.NO_MOD then
					moneyGainDiv = 1
					moneyGainMult = 1
					for c=1, #GameCarInstances do
						GameCarInstances[c].hpDivCar = 1
						GameCarInstances[c].spdDivCar = 1
						GameCarInstances[c].hpMultCar = 1
						GameCarInstances[c].spdMultCar = 1
						GameCarInstances[c].scaleAdd = 0
					end
					placingStuff.minX = 0
					placingStuff.maxX = 800
					for f=1, #Foggs do
						Foggs[f].spdDivFogg = 1
						Foggs[f].hpDivFogg = 1
						Foggs[f].spdMultFogg = 1
						Foggs[f].hpMultFogg = 1
					end
				elseif modifier.current == modifier.nameList.MOD_HALF_CAR_LIFE then
					moneyGainDiv = 1
					moneyGainMult = 1
					for c=1, #GameCarInstances do
						GameCarInstances[c].hpDivCar = 2
						GameCarInstances[c].spdDivCar = 1
						GameCarInstances[c].hpMultCar = 1
						GameCarInstances[c].spdMultCar = 1
						GameCarInstances[c].scaleAdd = 0
					end
					placingStuff.minX = 0
					placingStuff.maxX = 800
					for f=1, #Foggs do
						Foggs[f].spdDivFogg = 1
						Foggs[f].hpDivFogg = 1
						Foggs[f].spdMultFogg = 1
						Foggs[f].hpMultFogg = 1
					end
				elseif modifier.current == modifier.nameList.MOD_HALF_CAR_SPEED then
					moneyGainDiv = 1
					moneyGainMult = 1
					for c=1, #GameCarInstances do
						GameCarInstances[c].hpDivCar = 1
						GameCarInstances[c].spdDivCar = 2
						GameCarInstances[c].hpMultCar = 1
						GameCarInstances[c].spdMultCar = 1
						GameCarInstances[c].scaleAdd = 0
					end
					placingStuff.minX = 0
					placingStuff.maxX = 800
					for f=1, #Foggs do
						Foggs[f].spdDivFogg = 1
						Foggs[f].hpDivFogg = 1
						Foggs[f].spdMultFogg = 1
						Foggs[f].hpMultFogg = 1
					end
				elseif modifier.current == modifier.nameList.MOD_HALF_EVERYTHING then
					moneyGainDiv = 2
					moneyGainMult = 1
					for c=1, #GameCarInstances do
						GameCarInstances[c].hpDivCar = 2
						GameCarInstances[c].spdDivCar = 2
						GameCarInstances[c].hpMultCar = 1
						GameCarInstances[c].spdMultCar = 1
						GameCarInstances[c].scaleAdd = 0
					end
					placingStuff.minX = 0
					placingStuff.maxX = 800
					for f=1, #Foggs do
						Foggs[f].spdDivFogg = 2
						Foggs[f].hpDivFogg = 2
						Foggs[f].spdMultFogg = 1
						Foggs[f].hpMultFogg = 1
					end
				elseif modifier.current == modifier.nameList.MOD_HALF_FOGG_LIFE then
					moneyGainDiv = 1
					moneyGainMult = 1
					for c=1, #GameCarInstances do
						GameCarInstances[c].hpDivCar = 1
						GameCarInstances[c].spdDivCar = 1
						GameCarInstances[c].hpMultCar = 1
						GameCarInstances[c].spdMultCar = 1
						GameCarInstances[c].scaleAdd = 0
					end
					placingStuff.minX = 0
					placingStuff.maxX = 800
					for f=1, #Foggs do
						Foggs[f].spdDivFogg = 1
						Foggs[f].hpDivFogg = 2
						Foggs[f].spdMultFogg = 1
						Foggs[f].hpMultFogg = 1
					end
				elseif modifier.current == modifier.nameList.MOD_HALF_MONEY_GAIN then
					moneyGainDiv = 2
					moneyGainMult = 1
					for c=1, #GameCarInstances do
						GameCarInstances[c].hpDivCar = 1
						GameCarInstances[c].spdDivCar = 1
						GameCarInstances[c].hpMultCar = 1
						GameCarInstances[c].spdMultCar = 1
						GameCarInstances[c].scaleAdd = 0
					end
					placingStuff.minX = 0
					placingStuff.maxX = 800
					for f=1, #Foggs do
						Foggs[f].spdDivFogg = 1
						Foggs[f].hpDivFogg = 1
						Foggs[f].spdMultFogg = 1
						Foggs[f].hpMultFogg = 1
					end
				elseif modifier.current == modifier.nameList.MOD_HALF_SCREEN then
					moneyGainDiv = 1
					moneyGainMult = 1
					for c=1, #GameCarInstances do
						GameCarInstances[c].hpDivCar = 1
						GameCarInstances[c].spdDivCar = 1
						GameCarInstances[c].hpMultCar = 2
						GameCarInstances[c].spdMultCar = 1
						GameCarInstances[c].scaleAdd = 0
					end
					placingStuff.minX = 800 / 2
					placingStuff.maxX = 800
					for f=1, #Foggs do
						Foggs[f].spdDivFogg = 1
						Foggs[f].hpDivFogg = 1
						Foggs[f].spdMultFogg = 1
						Foggs[f].hpMultFogg = 1
					end
				elseif modifier.current == modifier.nameList.MOD_TIMES_TWO_CAR_LIFE then
					moneyGainDiv = 1
					moneyGainMult = 1
					for c=1, #GameCarInstances do
						GameCarInstances[c].hpDivCar = 1
						GameCarInstances[c].spdDivCar = 1
						GameCarInstances[c].hpMultCar = 2
						GameCarInstances[c].spdMultCar = 1
						GameCarInstances[c].scaleAdd = 0
					end
					placingStuff.minX = 0
					placingStuff.maxX = 800
					for f=1, #Foggs do
						Foggs[f].spdDivFogg = 1
						Foggs[f].hpDivFogg = 1
						Foggs[f].spdMultFogg = 1
						Foggs[f].hpMultFogg = 1
					end
				elseif modifier.current == modifier.nameList.MOD_TIMES_TWO_CAR_SIZE then
					moneyGainDiv = 1
					moneyGainMult = 1
					for c=1, #GameCarInstances do
						GameCarInstances[c].hpDivCar = 1
						GameCarInstances[c].spdDivCar = 1
						GameCarInstances[c].hpMultCar = 1
						GameCarInstances[c].spdMultCar = 2
						GameCarInstances[c].scaleAdd = 0
						GameCarInstances[c].scaleAdd = GameCarInstances[c].fromCar.scale
					end
					placingStuff.minX = 0
					placingStuff.maxX = 800
					for f=1, #Foggs do
						Foggs[f].spdDivFogg = 1
						Foggs[f].hpDivFogg = 1
						Foggs[f].spdMultFogg = 1
						Foggs[f].hpMultFogg = 1
					end
				elseif modifier.current == modifier.nameList.MOD_TIMES_TWO_CAR_SPEED then
					moneyGainDiv = 1
					moneyGainMult = 1
					for c=1, #GameCarInstances do
						GameCarInstances[c].hpDivCar = 1
						GameCarInstances[c].spdDivCar = 1
						GameCarInstances[c].hpMultCar = 1
						GameCarInstances[c].spdMultCar = 2
						GameCarInstances[c].scaleAdd = 0
					end
					placingStuff.minX = 0
					placingStuff.maxX = 800
					for f=1, #Foggs do
						Foggs[f].spdDivFogg = 1
						Foggs[f].hpDivFogg = 1
						Foggs[f].spdMultFogg = 1
						Foggs[f].hpMultFogg = 1
					end
				elseif modifier.current == modifier.nameList.MOD_TIMES_TWO_EVERYTHING then
					moneyGainDiv = 1
					moneyGainMult = 2
					for c=1, #GameCarInstances do
						GameCarInstances[c].hpDivCar = 1
						GameCarInstances[c].spdDivCar = 1
						GameCarInstances[c].hpMultCar = 2
						GameCarInstances[c].spdMultCar = 2
						GameCarInstances[c].scaleAdd = 0
					end
					placingStuff.minX = 0
					placingStuff.maxX = 800
					for f=1, #Foggs do
						Foggs[f].spdDivFogg = 1
						Foggs[f].hpDivFogg = 1
						Foggs[f].spdMultFogg = 2
						Foggs[f].hpMultFogg = 2
					end
				elseif modifier.current == modifier.nameList.MOD_TIMES_TWO_FOGG_LIFE then
					moneyGainDiv = 1
					moneyGainMult = 1
					for c=1, #GameCarInstances do
						GameCarInstances[c].hpDivCar = 1
						GameCarInstances[c].spdDivCar = 1
						GameCarInstances[c].hpMultCar = 1
						GameCarInstances[c].spdMultCar = 1
						GameCarInstances[c].scaleAdd = 0
					end
					placingStuff.minX = 0
					placingStuff.maxX = 800
					for f=1, #Foggs do
						Foggs[f].spdDivFogg = 1
						Foggs[f].hpDivFogg = 1
						Foggs[f].spdMultFogg = 1
						Foggs[f].hpMultFogg = 2
					end
				elseif modifier.current == modifier.nameList.MOD_TWO_TIMES_MONEY_GAIN then
					moneyGainDiv = 1
					moneyGainMult = 2
					for c=1, #GameCarInstances do
						GameCarInstances[c].hpDivCar = 1
						GameCarInstances[c].spdDivCar = 1
						GameCarInstances[c].hpMultCar = 1
						GameCarInstances[c].spdMultCar = 1
						GameCarInstances[c].scaleAdd = 0
					end
					placingStuff.minX = 0
					placingStuff.maxX = 800
					for f=1, #Foggs do
						Foggs[f].spdDivFogg = 1
						Foggs[f].hpDivFogg = 1
						Foggs[f].spdMultFogg = 1
						Foggs[f].hpMultFogg = 1
					end
				end
			--#endregion
		end


		if #GameCarInstances <= 0 and money < 100 then
			money = 100
		end


		if screenShake.enabled then
			gameCam.offset.x = math.random(-screenShake.force, screenShake.force)
			gameCam.offset.y = math.random(-screenShake.force, screenShake.force)


			if screenShake.force <= 0 then
				screenShake.enabled = false
			end


			screenShake.force = screenShake.force - (100 * gameStuff.speed) * dt
		else
			gameCam.offset.x = Lume.lerp(gameCam.offset.x, 0, 0.1)
			gameCam.offset.y = Lume.lerp(gameCam.offset.y, 0, 0.1)
		end


		gameCam.zoom = Lume.lerp(gameCam.zoom, 1, 0.1)
		local zoomPercent = 1
		if gameCam.zoom ~= 0 then
			zoomPercent = (1 / gameCam.zoom)
		end
		gameCam.transform:setTransformation(-((gameCam.pos.x - gameCam.offset.x + Push:getWidth() / 2)) + ((Push:getWidth() * zoomPercent) / 2), -((gameCam.pos.y - gameCam.offset.y + Push:getHeight() / 2)) + ((Push:getHeight() * zoomPercent) / 2), gameCam.rot, gameCam.zoom, gameCam.zoom, 0, 0)
	end


	gameStuff.speed = Lume.clamp(gameStuff.speed, 0, 4)
	damageEffectStuff.redRectRGBAdd = Lume.lerp(damageEffectStuff.redRectRGBAdd, 0, 0.1)


	for t=1, #onTopGameInstaces do
		onTopGameInstaces[t]:update()
	end


	if pauseMenuInstance ~= nil then
		pauseMenuInstance:update()
	end



	gameStuff.sfxVolume = Lume.clamp(gameStuff.sfxVolume, 0, 1)
	gameStuff.musicVolume = Lume.clamp(gameStuff.musicVolume, 0, 1)


	if gameStuff.timeSinceStart > 20000 then
		gameStuff.timeSinceStart = 0
	end
	math.randomseed(gameStuff.timeSinceStart)
	love.math.setRandomSeed(gameStuff.timeSinceStart)


	mouse:updateMouse()
	math.randomseed(love.timer.getTime())
	LastLeftMouseButton = love.mouse.isDown(1)
	LastRightMouseButton = love.mouse.isDown(2)
	GlobalSinAngle = GlobalSinAngle + (1 * gameStuff.speed) * dt
	foggCreateTimer = foggCreateTimer - (1 * gameStuff.speed) * dt
	oldMousePos = {x = PushsInGameMousePos.x, y = PushsInGameMousePos.y}
	Flux.update(dt * gameStuff.speed)
	gameStuff.timeSinceStart = gameStuff.timeSinceStart + 1 * dt
	saveGame(love.window.getFullscreen(), gameStuff.lang, gameStuff.sfxVolume, gameStuff.musicVolume)
end


function love.draw()
	Push:start()
		love.graphics.applyTransform(gameCam.transform)


		if currentRoom == rooms.mainMenu then
			gameInstances = {}


			if mainMenuInstance == nil then
				mainMenuInstance = createMainMenu()
			else
				drawGrass()


				drawAllCars()


				mainMenuInstance:draw()
			end
		elseif currentRoom == rooms.start then
			if startThingInstance == nil then
				startThingInstance = createStartThing()
			else
				startThingInstance:draw()
			end
		elseif currentRoom == rooms.game then
			drawGrass()
			drawRoad()
			drawRoadSide()


			for u=1, #gameInstances do
				if gameInstances[u].drawBack then
					gameInstances[u]:draw()
				end
			end


			drawAllCars()


			if placingCar then
				love.graphics.setColor(1, 1, 1, 0.5)
				GameCars[selectedCar].spr:draw(0.25 * math.cos(GlobalSinAngle), Lume.clamp(PushsInGameMousePos.x, placingStuff.minX, placingStuff.maxX), yForCar, GameCars[selectedCar].scale, GameCars[selectedCar].scale, nil, nil, 4 + 2 * math.cos(GlobalSinAngle), {0, 0, 0, 0.5})
				love.graphics.setColor(1, 1, 1, 1)


				love.graphics.setColor(1, 1, 1, 1)
				love.graphics.setFont(secFnt)
				local txt = "Cost: " .. GameCars[selectedCar].cost

				if gameStuff.lang == "pt-br" then
					txt = "Custo: " .. GameCars[selectedCar].cost
				end

				drawOutlinedText(txt, Lume.clamp(PushsInGameMousePos.x, placingStuff.minX, placingStuff.maxX), yForCar - 64, 0.1 * math.cos(GlobalSinAngle), 4, 4, love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4)
				love.graphics.setFont(mainFnt)
			end


			for f=1, #Foggs do
				Foggs[f]:draw()
			end


			for u=1, #gameInstances do
				if not gameInstances[u].drawBack then
					gameInstances[u]:draw()
				end
			end


			love.graphics.origin()


			love.graphics.setColor({0.8, 1, 0.8})
			love.graphics.rectangle("fill", upBoxStuff.x, upBoxStuff.y, upBoxStuff.w, upBoxStuff.h)
			love.graphics.setColor({0, 0, 0})
			love.graphics.rectangle("line", upBoxStuff.x, upBoxStuff.y, upBoxStuff.w, upBoxStuff.h)


			love.graphics.setColor(0.1, 0.1, 0.1, 0.5)
			love.graphics.rectangle("fill", upBoxStuff.x + 8, upBoxStuff.y + upBoxStuff.h + 8, (love.graphics.getFont():getWidth(tostring(money)) * 4) + 16, (love.graphics.getFont():getHeight(tostring(money)) * 4) + 8)
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.rectangle("line", upBoxStuff.x + 8, upBoxStuff.y + upBoxStuff.h + 8, (love.graphics.getFont():getWidth(tostring(money)) * 4) + 16, (love.graphics.getFont():getHeight(tostring(money)) * 4) + 8)
			love.graphics.setColor(1, 1, 1, 1)
			drawOutlinedText(tostring(money), upBoxStuff.x + (love.graphics.getFont():getWidth(tostring(money)) * 2) + 16, upBoxStuff.y + upBoxStuff.h + 32, 0, 4, 4, love.graphics.getFont():getWidth(tostring(money)) / 2, love.graphics.getFont():getHeight(tostring(money)) / 2, 8)


			local txt = tostring(math.floor(megaWave.timer))
			drawOutlinedText(txt, 800 - 8, upBoxStuff.y + upBoxStuff.h + 8, 0, 4, 4, love.graphics.getFont():getWidth(txt), 0, 4, {0, 0, 0})


			local txt = tostring(math.floor(gameStuff.hp))
			love.graphics.setColor({1, 0, 0})
				drawOutlinedText(txt, 800 / 2, upBoxStuff.y + upBoxStuff.h + 8, 0, 4 + healthTextStuff.scaleAdd, 4 + healthTextStuff.scaleAdd, love.graphics.getFont():getWidth(txt) / 2, 0, 4, {0, 0, 0})
			love.graphics.setColor({1, 1, 1})


			if modifier.current ~= nil then
				local txt = modifier.current.name
				drawOutlinedText(txt, 8, 600 - 4, 0, 4, 4, 0, love.graphics.getFont():getHeight(txt), 4, {0, 0, 0})
			end


			for b=1, #UiStuff do
				UiStuff[b]:draw()
			end
		end


		for t=1, #onTopGameInstaces do
			onTopGameInstaces[t]:draw()
		end


		if pauseMenuInstance ~= nil then
			pauseMenuInstance:draw()
		end


		if damageEffectStuff.redRectRGBAdd > 0 then
			love.graphics.setColor(damageEffectStuff.redRectRGBAdd, 0, 0, damageEffectStuff.redRectRGBAdd)
			love.graphics.rectangle("fill", 0, 0, 800, 600)
		end


		mouse:drawMouse()


		if sceneTransition.enabled then
			love.graphics.setColor({0, 0, 0})
				love.graphics.rectangle("fill", 0, -1, love.graphics.getWidth() + 256, ((love.graphics.getHeight()) / 2) * sceneTransition.progress)
				love.graphics.rectangle("fill", 0, (love.graphics.getHeight() - 1) - (((love.graphics.getHeight() - 1) / 2) * (sceneTransition.progress)), love.graphics.getWidth() + 256, love.graphics.getHeight() / 2)
			love.graphics.setColor({1, 1, 1})
				love.graphics.rectangle("line", -8, -1, love.graphics.getWidth() + 256, (love.graphics.getHeight() / 2) * sceneTransition.progress)
				love.graphics.rectangle("line", -8, (love.graphics.getHeight() + 1) - (((love.graphics.getHeight() - 1) / 2) * (sceneTransition.progress)), love.graphics.getWidth() + 256, love.graphics.getHeight() / 2)
		end
	
	
		if debugStuff.enabled then
			love.graphics.print("RedRect: " .. tostring(damageEffectStuff.redRectRGBAdd), 8, 8)
			love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 8, 16 + 4)
			love.graphics.print("gameCarsAmnt: " .. tostring(#GameCarInstances), 8, 16+8 + 4+4)
			love.graphics.print("FoggsAmnt: " .. tostring(#Foggs), 8, 16+8+8+4+4+4)
			love.graphics.print("gameInstancesAmnt: " .. tostring(#gameInstances), 8, 16+8+8+8+4+4+4+4)
			love.graphics.print("onTopGameInstancesAmnt: " .. tostring(#onTopGameInstaces), 8, 16+8+8+8+8+4+4+4+4+4)
		end
	Push:finish()
end


function love.resize(w, h)
	Push:resize(w, h)
end


function createANewFogg(altX, altY)
	local x = math.random(0, 800)
	local y = 632
	local selectedFogg = Lume.clamp((gameStuff.currentFoggGaved), 0, 3)


	if altX ~= nil then
		x = altX
	end
	if altY ~= nil then
		y = altY
	end


	if selectedFogg == 0 then
		table.insert(Foggs, 1, createForg(x, y, newAnimation(love.graphics.newImage("Sprs/Fog/Idle.png"), 18, 19, 1), newAnimation(love.graphics.newImage("Sprs/Fog/Jump.png"), 18, 19, 1), 2, 1.5))
	end
	if selectedFogg == 1 then
		table.insert(Foggs, 1, createForg(x, y, newAnimation(love.graphics.newImage("Sprs/Fog/IdleV2.png"), 18, 19, 1), newAnimation(love.graphics.newImage("Sprs/Fog/JumpV2.png"), 18, 19, 1), 3, 1))
	end
	if selectedFogg == 2 then
		table.insert(Foggs, 1, createForg(x, y, newAnimation(love.graphics.newImage("Sprs/Fog/IdleV3.png"), 18, 19, 1), newAnimation(love.graphics.newImage("Sprs/Fog/JumpV3.png"), 18, 19, 1), 4, 0.5))
	end
	if selectedFogg == 3 then
		table.insert(Foggs, 1, createForg(x, y, newAnimation(love.graphics.newImage("Sprs/Fog/IdleV4.png"), 18, 19, 1), newAnimation(love.graphics.newImage("Sprs/Fog/JumpV4.png"), 18, 19, 1), 5, 0.25))
	end
end


function love.keypressed(key)
	if key == "f11" then
		love.window.setFullscreen(not love.window.getFullscreen())
	end
	if key == "escape" then
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
	if key == "1" or key == "2" or key == "3" then
		if placingCar == false or selectedCar ~= tonumber(key) then
			startCarPlacing(tonumber(key))
		else
			stopCarPlacing()
		end
	end
	if key == "lshift" then
		if gameStuff.speed == 2 then
			gameStuff.speed = 1
		else
			gameStuff.speed = 2
		end
	end
	if key == "home" then
		love.event.quit()
	end
	if key == "f1" then
		debugStuff.enabled = not debugStuff.enabled
	end
end


function startCarPlacing(whatCar)
	selectedCar = whatCar
	placingCar = true
end


function stopCarPlacing()
	selectedCar = nil
	placingCar = false
end


function enableScreenShake(force)
	screenShake.enabled = true
	screenShake.force = force
end


function changeRoom(toWhat)
	if sceneTransition.enabled then return end


	rm = toWhat
	sceneTransition.enabled = true
	Flux.to(sceneTransition, 0.5, {progress=1}):ease("expoin"):oncomplete(setRoom):after(sceneTransition, 0.5, {progress=0}):ease("expoout"):oncomplete(disableTransition)
end


function disableTransition()
	sceneTransition.enabled = false
end


function setRoom()
	if currentRoom == rm then return end


	currentRoom = rm


	while #GameCarInstances > 0 do
		tableClear(GameCarInstances)
	end
	megaWave.timer = 60
	startThingInstance = nil
	tableClear(Foggs)
	modifier.current = modList[1]
	foggCreateTimerDef = 5
	gameStuff.currentFoggGaved = 0
	gameStuff.hp = 10
	modifier.current = modList[1]
	money = 100
end


function updateAllCars()
	for c=1, #GameCarInstances do
		if GameCarInstances[c] ~= nil then
			GameCarInstances[c]:update()
		end
	end
end


function drawAllCars()
	for c=1, #GameCarInstances do
		love.graphics.setColor({1, 1, 1})
		love.graphics.draw(GameCarInstances[c].driveParticle)


		for t=1, #GameCarInstances[c].trailPoses do
			if t >= #GameCarInstances[c].trailPoses then break end


			love.graphics.setLineWidth(32)
			love.graphics.setColor({0, 0, 0, Lume.clamp(1 * (t / #GameCarInstances[c].trailPoses), 0, 0.9)})


			if Lume.distance(GameCarInstances[c].trailPoses[t].x, GameCarInstances[c].trailPoses[t].y, GameCarInstances[c].trailPoses[t + 1].x, GameCarInstances[c].trailPoses[t + 1].y) <= 32 then
				love.graphics.line(GameCarInstances[c].trailPoses[t].x, GameCarInstances[c].trailPoses[t].y, GameCarInstances[c].trailPoses[t + 1].x, GameCarInstances[c].trailPoses[t + 1].y)
			end
			
			
			love.graphics.setLineWidth(1)
		end
	end


	for c=1, #GameCarInstances do
		if GameCarInstances[c] ~= nil then
			GameCarInstances[c]:draw()
		end
	end
end


function recieveDamage(dmg, x, y)
	gameStuff.hp = gameStuff.hp - dmg
	gameCam.zoom = 0.5
	damageEffectStuff.redRectRGBAdd = 1
	createDamageText(x, y)
end


function updateMusicVolume()
	explosionSfx:setVolume(gameStuff.sfxVolume)
	moneyGainSfx:setVolume(gameStuff.sfxVolume)
	interactSfx:setVolume(gameStuff.sfxVolume)
	modChangeSfx:setVolume(gameStuff.sfxVolume)
	warningSfx:setVolume(gameStuff.sfxVolume - 0.25)
	for c=1, #GameCarInstances do
		if GameCarInstances[c] ~= nil then
			GameCarInstances[c].walkSfx:setVolume(gameStuff.sfxVolume - 0.1)
			if GameCarInstances[c].startSfx ~= nil then
				GameCarInstances[c].startSfx:setVolume(gameStuff.sfxVolume - 0.1)
			end
		end
	end
	
	
	for m=1, #musics do
		musics[m]:setVolume(Lume.clamp(gameStuff.musicVolume + gameStuff.musicVolumeAdd, 0, 1))
	end
end


function isPointInsideCam(x, y)
	return x >= (gameCam.pos.x + gameCam.offset.x) - ((800) * gameCam.zoom) and x <= (gameCam.pos.x + gameCam.offset.x) - ((800 / 2) * gameCam.zoom) + 800 * 2 and y >= (gameCam.pos.y + gameCam.offset.y) - ((600) * gameCam.zoom) and y <= (gameCam.pos.y + gameCam.offset.y) - ((600 / 2) * gameCam.zoom) + 600 * 2
end