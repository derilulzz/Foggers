require("rectangle")


originalFrogColors = {
    {0.376, 1, 0.251, 1},
    {0, 0.502, 0.243, 1},
    {0, 0, 0, 1},
}


function createForg(_x, _y, _level, _hp, _jumpTimerDef)
    if _hp == nil then _hp = 2 end


    local f = {
        pos = { x = _x, y = _y },
        spr = newAnimation(love.graphics.newImage("Sprs/Fog/Idle.png"), 18, 19, 2, 1, 5),
        jumpSpr = newAnimation(love.graphics.newImage("Sprs/Fog/Jump.png"), 18, 19, 2, 1, 5),
        targetPos = { x = _x, y = _y },
        jumpTimer = _jumpTimerDef,
        zIndex = 0,
        mspd = 64,
        scale = 2,
        jumping = false,
        col = createRectangle(_x, _y, 20, 20),
        rot = 0,
        hp = _hp,
        jumpTimerDef = _jumpTimerDef,
        hpAddFogg = 0,
        hpDivFogg = 1,
        hpMultFogg = 1,
        spdAddFogg = 0,
        spdDivFogg = 1,
        spdMultFogg = 1,
        alpha = 0,
        newSprColors = {
            {
                {0.376, 1, 0.251, 1},
                {0, 0.502, 0.243, 1},
                {0, 0, 0, 1},
            },
            {
                {1, 0.984, 0.251, 1},
                {0.502, 0.208, 0, 1},
                {0, 0, 0, 1},
            },
        },
        usedColors = {},
    }


    function f:init()
        self.scale = 16


        if gameStuff.currentFoggGaved + 1 <= #self.newSprColors then
            self.usedColors = self.newSprColors[gameStuff.currentFoggGaved + 1]
        else
            self.usedColors = {
                {Lume.random(), Lume.random(), Lume.random(), 1},
                {Lume.random(), Lume.random(), Lume.random(), 1},
                {0, 0, 0, 1},
            }
        end


        Flux.to(self, 1, { alpha = 1, scale = 2 }):ease("expoout")
    end

    function f:update()
        if self.jumpTimer <= 0 then
            local jumpChanceX = math.random(0, 5)
            local jumpChanceY = math.random(0, 10)

            if jumpChanceX <= 0 then
                local xAdd = math.random(-1, 1)

                while xAdd == 0 do
                    xAdd = math.random(-1, 1)
                end

                self.targetPos.x = self.targetPos.x + (self.mspd * xAdd)
                self.rot = 1.5 * xAdd
                self.scale = self.scale + 2
            elseif jumpChanceY > 5 then
                self.targetPos.y = self.targetPos.y - self.mspd
                self.rot = 0
                self.scale = self.scale + 2
            end


            self.jumpTimer = self.jumpTimerDef
        end


        self.jumping = self.scale > 2.2


        self.targetPos.x = Lume.clamp(self.targetPos.x, 0, 800 * 1.5)
        self.pos.x = Lume.clamp(self.pos.x, 0, 800 * 1.5)


        if ((self.hp + self.hpAddFogg) / self.hpDivFogg) * self.hpMultFogg <= 0 then
            self:die()
        end
        if self.pos.y <= -32 then
            table.remove(Foggs, tableFind(Foggs, self))
            recieveDamage(1, self.pos.x, self.pos.y)
        end


        self.col.x = self.pos.x
        self.col.y = self.pos.y
        self.col.w = self.spr.sprWidth * self.scale
        self.col.h = self.spr.sprHeight * self.scale


        self.pos.x = Lume.lerp(self.pos.x, self.targetPos.x, 12)
        self.pos.y = Lume.lerp(self.pos.y, self.targetPos.y, 12)
        self.scale = Lume.lerp(self.scale, 2, 15)
        self.jumpTimer = self.jumpTimer -
            ((((1 + self.spdAddFogg) / self.spdDivFogg) * self.spdMultFogg) * gameStuff.speed) * globalDt
        self.zIndex = self.pos.y
    end

    function f:recieveDamage(amnt, x, y)
        if y == nil then return end
        if x == nil then return end
        if amnt == nil then return end


        self.hp = self.hp - amnt * permaUpgrades.carDamage
        warningSfx:setPitch(math.random())
        playSound(warningSfx)
        createDamageNum(amnt * permaUpgrades.carDamage, self.pos.x, self.pos.y)


        if self.hp <= 0 then
            self:die()
        end


        if self ~= nil then
            local angleTo = math.atan2(y - self.pos.y, x - self.pos.x)


            self.targetPos.x = self.targetPos.x - (math.cos(angleTo) * 64)
            self.targetPos.y = self.targetPos.y - (math.sin(angleTo) * 64)
            self.pos.x = self.pos.x - (math.cos(angleTo) * 74)
            self.pos.y = self.pos.y - (math.sin(angleTo) * 74)
        end
    end

    function f:draw()
        love.graphics.setColor(1, 1, 1, self.alpha)
            paletteSetterShader:send("colorOriginal",
                {
                    originalFrogColors[1][1], originalFrogColors[1][2], originalFrogColors[1][3], originalFrogColors[1][4],
                    originalFrogColors[2][1], originalFrogColors[2][2], originalFrogColors[2][3], originalFrogColors[2][4],
                    originalFrogColors[3][1], originalFrogColors[3][2], originalFrogColors[3][3], originalFrogColors[3][4],
                }
            )
            paletteSetterShader:send("colorToSet",
                {
                    self.usedColors[1][1], self.usedColors[1][2], self.usedColors[1][3], self.usedColors[1][4],
                    self.usedColors[2][1], self.usedColors[2][2], self.usedColors[2][3], self.usedColors[2][4],
                    self.usedColors[3][1], self.usedColors[3][2], self.usedColors[3][3], self.usedColors[3][4],
                }
            )
            love.graphics.setShader(paletteSetterShader)


            if self.jumping then
                self.jumpSpr:draw(self.rot, self.pos.x, self.pos.y, self.scale, self.scale)
            else
                self.spr:draw(self.rot, self.pos.x, self.pos.y, self.scale, self.scale)
            end 


            love.graphics.setShader()
        love.graphics.setColor(1, 1, 1, 1)
    end

    function f:die()
        for c = 1, #GameCarInstances do
            if GameCarInstances[c].fromCar.especialPropertys.seller and GameCarInstances[c].fromCar.especialPropertys.froggsKilled ~= nil then
                GameCarInstances[c].fromCar.especialPropertys.froggsKilled = GameCarInstances[c].fromCar
                    .especialPropertys.froggsKilled + 1
            end
        end


        money = money + (((100 * Lume.clamp(gameStuff.currentFoggGaved, 1, 999)) / moneyGainDiv) * moneyGainMult)
        createMoneyGainEffect((((100 * Lume.clamp(gameStuff.currentFoggGaved, 1, 999)) / moneyGainDiv) * moneyGainMult),
            self.pos.x, self.pos.y)
        createBlood(self.pos.x, self.pos.y)
        table.remove(Foggs, tableFind(Foggs, self))
    end


    f:init()


    table.insert(Foggs, #Foggs + 1, f)
    return f
end

bloodSprs = {
    love.graphics.newImage("Sprs/Blood/Blood.png"),
    love.graphics.newImage("Sprs/Blood/Blood2.png"),
}


function createBlood(_x, _y)
    _y = Lume.clamp(_y, 0, 600)


    local b = {
        pos = { x = _x, y = _y },
        spr = bloodSprs[math.random(1, #bloodSprs)],
        scale = { x = 0, y = 0 },
        drawBack = true,
        alpha = 1,
    }


    function b:update()
        if self.alpha <= 0 then
            table.remove(gameInstances, tableFind(gameInstances, self))
        end


        self.scale.x = Lume.lerp(self.scale.x, 4, 6)
        self.scale.y = Lume.lerp(self.scale.y, 4, 6)
        self.alpha = self.alpha - 0.1 * globalDt
    end

    function b:draw()
        love.graphics.setColor(1, 1, 1, self.alpha)
        love.graphics.draw(self.spr, self.pos.x, self.pos.y, 0, self.scale.x, self.scale.y, self.spr:getWidth() / 2,
            self.spr:getHeight() / 2)
    end

    table.insert(gameInstances, 1, b)
    return b
end
