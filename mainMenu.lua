mainMenuInstance = nil
heights = {}


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
                "V-Sync: Yes",
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
                "Target FPS: 60",
                "GUI Scale: 1",
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
                "V-Sync: Sim",
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
                "FPS Desejado: 60",
                "Tamanho Do GUI: 1",
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
        pauseMainMenu = false,
        fpsSetter = nil,
        sourceCodeButton = nil,
        showRunConfig = false,
        runConfigStuff = {
            boxYOffset = gameSize.h,
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
        self.sourceCodeButton = createButton(gameSize.w - (64 + 8), gameSize.h - (64 + 32 + 8 + 8), 128, 64, "Source Code", "", false)
        self.creditsButton = createButton(gameSize.w - (64 + 8), gameSize.h - (32 + 8), 128, 64, text, "", false)
    end

    function m:init()
        gameStuff.musicLooping = true
        self.theme = randomNumber
        self:createCreditsButton()


        Flux.to(self, 1, { scale = 16, blackEnterAlpha = 0 }):ease("expoout")


        for i = 1, #GameCars do
            if 128 + 32 * i > gameSize.h then break end


            createCarInstance(GameCars[i], gameSize.w, 128 + 32 * i)
        end


        oldMainMenuTheme = self.theme
    end

    function m:update()
        local acceptKey = love.keyboard.isDown("return", "space")
        local upKey = love.keyboard.isDown("up", "w")
        local downKey = love.keyboard.isDown("down", "s")


        if not self.pauseMainMenu then
            self.mouseMoved = oldMousePos.x ~= PushsInGameMousePos.x or oldMousePos.y ~= PushsInGameMousePos.y
            self.rot = Lume.lerp(self.rot, 0.05 * math.cos(self.angle), 6)



            if not self.showCarsStats then
                if not self.showRunConfig then
                    if upKey and self.oldUpBtn == false then
                        self.pos = self.pos - 1
                        self.currentOptionScale = 6
                    end
                    if downKey and self.oldDownBtn == false then
                        self.pos = self.pos + 1
                        self.currentOptionScale = 6
                    end
                    if acceptKey == false and self.oldSelectButtonPressed then
                        self:selectOption()
                    end
                    if acceptKey and self.oldSelectButtonPressed == false then
                        self.currentOptionScale = 1
                    end


                    if self.pos < 1 then self.pos = #self.options[self.menuLevel] end
                    if self.pos > #self.options[self.menuLevel] then self.pos = 1 end


                    --[[gameSize.w, gameSize.h
                    gameSize.w - (64 + 8), gameSize.h - (32 + 8), 128, 64,]]
                    self.creditsButton.pos.x = gameSize.w - (8) - self.creditsButton.size.w / 2
                    self.creditsButton.pos.y = gameSize.h - (8 + 8) - self.creditsButton.size.h / 2
                    self.sourceCodeButton.pos.x = gameSize.w - (8) - self.sourceCodeButton.size.w / 2
                    self.sourceCodeButton.pos.y = gameSize.h - (32 + 32 + 8 + 8 + 8) - self.sourceCodeButton.size.h / 2


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


                    if #heights > 0 then
                        local hoveringOne = false
                        local optionsYRem = 0
                        while ((gameSize.h / 2) + 64 + 40 * #self.options[self.menuLevel]) + 32 - optionsYRem > gameSize.h do
                            optionsYRem = optionsYRem + 1
                        end
                        for o = 1, #self.options[self.menuLevel] do
                            if PushsInGameMousePos.x > (gameSize.w / 2) - (love.graphics.getFont():getWidth(self.options[self.menuLevel][o]) * 4) / 2 and PushsInGameMousePos.y > heights[Lume.clamp(o, 1, #heights)] - ((love.graphics.getFont():getHeight(self.options[self.menuLevel][o]) * 4) / 2) then
                                if PushsInGameMousePos.x < (gameSize.w / 2) + (love.graphics.getFont():getWidth(self.options[self.menuLevel][o]) * 4) / 2 and PushsInGameMousePos.y < heights[Lume.clamp(o, 1, #heights)] + ((love.graphics.getFont():getHeight(self.options[self.menuLevel][o]) * 4) / 2) then
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


                        if (hoveringOne and love.mouse.isDown(1)) or acceptKey then
                            if not acceptKey then
                                if LastLeftMouseButton == false then
                                    self.currentOptionScale = 1
                                end
                            end


                            self.currentOptionScale = Lume.lerp(self.currentOptionScale, 3, 24)
                        else
                            self.currentOptionScale = Lume.lerp(self.currentOptionScale, 5, 6)
                        end
                    end


                    if self.menuLevel == 3 and self.pos == 1 then
                        if love.keyboard.isDown("left", "a") then
                            gameStuff.sfxVolume = gameStuff.sfxVolume - 0.1 * globalDt
                            self:updateOptions()
                        end
                        if love.keyboard.isDown("right", "d") then
                            gameStuff.sfxVolume = gameStuff.sfxVolume + 0.1 * globalDt
                            self:updateOptions()
                        end
                    end
                    if self.menuLevel == 3 and self.pos == 2 then
                        if love.keyboard.isDown("left", "a") then
                            gameStuff.musicVolume = gameStuff.musicVolume - 0.1 * globalDt
                            self:updateOptions()
                        end
                        if love.keyboard.isDown("right", "d") then
                            gameStuff.musicVolume = gameStuff.musicVolume + 0.1 * globalDt
                            self:updateOptions()
                        end
                    end
                else
                    if self.runConfigStuff.startRunButton.pressed or self.oldSelectButtonPressed == false and acceptKey then
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


                        stopMusic()


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
                    self.runConfigStuff.startRunButton.pos.y = (gameSize.h) - 64 - 8 + self.runConfigStuff.boxYOffset
                    self.runConfigStuff.cancelRunButton.pos.y = (gameSize.h) - 64 - 8 + self.runConfigStuff.boxYOffset
                    self.runConfigStuff.startingRoundNumBtn.pos.y = 64 + 8 + self.runConfigStuff.boxYOffset
                    self.runConfigStuff.seedNumBtn.pos.y = 128 + 16 + self.runConfigStuff.boxYOffset
                end


                if self.runConfigStuff.cancelRunButton ~= nil and self.runConfigStuff.cancelRunButton.pressed then
                    Flux.to(self.runConfigStuff, 0.5, { boxYOffset = gameSize.h }):ease("expoin"):oncomplete(m.disableRunConf)
                    self.runConfigStuff.cancelRunButton.pressed = false
                end


                if self.runConfigStuff.startingRoundNumBtn ~= nil and string.len(self.runConfigStuff.startingRoundNumBtn.textedText) > 0 then
                    if tonumber(self.runConfigStuff.startingRoundNumBtn.textedText) > gameStuff.higestRound then
                        self.runConfigStuff.startingRoundNumBtn.textedText = tostring(gameStuff.higestRound)
                    end
                end
            end
        end
        if self.fpsSetter ~= nil then
            self.fpsSetter:update()


            if self.fpsSetter.died then
                if self.fpsSetter.wantedFps ~= nil then
                    targetFps = self.fpsSetter.wantedFps
                    frameTime = 1 / targetFps
                end


                self.fpsSetter = nil
                self.pauseMainMenu = false
            end
        end


        self.creditsButton.visible = self.showRunConfig == false and self.showCarsStats == false and not self.pauseMainMenu
        self.sourceCodeButton.visible = self.showRunConfig == false and self.showCarsStats == false and not self.pauseMainMenu


        self.angle = self.angle + 1 * globalDt
        self.oldUpBtn = upKey
        self.oldDownBtn = downKey
        self.oldSelectButtonPressed = acceptKey
    end

    function m:disableRunConf()
        m.showRunConfig = false
    end

    function m:selectOption()
        if self.menuLevel == 1 then
            if self.pos == 1 then
                self.showRunConfig = true
                self:initRunConfig()
                Flux.to(self.runConfigStuff, 0.5, { boxYOffset = 0 }):ease("expoout")
            elseif self.pos == 2 then
                self.showCarsStats = true
            elseif self.pos == 3 then
                self:setMenuLevel(2)
            elseif self.pos == 4 then
                love.event.quit()
            end
        elseif self.menuLevel == 2 then
            if self.pos == 1 then
                setFullscreen(not love.window.getFullscreen())
            elseif self.pos == 2 then
                if gameStuff.lang == "pt-br" then
                    gameStuff.lang = "eng"
                else
                    gameStuff.lang = "pt-br"
                end
                self:createCreditsButton()
            elseif self.pos == 3 then
                setVSyncUse(not useVSync)
            elseif self.pos == 4 then
                changeRoom(rooms.mods)
            elseif self.pos == 5 then
                self:setMenuLevel(4)
            elseif self.pos == 6 then
                self:setMenuLevel(3)
            elseif self.pos == 7 then
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
                self.pauseMainMenu = true
                self.fpsSetter = createFpsSetter()
            elseif self.pos == 3 then
                gameStuff.usePush = not gameStuff.usePush
                love.resize(love.graphics.getWidth(), love.graphics.getHeight())
            elseif self.pos == 4 then
                self:setMenuLevel(2)
            end
        end


        self:updateOptions()
    end


    function m:updateOptions()
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


        self.options[4][3] = "Use 4:3 Ratio: " .. tostring(gameStuff.usePush)
        self.optionsPT[4][3] = "Usar O Aspecto 4:3: " .. tostring(gameStuff.usePush)


        self.creditsButton.text = "Creditos"
        self.options[2][2] = "Lenguage: PT-BR"
        self.creditsButton.text = "Credits"
        self.options[2][2] = "Lenguage: Eng"
        self.creditsButton.text = "Creditos"
        self.optionsPT[2][2] = "Lingua: PT-BR"
        self.creditsButton.text = "Credits"
        self.optionsPT[2][2] = "Lingua: Eng"
        if targetFps > 0 then
            self.options[4][2] = "Target FPS: " .. tostring(targetFps)
            self.optionsPT[4][2] = "FPS Desejado: " .. tostring(targetFps)
        else
            self.options[4][2] = "Target FPS: Unlimited"
            self.optionsPT[4][2] = "FPS Desejado: Ilimitado"
        end
        if useVSync then
            self.options[2][3] = "V-Sync: Yes"
            self.optionsPT[2][3] = "V-Sync: Sim"
        else
            self.options[2][3] = "V-Sync: No"
            self.optionsPT[2][3] = "V-Sync: Não"
        end


        self.options[3][1] = "SFX Volume: " .. math.floor(gameStuff.sfxVolume * 100)
        self.optionsPT[3][1] = "Volume Dos efeitos sonoros: " .. math.floor(gameStuff.sfxVolume * 100)


        self.options[3][2] = "Music Volume: " .. math.floor(gameStuff.musicVolume * 100)
        self.optionsPT[3][2] = "Volume Da Musica: " .. math.floor(gameStuff.musicVolume * 100)
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
        self.runConfigStuff.startRunButton = createButton((gameSize.w / 2) + 128, (gameSize.h) - 64, 128, 64, "Start", "Start the run")
        self.runConfigStuff.startingRoundNumBtn = createNumberInsertButton(gameSize.w / 2, 64, 128, 64, "0",
            "The round that the game will start", true, true)
        self.runConfigStuff.seedNumBtn = createNumberInsertButton(gameSize.w / 2, 128 + 8, 128, 64, "Random",
            "The number used to create random numbers", true, true)
        self.runConfigStuff.cancelRunButton = createButton((gameSize.w / 2) - 128, gameSize.h - 32 - 8, 128, 64, "Cancel", "Cancel run",
            true)
        

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
    end

    function m:setMenuLevel(toWhat)
        self.menuLevel = toWhat
        self.pos = 1
        createExplosion(gameSize.w / 2, (gameSize.h / 2) + 128, { fromCar = GameCars[3] })
    end

    function m:draw()
        if self.theme == self.THEMES.THEME_NORMAL then
            drawGrass()
            local txt = "FOGGERS"
            love.graphics.setColor({ 0, 0, 0, 1 })
            drawOutlinedText(txt, (gameSize.w / 2) + 8 + 8, 80 + 8, self.rot, self.scale, self.scale,
                love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, { 0, 0, 0 })
            love.graphics.setColor({ 1, 1, 1 })
            
            
            drawOutlinedText(txt, (gameSize.w / 2) + 8, 80, self.rot, self.scale, self.scale,
                love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, { 0, 0, 0 })
        elseif self.theme == self.THEMES.THEME_HARD then
            love.graphics.setColor(HSV(0, 1, 1))
            love.graphics.rectangle("fill", 0, 0, gameSize.w, gameSize.h)


            local txt = "FOGGERS"
            love.graphics.setColor(HSV(0, 0, 0.25 + 0.25 * math.sin(GlobalSinAngle)))
            drawOutlinedText(txt, (gameSize.w / 2) + 8 + 8, 80 + 8, self.rot, self.scale, self.scale,
                love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, { 0, 0, 0 })
            love.graphics.setColor(HSV(0, 1, 0.85 + 0.25 * math.sin(GlobalSinAngle / 2)))
            drawOutlinedText(txt, (gameSize.w / 2) + 8, 80, self.rot, self.scale, self.scale,
                love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, { 0, 0, 0 })


            drawOutlinedText("DIE EDITION", gameSize.w / 2, 8 + (love.graphics.getFont():getHeight(txt) * self.scale),
                0.05 * math.sin(GlobalSinAngle), 2, 2, love.graphics.getFont():getWidth("DIE EDITION") / 2,
                love.graphics.getFont():getHeight("DIE EDITION") / 2, 2, { 0, 0, 0 })
        elseif self.theme == self.THEMES.THEME_SOFT then
            love.graphics.setColor(HSV(0.95, 0.25, 1))
            love.graphics.rectangle("fill", 0, 0, gameSize.w, gameSize.h)


            local txt = "FOGGERS"
            love.graphics.setColor(HSV(0.985, 0.5, 1))
            drawOutlinedText(txt, (gameSize.w / 2) + 8 + 8, 80 + 8, self.rot, self.scale, self.scale,
                love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4,
                HSV(0.925, 1, 0.4))
            love.graphics.setColor(HSV(0.95, 0, 1))
            drawOutlinedText(txt, (gameSize.w / 2) + 8, 80, self.rot, self.scale, self.scale,
                love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4,
                HSV(0.9, 0.85, 0.6))


            drawOutlinedText("CALM EDITION", gameSize.w / 2, 8 + (love.graphics.getFont():getHeight(txt) * self.scale),
                0.05 * math.sin(GlobalSinAngle), 2, 2, love.graphics.getFont():getWidth("CALM EDITION") / 2,
                love.graphics.getFont():getHeight("CALM EDITION") / 2, 2, { 0, 0, 0 })
        elseif self.theme == self.THEMES.THEME_BLOOD then
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("fill", 0, 0, gameSize.w, gameSize.h)


            local txt = "FOGGERS"
            love.graphics.setColor(0, 0, 0)
            drawOutlinedText(txt, (gameSize.w / 2) + 8 + 8, 80 + 8, self.rot, self.scale, self.scale,
                love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, { 1, 0, 0 })
            love.graphics.setColor(0, 0, 0)
            drawOutlinedText(txt, (gameSize.w / 2) + 8, 80, self.rot, self.scale, self.scale,
                love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, { 1, 0, 0 })


            drawOutlinedText("DARK EDITION", gameSize.w / 2, 8 + (love.graphics.getFont():getHeight(txt) * self.scale),
                0.05 * math.sin(GlobalSinAngle), 2, 2, love.graphics.getFont():getWidth("DARK EDITION") / 2,
                love.graphics.getFont():getHeight("DARK EDITION") / 2, 2, { 0, 0, 0 })
        elseif self.theme == self.THEMES.THEME_CAT then
            love.graphics.setColor(HSV(0.5 + 0.5 * math.cos(GlobalSinAngle), 1, 1))
            love.graphics.rectangle("fill", 0, 0, gameSize.w, gameSize.h)


            local txt = "FOGGERS"
            love.graphics.setColor(0, 0, 0)
            drawOutlinedText(txt, (gameSize.w / 2) + 8 + 8, 80 + 8, self.rot, self.scale, self.scale,
                love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, { 1, 0, 0 })
            love.graphics.setColor(1, 1, 1)
            drawOutlinedText(txt, (gameSize.w / 2) + 8, 80, self.rot, self.scale, self.scale,
                love.graphics.getFont():getWidth(txt) / 2, love.graphics.getFont():getHeight(txt) / 2, 4, { 1, 0, 0 })


            drawOutlinedText("CAT EDITION", gameSize.w / 2, 8 + (love.graphics.getFont():getHeight(txt) * self.scale),
                0.05 * math.sin(GlobalSinAngle), 2, 2, love.graphics.getFont():getWidth("DARK EDITION") / 2,
                love.graphics.getFont():getHeight("DARK EDITION") / 2, 2, { 0, 0, 0 })


            love.graphics.setColor(1, 1, 1)
            love.graphics.circle("fill", (gameSize.w / 2) - 164, gameSize.h / 2, 128, 8)
            love.graphics.circle("fill", (gameSize.w / 2) + 164, gameSize.h / 2, 128, 8)
            love.graphics.setColor(0, 0, 0)
            love.graphics.ellipse("fill", (gameSize.w / 2) - 164 + 32 * math.cos(GlobalSinAngle),
                (gameSize.h / 2) + 32 * math.sin(GlobalSinAngle), 32, 64, 8)
            love.graphics.ellipse("fill", (gameSize.w / 2) + 164 + 32 * math.cos(GlobalSinAngle),
                (gameSize.h / 2) + 32 * math.sin(GlobalSinAngle), 32, 64, 8)
            love.graphics.setColor(1, 1, 1)
            love.graphics.setLineWidth(8)
            love.graphics.line((gameSize.w / 2) - 164, (gameSize.h / 2) + 164, (gameSize.w / 2) - 148, (gameSize.h / 2) + 256, (gameSize.w / 2),
                (gameSize.h / 2) + 164, (gameSize.w / 2) + 128, (gameSize.h / 2) + 256, (gameSize.w / 2) + 148, (gameSize.h / 2) + 164)
            love.graphics.setLineWidth(1)
        end


        local optionsYRem = 0
        optionsHeight = 0
        local optionsY = ((gameSize.h / 2) + 64 + 40)
        heights = {}
        
        
        for o=1, #self.options[self.menuLevel] do
            local txtHeight = 0


            if gameStuff.lang == "pt-br" then
                txtHeight = getWAndHOfFText(self.optionsPT[self.menuLevel][o], gameSize.w / 8).h * (10)
            else
                txtHeight = getWAndHOfFText(self.optionsPT[self.menuLevel][o], gameSize.w / 8).h * (10)
            end

            
            optionsHeight = optionsHeight + txtHeight
        end


        while optionsHeight - optionsYRem > gameSize.h do
            optionsYRem = optionsYRem + 1
        end


        if not self.showRunConfig and not self.showCarsStats then
            for o = 1, #self.options[self.menuLevel] do
                local scale = 4
                local rotAdd = 0
                
                
                table.insert(heights, #heights + 1, optionsY - optionsYRem)
                    
                
                if o ~= self.pos then
                    local outlineColor = { 0, 0, 0 }
                    love.graphics.setColor({ 1, 1, 1 })


                    if self.theme == self.THEMES.THEME_SOFT then
                        outlineColor = HSV(0.925, 1, 0.4)
                    end
                    if self.theme == self.THEMES.THEME_BLOOD then
                        outlineColor = { 0.25, 0, 0 }
                        love.graphics.setColor({ 0, 0, 0 })
                    end

                    local txt = self.options[self.menuLevel][o]


                    if gameStuff.lang == "pt-br" then
                        txt = self.optionsPT[self.menuLevel][o]
                    end


                    drawOutlinedTextF(txt, (gameSize.w / 2), heights[o], gameSize.w / 8, "center", 0 + rotAdd, scale, scale, gameSize.w / 16, love.graphics.getFont():getHeight(txt) / 2, 4, outlineColor)


                    if gameStuff.lang == "pt-br" then
                        optionsY = optionsY + getWAndHOfFText(self.optionsPT[self.menuLevel][o], gameSize.w / 8).h * (scale)
                    else
                        optionsY = optionsY + getWAndHOfFText(self.options[self.menuLevel][o], gameSize.w / 8).h * (scale)
                    end
                else
                    if gameStuff.lang == "pt-br" then
                        optionsY = optionsY + getWAndHOfFText(self.optionsPT[self.menuLevel][o], gameSize.w / 8).h * (self.currentOptionScale)
                    else
                        optionsY = optionsY + getWAndHOfFText(self.options[self.menuLevel][o], gameSize.w / 8).h * (self.currentOptionScale)
                    end
                end
            end


            local outlineColor = { 0, 0, 0 }
            if self.theme == self.THEMES.THEME_NORMAL then
                love.graphics.setColor({ 0, 1, 0 })
            elseif self.theme == self.THEMES.THEME_HARD then
                love.graphics.setColor(HSV(0, 1, 0.85 + 0.25 * math.sin(GlobalSinAngle / 2)))
            elseif self.theme == self.THEMES.THEME_SOFT then
                love.graphics.setColor(HSV(0.95, 0, 1))
                outlineColor = HSV(0.9, 0.85, 0.6)
            elseif self.theme == self.THEMES.THEME_BLOOD then
                love.graphics.setColor({ 0, 0, 0 })
                outlineColor = { 1, 0, 0 }
            elseif self.theme == self.THEMES.THEME_CAT then
                love.graphics.setColor(HSV(0.5 + 0.5 * math.sin(GlobalSinAngle), 1, 1))
                outlineColor = { 0, 0, 0 }
            end
            rotAdd = 0.1 * math.sin(GlobalSinAngle)
            scale = self.currentOptionScale
            local currTxt = self.options[self.menuLevel][self.pos]


            if gameStuff.lang == "pt-br" then
                currTxt = self.optionsPT[self.menuLevel][self.pos]
            end
            drawOutlinedTextF(currTxt, (gameSize.w / 2), heights[self.pos], gameSize.w / 8, "center", 0 + rotAdd, scale, scale, gameSize.w / 16, love.graphics.getFont():getHeight(currTxt) / 2, 4, outlineColor)


            love.graphics.setColor({ 1, 1, 1 })
            local txt = "Version: " .. tostring(gameStuff.currentVersion)
            if gameStuff.lang == "pt-br" then txt = "Versão: " .. tostring(gameStuff.currentVersion) end
            drawOutlinedText(txt, 8, gameSize.h - 8, 0, 2, 2, 0, love.graphics.getFont():getHeight(txt), 2, { 0, 0, 0 })


            if debugStuff.enabled then
                drawOutlinedText(tostring(self.theme), 8, gameSize.h - 8 - 32, 0, 2, 2, 0,
                    love.graphics.getFont():getHeight(txt), 2, { 0, 0, 0 })
            end
        end


        drawAllCars()


        love.graphics.setColor(0, 0, 0, self.blackEnterAlpha)
        love.graphics.rectangle("fill", 0, 0, gameSize.w, gameSize.h)


        if self.showRunConfig then
            love.graphics.setColor(HSV(0, 0, 0.1 + 0.1 * math.cos(GlobalSinAngle)))
            drawOutlinedRect(32, 32 + self.runConfigStuff.boxYOffset, gameSize.w - 64, gameSize.h - 64, { 0, 0, 0 })
            love.graphics.setColor(1, 1, 1)


            local text1 = "Starting round: "
            local text2 = "Seed: "


            if gameStuff.lang == "pt-br" then
                text1 = "Round Inicial: "
            end


            drawOutlinedText(text1, (gameSize.w / 2) - (love.graphics.getFont():getWidth(text1) * 2),
                68 + self.runConfigStuff.boxYOffset, 0, 2, 2, love.graphics.getFont():getWidth(text1) / 2,
                love.graphics.getFont():getHeight(text1) / 2, 4, { 0, 0, 0 })
            drawOutlinedText(text2, (gameSize.w / 2) - (love.graphics.getFont():getWidth(text2) * 3.85),
                128 + 8 + self.runConfigStuff.boxYOffset, 0, 2, 2, love.graphics.getFont():getWidth(text2) / 2,
                love.graphics.getFont():getHeight(text2) / 2, 4, { 0, 0, 0 })
        end


        if self.showCarsStats then
            if self.carsStats.statsInstance ~= nil then
                self.carsStats.statsInstance:draw()
            end
        end


        if self.fpsSetter ~= nil then
            self.fpsSetter:draw()
        end
    end

    m:init()


    return m
end

function createFpsSetter()
    local f = {
        fpsBox = createNumberInsertButton(gameSize.w / 2, gameSize.h / 2, 256, 128, "Target FPS", "", true, true),
        acceptButton = createButton(gameSize.w / 2, (gameSize.h / 2) + 128, 128, 64, "OK", "", true),
        wantedFps = 0,
        died = false,
    }
    if gameStuff.lang == "pt-br" then f.fpsBox.text = "FPS Desejado" end


    function f:update()
        if self.acceptButton.pressed then
            self.died = true
            self.wantedFps = tonumber(self.fpsBox.textedText)
            deleteUIInstance(self.fpsBox)
            deleteUIInstance(self.acceptButton)
            self.acceptButton.pressed = false
        end
    end

    function f:draw()
        love.graphics.setColor(0, 0, 0)
        drawOutlinedRect((gameSize.w / 2) - 256, (gameSize.h / 2) - 256, 512, 512, { 1, 1, 1 })
        love.graphics.setColor(1, 1, 1)
        local text1 = "FPS Setter"
        local text2 = "0 Will Make your FPS Be Unlimited"
        if gameStuff.lang == "pt-br" then text1 = "Definidor de FPS"; text2 = "0 Vai fazer o seu fps ser ilimitado" end
        drawOutlinedText(text1, gameSize.w / 2, 128, 0.09 * math.cos(GlobalSinAngle), 4, 4, nil, nil, 4, { 0, 0, 0, 1 })
        drawOutlinedText(text2, gameSize.w / 2, (gameSize.h / 2) + 64 + 16, 0.09 * math.sin(GlobalSinAngle), 2, 2, nil, nil, 4, { 0, 0, 0, 1 })
    end

    return f
end
