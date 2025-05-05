function createCitizen()
    local c = {
        pos = {x = -128, y = math.random((600 / 2) - 128, (600 / 2) + 128)},
        spr = newAnimation(love.graphics.newImage("Sprs/Events/Citizen/CitizenWalk.png"), 32, 32, 3, 5),
        mspd = 50,
    }


    function c:update()
        if self.pos.x >= 800 * 1.5 then
            createMoneyGainEffect(500, self.pos.x - 64, self.pos.y)
            money = money + 500
            table.remove(gameInstances, tableFind(gameInstances, self))
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


eventTypes = {
    {creationCode = createCitizen, stopFrogg=false, id = 0, name = "Citizen"},
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


        drawOutlinedText(self.forEvent.name, 800 / 2, (600 / 2) + 128, 0, self.scale, self.scale, love.graphics.getFont():getWidth(self.forEvent.name) / 2, love.graphics.getFont():getHeight(self.forEvent.name) / 2, 8, {0, 0, 0})
    end


    t:init()


    table.insert(onTopGameInstaces, 1, t)
end