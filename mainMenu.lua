


mainMenuInstance = nil
function createMainMenu()
    local m = {
        scale = 0,
        rot = 0,
        angle = 0,
        options = {
            {
                "Start",
                "Cars Info",
                "Options",
                "Quit",
            },
            {
                "Fullscreen: No",
                "Lenguage: Eng",
                "Mods",
                "Graphics",
                "Sounds",
                "Return",
            },
            {
                "SFX Volume: 100",
                "Music Volume: 100",
                "Return",
            },
            {
                "Draw outlines: Yes",
                "Return",
            }
        },
        optionsPT = {
            {
                "Começar",
                "Informações de carros",
                "Opções",
                "Sair",
            },
            {
                "Tela Cheia: Nao",
                "Lenguage: Eng",
                "Mods",
                "Gráficos",
                "Sons",
                "Voltar",
            },
            {
                "Volume dos Effeitos sonoros: 100",
                "Volume da Musica: 100",
                "Voltar",
            },
            {
                "Desenhar outlines: Sim",
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
        creditsButton = nil,
        sourceCodeButton = nil,
        showRunConfig = false,
        runConfigStuff = {
            boxYOffset = 600,
            startRunButton = nil,
            cancelRunButton = nil,
            startingRoundNumBtn = nil,
            seedNumBtn = nil,
        },
        showCarsStats = false,
        carsStats = {
            statsInstance = nil,
        }
    }


    function m:createCreditsButton()
        local text = "Credits"


        if gameStuff.lang == "pt-br" then
            text = "Creditos"
        end


        deleteUIInstance(self.creditsButton)
        deleteUIInstance(self.sourceCodeButton)
        self.sourceCodeButton = createButton(800 - (64 + 8), 600 - (64 + 32 + 8 + 8), 128, 64, "Source Code", "", true)
        self.creditsButton = createButton(800 - (64 + 8), 600 - (32 + 8), 128, 64, text, "", true)
    end


    function m:init()
        gameStuff.musicLooping = true
        self.theme = randomNumber
        self:createCreditsButton()


        Flux.to(self, 1, {scale=16, blackEnterAlpha=0}):ease("expoout")


        for i=1, #GameCars do
            if 128 + 32 * i > 600 then break end

            
            createCarInstance(GameCars[i], 800, 128 + 32 * i)
        end


        oldMainMenuTheme = self.theme
    end


    function m:update()
        self.mouseMoved = oldMousePos.x ~= PushsInGameMousePos.x or oldMousePos.y ~= PushsInGameMousePos.y
        self.rot = Lume.lerp(self.rot, 0.05 * math.cos(self.angle), 0.1)



        if not self.showCarsStats then
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


                if gameStuff.lang == "pt-br" then
                    self.creditsButton.text = "Creditos"
                else
                    self.creditsButton.text = "Credits"
                end
                if self.creditsButton.pressed then
                    changeRoom(rooms.credits)


                    self.creditsButton.pressed = false
                end
                if self.sourceCodeButton.pressed then
                    changeRoom(rooms.sourceCode)
                    self.sourceCodeButton.pressed = false
                end


                local hoveringOne = false
                local optionsYRem = 0
                while ((Push:getHeight() / 2) + 64 + 40 * #self.options[self.menuLevel]) + 32 - optionsYRem > 600 do
                    optionsYRem = optionsYRem + 1
                end
                for o=1, #self.options[self.menuLevel] do
                    if PushsInGameMousePos.x > (Push:getWidth() / 2) - (love.graphics.getFont():getWidth(self.options[self.menuLevel][o]) * 4) / 2 and PushsInGameMousePos.y > (((Push:getHeight() / 2) + 64 + 40 * o) - (love.graphics.getFont():getHeight(self.options[self.menuLevel][o]) * 4) / 2) - optionsYRem then
                        if PushsInGameMousePos.x < (Push:getWidth() / 2) + (love.graphics.getFont():getWidth(self.options[self.menuLevel][o]) * 4) / 2 and PushsInGameMousePos.y < ((Push:getHeight() / 2) + 64 + 40 * o) + ((love.graphics.getFont():getHeight(self.options[self.menuLevel][o]) * 4) / 2) - 4 - optionsYRem then
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
                if gameStuff.drawOutlines then
                    self.optionsPT[4][1] = "Desenhar outlines: Sim"
                    self.options[4][1] = "Draw outlines: Yes"
                else
                    self.optionsPT[4][1] = "Desenhar outlines: Não"
                    self.options[4][1] = "Draw outlines: No"
                end


                if gameStuff.lang == "pt-br" then
                    self.creditsButton.text = "Creditos"
                    self.options[2][2] = "Lenguage: PT-BR"
                else
                    self.creditsButton.text = "Credits"
                    self.options[2][2] = "Lenguage: Eng"
                end
                if gameStuff.lang == "pt-br" then
                    self.creditsButton.text = "Creditos"
                    self.optionsPT[2][2] = "Lingua: PT-BR"
                else
                    self.creditsButton.text = "Credits"
                    self.optionsPT[2][2] = "Lingua: Eng"
                end


                if gameStuff.lang == "eng" then
                    self.options[3][1] = "SFX Volume: " .. math.floor(gameStuff.sfxVolume * 100)
                end
                if gameStuff.lang == "pt-br" then
                    self.optionsPT[3][1] = "Volume Dos efeitos sonoros: " .. math.floor(gameStuff.sfxVolume * 100)
                end


                if gameStuff.lang == "eng" then
                    self.options[3][2] = "Music Volume: " .. math.floor(gameStuff.musicVolume * 100)
                end
                if gameStuff.lang == "pt-br" then
                    self.optionsPT[3][2] = "Volume Da Musica: " .. math.floor(gameStuff.musicVolume * 100)
                end


                if self.menuLevel == 3 and self.pos == 1 then
                    if love.keyboard.isDown("left", "a") then gameStuff.sfxVolume = gameStuff.sfxVolume - 0.1 * globalDt end
                    if love.keyboard.isDown("right", "d") then gameStuff.sfxVolume = gameStuff.sfxVolume + 0.1 * globalDt end
                end
                if self.menuLevel == 3 and self.pos == 2 then
                    if love.keyboard.isDown("left", "a") then gameStuff.musicVolume = gameStuff.musicVolume - 0.1 * globalDt end
                    if love.keyboard.isDown("right", "d") then gameStuff.musicVolume = gameStuff.musicVolume + 0.1 * globalDt end
                end
            else
                if gameStuff.lang == "pt-br" then
                    self.runConfigStuff.cancelRunButton.text = "Cancelar"
                    self.runConfigStuff.startRunButton.text = "Começar"
                    self.runConfigStuff.startRunButton.addText = "Começar A Run"
                    self.runConfigStuff.cancelRunButton.addText = "Cancelar A Run"
                    self.runConfigStuff.seedNumBtn.addText = "O Numero Usado Para Criar Numeros Aleatorios"
                    self.runConfigStuff.startingRoundNumBtn.addText = "O Round Onde O Jogo Começa"
                    self.runConfigStuff.seedNumBtn.text = "Aleatorio"
                else
                    self.runConfigStuff.cancelRunButton.text = "Cancel"
                    self.runConfigStuff.startRunButton.text = "Start"
                    self.runConfigStuff.seedNumBtn.text = "Random"
                end


                if self.runConfigStuff.startRunButton.pressed then
                    if self.runConfigStuff.startingRoundNumBtn.textedText == "" then
                        gameStuff.currentStartingRound = 0
                    else
                        if self.runConfigStuff.startingRoundNumBtn.textedText ~= "" then
                            gameStuff.currentStartingRound = tonumber(self.runConfigStuff.startingRoundNumBtn.textedText)
                        else
                            gameStuff.currentStartingRound = 0
                        end
                    end
                    
                    
                    if self.runConfigStuff.seedNumBtn ~= nil and self.runConfigStuff.seedNumBtn.textedText ~= "" then
                        gameStuff.useFixedSeed = true
                        gameStuff.fixedSeed = tonumber(self.runConfigStuff.seedNumBtn.textedText)
                    end
                    
                    
                    changeRoom(rooms.game)


                    self.runConfigStuff.startRunButton.pressed = false
                end
            end
        else
            if self.carsStats.statsInstance == nil then
                self.carsStats.statsInstance = createCarStats()
            else
                self.carsStats.statsInstance:update()


                if self.carsStats.statsInstance.died then
                    self.carsStats.statsInstance = nil
                    self.showCarsStats = false
                end
            end
        end


        if not self.showRunConfig then
            if self.runConfigStuff.startRunButton ~= nil then
                self:unnitRunConfig()
            end
        end


        if self.showRunConfig then
            if self.runConfigStuff.startRunButton ~= nil then
                self.runConfigStuff.startRunButton.pos.y = (600) - 64 - 8 + self.runConfigStuff.boxYOffset
                self.runConfigStuff.cancelRunButton.pos.y = (600) - 64 - 8 + self.runConfigStuff.boxYOffset
                self.runConfigStuff.startingRoundNumBtn.pos.y = 64 + 8 + self.runConfigStuff.boxYOffset
                self.runConfigStuff.seedNumBtn.pos.y = 128 + 16 + self.runConfigStuff.boxYOffset
            end


            if self.runConfigStuff.cancelRunButton ~= nil and self.runConfigStuff.cancelRunButton.pressed then
                Flux.to(self.runConfigStuff, 0.5, {boxYOffset=600}):ease("expoin"):oncomplete(m.disableRunConf)
                self.runConfigStuff.cancelRunButton.pressed = false
            end


            if self.runConfigStuff.startingRoundNumBtn ~= nil and string.len(self.runConfigStuff.startingRoundNumBtn.textedText) > 0 then
                if tonumber(self.runConfigStuff.startingRoundNumBtn.textedText) > gameStuff.higestRound then
                    self.runConfigStuff.startingRoundNumBtn.textedText = tostring(gameStuff.higestRound)
                end
            end
        end

        
        self.creditsButton.visible = self.showRunConfig == false and self.showCarsStats == false
        self.sourceCodeButton.visible = self.showRunConfig == false and self.showCarsStats == false


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


    function m:disableRunConf()
        m.showRunConfig = false
    end


    function m:selectOption()
        if self.menuLevel == 1 then
            if self.pos == 1 then
                self.showRunConfig = true
                self:initRunConfig()
                Flux.to(self.runConfigStuff, 0.5, {boxYOffset=0}):ease("expoout")
            elseif self.pos == 2 then
                self.showCarsStats = true
            elseif self.pos == 3 then
                self:setMenuLevel(2)
            elseif self.pos == 4 then
                love.event.quit()
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
                self:createCreditsButton()
            elseif self.pos == 3 then
                changeRoom(rooms.mods)
            elseif self.pos == 4 then
                self:setMenuLevel(4)
            elseif self.pos == 5 then
                self:setMenuLevel(3)
            elseif self.pos == 6 then
                self:setMenuLevel(1)
            end
        elseif self.menuLevel == 3 then
            if self.pos == 3 then
                self:setMenuLevel(2)
            end
        elseif self.menuLevel == 4 then
            if self.pos == 1 then
                gameStuff.drawOutlines = not gameStuff.drawOutlines
            elseif self.pos == 2 then
                self:setMenuLevel(2)
            end
        end
    end


    function m:unnitRunConfig()
        deleteUIInstance(self.runConfigStuff.startRunButton)
        deleteUIInstance(self.runConfigStuff.startingRoundNumBtn)
        deleteUIInstance(self.runConfigStuff.seedNumBtn)
        deleteUIInstance(self.runConfigStuff.cancelRunButton)


        self.runConfigStuff.startRunButton = nil
        self.runConfigStuff.startingRoundNumBtn = nil
        self.runConfigStuff.seedNumBtn = nil
        self.runConfigStuff.cancelRunButton = nil
    end


    function m:initRunConfig()
        self.runConfigStuff.startRunButton = createButton((800 / 2) + 128, (600) - 64, 128, 64, "Start", "Start the run")
        self.runConfigStuff.startingRoundNumBtn = createNumberInsertButton(800 / 2, 64, 128, 64, "0", "The round that the game will start",  true, true)
        self.runConfigStuff.seedNumBtn = createNumberInsertButton(800 / 2, 128 + 8, 128, 64, "Random", "The number used to create random numbers",  true, true)
        self.runConfigStuff.cancelRunButton = createButton((800 / 2) - 128, 600 - 32 - 8, 128, 64, "Cancel", "Cancel run", true)
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


        local optionsYRem = 0
        while ((Push:getHeight() / 2) + 64 + 40 * #self.options[self.menuLevel]) + 32 - optionsYRem > 600 do
            optionsYRem = optionsYRem + 1
        end


        if not self.showRunConfig and not self.showCarsStats then
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


                    drawOutlinedText(txt, (Push:getWidth() / 2), ((Push:getHeight() / 2) + 64 + 40 * o) - optionsYRem, 0 + rotAdd, scale, scale, love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, outlineColor)
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
            drawOutlinedText(txt, (Push:getWidth() / 2), ((Push:getHeight() / 2) + 64 + 40 * self.pos) - optionsYRem, 0 + rotAdd, scale, scale, love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, outlineColor)


            love.graphics.setColor({1, 1, 1})
            local txt = "Version: " .. tostring(gameStuff.currentVersion)
            if gameStuff.lang == "pt-br" then txt = "Versão: " .. tostring(gameStuff.currentVersion) end
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
            drawOutlinedRect(32, 32 + self.runConfigStuff.boxYOffset, 800 - 64, 600 - 64, {0, 0, 0})
            love.graphics.setColor(1, 1, 1)


            local text1 = "Starting round: "
            local text2 = "Seed: "


            if gameStuff.lang == "pt-br" then
                text1 = "Round Inicial: "
            end


            drawOutlinedText(text1, (800 / 2) - (love.graphics.getFont():getWidth(text1) * 2), 68 + self.runConfigStuff.boxYOffset, 0, 2, 2, love.graphics.getFont():getWidth(text1) / 2, love.graphics.getFont():getHeight(text1) / 2, 4, {0, 0, 0})
            drawOutlinedText(text2, (800 / 2) - (love.graphics.getFont():getWidth(text2) * 3.85), 128 + 8 + self.runConfigStuff.boxYOffset, 0, 2, 2, love.graphics.getFont():getWidth(text2) / 2, love.graphics.getFont():getHeight(text2) / 2, 4, {0, 0, 0})
        end
        if self.showCarsStats then
            if self.carsStats.statsInstance ~= nil then
                self.carsStats.statsInstance:draw()
            end
        end
    end


    m:init()


    return m
end