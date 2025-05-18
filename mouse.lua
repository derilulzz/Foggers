mouse = {
    pos = {x = 0, y = 0},
    idleSpr = love.graphics.newImage("Sprs/Mouse/Idle.png"),
    pressSpr = love.graphics.newImage("Sprs/Mouse/Pressed.png"),
    pressRSpr = love.graphics.newImage("Sprs/Mouse/PressedR.png"),
    rot = 0,
    scale = 4,
    oldMousePos = {x = 0, y = 0},
    rmbPressSpr = newAnimation(love.graphics.newImage("Sprs/Mouse/RMBPress.png"), 9, 9, 1, 10, 0),
    showRMBIcon = false,
    showLMBIcon = false,
    RMBModulate = {1, 1, 1},
    LMBModulate = {1, 1, 1},
}


function mouse:updateMouse()
    local mGame = {Push:toGame(love.mouse.getX(), love.mouse.getY())}
    self.pos.x = mGame[1]
    self.pos.y = mGame[2]


    self.rot = Lume.lerp(self.rot, (mGame[1] - self.oldMousePos.x) / 16, 0.1)


    if love.mouse.isDown(1) and LastLeftMouseButton == false then
        self.scale = self.scale - 1
    end
    if love.mouse.isDown(1) == false and LastLeftMouseButton then
        self.scale = self.scale + 1
    end
    if love.mouse.isDown(2) and LastRightMouseButton == false then
        self.scale = self.scale + 1
    end
    if love.mouse.isDown(2) == false and LastRightMouseButton then
        self.scale = self.scale - 1
    end


    self.scale = Lume.lerp(self.scale, 4, 0.1)
    self.rot = Lume.lerp(self.rot, 0, 0.1)
    self.oldMousePos = {x = mGame[1], y = mGame[2]}
    self.rmbPressSpr:update(globalDt)
end


function mouse:drawMouse()
    local spr = self.idleSpr

    
    love.graphics.setColor({1, 1, 1})

    if love.mouse.isDown(1) then spr = self.pressSpr end
    if love.mouse.isDown(2) then spr = self.pressRSpr end

    love.graphics.draw(spr, self.pos.x, self.pos.y, self.rot, self.scale, self.scale, 3)


    if self.showRMBIcon then
        love.graphics.setColor(self.RMBModulate)
        self.rmbPressSpr:draw(0, self.pos.x + 32, self.pos.y, -4, 4)
    end
    if self.showLMBIcon then
        love.graphics.setColor(self.LMBModulate)
        self.rmbPressSpr:draw(0, self.pos.x - 32, self.pos.y, 4, 4)
    end
end