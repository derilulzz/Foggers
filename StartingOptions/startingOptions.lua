function createStartingOptions()
    local o = {
        questions = {
            {"What language you speak?", "Que lingua você fala?"},
            {"Do you want to use the game OST?", "Você quer usar a OST do jogo?"},
        },
        answers = {
            {
                "English",
                "Portuguese (Brasil)",
            },
            {
                "Yes",
                "No",
            }
        },
        alpha = 0,
        currentQuestion = 1,
        optionsButtons = {},
        w = 1
    }


    function o:init()
        if gameStuff.firstPlay == false then rm = rooms.start; setRoom(); startingOptionsInstance = nil; return end


        self:setCurrentOptions(1)
    end


    function o:setCurrentOptions(whatOptions)
        if whatOptions == nil then return end


        op = whatOptions


        Flux.to(self, 1, {alpha = 0}):ease("expoout"):oncomplete(o.updateOptions)
    end


    function o:updateOptions()
        for b=1, #o.optionsButtons do deleteUIInstance(o.optionsButtons[b]) end
        o.optionsButtons = {}


        o.currentQuestion = op


        rm = rooms.start
        if op == 3 then setRoom(); return end


        for i=1, #o.answers[o.currentQuestion] do
            table.insert(o.optionsButtons, #o.optionsButtons + 1, createButton((800 / #o.answers[o.currentQuestion]) - (384 / 2) + 384 * (i - 1), 600 - 256, 256, 128, o.answers[o.currentQuestion][i], "", true))
        end


        Flux.to(o, 1, {alpha = 1}):ease("expoin")
    end


    function o:update()
        if self.currentQuestion == 1 then
            if self.optionsButtons[1] ~= nil then
                if self.optionsButtons[1].pressed then
                    gameStuff.lang = "eng"
                    self:setCurrentOptions(2)
                    self.optionsButtons[1].pressed = false
                end
            end
            if self.optionsButtons[2] ~= nil then
                if self.optionsButtons[2].pressed then
                    gameStuff.lang = "pt-br"
                    self:setCurrentOptions(2)
                    self.optionsButtons[2].pressed = false
                end
            end
        end


        if self.currentQuestion == 2 then
            print(#self.optionsButtons)
            if self.optionsButtons[1] ~= nil then
                if self.optionsButtons[1].pressed then
                    gameStuff.useOST = true
                    self:setCurrentOptions(3)
                    self.optionsButtons[1].pressed = false
                end
            end
            if self.optionsButtons[2] ~= nil then
                if self.optionsButtons[2].pressed then
                    gameStuff.useOST = false
                    self:setCurrentOptions(3)
                    self.optionsButtons[2].pressed = false
                end
            end
        end
    end


    function o:draw()
        for b=1, #self.optionsButtons do
            self.optionsButtons[b].alpha = self.alpha
        end


        local text = self.questions[self.currentQuestion]
        if self.currentQuestion == 1 then
            if self.alpha >= 1 then
                if self.optionsButtons[1] ~= nil then
                    if self.optionsButtons[1].hovered then
                        self.w = 1
                    end
                end
                if self.optionsButtons[2] ~= nil then
                    if self.optionsButtons[2].hovered then
                        self.w = 2
                    end
                end


                text = self.questions[self.currentQuestion][self.w]
            else
                text = self.questions[self.currentQuestion][1]
            end
        end
        if self.currentQuestion == 2 then
            if gameStuff.lang == "pt-br" then
                text = self.questions[self.currentQuestion][2]
            else
                text = self.questions[self.currentQuestion][1]
            end
        end


        love.graphics.setColor(0, 0, 0, self.alpha)
        drawOutlinedTextF(text, 800 / 2, 64, 800 / 4, "center", 0, 4, 4, nil, nil, 4, {1, 1, 1, self.alpha})
        if self.currentQuestion == 2 then
            local text = "The music is very bad\n:("
            local wtfIsOST = "OST: Original SoundTrack"
            if gameStuff.lang == "pt-br" then text = "A musica é bem ruim\n:(" end
            drawOutlinedTextF(text, 800 / 2, 128 + 32, 800 / 4, "center", 0, 2, 2, nil, nil, 2, {1, 1, 1, self.alpha})
            drawOutlinedText(wtfIsOST, 8, 128 + 32, 0, 1, 1, 0, nil, 1, {1, 1, 1, self.alpha})
        end


        local fnt = love.graphics.getFont()
        local text = "This can be changed later"
        if self.currentQuestion == 1 then
            if self.w == 2 then text = "Isso pode ser mudado depois" end
        else
            if gameStuff.lang == "pt-br" then text = "Isso pode ser mudado depois" end
        end
        drawOutlinedText(text, 800 / 2, 600 - (fnt:getHeight() * 2), 0, 2, 2, nil, fnt:getHeight(), 2, {1, 1, 1, self.alpha})
    end


    startingOptionsInstance = o


    o:init()
end


startingOptionsInstance = nil