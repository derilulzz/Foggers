function newAnimation(image, width, height, framesH, framesV, speed, replayType)
    if speed == nil then
        speed = 8
    end
    if replayType == nil then
        replayType = 0
    end


    local animation = {}
    framesH = framesH or 0
    framesV = framesV or 0
    animation.spriteSheet = image;
    animation.quads = {};
    animation.currentFrame = 1
    animation.sprWidth = width
    animation.sprHeight = height
    animation.speed = speed
    animation.replayType = replayType
    animation.finished = false


    function animation:reset()
        self.currentFrame = 1
        self.finished = false
    end

    for y = 0, framesV do
        for x = 0, framesH do
            table.insert(animation.quads,
                love.graphics.newQuad(width * x, height * y, width, height, image:getDimensions()))
        end
    end


    animation.totalFrames = #animation.quads + 1
    animation.duration = (#animation.quads + 1) / speed


    function animation:update(dt)
        if math.ceil(self.currentFrame) >= #self.quads + 1 then
            if self.replayType == 0 then
                self.currentFrame = 0
            else
                self.finished = true
            end
        end


        self.currentFrame = self.currentFrame + self.speed * dt
    end

    function animation:draw(rot, x, y, sx, sy, ox, oy, outlineSize, outlineColor)
        local spriteNum = 1


        if #self.quads ~= 0 then
            spriteNum = Lume.clamp(math.ceil(self.currentFrame), 1, #animation.quads)
        end
        if ox == nil then
            ox = width / 2
        end
        if oy == nil then
            oy = height / 2
        end


        if outlineSize == nil then
            love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], x, y, rot, sx, sy, ox, oy)
        else
            drawOutlinedSpriteQuad(animation.spriteSheet, animation.quads[spriteNum], x, y, rot, sx, sy, ox, oy,
                outlineSize, outlineColor)
        end
    end

    function animation:drawFrame(whatFrame, rot, x, y, sx, sy, ox, oy, outlineSize, outlineColor)
        local spriteNum = math.floor(whatFrame)


        if spriteNum > #animation.quads then
            spriteNum = 1
        end


        if ox == nil then
            ox = width / 2
        end
        if oy == nil then
            oy = height / 2
        end


        if outlineSize == nil then
            love.graphics.draw(animation.spriteSheet, animation.quads[Lume.clamp(spriteNum, 1, #animation.quads)], x, y, rot, sx, sy, ox, oy)
        else
            drawOutlinedSpriteQuad(animation.spriteSheet, animation.quads[spriteNum], x, y, rot, sx, sy, ox, oy,
                outlineSize, outlineColor)
        end
    end

    return animation
end

function isAnimation(what)
    return what.spriteSheet ~= nil
end
