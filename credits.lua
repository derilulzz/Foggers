

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
        


        if gameStuff.lang == "pt-br" then
            self.returnButton.text = "Retornar"
        else
            self.returnButton.text = "Return"
        end


        self.returnButton.pos.x = 8 + (self.returnButton.size.w / 2)
        self.returnButton.pos.y = gameSize.h - 8 - (self.returnButton.size.h / 2)
        if self.returnButton.pressed then
            changeRoom(rooms.mainMenu)
            self.returnButton.pressed = false
        end
    end


    function c:draw()
        drawGrass()


        local meText = "Art, Coding And Everything Else By:"
        local playtestText = "Playtest:"
        local createdText = "Created Using:"
        local disaggreedmentText = {{1, 1, 1, 1}, "<- I DID ", {1, 0, 0, 1}, "NOT\n", {1, 1, 1, 1}, " AGREEDED WITH\n THIS ICON"}
        local disaggreedmentFrText = "<- I DID NOT\n AGREEDED WITH\n THIS ICON"
        local usingTheLibrarysText = "Using the external librarys:\nFlux,\nLume,\nPush,\nBase64"


        if gameStuff.lang == "pt-br" then
            meText = "Arte, Codigo E Todo Resto Por:"
            createdText = "Criado Usando:"
            disaggreedmentText = {{1, 1, 1, 1}, "<- EU ", {1, 0, 0, 1}, "NAO\n", {1, 1, 1, 1}, " CONCORDEI COM\n ESSE ICONE"}
            disaggreedmentFrText = "<- EU NAO\n CONCORDEI COM\n ESSE ICONE"
            usingTheLibrarysText = "Usando as librarys:\nFlux,\nLume,\nPush,\nBase64"
        end


        local fnt1 = love.graphics.getFont()
        drawOutlinedText(meText, gameSize.w / 2, 90, 0.1 * math.cos(GlobalSinAngle), 3, 3, fnt1:getWidth(meText) / 2, fnt1:getHeight(meText) / 2, 4, {0, 0, 0})
    
    
        love.graphics.draw(self.icons.me, gameSize.w / 2, 168, 0.05 * math.cos(GlobalSinAngle / 2), 0.075, 0.075, self.icons.me:getWidth() / 2, self.icons.me:getHeight() / 2)
        drawOutlinedText("Deri LULZZ", gameSize.w / 2, 168 + 8 + 8 + (self.icons.me:getHeight() * 0.075) / 2, 0.1 * math.cos(GlobalSinAngle), 2, 2, fnt1:getWidth("Deri LULZZ") / 2, fnt1:getHeight("Deri LULZZ") / 2, 2, {0, 0, 0})


        drawOutlinedText(playtestText, gameSize.w / 2, (gameSize.h / 2) - 32 + 4, 0.1 * math.cos(GlobalSinAngle), 4, 4, fnt1:getWidth(playtestText) / 2, fnt1:getHeight(playtestText) / 2, 4, {0, 0, 0})


        drawOutlinedSprite(self.icons.cherryDev, (gameSize.w / 2) - 128, gameSize.h / 2 + 32 + 16, 0.25 * math.cos(GlobalSinAngle / 2), 7, 7, self.icons.cherryDev:getWidth() / 2, self.icons.cherryDev:getHeight() / 2, 4, {0, 0, 0})
        drawOutlinedText("Cherry Dev", (gameSize.w / 2) - 128, gameSize.h / 2 + 32 + 16 + 8 + (self.icons.cherryDev:getHeight() * 7) / 2, 0.1 * math.cos(GlobalSinAngle), 2, 2, fnt1:getWidth("Cherry Dev") / 2, fnt1:getHeight("Cherry Dev") / 2, 2, {0, 0, 0})


        drawOutlinedSprite(self.icons.bolachito, (gameSize.w / 2) + 128, gameSize.h / 2 + 32 + 16, 0.25 * math.cos(GlobalSinAngle / 2), 1, 1, self.icons.bolachito:getWidth() / 2, self.icons.bolachito:getHeight() / 2, 4, {0, 0, 0})
        drawOutlinedText("Bolachito", (gameSize.w / 2) + 128, gameSize.h / 2 + 32 + 16 + 8 + (self.icons.bolachito:getHeight()) / 2, 0.1 * math.cos(GlobalSinAngle), 2, 2, fnt1:getWidth("Bolachito") / 2, fnt1:getHeight("Bolachito") / 2, 2, {0, 0, 0})
        
        
        drawOutlinedText(disaggreedmentText, (gameSize.w / 2) + 300, gameSize.h / 2 + 32 + 16, 0, 2, 2, love.graphics.getFont():getWidth(disaggreedmentFrText) / 2, love.graphics.getFont():getHeight(disaggreedmentFrText) / 2, 2, {0, 0, 0})


        drawOutlinedText(createdText, gameSize.w / 2 - 188, gameSize.h - 146, 0.1 * math.cos(GlobalSinAngle), 4, 4, fnt1:getWidth(createdText) / 2, fnt1:getHeight(createdText) / 2, 4, {0, 0, 0})


        drawOutlinedSprite(self.icons.love, gameSize.w / 2 - 188, gameSize.h - 80, 0.25 * math.cos(GlobalSinAngle / 2), 0.5, 0.5, self.icons.love:getWidth() / 2, self.icons.love:getHeight() / 2, 2, {0, 0, 0})
        drawOutlinedText("Love2D", (gameSize.w / 2) - 188, gameSize.h - 80 + 32 + (self.icons.love:getHeight() * 0.25) / 2, 0.1 * math.cos(GlobalSinAngle), 2, 2, fnt1:getWidth("Love2D") / 2, fnt1:getHeight("Love2D") / 2, 2, {0, 0, 0})
        
        
        drawOutlinedTextF(usingTheLibrarysText, (gameSize.w / 2) + 216 - 16, gameSize.h - 71, 256, "center", 0.1 * math.cos(GlobalSinAngle), 2, 2, nil, nil, 2, {0, 0, 0})


        drawOutlinedText("Credits", gameSize.w / 2, 32, 0.01 * math.cos(GlobalSinAngle), 4, 4, nil, nil, 2, {0, 0, 0})
    end


    return c
end


creditsInstance = nil