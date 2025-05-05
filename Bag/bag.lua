


--#region Item Create Functions


function createMoneyPrinter()
    local m = {
        pos = {x = 0, y = 0},
        spr = newAnimation(love.graphics.newImage("Sprs/Items/MoneyPrinter/PrinterSpr.png"), 32, 40, 28, 5, 1),
        scale = 4,
        col = createRectangle(0, 0, 32, 40),
    }


    function m:update()
        self.col.x = self.pos.x - (self.spr.sprWidth * self.scale) / 2
        self.col.y = self.pos.y - (self.spr.sprHeight * self.scale) / 2
        self.col.w = self.spr.sprWidth * self.scale
        self.col.h = self.spr.sprHeight * self.scale


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
        self.spr:draw(0, self.pos.x, self.pos.y, self.scale, self.scale + 0.1 * math.sin(GlobalSinAngle), nil, nil, nil, nil)
    end
    

    return m
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
    placingItem = false,
    hoveredId = 0,
    currentPlacingItem = nil,
}


function placeItem()
    local a = bagStuff.currentSelectedItem.itemCreateFunction()
    bagStuff.currentPlacingItem = a
    bagStuff.placingItem = true
end


bagItems = {
    moneyPrinter = {name = "Money Printer", desc = "Prints 1 Money Per Second", useFuntion = placeItem, itemCreateFunction = createMoneyPrinter}
}


function bagStuff:restartBag()
    bagStuff.bagButton = nil
    bagStuff.showingBag = false
end


function bagStuff:initBag()
    self.bagButton = createButton(800 - 64 - 8, 600 - 32 - 8, 128, 64, "Bag", "Your Bag", true)
    self.showingBag = false
    self.stored = {
        bagItems.moneyPrinter
    }


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
            self.currentPlacingItem.col.x = self.currentPlacingItem.pos.x - (self.currentPlacingItem.spr.sprWidth * self.currentPlacingItem.scale) / 2
            self.currentPlacingItem.col.y = self.currentPlacingItem.pos.y - (self.currentPlacingItem.spr.sprHeight * self.currentPlacingItem.scale) / 2
            self.currentPlacingItem.col.w = self.currentPlacingItem.spr.sprWidth * self.currentPlacingItem.scale
            self.currentPlacingItem.col.h = (self.currentPlacingItem.spr.sprHeight * self.currentPlacingItem.scale)
        else
            self.currentPlacingItem.col.x = PushsInGameMousePosNoTransform.x - (self.currentPlacingItem.spr.sprWidth * self.currentPlacingItem.scale) / 2
            self.currentPlacingItem.col.y = PushsInGameMousePosNoTransform.y - (self.currentPlacingItem.spr.sprHeight * self.currentPlacingItem.scale) / 2
            self.currentPlacingItem.col.w = self.currentPlacingItem.spr.sprWidth * self.currentPlacingItem.scale
            self.currentPlacingItem.col.h = self.currentPlacingItem.spr.sprHeight * self.currentPlacingItem.scale
        end


        if not love.mouse.isDown(1) then
            local newPos = {gameCam.transform:inverseTransformPoint(self.currentPlacingItem.pos.x, self.currentPlacingItem.pos.y)}
            self.currentPlacingItem.pos = {x = newPos[1], y = newPos[2]}
            table.insert(gameInstances, #gameInstances + 1, self.currentPlacingItem)
            self.currentPlacingItem = nil
            self.placingItem = false
        end
    end
end


function bagStuff:draw()
    if self.showingBag then
        love.graphics.setColor(0.5, 0.25, 0)
        drawOutlinedRect(bagStuff.bagRect.x, bagStuff.bagRect.y, bagStuff.bagRect.w, bagStuff.bagRect.h, {0.25, 0.1, 0})


        love.graphics.setColor(1, 1, 1)
        drawOutlinedText("BAG", self.bagRect.x + self.bagRect.w / 2, self.bagRect.y + 32, 0, 4, 4, love.graphics.getFont():getWidth("BAG") / 2, love.graphics.getFont():getHeight("BAG") / 2, 4, {0, 0, 0})



        drawOutlinedText(tostring(#self.stored), 8, 8, 0, 4, 4, nil, nil, 2, {0, 0, 0})



        local x = bagStuff.bagRect.x + 16
        local y = bagStuff.bagRect.y + 70
        local i = 0
        local iDec = 0
        local hoveringOne = false
        while i < #self.stored do
            x = x + Lume.clamp((32 * (i - iDec)), 0, 32)


            if x > bagStuff.bagRect.w * 1.5 then
                y = y + 32
                x = bagStuff.bagRect.x + 16
                iDec = iDec + i
            end


            drawOutlinedText(self.stored[i + 1].name, x, y, 0, 2, 2, 0, 0, 2, {0, 0, 0})


            hoveringOne = PushsInGameMousePosNoTransform.x > x and PushsInGameMousePosNoTransform.x < x + (love.graphics.getFont():getWidth(self.stored[i + 1].name) * 2) and PushsInGameMousePosNoTransform.y > y and PushsInGameMousePosNoTransform.y < y + (love.graphics.getFont():getHeight(self.stored[i + 1].name) * 2)
            if hoveringOne then
                self.hoveredId = i + 1
            end


            i = i + 1
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