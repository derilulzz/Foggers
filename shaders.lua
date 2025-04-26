function drawOutlinedSprite(drawable, x, y, r, sx, sy, ox, oy, outlineSize, outlineColor)
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
                if outlineColor == nil then
                    love.graphics.setColor({ currentColor[1] / 8, currentColor[2] / 8, currentColor[3] / 8 })
                else
                    love.graphics.setColor(outlineColor)
                end
            else
                love.graphics.setColor(currentColor)
            end


            love.graphics.draw(drawable, x + add.x, y + add.y, r, sx, sy, ox, oy)
        end


        outlineSize = outlineSize - 4
    end
end

function drawOutlinedSpriteQuad(drawable, quad, x, y, r, sx, sy, ox, oy, outlineSize, outlineColor)
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


        outlineSize = outlineSize - 4
    end
end

function drawOutlinedText(text, x, y, r, sx, sy, ox, oy, outlineSize, outlineColor)
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
                if outlineColor == nil then
                    love.graphics.setColor({ currentColor[1] / 8, currentColor[2] / 8, currentColor[3] / 8 })
                else
                    love.graphics.setColor(outlineColor)
                end
            else
                love.graphics.setColor(currentColor)
            end


            love.graphics.print(text, x + add.x, y + add.y, r, sx, sy, ox, oy)
        end
        outlineSize = outlineSize - 4
    end
end

function drawOutlinedTextF(text, x, y, limit, align, r, sx, sy, ox, oy, outlineSize, outlineColor)
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
        outlineSize = outlineSize - 4
    end
end
