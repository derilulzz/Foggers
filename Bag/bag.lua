


--#region Item Create Functions


function createMoneyPrinter()
    local m = {
        pos = {x = 0, y = 0},
        spr = newAnimation(love.graphics.newImage("Sprs/Items/MoneyPrinter/PrinterSpr.png"), 32, 40, 28, 10, 1),
        scale = {
		    x = 4,
	    	y = 4
    	},
        col = createRectangle(0, 0, 32, 40),
    }


    function m:update()
        self.col.x = self.pos.x - (self.spr.sprWidth * self.scale.x) / 2
        self.col.y = self.pos.y - (self.spr.sprHeight * self.scale.y) / 2
        self.col.w = self.spr.sprWidth * self.scale.x
        self.col.h = self.spr.sprHeight * self.scale.y


        self.spr:update(globalDt * gameStuff.speed)


        if self.spr.finished then
            money = money + 1
            createMoneyGainEffect(1, self.pos.x, self.pos.y)
            self.spr.currentFrame = 0
            self.spr.finished = false
        end
    end


    function m:draw()
        love.graphics.setColor(1, 1, 1)
        self.spr:draw(0, self.pos.x, self.pos.y, self.scale.x, self.scale.y + 0.1 * math.sin(GlobalSinAngle), nil, nil, nil, nil)
    end
    

    return m
end
function createCarCreator()
    local m = {
        pos = {x = 0, y = 0},
        spr = newAnimation(love.graphics.newImage("Sprs/Items/MoneyPrinter/CarCreator.png"), 30, 22, 3, 4, 1),
        scale = {
            x = 4,
            y = 4
        },
        col = createRectangle(0, 0, 32, 40),
    }


    function m:update()
        self.col.x = self.pos.x - (self.spr.sprWidth * self.scale.x) / 2
        self.col.y = self.pos.y - (self.spr.sprHeight * self.scale.y) / 2
        self.col.w = self.spr.sprWidth * self.scale.x
        self.col.h = self.spr.sprHeight * self.scale.y


        self.spr:update(globalDt * gameStuff.speed)


        if self.spr.finished then
            local puttedX = Lume.random(0, 800 * 1.5)
            local puttedY = transformToCarYPosGrid(Lume.random(0, 600))


            createCarGenerationOrb(self.pos.x, self.pos.y, puttedX, puttedY)


            self.spr.currentFrame = 0
            self.spr.finished = false
        end
    end


    function m:draw()
        love.graphics.setColor(1, 1, 1)
        self.spr:draw(0, self.pos.x, self.pos.y, self.scale.x, self.scale.y + 0.1 * math.sin(GlobalSinAngle), nil, nil, nil, nil)
    end
    

    return m
