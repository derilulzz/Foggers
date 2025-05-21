function createStartThing()
    local s = {
        myLogo = love.graphics.newImage("Sprs/Logos/Me.png"),
        loveLogo = love.graphics.newImage("Sprs/Logos/love.png"),
        currentLogo = 0,
        logoAlpha = 0,
        logoRot = 16,
        logoScale = 0,
        blackBarsProgress = 1,
        state = 0,
        nextStateTimer = 5,
        oldAccKey = false,
        blackbarsWhiteLineAlpha = 1,
    }


    function s:init()
        playMusic(1)
    end


    function s:update()
        if (love.keyboard.isDown("space", "return") and self.oldAccKey == false) or (love.mouse.isDown(1) and LastLeftMouseButton == false) then
            if self.state < 3 then
                self.state = self.state + 1
            end
        end


        if self.state == 0 then
            self.currentLogo = 0
            self.logoScale = Lume.lerp(self.logoScale, 0.1, 0.1)
            self.logoRot = Lume.lerp(self.logoRot, 0, 0.1)
            self.logoAlpha = Lume.lerp(self.logoAlpha, 1, 0.1)
            self.blackBarsProgress = Lume.lerp(self.blackBarsProgress, 0, 0.15)
        elseif self.state == 1 then
            self.logoScale = Lume.lerp(self.logoScale, 0, 0.1)
            self.logoRot = Lume.lerp(self.logoRot, 16, 0.1)
            self.logoAlpha = Lume.lerp(self.logoAlpha, 0, 0.1)
            self.blackBarsProgress = Lume.lerp(self.blackBarsProgress, 1, 0.15)
            if self.blackBarsProgress >= 0.999 then self.state = self.state + 1; self.nextStateTimer = 5 end
        elseif self.state == 2 then
            self.currentLogo = 1
            self.logoScale = Lume.lerp(self.logoScale, 0.5, 0.1)
            self.logoRot = Lume.lerp(self.logoRot, 0, 0.1)
            self.logoAlpha = Lume.lerp(self.logoAlpha, 1, 0.1)
            self.blackBarsProgress = Lume.lerp(self.blackBarsProgress, 0, 0.15)
        elseif self.state == 3 then
            self.logoScale = Lume.lerp(self.logoScale, 0, 0.1)
            self.logoRot = Lume.lerp(self.logoRot, 16, 0.1)
            self.logoAlpha = Lume.lerp(self.logoAlpha, 0, 0.1)
            self.blackBarsProgress = Lume.lerp(self.blackBarsProgress, 1, 0.15)
            if self.blackBarsProgress >= 0.999 then self.state = self.state + 1; self.nextStateTimer = 5 end
        end
        if self.state == 4 then
            if self.blackBarsProgress >= 0.999 then self.blackbarsWhiteLineAlpha = Lume.lerp(self.blackbarsWhiteLineAlpha, 0, 0.2) end
            
            
            if self.blackbarsWhiteLineAlpha <= 0.01 then
                rm = rooms.mainMenu
                setRoom()
            end
        end


        if self.nextStateTimer <= 0 then self.state = self.state + 1; self.nextStateTimer = 5 end


        if self.state ~= 1 and self.state ~= 3 and self.state ~= 4 then
            self.blackBarsProgress = Lume.lerp(self.blackBarsProgress, 0.25 + 0.1 * math.sin(GlobalSinAngle), 0.1)
        end
        self.logoScale = self.logoScale + 0.0001 * math.cos(GlobalSinAngle * 4)
        self.logoRot = self.logoRot + 0.025 * math.cos(GlobalSinAngle * 4)
        self.oldAccKey = love.keyboard.isDown("space", "return")
        self.nextStateTimer = self.nextStateTimer - 1 * globalDt


        self.state = Lume.clamp(self.state, 0, 4)
    end


    function s:draw()
        drawGrass()


        love.graphics.setColor(1, 1, 1, self.logoAlpha)
            if self.currentLogo == 0 then
                local text = "Made by Deri LULZZ"
                if gameStuff.lang == "pt-br" then text = "Criado por Deri LULZZ" end
                love.graphics.draw(self.myLogo, 800 / 2, 600 / 2, self.logoRot, self.logoScale, self.logoScale, self.myLogo:getWidth() / 2, self.myLogo:getHeight() / 2)
                local scalePerc = self.logoScale / 0.1
                drawOutlinedText(text, 800 / 2, 200, 0, 4 * scalePerc, 4 * scalePerc, love.graphics.getFont():getWidth(text) / 2, love.graphics.getFont():getHeight(text) / 2, 4, {0, 0, 0, self.logoAlpha})
            elseif self.currentLogo == 1 then
                local text = "Made using Love2D"
                if gameStuff.lang == "pt-br" then text = "Criado usando Love2D" end
                drawOutlinedSprite(self.loveLogo, 800 / 2, 600 / 2, self.logoRot, self.logoScale, self.logoScale, self.loveLogo:getWidth() / 2, self.loveLogo:getHeight() / 2, 4, {0, 0, 0, self.logoAlpha})
                local scalePerc = self.logoScale / 0.5
                drawOutlinedText(text, 800 / 2, 200, 0, 4 * scalePerc, 4 * scalePerc, love.graphics.getFont():getWidth(text) / 2, love.graphics.getFont():getHeight(text) / 2, 4, {0, 0, 0, self.logoAlpha})
            end
        love.graphics.setColor(1, 1, 1, 1)


        love.graphics.setColor({0, 0, 0})
            love.graphics.rectangle("fill", -8, 0, 816, (600 / 2) * self.blackBarsProgress)
            love.graphics.rectangle("fill", -8, 600 - ((600 / 2) * (self.blackBarsProgress)), 816, 600 / 2)
        love.graphics.setColor({1, 1, 1, self.blackbarsWhiteLineAlpha})
            love.graphics.rectangle("line", -8, 0, 816, (600 / 2) * self.blackBarsProgress)
            love.graphics.rectangle("line", -8, 600 - ((600 / 2) * (self.blackBarsProgress)), 816, 600)
        

        if debugStuff.enabled then
            drawOutlinedText(tostring(self.blackBarsProgress), 128, 8, 0, 2, 2, 0, 0, 4, {0, 0, 0})
            drawOutlinedText(tostring(self.state), 128, 8 + 32, 0, 2, 2, 0, 0, 4, {0, 0, 0})
        end
    end


    s:init()


    return s
end

startThingInstance = nil