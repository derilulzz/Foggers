


function createCarStats()
    local c = {
        pos = {x = 16, y = 16},
        size = {w = 800 - 32, h = 600 - 32},
        currentShowedCar = nil,
        oldCurrentShowedCar = nil,
        selectedCarScaleAdd = 0,
        returnButton = createButton(16, 600 - 32, 128, 64, "Return", "", true),
        died = false,
        alpha = 0,
        scroll = 0,
        wantedScroll = 0,
        totalCarLines = 0,
    }


    function c:init()
        self.pos.y = 600
        Flux.to(self.pos, 1, {y = 16}):ease("expoout")
    end


    function c:update()
        if self.returnButton.pressed then
            self:die()
            self.returnButton.pressed = false
        end


        if PushsInGameMousePos.x < self.pos.x + self.size.w / 2 then
            self.wantedScroll = self.wantedScroll + mouseScroll.y * 32
        end
        self.wantedScroll = Lume.lerp(self.wantedScroll, Lume.clamp(self.wantedScroll, -64 * self.totalCarLines, 0), 6)
        self.scroll = Lume.lerp(self.scroll, self.wantedScroll, 6)


        if gameStuff.lang == "pt-br" then
            self.returnButton.text = "Voltar"
        else
            self.returnButton.text = "Return"
        end


        if self.oldCurrentShowedCar ~= self.currentShowedCar then
            self.alpha = 0
        end

        
        self.returnButton.pos = {x = self.pos.x + self.size.w / 4, y = self.pos.y + self.size.h - 32 - 8}
        self.oldCurrentShowedCar = self.currentShowedCar
    end


    function c:die()
        Flux.to(self.pos, 0.5, {y = 600}):ease("expoin"):oncomplete(c.enableDeath)
    end


    function c:enableDeath()
        deleteUIInstance(c.returnButton)
        c.died = true
    end


    function c:draw()
        love.graphics.setColor(0, 0, 0)
        drawOutlinedRect(self.pos.x, self.pos.y, self.size.w, self.size.h, {1, 1, 1})

        
        local cRem = 0
        local hoveringOne = false
        local hoverId = 1
        local yAdd = 0
        local c = 0
        self.totalCarLines = 0
        local sizeW = (self.size.w / 2) / 4.5
        while c < #GameCars do
            local carScale = 1
            local biggerThanSlot = GameCars[c + 1].spr.sprWidth * (carScale) > sizeW / 2
            local x = self.pos.x + 8 + ((sizeW + 8) * (c - cRem))


            if x > self.size.w / 2 then
                cRem = cRem + 4
                self.totalCarLines = self.totalCarLines + 1
                yAdd = yAdd + 64 + 8
                x = self.pos.x + 8 + ((sizeW + 8) * (c - cRem))
            end


            if self.pos.y + 8 + yAdd + 64 + self.scroll < self.pos.y + self.size.h - (64 + 64) and self.pos.y + 8 + yAdd + self.scroll > self.pos.y then
                local nameScale = 1
                if biggerThanSlot then
                    if self.currentShowedCar == c + 1 then carScale = carScale + self.selectedCarScaleAdd / 32; nameScale = nameScale + self.selectedCarScaleAdd end
                end
                while GameCars[c + 1].spr.sprWidth * (carScale) > sizeW / 2 do carScale = carScale - 0.1 end
                while GameCars[c + 1].spr.sprHeight * (carScale) > sizeW / 2 do carScale = carScale - 0.1 end
                if not biggerThanSlot then
                    if self.currentShowedCar == c + 1 then carScale = carScale + self.selectedCarScaleAdd; nameScale = nameScale + self.selectedCarScaleAdd end
                end


                love.graphics.setColor(0.25, 0.25, 0.25)
                drawOutlinedRect(x, self.pos.y + 8 + yAdd + self.scroll, sizeW, 64, {1, 1, 1})
                GameCars[c + 1].spr:draw(0.1 * math.sin(GlobalSinAngle + c), x + (sizeW / 2), self.pos.y + 8 + yAdd + self.scroll + 32 - 16, carScale, carScale)
                for sAdd=1, #GameCars[c + 1].carAddSprs do
                    drawOutlinedSprite(GameCars[c + 1].carAddSprs[sAdd], x + (sizeW / 2), self.pos.y + 8 + self.scroll + yAdd + 32 - 16, 0.1 * math.sin(GlobalSinAngle + c), carScale, carScale, nil, nil, 2, {0, 0, 0})
                end
                local nameTxt = GameCars[c + 1].name
                if gameStuff.lang == "pt-br" then nameTxt =  GameCars[c + 1].namePT end
                drawOutlinedTextF(nameTxt, x + (sizeW / 2), self.pos.y + yAdd + 16 + 32 + self.scroll, 64, "center", 0.1 * math.cos(GlobalSinAngle + c), nameScale, nameScale, nil, 0, 2, {0, 0, 0})


                if PushsInGameMousePos.x > x and PushsInGameMousePos.x < x + sizeW and PushsInGameMousePos.y > self.pos.y + yAdd + self.scroll and PushsInGameMousePos.y < self.pos.y + yAdd + 64 + self.scroll then
                    hoveringOne = true
                    hoverId = c + 1
                end
            end

            c = c + 1
        end


        love.graphics.setColor(1, 1, 1)
        love.graphics.line(self.pos.x + self.size.w / 2, self.pos.y, self.pos.x + self.size.w / 2, self.pos.y + self.size.h)


        local text = "Hover an car to see it's stats"
        if gameStuff.lang == "pt-br" then text = "Use o mouse para ver as estatisticas dos carros" end
        local textHeight = love.graphics.getFont():getHeight(text)
        drawOutlinedTextF(text, self.pos.x + (self.size.w / 2) / 2, self.pos.y - 64 - 16 + self.size.h - textHeight, self.size.w / 4, "center", 0.05 * math.sin(GlobalSinAngle), 2, 2, nil, "bottom", 2, {0, 0, 0})
        

        if hoveringOne then
            if hoverId ~= self.oldCurrentShowedCar then
                self.alpha = -1
                self.selectedCarScaleAdd = 0
            end


            self.currentShowedCar = hoverId
            self.alpha = Lume.lerp(self.alpha, 1, 6)
            self.selectedCarScaleAdd = Lume.lerp(self.selectedCarScaleAdd, 1, 6)
        else
            self.alpha = Lume.lerp(self.alpha, 0, 6)
            self.selectedCarScaleAdd = Lume.lerp(self.selectedCarScaleAdd, 0, 6)


            if self.alpha <= 0.1 then
                self.currentShowedCar = nil
            end
        end


        if self.currentShowedCar ~= nil then
            local speedText = "Speed: "
            local hpText = "Hp: "
            local damageText = "Damage: "
            local costText = "Cost: "
            local isTankText = "Is An Tank"
            local targetText = "Target: "
            local shootsText = "Shoots"
            local cooldownText = "Cooldown: "
            local createsCatText = "Creates Cats"
            local carDesc = GameCars[self.currentShowedCar].desc

            
            if gameStuff.lang == "pt-br" then
                speedText = "Velocidade: "
                hpText = "Vida: "
                damageText = "Dano: "
                costText = "Custo: "
                isTankText = "É um tanque"
                targetText = "Alvo: "
                shootsText = "Atira"
                cooldownText = "Recarga: "
                createsCatText = "Cria gatos"
                carDesc = GameCars[self.currentShowedCar].descPT
            end


            love.graphics.setColor(1, 1, 1, self.alpha)
            local scrnHalf = self.size.w / 2
            local sprHeight = GameCars[self.currentShowedCar].spr.sprHeight
            local y = self.pos.y + 64
            local carScale = 4


            while sprHeight * carScale > 170 do
                carScale = carScale - 0.1
            end


            GameCars[self.currentShowedCar].spr:draw(0.1 * math.sin(GlobalSinAngle), (self.pos.x + scrnHalf) + scrnHalf / 2, y, carScale, carScale)
            for sAdd=1, #GameCars[self.currentShowedCar].carAddSprs do
                drawOutlinedSprite(GameCars[self.currentShowedCar].carAddSprs[sAdd], (self.pos.x + scrnHalf) + scrnHalf / 2, y, 0.1 * math.sin(GlobalSinAngle + c), carScale, carScale, nil, nil, 2, {0, 0, 0})
            end


            local descStats = drawOutlinedTextF(carDesc, (self.pos.x + scrnHalf) + scrnHalf / 2, self.pos.y + 200, scrnHalf / 2, "center", 0.025 * math.cos(GlobalSinAngle), 2, 2, nil, nil, 2, {0, 0, 0, self.alpha})
            drawOutlinedText(speedText .. tostring(GameCars[self.currentShowedCar].spd), self.pos.x + scrnHalf + 64 + 8, self.pos.y + 200 + descStats.h + 32, 0.01 * math.sin(GlobalSinAngle), 2, 2, nil, nil, 2, {0, 0, 0, self.alpha})
            drawOutlinedText(hpText .. tostring(GameCars[self.currentShowedCar].hp), self.pos.x + scrnHalf + 64 + 8, self.pos.y + 200 + descStats.h + 32 + 32, 0.01 * math.sin(GlobalSinAngle), 2, 2, nil, nil, 2, {0, 0, 0, self.alpha})
            drawOutlinedText(damageText .. tostring(GameCars[self.currentShowedCar].damage), self.pos.x + scrnHalf + 64 + 8, self.pos.y + 200 + descStats.h + 32 + 32 + 32, 0.01 * math.sin(GlobalSinAngle), 2, 2, nil, nil, 2, {0, 0, 0, self.alpha})
            drawOutlinedText(costText .. tostring(GameCars[self.currentShowedCar].cost), self.pos.x + scrnHalf + 64 + 8, self.pos.y + 200 + descStats.h + 32 + 32 + 32 + 32, 0.01 * math.sin(GlobalSinAngle), 2, 2, nil, nil, 2, {0, 0, 0, self.alpha})


            if GameCars[self.currentShowedCar].especialPropertys.shoots then
                local yDec = 0


                if GameCars[self.currentShowedCar].especialPropertys.isTank then
                    yDec = yDec + 32
                    yDec = yDec + 32
                    drawOutlinedText(isTankText, self.pos.x + scrnHalf + 64 + 8 + scrnHalf / 2, self.pos.y + 200 + descStats.h + 32 + 32, 0.01 * math.sin(GlobalSinAngle), 2, 2, nil, nil, 2, {0, 0, 0, self.alpha})
                    drawOutlinedText(targetText .. tostring(GameCars[self.currentShowedCar].especialPropertys.target), self.pos.x + scrnHalf + 64 + 8 + scrnHalf / 2, self.pos.y + 200 + descStats.h + 32 + 32 + 32, 0.01 * math.sin(GlobalSinAngle), 2, 2, nil, nil, 2, {0, 0, 0, self.alpha})
                end


                drawOutlinedText(shootsText, self.pos.x + scrnHalf + 64 + 8 + scrnHalf / 2, self.pos.y + 200 + descStats.h + 32, 0.01 * math.sin(GlobalSinAngle), 2, 2, nil, nil, 2, {0, 0, 0, self.alpha})
                drawOutlinedText(cooldownText .. tostring(GameCars[self.currentShowedCar].especialPropertys.cooldownDef), self.pos.x + scrnHalf + 64 + 8 + scrnHalf / 2, self.pos.y + 200 + yDec + descStats.h + 32 + 32, 0.01 * math.sin(GlobalSinAngle), 2, 2, nil, nil, 2, {0, 0, 0, self.alpha})
            end


            if GameCars[self.currentShowedCar].especialPropertys.cats then
                drawOutlinedText(createsCatText, self.pos.x + scrnHalf + 64 + 8 + scrnHalf / 2, self.pos.y + 200 + descStats.h + 32, 0.01 * math.sin(GlobalSinAngle), 2, 2, nil, nil, 2, {0, 0, 0, self.alpha})
                drawOutlinedText(cooldownText .. tostring(GameCars[self.currentShowedCar].especialPropertys.catCreateDelayDef), self.pos.x + scrnHalf + 64 + 8 + scrnHalf / 2, self.pos.y + 200 + descStats.h + 32 + 32, 0.01 * math.sin(GlobalSinAngle), 2, 2, nil, nil, 2, {0, 0, 0, self.alpha})
            end
        end
    end


    c:init()


    return c
end