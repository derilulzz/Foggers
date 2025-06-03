carsCategorys = {
    Common = 0,
    Military = 1,
    Special = 2,
    Explosive = 3,
    MoneyGenerator = 4,
}


function createCar(_name, _namePT, desc, descPT, _spr, _carAddSprs, _scl, _speed, _damage, _waveForce, _hp, _cost,
                   _impactDiv, _explosiveMult, _explosionArea, especialPropertys, category)
    _damage = _damage or 1
    _waveForce = _waveForce or 1
    _hp = _hp or 1
    _cost = _cost or 100
    _impactDiv = _impactDiv or 1
    _explosiveMult = _explosiveMult or 1
    _carAddSprs = _carAddSprs or {}
    _explosionArea = _explosionArea or 128
    especialPropertys = especialPropertys or {}
    _speed = _speed or 500
    _scl = _scl or 1
    category = category or carsCategorys.Common


    local c = {
        name = _name,
        namePT = _namePT,
        desc = desc,
        descPT = descPT,
        spr = _spr,
        carAddSprs = _carAddSprs,
        scale = _scl,
        spd = _speed,
        damage = _damage,
        waveForce = _waveForce,
        hp = _hp,
        cost = _cost,
        impactDiv = _impactDiv,
        explosionMult = _explosiveMult,
        explosionArea = _explosionArea,
        especialPropertys = especialPropertys,
        category = category,
    }


    return c
end

