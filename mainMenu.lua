


mainMenuInstance = nil
function createMainMenu()
    local m = {
        scale = 0,
        rot = 0,
        angle = 0,
        options = {
            {
                "Start",
                "Options",
                "Quit",
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
                "Comecar",
                "Opcoes",
                "Sair",
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
        blackEnterAlpha = 1,
    }


    function m:init()
        Flux.to(self, 1, {scale=16, blackEnterAlpha=0}):ease("expoout")


        for i=1, #GameCars do
            createCarInstance(GameCars[i], 800, 128 + 64 * i)
        end
    end


    function m:update()
        self.mouseMoved = oldMousePos.x ~= PushsInGameMousePos.x or oldMousePos.y ~= PushsInGameMousePos.y
        self.rot = Lume.lerp(self.rot, 0.05 * math.cos(self.angle), 0.1)


        if love.keyboard.isDown("up", "w") and self.oldUpBtn == false then
            self.pos = self.pos - 1
            self.currentOptionScale = 6
        end
        if love.keyboard.isDown("down", "s") and self.oldDownBtn == false then
            self.pos = self.pos + 1
            self.currentOptionScale = 6
        end
        if love.keyboard.isDown("return", "space") and self.oldSelectButtonPressed == false then
            self:selectOption()
        end


        if self.pos < 1 then self.pos = #self.options[self.menuLevel] end
        if self.pos > #self.options[self.menuLevel] then self.pos = 1 end


        local hoveringOne = false
        for o=1, #self.options[self.menuLevel] do
            if PushsInGameMousePos.x > (Push:getWidth() / 2) - (love.graphics.getFont():getWidth(self.options[self.menuLevel][o]) * 4) / 2 and PushsInGameMousePos.y > ((Push:getHeight() / 2) + 64 + 40 * o) - (love.graphics.getFont():getHeight(self.options[self.menuLevel][o]) * 4) / 2 then
                if PushsInGameMousePos.x < (Push:getWidth() / 2) + (love.graphics.getFont():getWidth(self.options[self.menuLevel][o]) * 4) / 2 and PushsInGameMousePos.y < ((Push:getHeight() / 2) + 64 + 40 * o) + ((love.graphics.getFont():getHeight(self.options[self.menuLevel][o]) * 4) / 2) - 4 then
                    hoveringOne = true
                    if self.mouseMoved then
                        if self.pos ~= o then
                            self.pos = o
                            self.currentOptionScale = 6
                        end
                    end
                end
            end
        end
        if hoveringOne then
            if love.mouse.isDown(1) == false and LastLeftMouseButton then
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
        if hoveringOne and love.mouse.isDown(1) then
            self.currentOptionScale = Lume.lerp(self.currentOptionScale, 3, 0.4)
        else
            self.currentOptionScale = Lume.lerp(self.currentOptionScale, 5, 0.1)
        end
        self.oldUpBtn = love.keyboard.isDown("up", "w")
        self.oldDownBtn = love.keyboard.isDown("down", "s")
        self.oldSelectButtonPressed = love.keyboard.isDown("return", "space")
    end


    function m:selectOption()
        if self.menuLevel == 1 then
            if self.pos == 1 then
                changeRoom(rooms.game)
            elseif self.pos == 2 then
                self:setMenuLevel(2)
            elseif self.pos == 3 then
                changeRoom(rooms.quit)
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


    function m:setMenuLevel(toWhat)
        self.menuLevel = toWhat
        self.pos = 1
        createExplosion(Push:getWidth() / 2, (Push:getHeight() / 2) + 128, {fromCar=GameCars[2]})
    end


    function m:draw()
        local txt = "FOGGERS"
        love.graphics.setColor({0, 0, 0, 1})
        drawOutlinedText(txt, (Push:getWidth() / 2) + 8 + 8, 80 + 8, self.rot, self.scale, self.scale, love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, {0, 0, 0})
        love.graphics.setColor({1, 1, 1})
        drawOutlinedText(txt, (Push:getWidth() / 2) + 8, 80, self.rot, self.scale, self.scale, love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, {0, 0, 0})


        for o=1, #self.options[self.menuLevel] do
            local scale = 4
            local rotAdd = 0
            if o ~= self.pos then
                love.graphics.setColor({1, 1, 1})


                local txt = self.options[self.menuLevel][o]


                if gameStuff.lang == "pt-br" then
                    txt = self.optionsPT[self.menuLevel][o]
                end


                drawOutlinedText(txt, (Push:getWidth() / 2), (Push:getHeight() / 2) + 64 + 40 * o, 0 + rotAdd, scale, scale, love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, {0, 0, 0})
            end
        end
        love.graphics.setColor({0, 1, 0})
        rotAdd = 0.1 * math.sin(GlobalSinAngle)
        scale = self.currentOptionScale
        drawOutlinedText(self.options[self.menuLevel][self.pos], (Push:getWidth() / 2), (Push:getHeight() / 2) + 64 + 40 * self.pos, 0 + rotAdd, scale, scale, love.graphics.getFont():getWidth(self.options[self.menuLevel][self.pos]) / 2, love.graphics.getFont():getHeight(self.options[self.menuLevel][self.pos]) / 2, 4, {0, 0, 0})


        love.graphics.setColor({1, 1, 1})
        local txt = "Version: " .. tostring(gameStuff.currentVersion)
        drawOutlinedText(txt, 8, 600 - 8, 0, 2, 2, 0, love.graphics.getFont():getHeight(txt), 2, {0, 0, 0})


        love.graphics.setColor(0, 0, 0, self.blackEnterAlpha)
        love.graphics.rectangle("fill", 0, 0, 800, 600)
    end


    m:init()


    return m
end