function createRectangle(_x, _y, _w, _h)
    local r = {
        x = _x,
        y = _y,
        w = _w,
        h = _h,
    }


    function r:checkCollision(otherRect)
        local dx = math.abs(self.x - otherRect.x)
        local dy = math.abs(self.y - otherRect.y)
        local mx = (self.w / 2) + (otherRect.w / 2)
        local my = (self.h / 2) + (otherRect.h / 2)


        return dx < mx and dy < my
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