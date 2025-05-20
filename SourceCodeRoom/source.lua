function createSourceInfo()
    local sInf = {
        licence = "MIT-licence",
        gitUrl = "https://github.com/derilulzz/Foggers",
        openGitButton = createButton(800 / 2, 600 / 2, 128, 64, "Goto Source Code", "Open the git web page of the project", true),
        returnButton = createButton(800 / 2, (600 / 2) + 64 + 8, 128, 64, "Return", "", true),
    }


    function sInf:update()
        if self.openGitButton.pressed then
            love.system.openURL(self.gitUrl)
            self.openGitButton.pressed = false
        end
        if self.returnButton.pressed then
            changeRoom(rooms.mainMenu)
            self.returnButton.pressed = false
        end
    end


    function sInf:draw()
        drawGrass()


        drawOutlinedText("Source Code", 800 / 2, 16 + 8, 0.1 * math.sin(GlobalSinAngle), 4, 4, nil, nil, 2, {0, 0, 0})
        drawOutlinedTextF("All the game's code is under the MIT licence, that means you can do whatever you want with the game, the only thing you CANT do is say that you creted the original game", 800 / 2, 32 + 64, 800 / 2, "center", 0.01 * math.sin(GlobalSinAngle), 2, 2, nil, nil, 2, {0, 0, 0})
    end


    sourceInfoInstance = sInf
end


sourceInfoInstance = nil