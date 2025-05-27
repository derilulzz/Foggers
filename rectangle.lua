function createRectangle(_x, _y, _w, _h)
    local r = {
        x = _x,
        y = _y,
        w = _w,
        h = _h,
    }


    function r:checkCollision(otherRect)
        return self.x < otherRect.x+otherRect.w and
         otherRect.x < self.x + self.w and
         self.y < otherRect.y + otherRect.h and
         otherRect.y < self.y + self.h
    end


    function r:checkCollisionAdv(otherRect, xAdd, yAdd)
        local x = self.x + xAdd
        local y = self.y + yAdd


        return x < otherRect.x+otherRect.w and
         otherRect.x < x + self.w and
         y < otherRect.y + otherRect.h and
         otherRect.y < y + self.h
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