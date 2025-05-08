function createCamMoveTutorial()
    local t = {
        animsSpr = {
            newAnimation(love.graphics.newImage("Tutorial/CamMove.png"), 32, 32, 4, 2, 0),
            newAnimation(love.graphics.newImage("Tutorial/ClickButton.png"), 16, 16, 7, 4, 0),
            newAnimation(love.graphics.newImage("Tutorial/CreateCar.png"), 16, 16, 10, 4, 0),
        },
        state = 1,
        walkedA = false,
        walkedD = false,
        walkedW = false,
        walkedS = false,
    }


    function t:update()
        if gameStuff.canPlaceFroggs then
            table.remove(onTopGameInstaces, tableFind(onTopGameInstaces, self))
        end


        if self.state == 1 then
            if love.keyboard.isDown("a") then
                self.walkedA = true
            end
            if love.keyboard.isDown("d") then
                self.walkedD = true
            end
            if love.keyboard.isDown("s") then
                self.walkedS = true
            end
            if love.keyboard.isDown("w") then
                self.walkedW = true
            end


            if self.walkedA and self.walkedD and self.walkedW and self.walkedS then
                self.state = 2
            end
        elseif self.state == 2 then
            if placingCar then
                self.state = 3
            end
        elseif self.state == 3 then
            if not placingCar then
                self.state = 2
            end
        end


        self.animsSpr[self.state]:update(globalDt)
    end


    function t:draw()
        love.graphics.setColor({1, 1, 1})
        self.animsSpr[self.state]:draw(0, 800 / 2, 600 - self.animsSpr[self.state].sprHeight * 2, 4, 4, nil, nil, 4, {0, 0, 0})


        if self.state == 1 then
            drawOutlinedText("WASD To Move", 800 / 2, (600 - self.animsSpr[self.state].sprHeight * 3) - 8, 0, 2, 2, love.graphics.getFont():getWidth("WASD To Move") / 2, love.graphics.getFont():getHeight("WASD To Move"), 4, {0, 0, 0})
        elseif self.state == 2 then
            local wrap = {love.graphics.getFont():getWrap("LMB In The Buttons At The Top To Select A Car", 800 / 2)}
            local linesNum = #wrap[2]


            local txtHeight = love.graphics.getFont():getHeight() * linesNum


            drawOutlinedTextF("LMB In The Buttons At The Top To Select A Car", 0, (600 - self.animsSpr[self.state].sprHeight * 4) - 8, 800 / 2, "center", 0, 2, 2, 0, txtHeight / 2, 4, {0, 0, 0})
        elseif self.state == 3 then
            local wrap = {love.graphics.getFont():getWrap("LMB To Create An Car", 800 / 2)}
            local linesNum = #wrap[2]


            local txtHeight = love.graphics.getFont():getHeight() * linesNum


            drawOutlinedTextF("LMB To Create An Car", 0, (600 - self.animsSpr[self.state].sprHeight * 4) - 8, 800 / 2, "center", 0, 2, 2, 0, txtHeight / 2, 4, {0, 0, 0})
        end
    end


    table.insert(onTopGameInstaces, 1, t)
end