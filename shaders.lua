colorSetterShader = love.graphics.newShader("Shaders/setColor.fs")


function drawOutlinedSprite(drawable, x, y, r, sx, sy, ox, oy, outlineSize, outlineColor)
    if outlineColor == nil then
        outlineColor = {0, 0, 0, 1}
    else
        for i=1, #outlineColor do
            if outlineColor[i] == nil or type(outlineColor[i]) ~= "number" then
                outlineColor[i] = 1
            end
        end
        if outlineColor[4] == nil then
            outlineColor[4] = 1
        end
    end
    local add = { x = outlineSize, y = outlineSize }
    local currentColor = { love.graphics.getColor() }


    while outlineSize > 0 do
        for rt = 0, 4 do
            if rt == 0 then
                add.x = 0; add.y = -outlineSize
            end
            if rt == 1 then
                add.x = -outlineSize; add.y = 0
            end
            if rt == 2 then
                add.x = 0; add.y = outlineSize
            end
            if rt == 3 then
                add.x = outlineSize; add.y = 0
            end
            if rt == 4 then
                add.x = 0; add.y = 0
            end


            if rt < 4 then
                colorSetterShader:send("colorToSet", outlineColor)
                love.graphics.setShader(colorSetterShader)
                love.graphics.setColor(outlineColor)
            else
                love.graphics.setShader()
                love.graphics.setColor(currentColor)
            end


            love.graphics.draw(drawable, x + add.x, y + add.y, r, sx, sy, ox, oy)
        end


        outlineSize = outlineSize - 8
    end
end

function drawOutlinedSpriteQuad(drawable, quad, x, y, r, sx, sy, ox, oy, outlineSize, outlineColor)
    local add = { x = outlineSize, y = outlineSize }
    local currentColor = { love.graphics.getColor() }
    x = x or 0
    y = y or 0
    text = text or ""
    r = r or 0
    sx = sx or 1
    sy = sy or 1
    ox = ox or drawable:getWidth() / 2
    oy = oy or drawable:getHeight() / 2


    while outlineSize > 0 do
        for rt = 0, 4 do
            if rt == 0 then
                add.x = 0; add.y = -outlineSize
            end
            if rt == 1 then
                add.x = -outlineSize; add.y = 0
            end
            if rt == 2 then
                add.x = 0; add.y = outlineSize
            end
            if rt == 3 then
                add.x = outlineSize; add.y = 0
            end
            if rt == 4 then
                add.x = 0; add.y = 0
            end


            if rt < 4 then
                if outlineColor == nil then
                    love.graphics.setColor({ currentColor[1] / 8, currentColor[2] / 8, currentColor[3] / 8 })
                else
                    love.graphics.setColor(outlineColor)
                end
            else
                love.graphics.setColor(currentColor)
            end


            love.graphics.draw(drawable, quad, x + add.x, y + add.y, r, sx, sy, ox, oy)
        end


        outlineSize = outlineSize - 8
    end
end


function drawOutlinedText(text, x, y, r, sx, sy, ox, oy, outlineSize, outlineColor)
    if outlineColor == nil then
        outlineColor = {0, 0, 0, 1}
    else
        for i=1, #outlineColor do
            if outlineColor[i] == nil or type(outlineColor[i]) ~= "number" then
                outlineColor[i] = 1
            end
        end
        if outlineColor[4] == nil then
            outlineColor[4] = 1
        end
    end
    if outlineSize == nil then outlineSize = 1 * (sx or 1) end
    x = x or 0
    y = y or 0
    text = text or ""
    r = r or 0
    sx = sx or 1
    sy = sy or 1
    ox = ox or love.graphics.getFont():getWidth(text) / 2
    oy = oy or love.graphics.getFont():getHeight(text) / 2


    local add = { x = outlineSize, y = outlineSize }
    local currentColor = { love.graphics.getColor() }


    while outlineSize > 0 do
        for rt = 0, 4 do
            if rt == 0 then
                add.x = 0; add.y = -outlineSize
            end
            if rt == 1 then
                add.x = -outlineSize; add.y = 0
            end
            if rt == 2 then
                add.x = 0; add.y = outlineSize
            end
            if rt == 3 then
                add.x = outlineSize; add.y = 0
            end
            if rt == 4 then
                add.x = 0; add.y = 0
            end


            if rt < 4 then
                if outlineColor then
                    for i=1, #outlineColor do
                        if outlineColor[i] == nil or type(outlineColor[i]) ~= "number" then
                            outlineColor[i] = 1
                        end
                    end


                    love.graphics.setColor(outlineColor)
                else
                    love.graphics.setColor({ currentColor[1] / 8, currentColor[2] / 8, currentColor[3] / 8 })
                end
            else
                love.graphics.setColor(currentColor)
            end


            love.graphics.print(text, x + add.x, y + add.y, r, sx, sy, ox, oy)
        end
        outlineSize = outlineSize - 1
    end
end

function drawOutlinedTextF(text, x, y, limit, align, r, sx, sy, ox, oy, outlineSize, outlineColor)
    local add = { x = outlineSize, y = outlineSize }
    local currentColor = { love.graphics.getColor() }
    x = x or 0
    y = y or 0
    text = text or ""
    r = r or 0
    sx = sx or 1
    sy = sy or 1
    ox = ox or love.graphics.getFont():getWidth(text) / 2
    oy = oy or love.graphics.getFont():getHeight(text) / 2


    while outlineSize > 0 do
        for rt = 0, 4 do
            if rt == 0 then
                add.x = 0; add.y = -outlineSize
            end
            if rt == 1 then
                add.x = -outlineSize; add.y = 0
            end
            if rt == 2 then
                add.x = 0; add.y = outlineSize
            end
            if rt == 3 then
                add.x = outlineSize; add.y = 0
            end
            if rt == 4 then
                add.x = 0; add.y = 0
            end


            if rt < 4 then
                if outlineColor == nil then
                    love.graphics.setColor({ currentColor[1] / 8, currentColor[2] / 8, currentColor[3] / 8 })
                else
                    love.graphics.setColor(outlineColor)
                end
            else
                love.graphics.setColor(currentColor)
            end


            love.graphics.printf(text, x + add.x, y + add.y, limit, align, r, sx, sy, ox, oy)
        end
        outlineSize = outlineSize - 1
    end
end


function drawOutlinedRect(x, y, width, height, outlineColor)
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.setColor(outlineColor)
    love.graphics.rectangle("line", x, y, width, height)
end