

function createCredits()
    local c = {
        icons = {
            me = love.graphics.newImage("Sprs/Logos/Me.png"),
            cherryDev = love.graphics.newImage("Sprs/Credits/CherryDev.png"),
            bolachito = love.graphics.newImage("Sprs/Credits/BOLACHUDO.png"),
        },
    }


    function c:update()
        
    end


    function c:draw()
        drawGrass()


        local fnt1 = love.graphics.getFont()
        drawOutlinedText("Art, Coding, And Everything Else By:", 800 / 2, 32, 0.1 * math.cos(GlobalSinAngle), 3, 3, fnt1:getWidth("Art, Coding, And Everything Else By:") / 2, fnt1:getHeight("Art, Coding, And Everything Else By:") / 2, 4, {0, 0, 0})
    
    
        love.graphics.draw(self.icons.me, 800 / 2, 128, 0.05 * math.cos(GlobalSinAngle / 2), 0.1, 0.1, self.icons.me:getWidth() / 2, self.icons.me:getHeight() / 2)
        drawOutlinedText("Deri LULZZ", 800 / 2, 128 + 8 + (self.icons.me:getHeight() * 0.1) / 2, 0.1 * math.cos(GlobalSinAngle), 2, 2, fnt1:getWidth("Deri LULZZ") / 2, fnt1:getHeight("Deri LULZZ") / 2, 2, {0, 0, 0})


        drawOutlinedText("Playtest:", 800 / 2, 256, 0.1 * math.cos(GlobalSinAngle), 4, 4, fnt1:getWidth("Playtest:") / 2, fnt1:getHeight("Playtest:") / 2, 4, {0, 0, 0})


        drawOutlinedSprite(self.icons.cherryDev, (800 / 2) - 32, 352, 0.25 * math.cos(GlobalSinAngle / 2), 8, 8, self.icons.cherryDev:getWidth() / 2, self.icons.cherryDev:getHeight() / 2, 4, {0, 0, 0})
        drawOutlinedText("Cherry Dev", 800 / 2, 352 + 8 + (self.icons.cherryDev:getHeight() * 8) / 2, 0.1 * math.cos(GlobalSinAngle), 2, 2, fnt1:getWidth("Cherry Dev") / 2, fnt1:getHeight("Cherry Dev") / 2, 2, {0, 0, 0})


        drawOutlinedSprite(self.icons.bolachito, (800 / 2) + 32, 352, 0.25 * math.cos(GlobalSinAngle / 2), 0.5, 0.5, self.icons.bolachito:getWidth() / 2, self.icons.bolachito:getHeight() / 2, 4, {0, 0, 0})
        drawOutlinedText("Bolachito", 800 / 2, 352 + 8 + (self.icons.bolachito:getHeight() * 8) / 2, 0.1 * math.cos(GlobalSinAngle), 2, 2, fnt1:getWidth("Cherry Dev") / 2, fnt1:getHeight("Cherry Dev") / 2, 2, {0, 0, 0})
    end


    return c
end


creditsInstance = nil