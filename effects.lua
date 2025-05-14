


function createMoneyGainEffect(amnt, x, y)
    local e = {
        pos = {x = x, y = y},
        text = "+" .. tostring(amnt),
        scale = 8,
        rot = 6,
        enableMov = false,
        angle = 1.5,
    }


    function e:enMov()
        e.enableMov = true
    end


    moneyGainSfx:setPitch(2 * math.random())
    playSound(moneyGainSfx)


    function e:init()
        Flux.to(self, 1, {scale=2, rot=0}):ease("expoout"):oncomplete(e.enMov)
    end


    function e:update()
        self.pos.y = self.pos.y - (100 * gameStuff.speed) * globalDt


        if self.enableMov then
            self.rot = Lume.lerp(self.rot, 0.5 * math.cos(GlobalSinAngle * 2), 0.1)
            self.scale = Lume.lerp(self.scale, 2 + 1 * math.cos(GlobalSinAngle), 0.1)
            self.angle = self.angle + 1 * globalDt
        end
    end


    function e:draw()
        love.graphics.setColor({1, 1, 1})
        drawOutlinedText(self.text, self.pos.x, self.pos.y, self.rot, self.scale, self.scale, love.graphics.getFont():getWidth(self.text) / 2, love.graphics.getFont():getHeight(self.text) / 2, 2, {0, 0, 0})
    end


    e:init()
    table.insert(gameInstances, #gameInstances + 1, e)


    return e
end



function createDamageNum(amnt, x, y)
    local e = {
        pos = {x = x, y = y},
        text = tostring(amnt),
        scale = 8,
        rot = 6,
        alpha = 1,
    }


    function e:init()
        Flux.to(self, 1, {scale=2, rot=0}):ease("expoout")
        Flux.to(self, 4, {alpha=0}):ease("expoout")
    end


    function e:die()
        table.remove(gameInstances, tableFind(gameInstances, self))
    end


    function e:update()
        if self.alpha <= 0 then
            self:die()
        end
    end


    function e:draw()
        love.graphics.setColor({1, 1, 1, self.alpha})
        drawOutlinedText(self.text, self.pos.x, self.pos.y, self.rot, self.scale, self.scale, love.graphics.getFont():getWidth(self.text) / 2, love.graphics.getFont():getHeight(self.text) / 2, 2, {0, 0, 0, self.alpha})
    end


    e:init()
    table.insert(gameInstances, 1, e)


    return e
end



function createMoneyRecievePerCar(amnt, x, y)
    local e = {
        pos = {x = x, y = y},
        text = "+" .. tostring(amnt),
        scale = 16,
        rot = 6,
        alpha = 1,
    }


    function e:init()
        Flux.to(self, 1, {scale=4, rot=0}):ease("expoout")
        Flux.to(self, 4, {alpha=0}):ease("expoout")
    end


    function e:die()
        table.remove(gameInstances, tableFind(gameInstances, self))
    end


    function e:update()
        if self.alpha <= 0 then
            self:die()
        end
    end


    function e:draw()
        love.graphics.setColor({1, 1, 1, self.alpha})
        drawOutlinedText(self.text, self.pos.x, self.pos.y, self.rot, self.scale, self.scale, love.graphics.getFont():getWidth(self.text) / 2, love.graphics.getFont():getHeight(self.text) / 2, 2, {0, 0, 0, self.alpha})
    end


    e:init()


    return e
end


function createMegaWaveWarning()
    local t = {
        alpha = 0,
        scale = 0,
        rot = 12,
    }


    warningSfx:setPitch(1.5 * math.random())
    playSound(warningSfx)


    function t:init()
        Flux.to(self, 1, {alpha=1, scale=8, rot=0}):ease("expoout"):after(self, 1, {alpha=0}):delay(2):oncomplete(t.delete)
    end
    
    
    function t:delete()
        table.remove(onTopGameInstaces, tableFind(onTopGameInstaces, t))
    end


    function t:update()
        
    end


    function t:draw()
		love.graphics.setColor(1, 1, 1, self.alpha)
        drawOutlinedText("MEGA WAVE\nCOMING", 800 / 2, 600 / 2, self.rot, self.scale, self.scale, love.graphics.getFont():getWidth("MEGA WAVE\nCOMING") / 2, love.graphics.getFont():getHeight("MEGA WAVE\nCOMING") / 2, 4, {0, 0, 0})
    end


    t:init()
    table.insert(onTopGameInstaces, 1, t)


    return t
end


function createDamageText(x, y)
    local t = {
        pos = {x = x, y = y},
        angle = 0,
        scale = 4,
        rot = 0,
        alpha = 0,
    }


    function t:init()
        Flux.to(self, 1, {alpha = 0}):delay(2):ease("expoout"):oncomplete(t.delete)
    end


    function t:delete()
        table.remove(onTopGameInstaces, tableFind(onTopGameInstaces, t))
    end


    function t:update()
        self.rot = 0.1 * math.cos(self.angle)
        self.scale = 4 + 0.5 * math.cos(self.angle / 2)


        self.angle = self.angle + 1 * globalDt
    end


    function t:draw()
        local txt = "Fogg Reached"


        love.graphics.setColor({1, 1, 1, self.alpha})
        drawOutlinedText(txt, self.pos.x, self.pos.y, self.rot, self.scale, self.scale, love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, {0, 0, 0, self.alpha})
    end


    t:init()
    table.insert(onTopGameInstaces, 1, t)
end


shadowSpr = love.graphics.newImage("Sprs/Other/Shadow.png")


function drawShadow(x, y, scaleX, scaleY, rot)
    love.graphics.setColor(1, 1, 1, 0.5)


    scaleX = scaleX or 1
    scaleY = scaleY or 1
    rot = rot or 1


    love.graphics.draw(shadowSpr, x, y, rot, scaleX, scaleY, shadowSpr:getWidth() / 2, shadowSpr:getHeight() / 2)
end


function createWarningText(warningText)
    local w = {
        scale = 0,
        rot = 999,
        text = warningText,
    }


    function w:init()
        Flux.to(self, 1, {scale = 8, rot = 0}):ease("expoin"):after(self, 1, {scale = 0, rot = -999}):delay(1):ease("expoout"):oncomplete(w.delete)
    end


    function w:delete()
        table.remove(onTopGameInstaces, tableFind(onTopGameInstaces, w))
    end


    function w:draw()
        love.graphics.setColor(1, 0, 0, 1)
        drawOutlinedText(self.text, 800 / 2, 600 / 2, self.rot, self.scale, self.scale, nil, nil, 4, {0, 0, 0})
    end


    w:init()


    table.insert(onTopGameInstaces, #onTopGameInstaces + 1, w)
end


function createBagItemRecieveText(whatItem)
    local w = {
        scale = 0,
        rot = 999,
        item = whatItem,
    }


    function w:init()
        Flux.to(self, 1, {scale = 8, rot = 0}):ease("expoin"):after(self, 1, {scale = 0, rot = -999}):delay(2):ease("expoout"):oncomplete(w.delete)
    end


    function w:delete()
        table.remove(onTopGameInstaces, tableFind(onTopGameInstaces, w))
    end


    function w:draw()
        love.graphics.setColor(HSV(0.5 + 0.5 * math.cos(GlobalSinAngle), 1, 1))
        drawOutlinedText("item recieved", 800 / 2, (600 / 2) - (love.graphics.getFont():getHeight(self.item.name) * self.scale), self.rot, self.scale / 2, self.scale / 2, nil, nil, 4, {0, 0, 0})
        drawOutlinedText(self.item.name, 800 / 2, 600 / 2, self.rot, self.scale, self.scale, nil, nil, 4, {0, 0, 0})
        drawOutlinedText(self.item.desc, 800 / 2, (600 / 2) + (love.graphics.getFont():getHeight(self.item.name) * self.scale), self.rot, self.scale / 2, self.scale / 2, nil, nil, 4, {0, 0, 0})
    end


    w:init()


    table.insert(onTopGameInstaces, #onTopGameInstaces + 1, w)
end