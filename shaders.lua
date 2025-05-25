local colorSetterShader = love.graphics.newShader("Shaders/setColor.fs")

local function processOutlineColor(color)
    if not color then
        return {0, 0, 0, 1}
    end
    return {
        color[1] or 0,
        color[2] or 0,
        color[3] or 0,
        color[4] or 1
    }
end

local Dirs = {
    {x=0,  y=-1},
    {x=-1, y=0},
    {x=0,  y=1},
    {x=1,  y=0},
}

function drawOutlinedSprite(drawable, x, y, r, sx, sy, ox, oy, outlineSize, outlineColor)
    if not drawable then return end
    if not gameStuff.drawOutlines then
        love.graphics.draw(drawable, x, y, r, sx, sy, ox or drawable:getWidth()/2, oy or drawable:getHeight()/2)
        return
    end
    
    ox = ox or drawable:getWidth() / 2
    oy = oy or drawable:getHeight() / 2
    outlineColor = processOutlineColor(outlineColor)
    local currentColor = {love.graphics.getColor()}

    colorSetterShader:send("colorToSet", outlineColor)
    love.graphics.setShader(colorSetterShader)
    love.graphics.setColor(outlineColor)

    while outlineSize > 0 do
        for _, dir in ipairs(Dirs) do
            local addX = dir.x * outlineSize
            local addY = dir.y * outlineSize
            love.graphics.draw(drawable, x + addX, y + addY, r, sx, sy, ox, oy)
        end
        outlineSize = outlineSize - 8
    end

    love.graphics.setShader()
    love.graphics.setColor(currentColor)
    love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy)
end

function drawOutlinedSpriteQuad(drawable, quad, x, y, r, sx, sy, ox, oy, outlineSize, outlineColor)
    if not drawable or not quad then return end
    if not gameStuff.drawOutlines then
        love.graphics.draw(drawable, quad, x, y, r, sx, sy, ox or drawable:getWidth()/2, oy or drawable:getHeight()/2)
        return
    end

    ox = ox or drawable:getWidth() / 2
    oy = oy or drawable:getHeight() / 2
    local currentColor = {love.graphics.getColor()}
    local processedOutlineColor = processOutlineColor(outlineColor)

    colorSetterShader:send("colorToSet", processedOutlineColor)
    love.graphics.setShader(colorSetterShader)
    love.graphics.setColor(processedOutlineColor)

    while outlineSize > 0 do
        for _, dir in ipairs(Dirs) do
            local addX = dir.x * outlineSize
            local addY = dir.y * outlineSize
            love.graphics.draw(drawable, quad, x + addX, y + addY, r, sx, sy, ox, oy)
        end
        outlineSize = outlineSize - 8
    end

    love.graphics.setShader()
    love.graphics.setColor(currentColor)
    love.graphics.draw(drawable, quad, x, y, r, sx, sy, ox, oy)
end

function drawOutlinedText(text, x, y, r, sx, sy, ox, oy, outlineSize, outlineColor)
    if not text or text == "" then return end
    if not gameStuff.drawOutlines then
        love.graphics.print(text, x, y, r, sx, sy, ox, oy)
        return
    end

    outlineSize = outlineSize or 1 * (sx or 1)
    outlineColor = processOutlineColor(outlineColor)
    local currentColor = {love.graphics.getColor()}
    local font = love.graphics.getFont()
    ox = ox or font:getWidth(text) / 2
    oy = oy or font:getHeight() / 2

    love.graphics.push("all")
    love.graphics.setShader(colorSetterShader)
    colorSetterShader:send("colorToSet", outlineColor)

    while outlineSize > 0 do
        for _, dir in ipairs(Dirs) do
            love.graphics.setColor(outlineColor)
            local addX = dir.x * outlineSize
            local addY = dir.y * outlineSize
            love.graphics.print(text, x + addX, y + addY, r, sx, sy, ox, oy)
        end
        outlineSize = outlineSize - 1
    end
    love.graphics.pop()

    love.graphics.setColor(currentColor)
    love.graphics.print(text, x, y, r, sx, sy, ox, oy)
end

function drawOutlinedTextF(text, x, y, limit, align, r, sx, sy, ox, oy, outlineSize, outlineColor)
    if not text or text == "" then return {w=0, h=0} end
    if not gameStuff.drawOutlines then
        local wrap = {love.graphics.getFont():getWrap(text, limit)}
        love.graphics.printf(text, x, y, limit, align, r, sx, sy, ox, oy)
        return {w=limit, h=love.graphics.getFont():getHeight() * #wrap[2]}
    end

    outlineSize = outlineSize or 1 * (sx or 1)
    outlineColor = processOutlineColor(outlineColor)
    local currentColor = {love.graphics.getColor()}
    local font = love.graphics.getFont()
    local wrap = {font:getWrap(text, limit)}
    ox = ox or limit / 2
    oy = oy or (font:getHeight() * #wrap[2]) / 2

    love.graphics.push("all")
    colorSetterShader:send("colorToSet", outlineColor)
    love.graphics.setShader(colorSetterShader)
    
    while outlineSize > 0 do
        for _, dir in ipairs(Dirs) do
            local addX = dir.x * outlineSize
            local addY = dir.y * outlineSize
            love.graphics.printf(text, x + addX, y + addY, limit, align, r, sx, sy, ox, oy)
        end
        outlineSize = outlineSize - 1
    end
    love.graphics.pop()

    love.graphics.setColor(currentColor)
    love.graphics.printf(text, x, y, limit, align, r, sx, sy, ox, oy)

    return {w=limit, h=font:getHeight() * #wrap[2]}
end

function drawOutlinedRect(x, y, width, height, outlineColor)
    local currentColor = {love.graphics.getColor()}
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.setColor(processOutlineColor(outlineColor))
    love.graphics.rectangle("line", x, y, width, height)
    love.graphics.setColor(currentColor)
end