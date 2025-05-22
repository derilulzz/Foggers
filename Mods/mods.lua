

function createModsManager()
    local m = {
        returnButton = createButton(64 + 8, 600 - 32 - 8, 128, 64, "Return", "", true),
        hoveringOneMod = false,
        modHoveredId = 0,
        oldModHoveredId = 0,
        currentModScaleAdd = 0,
    }


    function m:update()
        if tableFind(UiStuff, self.returnButton) == -1 then self.returnButton = createButton(64 + 8, 600 - 32 - 8, 128, 64, "Return", "", true) end


        if gameStuff.lang == "pt-br" then
            self.returnButton.text = "Voltar"
        else
            self.returnButton.text = "Return"
        end


        if self.hoveringOneMod then
            self.currentModScaleAdd = Lume.lerp(self.currentModScaleAdd, 2, 0.1)


            if love.mouse.isDown(1) and LastLeftMouseButton == false then
                local suc = love.system.openURL("file://" .. love.filesystem.getSaveDirectory() .. "/Mods/"--[[ .. mods[self.modHoveredId] .. ".lua"]])
                if not suc then print("Could not open file: " .. "file://" .. love.filesystem.getSaveDirectory() .. "/Mods/"--[[ .. mods[self.modHoveredId]]) end
            end
            if love.mouse.isDown(2) and LastRightMouseButton == false then
                local suc = love.system.openURL("file://" .. love.filesystem.getSaveDirectory() .. "/Mods/" .. mods[self.modHoveredId] .. ".lua")
                if not suc then print("Could not open file: " .. "file://" .. love.filesystem.getSaveDirectory() .. "/Mods/" .. mods[self.modHoveredId]) end
            end
        else
            self.currentModScaleAdd = Lume.lerp(self.currentModScaleAdd, 0, 0.2)
        end


        if self.returnButton.pressed then
            changeRoom(rooms.mainMenu)
            self.returnButton.pressed = false
        end


        self.oldModHoveredId = self.modHoveredId
    end


    function m:draw()
        drawGrass()


        drawOutlinedText("Loaded Mods: ", 800 / 2, 16, 0.1 * math.cos(GlobalSinAngle), 2, 2, nil, nil, 2, {0, 0, 0})


        local hoveredOne = false
        local hoverId = 0
        for m=1, #mods do
            local textWidth = love.graphics.getFont():getWidth(mods[m])
            local textHeight = love.graphics.getFont():getHeight(mods[m])
            local scale = 2

            if m == self.modHoveredId then
                scale = 2 + self.currentModScaleAdd
            end

            drawOutlinedText(mods[m], 800 / 2, 16 + 32 * m, 0.1 * math.sin(GlobalSinAngle), scale, scale, nil, nil, 2, {0, 0, 0})


            if PushsInGameMousePos.x > (800 / 2) - (textWidth / 2) * 2 and PushsInGameMousePos.x < ((800 / 2) - (textWidth / 2) * 2) + textWidth * 2 and PushsInGameMousePos.y > (16 + 32 * m) - (textHeight / 2) * 2 and PushsInGameMousePos.y < ((16 + 32 * m) - (textHeight / 2) * 2) + textHeight * 2 then
                if not self.hoveringOneMod then self.currentModScaleAdd = 0 end
                hoveredOne = true
                hoverId = m
            end
        end

        
        if hoveredOne then
            self.hoveringOneMod = true
            if self.modHoveredId ~= hoverId then
                self.modHoveredId = hoverId
            end
        else
            self.hoveringOneMod = false
        end


        if #mods == 0 then
            drawOutlinedText("None", 800 / 2, 64, 0.05 * math.sin(GlobalSinAngle), 4, 4, nil, nil, 2, {0, 0, 0})
        end


        drawOutlinedTextF("Please put your mods in the " .. '"' .. love.filesystem.getSaveDirectory() .. "/Mods/" .. '"' .. " folder", 8, 8, 128, "center", 0, 2, 2, 0, 0, 2, {0, 0, 0})
    end


    modManagerInstance = m
end


modManagerInstance = nil