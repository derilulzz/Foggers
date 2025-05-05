function createCamMoveTutorial()
    local t = {
        animSpr = newAnimation(love.graphics.newImage("Tutorial/CamMove.png"), 32, 32, 4, 2, 0),
    }


    function t:update()
        if gameStuff.canPlaceFroggs then
            table.remove(onTopGameInstaces, tableFind(onTopGameInstaces, self))
        end
        self.animSpr:update(globalDt)
    end


    function t:draw()
        love.graphics.setColor({1, 1, 1})
        self.animSpr:draw(0, 800 / 2, 600 - self.animSpr.sprHeight * 2, 4, 4, nil, nil, 4, {0, 0, 0})


        drawOutlinedText("WASD To Move", 800 / 2, (600 - self.animSpr.sprHeight * 3) - 8, 0, 2, 2, love.graphics.getFont():getWidth("WASD To Move") / 2, love.graphics.getFont():getHeight("WASD To Move"), 4, {0, 0, 0})
    end


    table.insert(onTopGameInstaces, 1, t)
end