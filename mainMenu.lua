


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
        theme = oldMainMenuTheme,
        THEMES = {
            THEME_NORMAL = 0,
            THEME_HARD = 1,
            THEME_SOFT = 2,
            THEME_BLOOD = 3,
            THEME_CAT = 4,
        },
        pos = 1,
        oldUpBtn = false,
        oldDownBtn = false,
        oldSelectButtonPressed = false,
        currentOptionScale = 5,
        mouseMoved = false,
        blackEnterAlpha = 1,
        creditsButton = createButton(800 - (64 + 8), 600 - (32 + 8), 128, 64, "Credits", "", true),
        showRunConfig = false,
        runConfigStuff = {
            startRunButton = nil,
            numButton = nil,
        }
    }


    function m:createCreditsButton()
        self.creditsButton = createButton(800 - (64 + 8), 600 - (32 + 8), 128, 64, "Credits", "", true)
    end


    function m:init()
        self.theme = randomNumber
        self:createCreditsButton()


        Flux.to(self, 1, {scale=16, blackEnterAlpha=0}):ease("expoout")


        for i=1, #GameCars do
            createCarInstance(GameCars[i], 800, 128 + 64 * i)
        end


        oldMainMenuTheme = self.theme
    end


    function m:update()
        self.mouseMoved = oldMousePos.x ~= PushsInGameMousePos.x or oldMousePos.y ~= PushsInGameMousePos.y
        self.rot = Lume.lerp(self.rot, 0.05 * math.cos(self.angle), 0.1)


        if not self.showRunConfig then
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


            if self.creditsButton.pressed then
                changeRoom(rooms.credits)


                self.creditsButton.pressed = false
            end


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
        else
            if self.runConfigStuff.startRunButton.pressed then
                changeRoom(rooms.game)


                self.runConfigStuff.startRunButton.pressed = false
            end
        end



        if tableFind(UiStuff, self.creditsButton) == -1 and not self.showRunConfig then
            table.insert(UiStuff, 1, self.creditsButton)
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
                self.showRunConfig = true
                UiStuff = {}
                self:initRunConfig()
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


    function m:initRunConfig()
        self.runConfigStuff.startRunButton = createButton(800 / 2, (600) - 64, 128, 64, "Start", "")
        self.runConfigStuff.numButton = createNumberInsertButton(800 / 2, 64, 128, 64, "Text", "",  true)
    end


    function m:setMenuLevel(toWhat)
        self.menuLevel = toWhat
        self.pos = 1
        createExplosion(Push:getWidth() / 2, (Push:getHeight() / 2) + 128, {fromCar=GameCars[2]})
    end


    function m:draw()
        if self.theme == self.THEMES.THEME_NORMAL then
            drawGrass()
            local txt = "FOGGERS"
            love.graphics.setColor({0, 0, 0, 1})
            drawOutlinedText(txt, (Push:getWidth() / 2) + 8 + 8, 80 + 8, self.rot, self.scale, self.scale, love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, {0, 0, 0})
            love.graphics.setColor({1, 1, 1})
            drawOutlinedText(txt, (Push:getWidth() / 2) + 8, 80, self.rot, self.scale, self.scale, love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, {0, 0, 0})
        elseif self.theme == self.THEMES.THEME_HARD then
            love.graphics.setColor(HSV(0, 1, 1))
            love.graphics.rectangle("fill", 0, 0, 800, 600)


            local txt = "FOGGERS"
            love.graphics.setColor(HSV(0, 0, 0.25 + 0.25 * math.sin(GlobalSinAngle)))
            drawOutlinedText(txt, (Push:getWidth() / 2) + 8 + 8, 80 + 8, self.rot, self.scale, self.scale, love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, {0, 0, 0})
            love.graphics.setColor(HSV(0, 1, 0.85 + 0.25 * math.sin(GlobalSinAngle / 2)))
            drawOutlinedText(txt, (Push:getWidth() / 2) + 8, 80, self.rot, self.scale, self.scale, love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, {0, 0, 0})


            drawOutlinedText("DIE EDITION", 800 / 2, 8 + (love.graphics.getFont():getHeight(txt) * self.scale), 0.05 * math.sin(GlobalSinAngle), 2, 2, love.graphics.getFont():getWidth("DIE EDITION") / 2, love.graphics.getFont():getHeight("DIE EDITION") / 2, 2, {0, 0, 0})
        elseif self.theme == self.THEMES.THEME_SOFT then
            love.graphics.setColor(HSV(0.95, 0.25, 1))
            love.graphics.rectangle("fill", 0, 0, 800, 600)


            local txt = "FOGGERS"
            love.graphics.setColor(HSV(0.985, 0.5, 1))
            drawOutlinedText(txt, (Push:getWidth() / 2) + 8 + 8, 80 + 8, self.rot, self.scale, self.scale, love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, HSV(0.925, 1, 0.4))
            love.graphics.setColor(HSV(0.95, 0, 1))
            drawOutlinedText(txt, (Push:getWidth() / 2) + 8, 80, self.rot, self.scale, self.scale, love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, HSV(0.9, 0.85, 0.6))
            
            
            drawOutlinedText("CALM EDITION", 800 / 2, 8 + (love.graphics.getFont():getHeight(txt) * self.scale), 0.05 * math.sin(GlobalSinAngle), 2, 2, love.graphics.getFont():getWidth("CALM EDITION") / 2, love.graphics.getFont():getHeight("CALM EDITION") / 2, 2, {0, 0, 0})
        elseif self.theme == self.THEMES.THEME_BLOOD then
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("fill", 0, 0, 800, 600)


            local txt = "FOGGERS"
            love.graphics.setColor(0, 0, 0)
            drawOutlinedText(txt, (Push:getWidth() / 2) + 8 + 8, 80 + 8, self.rot, self.scale, self.scale, love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, {1, 0, 0})
            love.graphics.setColor(0, 0, 0)
            drawOutlinedText(txt, (Push:getWidth() / 2) + 8, 80, self.rot, self.scale, self.scale, love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, {1, 0, 0})


            drawOutlinedText("DARK EDITION", 800 / 2, 8 + (love.graphics.getFont():getHeight(txt) * self.scale), 0.05 * math.sin(GlobalSinAngle), 2, 2, love.graphics.getFont():getWidth("DARK EDITION") / 2, love.graphics.getFont():getHeight("DARK EDITION") / 2, 2, {0, 0, 0})
        elseif self.theme == self.THEMES.THEME_CAT then
            love.graphics.setColor(HSV(0.5 + 0.5 * math.cos(GlobalSinAngle), 1, 1))
            love.graphics.rectangle("fill", 0, 0, 800, 600)


            local txt = "FOGGERS"
            love.graphics.setColor(0, 0, 0)
            drawOutlinedText(txt, (Push:getWidth() / 2) + 8 + 8, 80 + 8, self.rot, self.scale, self.scale, love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, {1, 0, 0})
            love.graphics.setColor(1, 1, 1)
            drawOutlinedText(txt, (Push:getWidth() / 2) + 8, 80, self.rot, self.scale, self.scale, love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, {1, 0, 0})


            drawOutlinedText("CAT EDITION", 800 / 2, 8 + (love.graphics.getFont():getHeight(txt) * self.scale), 0.05 * math.sin(GlobalSinAngle), 2, 2, love.graphics.getFont():getWidth("DARK EDITION") / 2, love.graphics.getFont():getHeight("DARK EDITION") / 2, 2, {0, 0, 0})


            love.graphics.setColor(1, 1, 1)
            love.graphics.circle("fill", (800 / 2) - 164, 600 / 2, 128, 8)
            love.graphics.circle("fill", (800 / 2) + 164, 600 / 2, 128, 8)
            love.graphics.setColor(0, 0, 0)
            love.graphics.ellipse("fill", (800 / 2) - 164 + 32 * math.cos(GlobalSinAngle), (600 / 2) + 32 * math.sin(GlobalSinAngle), 32, 64, 8)
            love.graphics.ellipse("fill", (800 / 2) + 164 + 32 * math.cos(GlobalSinAngle), (600 / 2) + 32 * math.sin(GlobalSinAngle), 32, 64, 8)
            love.graphics.setColor(1, 1, 1)
            love.graphics.setLineWidth(8)
            love.graphics.line((800 / 2) - 164, (600 / 2) + 164, (800 / 2) - 148, (600 / 2) + 256, (800 / 2), (600 / 2) + 164, (800 / 2) + 128, (600 / 2) + 256, (800 / 2) + 148, (600 / 2) + 164)
            love.graphics.setLineWidth(1)
        end


        if not self.showRunConfig then
            for o=1, #self.options[self.menuLevel] do
                local scale = 4
                local rotAdd = 0
                if o ~= self.pos then
                    local outlineColor = {0, 0, 0}
                    love.graphics.setColor({1, 1, 1})


                    if self.theme == self.THEMES.THEME_SOFT then
                        outlineColor = HSV(0.925, 1, 0.4)
                    end
                    if self.theme == self.THEMES.THEME_BLOOD then
                        outlineColor = {0.25, 0, 0}
                    love.graphics.setColor({0, 0, 0})
                end


                    local txt = self.options[self.menuLevel][o]


                    if gameStuff.lang == "pt-br" then
                        txt = self.optionsPT[self.menuLevel][o]
                    end


                    drawOutlinedText(txt, (Push:getWidth() / 2), (Push:getHeight() / 2) + 64 + 40 * o, 0 + rotAdd, scale, scale, love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, outlineColor)
                end
            end


            local outlineColor = {0, 0, 0}
            if self.theme == self.THEMES.THEME_NORMAL then
                love.graphics.setColor({0, 1, 0})
            elseif self.theme == self.THEMES.THEME_HARD then
                love.graphics.setColor(HSV(0, 1, 0.85 + 0.25 * math.sin(GlobalSinAngle / 2)))
            elseif self.theme == self.THEMES.THEME_SOFT then
                love.graphics.setColor(HSV(0.95, 0, 1))
                outlineColor = HSV(0.9, 0.85, 0.6)
            elseif self.theme == self.THEMES.THEME_BLOOD then
                love.graphics.setColor({0, 0, 0})
                outlineColor = {1, 0, 0}
            elseif self.theme == self.THEMES.THEME_CAT then
                love.graphics.setColor(HSV(0.5 + 0.5 * math.sin(GlobalSinAngle), 1, 1))
                outlineColor = {0, 0, 0}
            end
            rotAdd = 0.1 * math.sin(GlobalSinAngle)
            scale = self.currentOptionScale
            local txt = self.options[self.menuLevel][self.pos]


            if gameStuff.lang == "pt-br" then
                txt = self.optionsPT[self.menuLevel][self.pos]
            end
            drawOutlinedText(txt, (Push:getWidth() / 2), (Push:getHeight() / 2) + 64 + 40 * self.pos, 0 + rotAdd, scale, scale, love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, outlineColor)


            love.graphics.setColor({1, 1, 1})
            local txt = "Version: " .. tostring(gameStuff.currentVersion)
            drawOutlinedText(txt, 8, 600 - 8, 0, 2, 2, 0, love.graphics.getFont():getHeight(txt), 2, {0, 0, 0})
            
            
            if debugStuff.enabled then
                drawOutlinedText(tostring(self.theme), 8, 600 - 8 - 32, 0, 2, 2, 0, love.graphics.getFont():getHeight(txt), 2, {0, 0, 0})
            end
        end


        drawAllCars()


        love.graphics.setColor(0, 0, 0, self.blackEnterAlpha)
        love.graphics.rectangle("fill", 0, 0, 800, 600)


        if self.showRunConfig then
            love.graphics.setColor(HSV(0, 0, 0.1 + 0.1 * math.cos(GlobalSinAngle)))
            drawOutlinedRect(32, 32, 800 - 64, 600 - 64, {0, 0, 0})
        end
    end


    m:init()


    return m
end