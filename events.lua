function createCitizen()
    local c = {
        pos = {x = -128, y = math.random((600 / 2) - 128, (600 / 2) + 128)},
        spr = newAnimation(love.graphics.newImage("Sprs/Events/Citizen/CitizenWalk.png"), 32, 32, 3, 5),
        mspd = 50,
    }


    function c:update()
        --Do stuff when he reaches the right bottom of the scene
        if self.pos.x >= 800 * 1.5 then
            local givenMoney = 500 * (gameStuff.currentFoggGaved + 1)
            createMoneyGainEffect(givenMoney, self.pos.x - 64, self.pos.y)
            money = money + givenMoney
            table.remove(gameInstances, tableFind(gameInstances, self))


            local willReciveve = math.random(0, 1)


            if willReciveve == 0 then
                local itemGaved = math.random(1, #bagItemsIndexed)
                recieveBagItem(bagItemsIndexed[itemGaved])
            end
        end


        --Die handling
        for f=1, #Foggs do
            if Foggs[f] ~= nil then
                if Lume.distance(self.pos.x, self.pos.y, Foggs[f].pos.x, Foggs[f].pos.y) <= 32 then
                    createWarningText("citizen died")
                    table.remove(gameInstances, tableFind(gameInstances, self))
                end
            end
        end


        self.pos.x = self.pos.x + (self.mspd * gameStuff.speed) * globalDt
        self.spr:update(globalDt * gameStuff.speed)
    end


    function c:draw()
        drawShadow(self.pos.x, self.pos.y + 32, 4, 4, 0)
        love.graphics.setColor(1, 1, 1, 1)
        self.spr:draw(self.rot, self.pos.x, self.pos.y, 2, 2, nil, nil, 2, {0, 0, 0})
    end


    table.insert(gameInstances, 1, c)
end
function createBombMan()
    local c = {
        pos = {x = -128, y = math.random((600 / 2) - 128, (600 / 2) + 128)},
        vel = {x = 0, y = 0},
        spd = 500,
        spr = newAnimation(love.graphics.newImage("Sprs/Events/SuicideBomber/SuicideBomberWalk.png"), 32, 32, 3, 5),
        mspd = 50,
        scaleX = 1,
    }


    function c:update()
        local targetCar = 1
        if GameCarInstances[targetCar] ~= nil then
            local angleTo = math.atan2(self.pos.y - GameCarInstances[targetCar].pos.y, self.pos.x - GameCarInstances[targetCar].pos.x)


            self.vel.x = Lume.lerp(self.vel.x, self.spd * math.cos(angleTo), 0.1)
            self.vel.y = Lume.lerp(self.vel.y, self.spd * math.sin(angleTo), 0.1)


            if Lume.distance(self.pos.x, self.pos.y, GameCarInstances[targetCar].pos.x, GameCarInstances[targetCar].pos.y) <= 32 then
                createExplosion(self.pos.x, self.pos.y, GameCars[2])
                GameCarInstances[targetCar].hp = 0
            end
        end
        for f=1, #Foggs do
            if Lume.distance(self.pos.x, self.pos.y, Foggs[f].pos.x, Foggs[f].pos.y) <= 32 then
                createExplosion(self.pos.x, self.pos.y, GameCars[2])
            end
        end
        if Lume.distance(self.pos.x, self.pos.y, PushsInGameMousePos.x, PushsInGameMousePos.y) <= 32 then
            createExplosion(self.pos.x, self.pos.y, GameCars[2])
        end


        if self.vel.x < 0 then
            self.scaleX = -1
        else
            self.scaleX = 1
        end


        self.pos.x = self.pos.x + (self.vel.x * gameStuff.speed) * globalDt
        self.pos.y = self.pos.y + (self.vel.y * gameStuff.speed) * globalDt
        self.spr:update(globalDt * gameStuff.speed)
    end


    function c:draw()
        drawShadow(self.pos.x, self.pos.y + 32, 4, 4, 0)
        love.graphics.setColor(1, 1, 1, 1)
        self.spr:draw(self.rot, self.pos.x, self.pos.y, 2 * self.scaleX, 2, nil, nil, 2, {0, 0, 0})
    end


    table.insert(gameInstances, 1, c)
end


eventTypes = {
    {creationCode = createCitizen, stopFrogg=false, id = 0, name = "Citizen", namePT = "Cidadão"},
    {creationCode = createBombMan, stopFrogg=false, id = 1, name = "Suicide Bomber", namePT = "Homem Bomba"},
}
currentEvent = 0



function startEvent()
    currentEvent = eventTypes[math.random(1, #eventTypes)]
    currentEvent.creationCode()


    if currentEvent.stopFrogg then
        gameStuff.pauseFroggCreation = true
    end


    createEventStartText(currentEvent)
end


function createEventStartText(whatEvent)
    local t = {
        text = "EVENT STARTED",
        forEvent = whatEvent,
        scale = 0,
        rot = 6,
        alpha = 0,
    }


    function t:init()
        Flux.to(self, 1, {scale=5, rot=0, alpha=1}):after(self, 1, {scale=0, rot=-6, alpha=0}):delay(1):oncomplete(t.destroy)
    end


    function t:destroy()
        table.remove(gameInstances, tableFind(gameInstances, t))
    end


    function t:draw()
        love.graphics.setColor(1, 1, 1, 1)


        drawOutlinedText(self.text, 800 / 2, 600 / 2, self.rot, self.scale, self.scale, love.graphics.getFont():getWidth(self.text) / 2, love.graphics.getFont():getHeight(self.text) / 2, 8, {0, 0, 0})


        local text = self.forEvent.name
        if gameStuff.lang == "pt-br" then text = self.forEvent.namePT end
        drawOutlinedText(text, 800 / 2, (600 / 2) + 128, 0, self.scale, self.scale, love.graphics.getFont():getWidth(text) / 2, love.graphics.getFont():getHeight(text) / 2, 8, {0, 0, 0})
    end


    t:init()


    table.insert(onTopGameInstaces, 1, t)
end