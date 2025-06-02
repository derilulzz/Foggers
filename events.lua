function createCitizen()
    local c = {
        pos = { x = -128, y = math.random((600 / 2) - 128, (600 / 2) + 128) },
        spr = newAnimation(love.graphics.newImage("Sprs/Events/Citizen/CitizenWalk.png"), 32, 32, 3, 0, 5),
        mspd = 50,
    }


    function c:update()
        --Do stuff when he reaches the right bottom of the scene
        if self.pos.x >= 800 * 1.5 then
            local givenMoney = 500 * (gameStuff.currentFoggGaved + 1)
            createMoneyGainEffect(givenMoney, self.pos.x - 64, self.pos.y)
            money = money + givenMoney
            table.remove(gameInstances, tableFind(gameInstances, self))


            local willReciveve = math.random(0, 1)


            if willReciveve == 0 then
                local itemGaved = math.random(1, #bagItemsIndexed)
                recieveBagItem(bagItemsIndexed[itemGaved])
            end
        end


        --Die handling
        for f = 1, #Foggs do
            if Foggs[f] ~= nil then
                if Lume.distance(self.pos.x, self.pos.y, Foggs[f].pos.x, Foggs[f].pos.y) <= 32 then
                    createWarningText("citizen died")
                    table.remove(gameInstances, tableFind(gameInstances, self))
                end
            end
        end


        self.pos.x = self.pos.x + (self.mspd * gameStuff.speed) * globalDt
        self.spr:update(globalDt * gameStuff.speed)
    end

    function c:draw()
        drawShadow(self.pos.x, self.pos.y + 32, 4, 4, 0)
        love.graphics.setColor(1, 1, 1, 1)
        self.spr:draw(self.rot, self.pos.x, self.pos.y, 2, 2, nil, nil, 2, { 0, 0, 0 })
    end

    table.insert(gameInstances, 1, c)
end

function createBombMan()
    local c = {
        pos = { x = -128, y = math.random((600 / 2) - 128, (600 / 2) + 128) },
        vel = { x = 0, y = 0 },
        spd = 1000,
        spr = newAnimation(love.graphics.newImage("Sprs/Events/SuicideBomber/SuicideBomberWalk.png"), 32, 32, 3, 0, 5),
        mspd = 50,
        scaleX = 1,
    }


    function c:update()
        local targetCar = 1
        if GameCarInstances[targetCar] ~= nil then
            local angleTo = Lume.angle(self.pos.x, self.pos.y, GameCarInstances[targetCar].pos.x,
                GameCarInstances[targetCar].pos.y)


            self.vel.x = Lume.lerp(self.vel.x, self.spd * math.cos(angleTo), 0.1)
            self.vel.y = Lume.lerp(self.vel.y, self.spd * math.sin(angleTo), 0.1)


            if Lume.distance(self.pos.x, self.pos.y, GameCarInstances[targetCar].pos.x, GameCarInstances[targetCar].pos.y) <= 32 then
                createExplosion(self.pos.x, self.pos.y, GameCars[2])
                GameCarInstances[targetCar].hp = 0
                table.remove(gameInstances, tableFind(gameInstances, self))
            end
        end
        for f = 1, #Foggs do
            if Lume.distance(self.pos.x, self.pos.y, Foggs[f].pos.x, Foggs[f].pos.y) <= 32 then
                createExplosion(self.pos.x, self.pos.y, GameCars[2])
                Foggs[f]:die()
                table.remove(gameInstances, tableFind(gameInstances, self))
            end
        end
        if Lume.distance(self.pos.x, self.pos.y, PushsInGameMousePos.x, PushsInGameMousePos.y) <= 32 then
            createExplosion(self.pos.x, self.pos.y, GameCars[2])
            table.remove(gameInstances, tableFind(gameInstances, self))
        end


        if self.vel.x < 0 then
            self.scaleX = -1
        else
            self.scaleX = 1
        end


        self.pos.x = self.pos.x + (self.vel.x * gameStuff.speed) * globalDt
        self.pos.y = self.pos.y + (self.vel.y * gameStuff.speed) * globalDt
        self.spr:update(globalDt * gameStuff.speed)
    end

    function c:draw()
        drawShadow(self.pos.x, self.pos.y + 32, 4, 4, 0)
        love.graphics.setColor(1, 1, 1, 1)
        self.spr:draw(self.rot, self.pos.x, self.pos.y, 2 * self.scaleX, 2, nil, nil, 2, { 0, 0, 0 })
    end

    table.insert(gameInstances, 1, c)
end

function createPlatformerChallenge()
    local p = {
        player = {
            pos = {
                x = 64,
                y = 0,
            },
            vel = {
                x = 0,
                y = 0,
            },
            mspd = 500,
            rect = createRectangle(0, 0, 32, 32),
            idleSpr = newAnimation(love.graphics.newImage("Sprs/Events/Platformer/PlayerIdle.png"), 32, 32, 1, 0, 1, 0),
            walkSprs = newAnimation(love.graphics.newImage("Sprs/Events/Platformer/PlayerWalk.png"), 32, 32, 5, 0, 10, 0),
            jumpSprs = newAnimation(love.graphics.newImage("Sprs/Events/Platformer/PlayerJump.png"), 32, 32, 1, 0, 4, 0),
            fallSprs = newAnimation(love.graphics.newImage("Sprs/Events/Platformer/PlayerFall.png"), 32, 32, 1, 0, 4, 0),
            spr = nil,
            rot = 0,
            scale = { x = 4, y = 4 },
            isMoving = false,
            velKeepTimer = 0,
            enableInputBuffer = false,
            inputBufferTimer = 0,
            coyoteTimeEnable = false,
            coyoteTimeTimer = 0,
        },
        cols = {
            {
                createRectangle(64, 600 - 256, 32, 600),
                createRectangle(64 + 32, 600 - 256, 32, 600),
                createRectangle(64 + 32 + 32, 600 - 256, 32, 600),
                createRectangle(64 + 32 + 32 + 32, 600 - 256, 32, 600),


                createRectangle(250 + 32, 600 - 300, 32, 600),
                createRectangle(250 + 32 + 32, 600 - 300, 32, 600),
                createRectangle(250 + 32 + 32 + 32, 600 - 300, 32, 600),
                createRectangle(250 + 32 + 32 + 32 + 32, 600 - 300, 32, 600),
                createRectangle(250 + 32 + 32 + 32 + 32 + 32, 600 - 300, 32, 600),


                createRectangle(512 + 32, 600 - 400, 32, 600),
                createRectangle(512 + 32 + 32, 600 - 400, 32, 600),
                createRectangle(512 + 32 + 32 + 32, 600 - 400, 32, 600),
                createRectangle(512 + 32 + 32 + 32 + 32, 600 - 400, 32, 600),
                createRectangle(512 + 32 + 32 + 32 + 32 + 32, 600 - 400, 32, 600),
            },
            {
                createRectangle(64 + 32, 600 - 300, 32, 600),
                createRectangle(64 + 32 + 32, 600 - 300, 32, 600),
                createRectangle(64 + 32 + 32 + 32, 600 - 300, 32, 600),
                createRectangle(64 + 32 + 32 + 32 + 32, 600 - 300, 32, 600),
                createRectangle(64 + 32 + 32 + 32 + 32 + 32, 600 - 300, 32, 600),


                createRectangle(250 + 32, 600 - 256, 32, 600),
                createRectangle(250 + 32, 600 - 256, 32, 600),
                createRectangle(250 + 32 + 32, 600 - 256, 32, 600),
                createRectangle(250 + 32 + 32 + 32, 600 - 256, 32, 600),


                createRectangle(512 + 32, 600 - 400, 32, 600),
                createRectangle(512 + 32 + 32, 600 - 400, 32, 600),
                createRectangle(512 + 32 + 32 + 32, 600 - 400, 32, 600),
                createRectangle(512 + 32 + 32 + 32 + 32, 600 - 400, 32, 600),
                createRectangle(512 + 32 + 32 + 32 + 32 + 32, 600 - 400, 32, 600),
            },
        },
        selectedCol = 1,
        targetFlag = {
            pos = {
                x = 512 + 32 + 64,
                y = 600 - 400,
            },
            spr = love.graphics.newImage("Sprs/Events/Platformer/Flag.png"),
            scale = 3,
            rot = 0,
        },
        tiles = newAnimation(love.graphics.newImage("Sprs/Events/Platformer/Tiles.png"), 16, 16, 1, 1, 0, 0),
        isOnFloor = false,
        oldIsOnFloor = false,
        grav = 2000,
        screenSpr = love.graphics.newImage("Sprs/Events/Platformer/Screen.png"),
        oldJumpKeyPressed = false,
        enterOffsetY = -600,
        happyPeople = {
            newAnimation(love.graphics.newImage("Sprs/Events/Platformer/HappyGuy1.png"), 32, 32, 1, 0, 4, 0),
            newAnimation(love.graphics.newImage("Sprs/Events/Platformer/HappyGuy2.png"), 32, 32, 1, 0, 4, 0),
            newAnimation(love.graphics.newImage("Sprs/Events/Platformer/HappyGuy3.png"), 32, 32, 1, 0, 4, 0),
        },
        drawHappyPeople = false,
        peopleToShow = {},
        peopleWave = 0,
        angle = 0,
        peopleOffsetY = 512,
        failed = false,
        completeTimer = 2,
        canDecreaseTimer = false,
        alpha = 1,
    }


    function p:init()
        Flux.to(self, 1, { enterOffsetY = 0 }):ease("expoout")
        self.tiles.spriteSheet:setWrap("repeat", "repeat")


        local x = 0
        while x < 800 do
            table.insert(self.peopleToShow, #self.peopleToShow + 1, math.random(1, #self.happyPeople))
            x = x + (800 / 8)
        end


        self.selectedCol = math.random(1, #self.cols)
        self.player.pos.x = self.cols[self.selectedCol][1].x + 16
    end

    function p:update()
        self.player.rect = createRectangle(self.player.pos.x - 32, self.player.pos.y - 32 * 4, 32 * 2, 32 * 4)


        local inputDirX = 0
        if love.keyboard.isDown("a") then inputDirX = inputDirX - 1 end; if love.keyboard.isDown("d") then
            inputDirX =
                inputDirX + 1
        end
        if self.player.isOnFloor then
            self.player.vel.x = Lume.lerp(self.player.vel.x, self.player.mspd * inputDirX, 12)
        else
            self.player.vel.x = Lume.lerp(self.player.vel.x, self.player.mspd * inputDirX, 0.6)
        end
        self.player.isMoving = self.player.vel.x < -5 or self.player.vel.x > 5


        if self.player.isMoving then
            self.canDecreaseTimer = true
            self.player.rot = Lume.lerp(self.player.rot, 0.05 * math.cos(self.angle / 2), 6)
        else
            self.player.rot = Lume.lerp(self.player.rot, 0.1 * math.cos(self.angle / 2), 6)
        end


        local isOnFloor = false
        for c = 1, #self.cols[self.selectedCol] do
            if self.player.rect:checkCollisionAdv(self.cols[self.selectedCol][c], self.player.vel.x * globalDt, -1) then
                self.player.vel.x = 0
            end


            if self.player.rect:checkCollisionAdv(self.cols[self.selectedCol][c], 0, self.player.vel.y * globalDt) then
                self.player.vel.y = Lume.sign(self.player.vel.y)


                while not self.player.rect:checkCollisionAdv(self.cols[self.selectedCol][c], 0, 0) do
                    if self.player.vel.y == 0 then self.player.vel.y = 1 end


                    self.player.pos.y = self.player.pos.y + 0.25 * self.player.vel.y
                    self.player.rect = createRectangle(self.player.pos.x - 32, self.player.pos.y - 32 * 4, 32 * 2, 32 * 4)
                end


                self.player.vel.y = 0
                isOnFloor = true
            end
        end
        if isOnFloor then
            if love.keyboard.isDown("space") and self.oldJumpKeyPressed == false then
                self.player.vel.y = -700
                self.player.velKeepTimer = 0.1
                self.player.scale.y = self.player.scale.y + 1
            end
        else
            self.player.vel.y = self.player.vel.y + self.grav * globalDt
            self.player.scale.y = self.player.scale.y - ((self.player.vel.y) * globalDt) / 32


            if love.keyboard.isDown("space") and self.oldJumpKeyPressed == false then
                if self.player.vel.y > 0 then
                    self.player.enableInputBuffer = true
                    self.player.inputBufferTimer = 0.1
                end
            end
            if self.oldIsOnFloor then
                if self.player.vel.y > 0 then
                    self.player.coyoteTimeEnable = true
                    self.player.coyoteTimeTimer = 0.1
                end
            end


            if not love.keyboard.isDown("space") and self.player.vel.y < 0 then self.player.vel.y = self.player.vel.y / 4 end
        end


        if self.player.enableInputBuffer then
            if self.player.inputBufferTimer > 0 then
                if isOnFloor then
                    self.player.vel.y = -700
                    self.player.velKeepTimer = 0.1
                    self.player.scale.y = self.player.scale.y + 1
                    self.player.enableInputBuffer = false
                end
            else
                self.player.enableInputBuffer = false
            end


            self.player.inputBufferTimer = self.player.inputBufferTimer - 1 * globalDt
        end
        if self.player.coyoteTimeEnable then
            if self.player.coyoteTimeTimer <= 0 then
                self.player.coyoteTimeEnable = false
            else
                if love.keyboard.isDown("space") and self.oldJumpKeyPressed == false then
                    self.player.vel.y = -700
                    self.player.velKeepTimer = 0.1
                    self.player.scale.y = self.player.scale.y + 1
                    self.player.coyoteTimeEnable = false
                end
            end


            self.player.coyoteTimeTimer = self.player.coyoteTimeTimer - 1 * globalDt
        end


        if Lume.distance(self.player.pos.x, self.player.pos.y, self.targetFlag.pos.x, self.targetFlag.pos.y) <= 32 and not self.failed then
            self:pass()
        end


        if self.player.velKeepTimer > 0 then
            self.player.vel.y = -700
            self.player.velKeepTimer = self.player.velKeepTimer - 1 * globalDt
        end


        self.player.scale.y = Lume.lerp(self.player.scale.y, 4 + 0.25 * math.sin(self.angle), 6)
        if self.player.vel.x < 0 then
            self.player.scale.x = Lume.lerp(self.player.scale.x, -4, 6)
        else
            self.player.scale.x = Lume.lerp(self.player.scale.x, 4, 6)
        end
        if isOnFloor then
            if self.player.isMoving then
                self.player.spr = self.player.walkSprs
            else
                self.player.spr = self.player.idleSpr
            end
        else
            if self.player.vel.y < 0 then
                self.player.spr = self.player.jumpSprs
            else
                self.player.spr = self.player.fallSprs
            end
        end
        self.player.isOnFloor = isOnFloor


        if self.player.pos.y - 64 > 600 - 64 or self.completeTimer <= 0 then
            self:fail()
        end


        if self.drawHappyPeople then
            for b = 1, #self.happyPeople do
                self.happyPeople[b]:update(globalDt)
            end
        end


        self.player.pos.x = self.player.pos.x + self.player.vel.x * globalDt
        self.player.pos.y = self.player.pos.y + self.player.vel.y * globalDt
        self.oldJumpKeyPressed = love.keyboard.isDown("space")
        if isAnimation(self.player.spr) then
            self.player.spr:update(globalDt)
        end
        self.oldIsOnFloor = isOnFloor
        self.peopleWave = self.peopleWave + 10 * globalDt
        if self.canDecreaseTimer then
            self.completeTimer = self.completeTimer - 1 * globalDt
        end
        self.angle = self.angle + 16 * globalDt
    end

    function p:pass()
        if not self.drawHappyPeople then
            self.drawHappyPeople = true
            Flux.to(self, 1, { peopleOffsetY = 0 }):ease("expoout")
            createEventSuccess(currentEvent)


            Flux.to(self, 1, { enterOffsetY = 600 }):ease("expoout"):oncomplete(p.proceed):delay(2)
        end
    end

    function p:proceed()
        money = money + 1000
        p.die()
    end

    function p:fail()
        if not self.failed and not self.drawHappyPeople then
            self.failed = true
            createEventFail(currentEvent)
            Flux.to(self, 1, { enterOffsetY = 600 }):ease("expoin"):oncomplete(self.die)
        end
    end

    function p:die()
        gameStuff.pauseFroggCreation = false
        gameStuff.eventPause = false


        table.remove(onTopGameInstaces, tableFind(onTopGameInstaces, p))
    end

    function p:draw()
        love.graphics.setScissor(32, 32 + self.enterOffsetY, 800 - 64, 600 - 64)


        love.graphics.setColor(HSV(0.5, 1, 1, self.alpha))
        love.graphics.rectangle("fill", 32, 32 + self.enterOffsetY, 800 - 64, 600 - 64)


        love.graphics.setColor(1, 1, 1, self.alpha)
        if isAnimation(self.player.spr) then
            self.player.spr:draw(self.player.rot, self.player.pos.x, self.player.pos.y + self.enterOffsetY,
                self.player.scale.x, self.player.scale.y, nil, self.player.spr.sprHeight, 2, { 0, 0, 0, self.alpha })
        else
            drawOutlinedSprite(self.player.spr, self.player.pos.x, self.player.pos.y + self.enterOffsetY, self.player
                .rot, self.player.scale.x, self.player.scale.y, nil, self.player.spr:getHeight(), 2,
                { 0, 0, 0, self.alpha })
        end


        for c = 1, #self.cols[self.selectedCol] do
            self.tiles:drawFrame(3, 0, self.cols[self.selectedCol][c].x,
                self.cols[self.selectedCol][c].y + self.enterOffsetY, 2, 2, 0, 0, nil)


            for b = 1, 1 do
                self.tiles:drawFrame(2, 0, self.cols[self.selectedCol][c].x,
                    self.cols[self.selectedCol][c].y + (32 * b) + self.enterOffsetY, 2, 2, 0, 0, nil)
            end
            for b = 1, 16 do
                self.tiles:drawFrame(1, 0, self.cols[self.selectedCol][c].x,
                    self.cols[self.selectedCol][c].y + 32 + (32 * b) + self.enterOffsetY, 2, 2, 0, 0, nil)
            end
        end


        drawOutlinedText(string.format("%.1f", Lume.clamp(self.completeTimer, 0, 10)), 800 / 2, 64 + self.enterOffsetY,
            0.1 * math.cos(GlobalSinAngle), 2 + 0.5 * math.cos(GlobalSinAngle * 2),
            2 + 0.5 * math.cos(GlobalSinAngle * 2), nil, nil, 2, { 0, 0, 0 })


        love.graphics.draw(self.targetFlag.spr, self.targetFlag.pos.x, self.targetFlag.pos.y + self.enterOffsetY,
            self.targetFlag.rot, self.targetFlag.scale, self.targetFlag.scale, self.targetFlag.spr:getWidth() / 2,
            self.targetFlag.spr:getHeight())


        love.graphics.setScissor()


        love.graphics.draw(self.screenSpr, 0, 0 + self.enterOffsetY, 0, 4, 4, 0, 0)


        if self.drawHappyPeople then
            for p = 1, #self.peopleToShow do
                self.happyPeople[self.peopleToShow[p]]:draw(0, 0 + 64 + ((800 / 8) * (p - 1)),
                    600 + 32 + self.peopleOffsetY + self.enterOffsetY + 32 * math.sin(self.peopleWave - p), 8, 8, nil,
                    self.happyPeople[self.peopleToShow[p]].sprHeight, nil)
            end
        end
    end

    p:init()
    table.insert(onTopGameInstaces, 1, p)
end

function createPillChoose()
    local p = {
        guySpr = love.graphics.newImage("Sprs/Events/Pills/Guy.png"),
        handSpr = love.graphics.newImage("Sprs/Events/Pills/MegaHand.png"),
        greenPillSpr = love.graphics.newImage("Sprs/Events/Pills/GreenPill.png"),
        pinkPillSpr = love.graphics.newImage("Sprs/Events/Pills/PinkPill.png"),
        vigneteSpr = love.graphics.newImage("Sprs/Other/Vignnete.png"),
        vigneteScale = 800,
        enterOffsetY = -600,
        backgroundAlpha = 0,
        pill1Alpha = 1,
        pill2Alpha = 1,
        selectedPillScale = 1,
        notSelectedPillScale = 1,
        currentSelectedPill = 1,
        choises = {
            "Permanent x2 Money Gain",
            "Permanent x2 Frog Amount",
            "Permanent x2 Car Amount, 0.25% Less Car Damage",
            "Permanent x2 Car Speed",
            "Permanent x2 Car Damage",
        },
        pillSelected = false,
        currentChoices = { 1, 1 },
    }


    function p:init()
        Flux.to(self, 1, { enterOffsetY = 0, backgroundAlpha = 0.85 }):ease("expoout")
        self.currentChoices[1] = math.random(1, #self.choises)
        self.currentChoices[2] = math.random(1, #self.choises)


        while self.currentChoices[2] == self.currentChoices[1] do
            self.currentChoices[1] = math.random(1, #self.choises)
            self.currentChoices[2] = math.random(1, #self.choises)
        end
    end

    function p:update()
        if Lume.distance(PushsInGameMousePosNoTransform.x, PushsInGameMousePosNoTransform.y, (800 / 2) - 90, (600 / 2) + 116 + (16 * math.cos(GlobalSinAngle)) + self.enterOffsetY) < 128 then
            if self.currentSelectedPill == 1 and not self.pillSelected then
                self.notSelectedPillScale = self.selectedPillScale
                self.selectedPillScale = 1
                self.currentSelectedPill = 2
            end


            if self.pillSelected then
                self.selectedPillScale = self.selectedPillScale + 8 * globalDt


                if self.selectedPillScale >= 4 then
                    self.pill1Alpha = Lume.lerp(self.pill1Alpha, 0, 6)
                end
            else
                self.selectedPillScale = Lume.lerp(self.selectedPillScale, 2, 6)
            end


            if love.mouse.isDown(1) and LastLeftMouseButton == false then
                self.pillSelected = true
            end
        elseif Lume.distance(PushsInGameMousePosNoTransform.x, PushsInGameMousePosNoTransform.y, (800 / 2) + 90, (600 / 2) + 116 + (16 * math.sin(GlobalSinAngle)) + self.enterOffsetY) < 128 then
            if self.currentSelectedPill == 2 and not self.pillSelected then
                self.notSelectedPillScale = self.selectedPillScale
                self.selectedPillScale = 1
                self.currentSelectedPill = 1
            end


            if self.pillSelected then
                self.selectedPillScale = self.selectedPillScale + 2 * globalDt


                if self.selectedPillScale >= 4 then
                    self.pill2Alpha = Lume.lerp(self.pill2Alpha, 0, 6)
                end
            else
                self.selectedPillScale = Lume.lerp(self.selectedPillScale, 2, 6)
            end


            if love.mouse.isDown(1) and LastLeftMouseButton == false then
                self.pillSelected = true
            end
        else
            if not self.pillSelected then
                self.selectedPillScale = Lume.lerp(self.selectedPillScale, 1, 6)
            else
                if self.pillSelected then
                    self.selectedPillScale = self.selectedPillScale + 2 * globalDt
                else
                    self.selectedPillScale = Lume.lerp(self.selectedPillScale, 2, 6)
                end
            end
        end


        if self.pillSelected then
            self.selectedPillScale = self.selectedPillScale + 10 * globalDt
        end


        self.vigneteScale = Lume.lerp(self.vigneteScale, 8, 6)
        self.notSelectedPillScale = Lume.lerp(self.notSelectedPillScale, 1, 6)
    end

    function p:draw()
        love.graphics.setColor(0, 0, 0, self.backgroundAlpha)
        love.graphics.rectangle("fill", 0, 0, 800, 600)


        love.graphics.setScissor(32, 32 + self.enterOffsetY, 800 - 64, 600 - 64)


        love.graphics.setColor(HSV(0, 0, 0.25 + 0.1 * math.cos(GlobalSinAngle)))
        drawOutlinedRect(32, 32 + self.enterOffsetY, 800 - 64, 600 - 64, { 0, 0, 0 })


        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.vigneteSpr, 800 / 2, 600 / 2, 0, self.vigneteScale, self.vigneteScale,
            self.vigneteSpr:getWidth() / 2, self.vigneteSpr:getHeight() / 2)


        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.guySpr, 800 / 2, (600 / 2) + self.enterOffsetY, 0, 4.5,
            4.5 + 0.1 * math.cos(GlobalSinAngle), self.guySpr:getWidth() / 2, self.guySpr:getHeight() / 2)
        love.graphics.draw(self.handSpr, (800 / 2) + 90,
            (600 / 2) + 116 + (16 * math.sin(GlobalSinAngle)) + self.enterOffsetY, 0, 0.1, 0.1,
            self.handSpr:getWidth() / 2, self.handSpr:getHeight() / 2)
        love.graphics.draw(self.handSpr, (800 / 2) - 90,
            (600 / 2) + 116 + (16 * math.cos(GlobalSinAngle)) + self.enterOffsetY, 0, -0.1, 0.1,
            self.handSpr:getWidth() / 2, self.handSpr:getHeight() / 2)


        local p1Scale = 1
        local p2Scale = 1


        if self.currentSelectedPill == 1 then p1Scale = self.selectedPillScale else p1Scale = self.notSelectedPillScale end
        if self.currentSelectedPill == 2 then p2Scale = self.selectedPillScale else p2Scale = self.notSelectedPillScale end


        love.graphics.setColor(1, 1, 1, self.pill1Alpha)
        love.graphics.draw(self.pinkPillSpr, (800 / 2) + 90,
            (600 / 2) + 116 + (16 * math.sin(GlobalSinAngle)) + self.enterOffsetY, 0.25 * math.sin(GlobalSinAngle),
            p1Scale, p1Scale, self.pinkPillSpr:getWidth() / 2, self.pinkPillSpr:getHeight() / 2)
        love.graphics.setColor(1, 1, 1, self.pill2Alpha)
        love.graphics.draw(self.greenPillSpr, (800 / 2) - 90,
            (600 / 2) + 116 + (16 * math.cos(GlobalSinAngle)) + self.enterOffsetY, 0.25 * math.cos(GlobalSinAngle),
            p2Scale, p2Scale, self.pinkPillSpr:getWidth() / 2, self.pinkPillSpr:getHeight() / 2)


        if self.currentSelectedPill == 1 then
            drawOutlinedText(self.choises[self.currentChoices[1]], 800 / 2, 128, 0, 2 + (0.1 * math.random()),
                2 + (0.1 * math.random()), nil, nil)
        elseif self.currentSelectedPill == 2 then
            drawOutlinedText(self.choises[self.currentChoices[2]], 800 / 2, 128, 0, 2 + (0.1 * math.random()),
                2 + (0.1 * math.random()), nil, nil)
        end


        love.graphics.setScissor()
    end

    p:init()
    table.insert(onTopGameInstaces, #onTopGameInstaces + 1, p)
end

--TODO: finish the pill chose event. FINISHED LADIES AND GENTLEMEN
eventTypes = {
    { creationCode = createCitizen,             stopFrogg = false, gamePause = false, id = 0, name = "Citizen",              namePT = "Cidadão" },
    { creationCode = createBombMan,             stopFrogg = false, gamePause = false, id = 1, name = "Suicide Bomber",       namePT = "Homem Bomba" },
    { creationCode = createPlatformerChallenge, stopFrogg = true,  gamePause = true,  id = 2, name = "Platformer Challenge", namePT = "Desafio de plataforma" },
    --{ creationCode = createPillChoose,          stopFrogg = true,  gamePause = true,  id = 2, name = "Pills",                namePT = "Pilulas" },
}
currentEvent = 0


function startEvent()
    --[[eventTypes[4]]
    currentEvent = eventTypes[math.floor(math.random(1, #eventTypes))]
    currentEvent.creationCode()


    if currentEvent.stopFrogg then
        gameStuff.pauseFroggCreation = currentEvent.stopFrogg
    end
    if currentEvent.gamePause then
        gameStuff.eventPause = currentEvent.gamePause
    end


    createEventStartText(currentEvent)
end

function createEventStartText(whatEvent)
    local t = {
        text = "EVENT STARTED",
        forEvent = whatEvent,
        scale = 0,
        rot = 6,
        alpha = 0,
    }


    function t:init()
        if gameStuff.lang == "pt-br" then self.text = "EVENTO INICIADO" end


        Flux.to(self, 1, { scale = 5, rot = 0, alpha = 1 }):after(self, 1, { scale = 0, rot = -6, alpha = 0 }):delay(1)
            :oncomplete(t.destroy)
    end

    function t:destroy()
        table.remove(gameInstances, tableFind(gameInstances, t))
    end

    function t:draw()
        love.graphics.setColor(1, 1, 1, 1)


        drawOutlinedText(self.text, 800 / 2, 600 / 2, self.rot, self.scale, self.scale,
            love.graphics.getFont():getWidth(self.text) / 2, love.graphics.getFont():getHeight(self.text) / 2, 8,
            { 0, 0, 0 })


        local text = self.forEvent.name
        if gameStuff.lang == "pt-br" then text = self.forEvent.namePT end
        drawOutlinedText(text, 800 / 2, (600 / 2) + 128, 0, self.scale, self.scale,
            love.graphics.getFont():getWidth(text) / 2, love.graphics.getFont():getHeight(text) / 2, 8, { 0, 0, 0 })
    end

    t:init()


    table.insert(onTopGameInstaces, #onTopGameInstaces + 1, t)
end

function createEventFail(whatEvent)
    local t = {
        text = "EVENT FAILED",
        forEvent = whatEvent,
        scale = 0,
        rot = 6,
        alpha = 0,
    }


    function t:init()
        if gameStuff.lang == "pt-br" then self.text = "EVENTO FALHO" end


        Flux.to(self, 1, { scale = 5, rot = 0, alpha = 1 }):after(self, 1, { scale = 0, rot = -6, alpha = 0 }):delay(1)
            :oncomplete(t.destroy)
    end

    function t:destroy()
        table.remove(gameInstances, tableFind(gameInstances, t))
    end

    function t:draw()
        love.graphics.setColor(1, 0, 0, 1)


        drawOutlinedText(self.text, 800 / 2, 600 / 2, self.rot, self.scale, self.scale,
            love.graphics.getFont():getWidth(self.text) / 2, love.graphics.getFont():getHeight(self.text) / 2, 8,
            { 0, 0, 0 })


        local text = self.forEvent.name
        if gameStuff.lang == "pt-br" then text = self.forEvent.namePT end
        drawOutlinedText(text, 800 / 2, (600 / 2) + 128, 0, self.scale, self.scale,
            love.graphics.getFont():getWidth(text) / 2, love.graphics.getFont():getHeight(text) / 2, 8, { 0, 0, 0 })
    end

    t:init()


    table.insert(onTopGameInstaces, #onTopGameInstaces + 1, t)
end

function createEventSuccess(whatEvent)
    local t = {
        text = "EVENT COMPLETED",
        forEvent = whatEvent,
        scale = 0,
        rot = 6,
        alpha = 0,
    }


    function t:init()
        if gameStuff.lang == "pt-br" then self.text = "EVENTO COMPLETADO" end


        Flux.to(self, 1, { scale = 5, rot = 0, alpha = 1 }):after(self, 1, { scale = 0, rot = -6, alpha = 0 }):delay(1)
            :oncomplete(t.destroy)
    end

    function t:destroy()
        table.remove(gameInstances, tableFind(gameInstances, t))
    end

    function t:draw()
        love.graphics.setColor(HSV(0.5, 1, 1))


        drawOutlinedText(self.text, 800 / 2, 600 / 2, self.rot, self.scale, self.scale,
            love.graphics.getFont():getWidth(self.text) / 2, love.graphics.getFont():getHeight(self.text) / 2, 8,
            { 0, 0, 0 })


        local text = self.forEvent.name
        if gameStuff.lang == "pt-br" then text = self.forEvent.namePT end
        drawOutlinedText(text, 800 / 2, (600 / 2) + 128, 0, self.scale, self.scale,
            love.graphics.getFont():getWidth(text) / 2, love.graphics.getFont():getHeight(text) / 2, 8, { 0, 0, 0 })
    end

    t:init()


    table.insert(onTopGameInstaces, #onTopGameInstaces + 1, t)
end
