function createStartThing()
    local s = {
        myLogo = love.graphics.newImage("Sprs/Logos/Me.png"),
        loveLogo = love.graphics.newImage("Sprs/Logos/love.png"),
        currentLogo = 0,
        logoAlpha = 0,
        logoRot = 16,
        logoScale = 0,
        blackBarsProgress = 0,
        oldAccKey = false,
        tweens = Flux.group(),
    }


    function s:init()
        self.tweens:to(self, 1, {logoAlpha=1, logoRot=0, logoScale=0.1}):ease("expoout"):after(self, 1, {logoRot=16, logoScale=0, blackBarsProgress=1}):ease("expoin"):oncomplete(s.gotoNextLogo):delay(3)
    end


    function s:gotoNextLogo()
        s.currentLogo = s.currentLogo + 1
        s.tweens:to(s, 1, {logoRot=0, logoScale=0.5}):ease("expoout"):after(s, 0, {}):delay(3):oncomplete(s.gotoMainMenu)
    end


    function s:gotoMainMenu()
        rm = rooms.mainMenu
        s.tweens:to(s, 1, {logoRot=16, logoScale=0, blackBarsProgress=1}):ease("expoin"):oncomplete(s.removeFluxShit):oncomplete(setRoom)
    end


    function s:removeFluxShit()
        s.tweens = nil
    end


    function s:update()
        if (love.keyboard.isDown("space", "return") and self.oldAccKey == false) or (love.mouse.isDown(1) and LastLeftMouseButton == false) then
            if self.currentLogo == 0 then
                s:gotoNextLogo()
            else
                s:gotoMainMenu()
            end
        end


        self.blackBarsProgress = Lume.lerp(self.blackBarsProgress, 0.25 + 0.1 * math.sin(GlobalSinAngle), 0.1)
        self.logoScale = self.logoScale + 0.0001 * math.cos(GlobalSinAngle * 4)
        self.logoRot = Lume.lerp(self.logoRot, 0.1 * math.cos(GlobalSinAngle * 8), 0.1)
        self.oldAccKey = love.keyboard.isDown("space", "return")
        if self.tweens ~= nil then
            self.tweens:update(globalDt)
        end
    end


    function s:draw()
        drawGrass()


        love.graphics.setColor({0, 0, 0})
            love.graphics.rectangle("fill", -8, 0, 816, (600 / 2) * self.blackBarsProgress)
            love.graphics.rectangle("fill", -8, 600 - ((600 / 2) * (self.blackBarsProgress)), 816, 600 / 2)
        love.graphics.setColor({1, 1, 1})
            love.graphics.rectangle("line", -8, 0, 816, (600 / 2) * self.blackBarsProgress)
            love.graphics.rectangle("line", -8, 600 - ((600 / 2) * (self.blackBarsProgress)), 816, 600 / 2)


        love.graphics.setColor(1, 1, 1, self.logoAlpha)
            if self.currentLogo == 0 then
                love.graphics.draw(self.myLogo, 800 / 2, 600 / 2, self.logoRot, self.logoScale, self.logoScale, self.myLogo:getWidth() / 2, self.myLogo:getHeight() / 2)
                local scalePerc = self.logoScale / 0.1
                drawOutlinedText("Made by Deri LULZZ", 800 / 2, 200, 0, 4 * scalePerc, 4 * scalePerc, love.graphics.getFont():getWidth("Made by Deri LULZZ") / 2, love.graphics.getFont():getHeight("Made by Deri LULZZ") / 2, 4, {0, 0, 0})
            elseif self.currentLogo == 1 then
                drawOutlinedSprite(self.loveLogo, 800 / 2, 600 / 2, self.logoRot, self.logoScale, self.logoScale, self.loveLogo:getWidth() / 2, self.loveLogo:getHeight() / 2, 4, {0, 0, 0})
                local scalePerc = self.logoScale / 0.5
                drawOutlinedText("Made with Love2D", 800 / 2, 200, 0, 4 * scalePerc, 4 * scalePerc, love.graphics.getFont():getWidth("Made with Love2D") / 2, love.graphics.getFont():getHeight("Made with Love2D") / 2, 4, {0, 0, 0})
            end
        love.graphics.setColor(1, 1, 1, 1)
    end


    s:init()
    return s
end

startThingInstance = nil