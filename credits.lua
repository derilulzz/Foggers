

function createCredits()
    local c = {
        icons = {
            me = love.graphics.newImage("Sprs/Logos/Me.png"),
            cherryDev = love.graphics.newImage("Sprs/Credits/CherryDev.png"),
            bolachito = love.graphics.newImage("Sprs/Credits/BOLACHUDO.png"),
            love = love.graphics.newImage("Sprs/Logos/love.png"),
        },
        returnButton = createButton(8 + 64, 600 - 32 - 8, 128, 64, "Return", "", true),
    }


    function c:update()
        if tableFind(UiStuff, self.returnButton) == -1 then
            table.insert(UiStuff, 1, self.returnButton)
        end
        

        if self.returnButton.pressed then
            changeRoom(rooms.mainMenu)
            self.returnButton.pressed = false
        end
    end


    function c:draw()
        drawGrass()


        local fnt1 = love.graphics.getFont()
        drawOutlinedText("Art, Coding And Everything Else By:", 800 / 2, 32, 0.1 * math.cos(GlobalSinAngle), 3, 3, fnt1:getWidth("Art, Coding, And Everything Else By:") / 2, fnt1:getHeight("Art, Coding, And Everything Else By:") / 2, 4, {0, 0, 0})
    
    
        love.graphics.draw(self.icons.me, 800 / 2, 128, 0.05 * math.cos(GlobalSinAngle / 2), 0.1, 0.1, self.icons.me:getWidth() / 2, self.icons.me:getHeight() / 2)
        drawOutlinedText("Deri LULZZ", 800 / 2, 128 + 8 + (self.icons.me:getHeight() * 0.1) / 2, 0.1 * math.cos(GlobalSinAngle), 2, 2, fnt1:getWidth("Deri LULZZ") / 2, fnt1:getHeight("Deri LULZZ") / 2, 2, {0, 0, 0})


        drawOutlinedText("Playtest:", 800 / 2, 256, 0.1 * math.cos(GlobalSinAngle), 4, 4, fnt1:getWidth("Playtest:") / 2, fnt1:getHeight("Playtest:") / 2, 4, {0, 0, 0})


        drawOutlinedSprite(self.icons.cherryDev, (800 / 2) - 128, 352, 0.25 * math.cos(GlobalSinAngle / 2), 8, 8, self.icons.cherryDev:getWidth() / 2, self.icons.cherryDev:getHeight() / 2, 4, {0, 0, 0})
        drawOutlinedText("Cherry Dev", (800 / 2) - 128, 352 + 8 + (self.icons.cherryDev:getHeight() * 8) / 2, 0.1 * math.cos(GlobalSinAngle), 2, 2, fnt1:getWidth("Cherry Dev") / 2, fnt1:getHeight("Cherry Dev") / 2, 2, {0, 0, 0})


        drawOutlinedSprite(self.icons.bolachito, (800 / 2) + 128, 352, 0.25 * math.cos(GlobalSinAngle / 2), 0.25, 0.25, self.icons.bolachito:getWidth() / 2, self.icons.bolachito:getHeight() / 2, 4, {0, 0, 0})
        drawOutlinedText("Bolachito", (800 / 2) + 128, 352 + 8 + (self.icons.bolachito:getHeight() * 0.25) / 2, 0.1 * math.cos(GlobalSinAngle), 2, 2, fnt1:getWidth("Bolachito") / 2, fnt1:getHeight("Bolachito") / 2, 2, {0, 0, 0})
        
        
        drawOutlinedText({{1, 1, 1, 1}, "<- I DID ", {1, 0, 0, 1}, "NOT\n", {1, 1, 1, 1}, " AGREEDED WITH\n THIS ICON"}, (800 / 2) + 300, 332, 0, 2, 2, love.graphics.getFont():getWidth("<- I DID NOT\n AGREEDED WITH\n THIS ICON") / 2, love.graphics.getFont():getHeight("<- I DID NOT\n AGREEDED WITH\n THIS ICON") / 2, 2, {0, 0, 0})


        drawOutlinedText("Created With:", 800 / 2, 464, 0.1 * math.cos(GlobalSinAngle), 4, 4, fnt1:getWidth("Created With:") / 2, fnt1:getHeight("Created With:") / 2, 4, {0, 0, 0})


        drawOutlinedSprite(self.icons.love, 800 / 2, 512 + 16, 0.25 * math.cos(GlobalSinAngle / 2), 0.25, 0.25, self.icons.love:getWidth() / 2, self.icons.love:getHeight() / 2, 2, {0, 0, 0})
        drawOutlinedText("Love2D", (800 / 2), 512 + 32 + 8 + (self.icons.love:getHeight() * 0.25) / 2, 0.1 * math.cos(GlobalSinAngle), 2, 2, fnt1:getWidth("Love2D") / 2, fnt1:getHeight("Love2D") / 2, 2, {0, 0, 0})
        
        
        drawOutlinedText("Using the librarys:\n\t\tFlux,\n\t\tLume,\n\t\tPush,\n\t\tBase64", (800 / 2) + 274, 500, 0, 2, 2, fnt1:getWidth("Using the librarys:\n\t\tFlux,\n\t\tLume,\n\t\tPush,\n\t\tBase64") / 2, fnt1:getHeight("Using the librarys:\n\t\tFlux,\n\t\tLume,\n\t\tPush,\n\t\tBase64") / 2, 2, {0, 0, 0})
    end


    return c
end


creditsInstance = nil