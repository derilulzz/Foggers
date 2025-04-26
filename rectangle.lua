function createRectangle(_x, _y, _w, _h)
    local r = {
        x = _x,
        y = _y,
        w = _w,
        h = _h,
    }


    function r:checkCollision(otherRect)
        local left = math.max(self.x, otherRect.x)
        local right = math.min(self.x + self.w, otherRect.x + otherRect.w)
        local top = math.max(self.y, otherRect.y)
        local bottom = math.min(self.y + self.h, otherRect.y + otherRect.h)
    
        return right > left and bottom > top
    end


    function r:draw(c)
        if c == nil then
            c = {1, 1, 1}
        end

        local oldC = {love.graphics.getColor()}

        love.graphics.setColor(c)

        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

        love.graphics.setColor(oldC)
    end


    return r
end