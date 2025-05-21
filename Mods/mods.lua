

function createModsManager()
    local m = {
        returnButton = createButton(64 + 8, 600 - 32 - 8, 128, 64, "Return", "", true),
    }


    function m:update()
        if tableFind(UiStuff, self.returnButton) == -1 then self.returnButton = createButton(64 + 8, 600 - 32 - 8, 128, 64, "Return", "", true) end


        if gameStuff.lang == "pt-br" then
            self.returnButton.text = "Voltar"
        else
            self.returnButton.text = "Return"
        end


        if self.returnButton.pressed then
            changeRoom(rooms.mainMenu)
            self.returnButton.pressed = false
        end
    end


    function m:draw()
        drawGrass()


        drawOutlinedText("Loaded Mods: ", 800 / 2, 16, 0.1 * math.cos(GlobalSinAngle), 2, 2, nil, nil, 2, {0, 0, 0})


        for m=1, #mods do
            drawOutlinedText(mods[m], 800 / 2, 16 + 32 * m, 0.1 * math.sin(GlobalSinAngle), 2, 2, nil, nil, 2, {0, 0, 0})
        end
        if #mods == 0 then
            drawOutlinedText("None", 800 / 2, 64, 0.05 * math.sin(GlobalSinAngle), 4, 4, nil, nil, 2, {0, 0, 0})
        end


        drawOutlinedTextF("Please put your mods in the " .. '"' .. love.filesystem.getSaveDirectory() .. "/Mods/" .. '"' .. " folder", 8, 8, 128, "center", 0, 2, 2, 0, 0, 2, {0, 0, 0})
    end


    modManagerInstance = m
end


modManagerInstance = nil