function createCarInstance(_inheritFrom, _x, _y, _ghostCar, _example)
    _example = _example or false
    if _inheritFrom == nil then return end


    local c = {
        pos = { x = _x, y = _y },
        vel = { x = 0, y = 0 },
        fromCar = _inheritFrom,
        isExampleCar = _example,
        sclYAdd = 0,
        rot = 0,
        driveParticle = love.graphics.newParticleSystem(love.graphics.newImage("Sprs/Particles/WhiteBall.png"), 100),
        col = createRectangle(_x, _y, 20, 20),
        angle = 0,
        hp = _inheritFrom.hp,
        spdAdd = math.random(-50, 50),
        drifiting = false,
        trailPoses = {},
        tankTopSpr = nil,
        hpAddCar = 0,
        hpDivCar = 1,
        hpMultCar = 1,
        spdAddCar = 0,
        spdDivCar = 1,
        spdMultCar = 1,
        isGhostCar = _ghostCar,
        scaleAdd = 0,
        startSfx = love.audio.newSource("Sfxs/CarOn.mp3", "static"),
        walkSfx = love.audio.newSource("Sfxs/CarWalking.mp3", "static"),
        ghostDisappearTimer = 1,
        additionalBehaviorFuncs = {},
        alpha = 0,
        zIndex = 0,
    }


    function c:init()
        if self.isExampleCar then return end


        self.driveParticle:setSizes(2, 0)
        self.driveParticle:setLinearAcceleration(10, -500, 100, -200)
        self.driveParticle:setParticleLifetime(0.5, 1)
        self.driveParticle:setSpeed(0.85, 1)
        self.driveParticle:setEmissionRate(10)
        self.driveParticle:setColors({ 1, 1, 1, 1 }, { 1, 1, 1, 0 })
        self.driveParticle:start()
        Flux.to(self, 1, { alpha = 1 }):ease("expoout")
        self.startSfx:setVolume(gameStuff.sfxVolume)
        self.startSfx:play()
        self.walkSfx:setLooping(true)
        if gameStuff.speed > 0 then
            self.walkSfx:play()
        end


        if self.fromCar.especialPropertys.shoots then
            table.insert(self.additionalBehaviorFuncs, 1, shootUpdateFunc)
        end
        if self.fromCar.especialPropertys.cats then
            table.insert(self.additionalBehaviorFuncs, 1, catCarUpdate)
        end
        if self.fromCar.especialPropertys.seller then
            table.insert(self.additionalBehaviorFuncs, 1, sellerCarUpdate)
            self.fromCar.especialPropertys.froggsKilled = 0
            self.fromCar.especialPropertys.recieveCooldown = self.fromCar.especialPropertys.recieveCooldownDef
        end
        if self.fromCar.especialPropertys.isTank then
            self.tankTopSpr = love.graphics.newImage("Sprs/Cars/TankTop.png")
        end
        if self.isGhostCar then table.insert(self.additionalBehaviorFuncs, 1, ghostCarUpdate) end
    end

    function c:update()
        if self.isExampleCar then return end


        self.vel.x = Lume.lerp(self.vel.x, ((((-self.fromCar.spd + self.spdAdd) + self.spdAddCar) * self.spdMultCar) / self.spdDivCar) * permaUpgrades.carSpeed, 6)
        self.vel.y = Lume.lerp(self.vel.y, 0, 6)


        self.driveParticle:setSpeed(gameStuff.speed - 0.1, gameStuff.speed)


        if self.startSfx ~= nil then
            if not self.startSfx:isPlaying() then
                self.startSfx:release()
                self.startSfx = nil
            end
        end


        self.drifiting = self.vel.y < -10 or self.vel.y > 10
        if self.drifiting then
            if #self.trailPoses > 0 then
                if Lume.distance(self.pos.x, self.pos.y, self.trailPoses[#self.trailPoses].x, self.trailPoses[#self.trailPoses].y) > 0 then
                    table.insert(self.trailPoses, 1, { x = self.pos.x, y = self.pos.y, timer = 5 })
                end
            else
                table.insert(self.trailPoses, 1, { x = self.pos.x, y = self.pos.y, timer = 5 })
            end
        end
        for t = 1, #self.trailPoses do
            if self.trailPoses[t].timer <= 0 then
                table.remove(self.trailPoses, t)
                break
            end


            self.trailPoses[t].timer = self.trailPoses[t].timer - 1 * globalDt
        end


        if gameStuff.speed > 0 then
            if self.walkSfx:isPlaying() == false then
                self.walkSfx:play()
            end
            self.walkSfx:setPitch(Lume.clamp(gameStuff.speed + 0.2 * math.cos(GlobalSinAngle * 2), 0.1, 99999))
            if self.startSfx ~= nil then
                self.startSfx:setPitch(Lume.clamp(gameStuff.speed + 0.2 * math.cos(GlobalSinAngle * 2), 0.1, 99999))
            end
        end


        if self.pos.x < -128 then
            self.pos.x = (800 * 1.5) + 128
        end
        if self.pos.x > (800 * 1.5) + 128 then
            self.pos.x = -128
        end
        if self.pos.y < -64 then
            self.pos.y = gameCam.pos.y + 600 + 64
        end
        if self.pos.y > gameCam.pos.y + 600 + 64 then
            self.pos.y = -64
        end



        if self.pos.y < (upBoxStuff.y + upBoxStuff.h) - 128 then
            self.vel.y = Lume.lerp(self.vel.y, 100, 12)
        end
        if self.pos.y > 600 + 128 then
            self.vel.y = Lume.lerp(self.vel.y, -100, 12)
        end


        self.col.x = self.pos.x
        self.col.y = self.pos.y
        self.col.w = self.fromCar.spr.sprWidth * (self.fromCar.scale + self.scaleAdd)
        self.col.h = self.fromCar.spr.sprHeight * (self.fromCar.scale + self.scaleAdd)


        for f = 1, #Foggs do
            if self.col:checkCollision(Foggs[f].col) then
                Foggs[f]:recieveDamage(self.fromCar.damage, self.pos.x, self.pos.y)


                self.hp = self.hp - 1
                if self.fromCar.especialPropertys.explosive then
                    createExplosion(self.pos.x, self.pos.y, self)
                    table.remove(GameCarInstances, tableFind(GameCarInstances, self))
                end


                if self.hp > 0 then
                    if Foggs[f] ~= nil then
                        createCarImpact(Foggs[f].pos.x, Foggs[f].pos.y)
                    end
                end


                return
            end
        end


        self.pos.x = self.pos.x + (self.vel.x * gameStuff.speed) * globalDt
        self.pos.y = self.pos.y + (self.vel.y * gameStuff.speed) * globalDt


        if ((self.hp + self.hpAddCar) * self.hpMultCar) / self.hpDivCar <= 0 then
            createExplosion(self.pos.x, self.pos.y, self)
            self.walkSfx:stop()
            if self.startSfx ~= nil then
                self.startSfx:stop()
            end
            table.remove(GameCarInstances, tableFind(GameCarInstances, self))
            return
        end


        self.sclYAdd = 0.25 * math.sin(self.angle * 8)
        self.rot = (0.1 - 0.1 * math.cos(self.angle * 16)) * self.fromCar.waveForce


        self.driveParticle:setPosition(self.pos.x + 16, self.pos.y + 24)
        self.driveParticle:update(globalDt)
        self.angle = self.angle + (1 * gameStuff.speed) * globalDt


        for f = 1, #self.additionalBehaviorFuncs do
            self.additionalBehaviorFuncs[f](self)
        end
        self.zIndex = self.pos.y
    end

    function c:delete()
        table.remove(GameCarInstances, tableFind(GameCarInstances, c))
    end

    function c:draw()
        --The particles gets drawn in the main.lua


        if not self.isExampleCar then
            local color = { 1, 1, 1, self.alpha }


            if self.isGhostCar then color = { 1, 0.5, 1, self.alpha / 2 } end


            love.graphics.setColor(color)
        end


        local rot = self.rot
        local addSprsRot = 0
        local scl = { self.fromCar.scale + self.scaleAdd, self.fromCar.scale + self.sclYAdd + self.scaleAdd }
        if self.fromCar.especialPropertys.isTank then
            self.scaleAdd = 0.1 * math.cos(self.angle); scl = { self.fromCar.scale + self.scaleAdd, self.fromCar.scale +
            self.scaleAdd }
        end
        self.fromCar.spr:draw(rot, self.pos.x, self.pos.y, scl[1], scl[2], self.fromCar.spr.sprWidth / 2,
            self.fromCar.spr.sprHeight / 2, 4, { 0, 0, 0, self.alpha })


        if self.fromCar.especialPropertys.isTank then
            addSprsRot = math.pi + self.fromCar.especialPropertys.weaponRot
        end


        for s = 1, #self.fromCar.carAddSprs do
            drawOutlinedSprite(self.fromCar.carAddSprs[s], self.pos.x, self.pos.y, addSprsRot, scl[1], scl[2], nil, nil,
                4,
                { 0, 0, 0, self.alpha })
        end
    end

    c:init()
    table.insert(GameCarInstances, 1, c)


    return c
end

function createExplosion(_x, _y, _fromCar)
    if _fromCar.fromCar == nil then return end


    local e = {
        pos = { x = _x, y = _y },
        spr = newAnimation(love.graphics.newImage("Sprs/Cars/Explosion.png"), 16, 16, 7, 0, 30, 1),
    }


    explosionSfx:setPitch(2 * math.random())
    playSound(explosionSfx)
    enableScreenShake(25 * _fromCar.fromCar.explosionMult)
    for c = 1, #GameCarInstances do
        local angleTo = math.atan2(e.pos.y - GameCarInstances[c].pos.y, e.pos.x - GameCarInstances[c].pos.x)


        if Lume.distance(e.pos.x, e.pos.y, GameCarInstances[c].pos.x, GameCarInstances[c].pos.y) <= _fromCar.fromCar.explosionArea then
            if GameCarInstances[c].pos.y == e.pos.y then
                GameCarInstances[c].vel.y = (GameCarInstances[c].vel.y - 800 * _fromCar.fromCar.explosionMult) /
                    GameCarInstances[c].fromCar.impactDiv
            end


            GameCarInstances[c].vel.x = GameCarInstances[c].vel.x -
                ((800 * _fromCar.fromCar.explosionMult) * math.cos(angleTo)) / GameCarInstances[c].fromCar.impactDiv
            GameCarInstances[c].vel.y = GameCarInstances[c].vel.y -
                ((800 * _fromCar.fromCar.explosionMult) * math.sin(angleTo)) / GameCarInstances[c].fromCar.impactDiv
        end
    end


    function e:update()
        self.spr:update(globalDt)


        if self.spr.finished then
            table.remove(gameInstances, tableFind(gameInstances, self))
        end
    end

    function e:draw()
        self.spr:draw(0, self.pos.x, self.pos.y, 8 * (_fromCar.fromCar.explosionArea / 128),
            8 * (_fromCar.fromCar.explosionArea / 128))
    end

    table.insert(gameInstances, 1, e)
end

function createCarImpact(_x, _y)
    local i = {
        pos = { x = _x, y = _y },
        spr = newAnimation(love.graphics.newImage("Sprs/Cars/Hit.png"), 16, 16, 3, 0, 20, 1),
    }


    function i:update()
        self.spr:update(globalDt)


        if self.spr.finished then
            table.remove(gameInstances, tableFind(gameInstances, self))
        end
    end

    function i:draw()
        self.spr:draw(0, self.pos.x, self.pos.y, 4, 4)
    end

    table.insert(gameInstances, 1, i)
end

function ghostCarUpdate(self)
    if self.ghostDisappearTimer <= 0 then
        Flux.to(self, 1, { alpha = 0 }):ease("expoout"):oncomplete(self.delete)
    end


    self.ghostDisappearTimer = self.ghostDisappearTimer - (1 * gameStuff.speed) * globalDt
end

function sellerCarUpdate(self)
    if self.fromCar.especialPropertys.recieveCooldown <= 0 then
        local moneyGaved = 0


        for f = 1, self.fromCar.especialPropertys.froggsKilled do
            moneyGaved = moneyGaved + Lume.clamp(((20) / moneyGainDiv) * moneyGainMult, 0, 9999)
        end


        money = money + moneyGaved


        table.insert(gameInstances, #gameInstances + 1, createMoneyRecievePerCar(tostring(moneyGaved)))
        self.fromCar.especialPropertys.froggsKilled = 0
        self.fromCar.especialPropertys.recieveCooldown = self.fromCar.especialPropertys.recieveCooldownDef
    end


    self.fromCar.especialPropertys.recieveCooldown = self.fromCar.especialPropertys.recieveCooldown -
        (1 * gameStuff.speed) * globalDt
end

function catCarUpdate(self)
    if currentRoom == rooms.mainMenu then return end


    if self.fromCar.especialPropertys.catCreateDelay <= 0 then
        createCat(self.pos.x, self.pos.y)
        self.fromCar.especialPropertys.catCreateDelay = math.random(1, 5)
    end


    self.fromCar.especialPropertys.catCreateDelay = self.fromCar.especialPropertys.catCreateDelay -
        (1 * gameStuff.speed) * globalDt
end

function createCat(x, y)
    local c = {
        pos = { x = x, y = y },
        vel = { x = 0, y = 0 },
        reverseX = 1,
        reverseY = 1,
        rot = 0,
        scale = { x = 2, y = 2 },
        mspd = 500,
        spr = newAnimation(love.graphics.newImage("Sprs/Other/CatWalk.png"), 20, 16, 3, 5, 0),
        hp = 2,
        targetFrog = 1,
    }


    function c:init()
        self.targetFrog = 1
    end

    function c:update()
        self.pos.x = self.pos.x + (self.vel.x * gameStuff.speed) * globalDt
        self.pos.y = self.pos.y + (self.vel.y * gameStuff.speed) * globalDt


        self.rot = 0.1 * math.sin(GlobalSinAngle)
        self.scale.y = 2 + 0.25 * math.cos(GlobalSinAngle)


        if self.vel.x < 0 then
            self.scale.x = -2
        else
            self.scale.x = 2
        end


        if Foggs[self.targetFrog] ~= nil then
            self.spr:update(globalDt * gameStuff.speed)
            local dir = Lume.angle(self.pos.x, self.pos.y, Foggs[self.targetFrog].pos.x, Foggs[self.targetFrog].pos.y)
            self.vel.x = Lume.lerp(self.vel.x, self.mspd * math.cos(dir), 6)
            self.vel.y = Lume.lerp(self.vel.y, self.mspd * math.sin(dir), 6)
            if Lume.distance(self.pos.x, self.pos.y, Foggs[self.targetFrog].pos.x, Foggs[self.targetFrog].pos.y) <= 32 then
                if Foggs[self.targetFrog].hp == 1 then
                    self.hp = self.hp - 1
                end


                Foggs[self.targetFrog]:recieveDamage(1, self.pos.x, self.pos.y)
            end
        else
            self.vel.x = Lume.lerp(self.vel.x, 0, 6)
            self.vel.y = Lume.lerp(self.vel.y, 0, 6)
        end


        if self.hp <= 0 then
            createBlood(self.pos.x, self.pos.y)
            table.remove(gameInstances, tableFind(gameInstances, self))
        end
    end

    function c:draw()
        love.graphics.setColor(1, 1, 1)
        self.spr:draw(self.rot, self.pos.x, self.pos.y, self.scale.x, self.scale.y, nil, nil, 4, { 0, 0, 0 })
    end

    c:init()


    table.insert(gameInstances, #gameInstances + 1, c)
end

function shootUpdateFunc(self)
    if currentRoom == rooms.mainMenu then
        self.fromCar.especialPropertys.weaponRot = self.fromCar.especialPropertys.weaponRot + 1 * globalDt; return
    end


    if self.fromCar.especialPropertys.target == "Frogs" and Foggs[1] ~= nil then
        local dir = Lume.angle(self.pos.x, self.pos.y, Foggs[1].pos.x, Foggs[1].pos.y)
        self.fromCar.especialPropertys.dir = dir
        self.fromCar.especialPropertys.weaponRot = dir
        self.fromCar.especialPropertys.cooldown = self.fromCar.especialPropertys.cooldown -
            (1 * gameStuff.speed) * globalDt
    else
        self.fromCar.especialPropertys.dir = Lume.lerp(self.fromCar.especialPropertys.dir, 0, 6)
        self.fromCar.especialPropertys.weaponRot = Lume.lerp(self.fromCar.especialPropertys.weaponRot, 0, 6)
    end


    if self.fromCar.especialPropertys.cooldown <= 0 then
        self.fromCar.especialPropertys.bulletCreateFunction(self.pos.x, self.pos.y, self.fromCar.especialPropertys.dir)


        self.fromCar.especialPropertys.cooldown = self.fromCar.especialPropertys.cooldownDef
    end
end

function createTankBullet(x, y, dir)
    local b = {
        pos = { x = x, y = y },
        dir = dir,
        mspd = 500,
        spr = love.graphics.newImage("Sprs/Bullets/TankBullet.png"),
        col = createRectangle(x, y, 32, 32),
        lifeTimer = 1,
    }


    function b:update()
        self.col.x = self.pos.x - self.spr:getWidth() / 2
        self.col.y = self.pos.y - self.spr:getHeight() / 2
        self.col.w = self.spr:getWidth()
        self.col.h = self.spr:getHeight()


        self.pos.x = self.pos.x + (self.mspd * math.cos(self.dir)) * globalDt
        self.pos.y = self.pos.y + (self.mspd * math.sin(self.dir)) * globalDt


        for f = 1, #Foggs do
            if Foggs[f] ~= nil then
                if self.col:checkCollision(Foggs[f].col) then
                    Foggs[f].hp = 0
                    self:hit()
                end
            end
        end


        self.lifeTimer = self.lifeTimer - (1 * gameStuff.speed) * globalDt
    end

    function b:hit()
        createExplosion(x, y, GameCars[1])
        table.remove(gameInstances, tableFind(gameInstances, self))
    end

    function b:draw()
        drawOutlinedSprite(self.spr, self.pos.x, self.pos.y, self.dir, 1, 1, nil, nil, 4, { 0, 0, 0 })
    end

    table.insert(gameInstances, #gameInstances + 1, b)
end
