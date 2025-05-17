function newAnimation(image, width, height, frames, speed, replayType)
    if speed == nil then
        speed = 8
    end
    if replayType == nil then
        replayType = 0
    end


    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};
    animation.currentFrame = 1
    animation.sprWidth = width
    animation.sprHeight = height
    animation.speed = speed
    animation.replayType = replayType
    animation.finished = false


    animation.totalFrames = frames + 1
    animation.duration = frames / speed

    
    for x = 0, frames do
        table.insert(animation.quads, love.graphics.newQuad(
            width * x, 0, width, height, image:getDimensions()
        ))
    end

    -- Reset animation (e.g., for replaying)
    function animation:reset()
        self.currentFrame = 1
        self.finished = false
        self.startTime = love.timer.getTime()
        self.endTime = self.startTime + self.duration
    end


    for x = 0, frames do
        table.insert(animation.quads, love.graphics.newQuad(width * x, 0, width, height, image:getDimensions()))
    end


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
            drawOutlinedSpriteQuad(animation.spriteSheet, animation.quads[spriteNum], x, y, rot, sx, sy, ox, oy, outlineSize, outlineColor)
        end
    end


    return animation
end