end
function createCarGenerationOrb(x, y, targetX, targetY)
    local o = {
        pos = {
            x = x,
            y = y
        },
        targetPos = {
            x = targetX,
            y = targetY
        },
        timeToReach = 1,
        spr = newAnimation(love.graphics.newImage("Sprs/Items/MoneyPrinter/CarCreateOrb.png"), 16, 16, 3, 10, 0),
    }


    function o:init()
        Flux.to(self.pos, self.timeToReach, {x=self.targetPos.x, y=self.targetPos.y}):ease("expoin"):oncomplete(o.destroySelf)
    end


    function o:destroySelf()
        createCarInstance(GameCars[1], o.pos.x, o.pos.y, true)
        table.remove(gameInstances, tableFind(gameInstances, o))
    end


    function o:draw()
        self.spr:draw(0, self.pos.x, self.pos.y, 4, 4)
    end


    o:init()


    table.insert(gameInstances, #gameInstances + 1, o)
end
function createBombExplosion()
    while #GameCarInstances > 0 do
        tableClear(GameCarInstances)
    end
    tableClear(Foggs)


    local w = {
        alpha = 1,
    }


    function w:init()
        Flux.to(self, 1, {alpha=0}):oncomplete(w.destroy)
    end


    function w:destroy()
        table.remove(onTopGameInstaces, tableFind(onTopGameInstaces, w))
    end


    function w:draw()
        love.graphics.setColor(1, 1, 1, self.alpha)
        love.graphics.rectangle("fill", 0, 0, 800, 600)
    end


    w:init()


    table.insert(onTopGameInstaces, #onTopGameInstaces + 1, w)
end


--#endregion


bagStuff = {
    stored = {},
    maxAmnt = 8,
    bagButton = nil,
    hoveringAnItem = false,
    showingBag = false,
    bagRect = {
        x = 800 - 512 - 16,
        y = 600 - 256 - 16,
        w = 512,
        h = 256
    },
    currentSelectedItem = nil,
    currentSlotScaleAdd = 0,
    placingItem = false,
    hoveredId = 0,
    oldHoveredId = 0,
    oldHoveringAnItem = false,
    currentPlacingItem = nil,
}


function placeItem()
    local a = bagStuff.currentSelectedItem.itemCreateFunction()
    bagStuff.currentPlacingItem = a
    bagStuff.placingItem = true
end


function useItem()
    local a = bagStuff.currentSelectedItem.itemCreateFunction()
end


bagItems = {
    moneyPrinter = {
        name = "Money Printer",
        namePT = "Impressora De Dinheiro",
        desc = "Faz 1 Dinheiro Por Segundo",
        useFuntion = placeItem,
        itemCreateFunction = createMoneyPrinter
    },
    carCreator = {
        name = "Car Creator",
        desc = "Creates An Temporary Car Every 1 Second",
        useFuntion = placeItem,
        itemCreateFunction = createCarCreator
    },
    bomb = {
        name = "Bomb R",
        desc = "An Bomb, it's self explanatory",
        useFuntion = useItem,
        itemCreateFunction = createBombExplosion
    },
}
bagItemsIndexed = {
    bagItems.moneyPrinter,
    bagItems.carCreator,
    bagItems.bomb,
}


function bagStuff:restartBag()
    bagStuff.bagButton = nil
    bagStuff.showingBag = false
end


function bagStuff:initBag()
    self.bagButton = createButton(800 - 64 - 16, 600 - 32 - 16, 128, 64, "Bag", "Your Bag", true)
    self.showingBag = false


    if tableFind(onTopGameInstaces, self) == -1 then
        table.insert(onTopGameInstaces, #onTopGameInstaces + 1, self)
    end
end


function bagStuff:update()
    if self.bagButton.pressed then
        self.showingBag = not self.showingBag
        self.bagButton.pressed = false
    end
    self.bagButton.disabled = self.showingBag


    if self.showingBag then
        if self.oldHoveredId ~= self.hoveredId or self.oldHoveringAnItem ~= self.hoveringAnItem then
            self.currentSlotScaleAdd = 2
        end



        if PushsInGameMousePosNoTransform.x < self.bagRect.x then
            self.showingBag = false
        end
        if PushsInGameMousePosNoTransform.x > self.bagRect.x + self.bagRect.w then
            self.showingBag = false
        end
        if PushsInGameMousePosNoTransform.y < self.bagRect.y then
            self.showingBag = false
        end
        if PushsInGameMousePosNoTransform.y > self.bagRect.y + self.bagRect.h then
            self.showingBag = false
        end
    end


    if self.hoveringAnItem then
        if love.mouse.isDown(1) and LastLeftMouseButton == false then
            self.currentSelectedItem = self.stored[self.hoveredId]
            self.currentSelectedItem:useFuntion()
        end
    end


    if self.placingItem then
        local canUpdatePos = true


        for c=1, #gameInstances do
            if gameInstances[c].col ~= nil then
                local realRect = createRectangle(PushsInGameMousePos.x - self.currentPlacingItem.col.w / 2, PushsInGameMousePos.y - self.currentPlacingItem.col.h / 2, self.currentPlacingItem.col.w, self.currentPlacingItem.col.h)
                if realRect:checkCollision(gameInstances[c].col) then
                    canUpdatePos = false
                end
            end
        end


        if canUpdatePos then
            self.currentPlacingItem.pos = PushsInGameMousePosNoTransform
            self.currentPlacingItem.col.x = self.currentPlacingItem.pos.x - (self.currentPlacingItem.spr.sprWidth * self.currentPlacingItem.scale.x) / 2
            self.currentPlacingItem.col.y = self.currentPlacingItem.pos.y - (self.currentPlacingItem.spr.sprHeight * self.currentPlacingItem.scale.y) / 2
            self.currentPlacingItem.col.w = self.currentPlacingItem.spr.sprWidth * self.currentPlacingItem.scale.x
            self.currentPlacingItem.col.h = (self.currentPlacingItem.spr.sprHeight * self.currentPlacingItem.scale.y)
        else
            self.currentPlacingItem.col.x = PushsInGameMousePosNoTransform.x - (self.currentPlacingItem.spr.sprWidth * self.currentPlacingItem.scale.x) / 2
            self.currentPlacingItem.col.y = PushsInGameMousePosNoTransform.y - (self.currentPlacingItem.spr.sprHeight * self.currentPlacingItem.scale.y) / 2
            self.currentPlacingItem.col.w = self.currentPlacingItem.spr.sprWidth * self.currentPlacingItem.scale.x
            self.currentPlacingItem.col.h = self.currentPlacingItem.spr.sprHeight * self.currentPlacingItem.scale.y
        end


        if not love.mouse.isDown(1) then
            local newPos = {gameCam.transform:inverseTransformPoint(self.currentPlacingItem.pos.x, self.currentPlacingItem.pos.y)}
            self.currentPlacingItem.pos = {x = newPos[1], y = newPos[2]}
            table.insert(gameInstances, #gameInstances + 1, self.currentPlacingItem)
            self.currentPlacingItem = nil
            self.placingItem = false
        end
    end


    self.currentSlotScaleAdd = Lume.lerp(self.currentSlotScaleAdd, 1, 0.1)
    self.oldHoveredId = self.hoveredId
    self.oldHoveringAnItem = self.hoveringAnItem
end


function bagStuff:draw()
    if self.showingBag then
        love.graphics.setColor(0.5, 0.25, 0)
        drawOutlinedRect(bagStuff.bagRect.x, bagStuff.bagRect.y, bagStuff.bagRect.w, bagStuff.bagRect.h, {0.25, 0.1, 0})


        love.graphics.setColor(1, 1, 1)
        drawOutlinedText("BAG", self.bagRect.x + self.bagRect.w / 2, self.bagRect.y + 32 + 8 * math.sin(GlobalSinAngle), 0, 4, 4, love.graphics.getFont():getWidth("BAG") / 2, love.graphics.getFont():getHeight("BAG") / 2, 4, {0, 0, 0})


        drawOutlinedText(tostring(#self.stored), 8, 8, 0, 4, 4, nil, nil, 2, {0, 0, 0})


        local x = bagStuff.bagRect.x + 80 + 8
        local y = bagStuff.bagRect.y + 70
        local i = 0
        local iDec = 0
        local hoveringOne = false
        local previousWidth = 0
        while i < #self.stored do
            if previousWidth == 0 then
                x = x + Lume.clamp((32 * (i - iDec)), 0, 32) + 8
            else
                x = x + Lume.clamp((previousWidth * (i - iDec)), 0, previousWidth) + 8
            end


            if x > bagStuff.bagRect.w * 1.5 then
                y = y + 32
                x = bagStuff.bagRect.x + 16
                iDec = iDec + i
            end

		
            local color = {0.25, 0.25, 0.25}
            local scale = 2


            if self.hoveredId == i + 1 and self.hoveringAnItem then color = {1, 1, 1}; scale = scale + self.currentSlotScaleAdd end


            local opX = x - (love.graphics.getFont():getWidth(self.stored[i + 1].name) * scale) / 2
            local opY = y - (love.graphics.getFont():getHeight(self.stored[i + 1].name) * scale) / 2
            local opW = opX + (love.graphics.getFont():getWidth(self.stored[i + 1].name) * scale)
            local opH = opY + (love.graphics.getFont():getHeight(self.stored[i + 1].name) * scale)


            love.graphics.setColor(color)
                drawOutlinedText(self.stored[i + 1].name, x, y, 0, scale, scale, love.graphics.getFont():getWidth(self.stored[i + 1].name) / 2, love.graphics.getFont():getHeight(self.stored[i + 1].name) / 2, 2, {0, 0, 0})


                previousWidth = (love.graphics.getFont():getWidth(self.stored[i + 1].name) * scale)


                if PushsInGameMousePosNoTransform.x > opX and PushsInGameMousePosNoTransform.x < opW and PushsInGameMousePosNoTransform.y > opY and PushsInGameMousePosNoTransform.y < opH then
                    hoveringOne = true


                    if hoveringOne then
                        self.hoveredId = i + 1
                    end
                end


            i = i + 1
        end


        if #self.stored <= 0 then
            love.graphics.setColor({1, 1, 1, 1})
            local text = "your bag is empty"
            if gameStuff.lang == "pt-br" then text = "sua mochila esta vazia" end
            drawOutlinedText(text, self.bagRect.x + self.bagRect.w / 2, self.bagRect.y + self.bagRect.h / 2, 0, 2 + 0.25 * math.cos(GlobalSinAngle), 2 + 0.25 * math.cos(GlobalSinAngle), nil, nil, 4 + 0.25 * math.cos(GlobalSinAngle), {0, 0, 0})
        end


        self.hoveringAnItem = hoveringOne
    else
        self.hoveringAnItem = false
    end
    

    love.graphics.setColor(1, 1, 1)
    if self.placingItem then
        if self.currentPlacingItem ~= nil then
            self.currentPlacingItem:draw()
        end
    end
end
