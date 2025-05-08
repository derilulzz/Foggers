


function createPause()
    local p = {
        bgAlpha = 0,
        scale = 0,
        rot = 0,
        angle = 0,
        options = {
            {
                "Continue",
                "Options",
                "Main Menu",
            },
            {
                "Fullscreen: No",
                "Lenguage: Eng",
                "SFX Volume: 100",
                "Music Volume: 100",
                "Return",
            }
        },
        optionsPT = {
            {
                "Continuar",
                "Opcoes",
                "Menu Principal",
            },
            {
                "Tela Cheia: Nao",
                "Lenguage: Eng",
                "Volume Dos SFX: 100",
                "Volume Da Musica: 100",
                "Voltar",
            }
        },
        menuLevel = 1,
        pos = 1,
        oldUpBtn = false,
        oldDownBtn = false,
        oldSelectButtonPressed = false,
        currentOptionScale = 5,
        mouseMoved = false,
    }


    function p:update()
        self.mouseMoved = oldMousePos.x ~= PushsInGameMousePosNoTransform.x or oldMousePos.y ~= PushsInGameMousePosNoTransform.y
        self.rot = Lume.lerp(self.rot, 0.05 * math.cos(self.angle), 0.1)


        if love.keyboard.isDown("up", "w") and self.oldUpBtn == false then
            self.pos = self.pos - 1
            self.currentOptionScale = 5
        end
        if love.keyboard.isDown("down", "s") and self.oldDownBtn == false then
            self.pos = self.pos + 1
            self.currentOptionScale = 5
        end
        if love.keyboard.isDown("return", "space") and self.oldSelectButtonPressed == false then
            self:selectOption()
        end


        if self.pos < 1 then self.pos = #self.options[self.menuLevel] end
        if self.pos > #self.options[self.menuLevel] then self.pos = 1 end


        local hoveringOne = false
        for o=1, #self.options[self.menuLevel] do
            if PushsInGameMousePosNoTransform.x > (Push:getWidth() / 2) - (love.graphics.getFont():getWidth(self.options[self.menuLevel][o]) * 4) / 2 and PushsInGameMousePosNoTransform.y > ((Push:getHeight() / 2) + 64 + 40 * o) - (love.graphics.getFont():getHeight(self.options[self.menuLevel][o]) * 4) / 2 then
                if PushsInGameMousePosNoTransform.x < (Push:getWidth() / 2) + (love.graphics.getFont():getWidth(self.options[self.menuLevel][o]) * 4) / 2 and PushsInGameMousePosNoTransform.y < ((Push:getHeight() / 2) + 64 + 40 * o) + (love.graphics.getFont():getHeight(self.options[self.menuLevel][o]) * 4) / 2 then
                    hoveringOne = true
                    if self.mouseMoved then
                        if self.pos ~= o then
                            self.pos = o
                            self.currentOptionScale = 5
                        end
                    end
                end
            end
        end
        if hoveringOne then
            if love.mouse.isDown(1) and LastLeftMouseButton == false then
                self:selectOption()
            end
        end


        if love.window.getFullscreen() then
            self.options[2][1] = "Fullscreen: Yes"
        else
            self.options[2][1] = "Fullscreen: No"
        end
        if love.window.getFullscreen() then
            self.optionsPT[2][1] = "Tela Cheia: Sim"
        else
            self.optionsPT[2][1] = "Tela Cheia: Nao"
        end


        if gameStuff.lang == "pt-br" then
            self.options[2][2] = "Lenguage: PT-BR"
        else
            self.options[2][2] = "Lenguage: Eng"
        end
        if gameStuff.lang == "pt-br" then
            self.optionsPT[2][2] = "Lingua: PT-BR"
        else
            self.optionsPT[2][2] = "Lingua: Eng"
        end


        if gameStuff.lang == "eng" then
            self.options[2][3] = "SFX Volume: " .. math.floor(gameStuff.sfxVolume * 100)
        end
        if gameStuff.lang == "pt-br" then
            self.optionsPT[2][3] = "Volume Dos SFX: " .. math.floor(gameStuff.sfxVolume * 100)
        end


        if gameStuff.lang == "eng" then
            self.options[2][4] = "Music Volume: " .. math.floor(gameStuff.musicVolume * 100)
        end
        if gameStuff.lang == "pt-br" then
            self.optionsPT[2][4] = "Volume Da Musica: " .. math.floor(gameStuff.musicVolume * 100)
        end


        if self.menuLevel == 2 and self.pos == 3 then
            if love.keyboard.isDown("left", "a") then gameStuff.sfxVolume = gameStuff.sfxVolume - 0.1 * globalDt end
            if love.keyboard.isDown("right", "d") then gameStuff.sfxVolume = gameStuff.sfxVolume + 0.1 * globalDt end
        end
        if self.menuLevel == 2 and self.pos == 4 then
            if love.keyboard.isDown("left", "a") then gameStuff.musicVolume = gameStuff.musicVolume - 0.1 * globalDt end
            if love.keyboard.isDown("right", "d") then gameStuff.musicVolume = gameStuff.musicVolume + 0.1 * globalDt end
        end


        self.angle = self.angle + 1 * globalDt
        self.currentOptionScale = Lume.lerp(self.currentOptionScale, 4, 0.1)
        self.oldUpBtn = love.keyboard.isDown("up", "w")
        self.oldDownBtn = love.keyboard.isDown("down", "s")
        self.oldSelectButtonPressed = love.keyboard.isDown("return", "space")
    end


    function p:selectOption()
        if self.menuLevel == 1 then
            if self.pos == 1 then
                self:die()
                gameStuff.paused = false
            elseif self.pos == 2 then
                self:setMenuLevel(2)
            elseif self.pos == 3 then
                changeRoom(rooms.mainMenu)
                self:die()
                gameStuff.paused = false
            end
        elseif self.menuLevel == 2 then
            if self.pos == 1 then
                love.window.setFullscreen(not love.window.getFullscreen())
            elseif self.pos == 2 then
                if gameStuff.lang == "pt-br" then
                    gameStuff.lang = "eng"
                else
                    gameStuff.lang = "pt-br"
                end
            elseif self.pos == 5 then
                self:setMenuLevel(1)
            end
        end
    end


    function p:setMenuLevel(toWhat)
        self.menuLevel = toWhat
        self.pos = 1
        self.currentOptionScale = 0
    end


    function p:init()
        Flux.to(self, 1, {bgAlpha=0.85})
    end


    function p:die()
        Flux.to(self, 1, {bgAlpha=0}):oncomplete(p.deleteSelf)
    end


    function p:deleteSelf()
        pauseMenuInstance = nil
    end


    function p:draw()
        love.graphics.setColor({0, 1, 0, self.bgAlpha})
        love.graphics.rectangle("fill", 0, 0, 800, 600)


        love.graphics.setColor({0.1, 0.25, 0, self.bgAlpha * 2})
        love.graphics.print("PAUSED", Push:getWidth() / 2, 64, 0, 8, 8, love.graphics.getFont():getWidth("PAUSED") / 2, love.graphics.getFont():getHeight("PAUSED") / 2)


        for o=1, #self.options[self.menuLevel] do
            local scale = 4
            if o ~= self.pos then
                love.graphics.setColor({1, 1, 1, self.bgAlpha * 2})
            else
                love.graphics.setColor({0, 1, 0, self.bgAlpha * 2})
                scale = self.currentOptionScale
            end


            local txt = self.options[self.menuLevel][o]


            if gameStuff.lang == "pt-br" then
                txt = self.optionsPT[self.menuLevel][o]
            end


            drawOutlinedText(txt, (Push:getWidth() / 2), (Push:getHeight() / 2) + 64 + 40 * o, 0, scale, scale, love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, {0, 0, 0, self.bgAlpha * 2})
        end
    end


    p:init()
    return p
end
pauseMenuInstance = nil