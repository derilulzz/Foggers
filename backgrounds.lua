

grassSpr = love.graphics.newImage("Sprs/Bgs/Grass.png")
roadSpr = love.graphics.newImage("Sprs/Bgs/Road.png")
roadSideSpr = love.graphics.newImage("Sprs/Bgs/Grass2.png")
roadSideSprExtend = love.graphics.newImage("Sprs/Bgs/Grass2Continue.png")


function drawGrass()
    local tileSize = {x = grassSpr:getWidth() * 2, y = grassSpr:getHeight() * 2}


    for x=-8, math.floor(800 / tileSize.x) + 16 do
        for y=-8, math.floor(600 / tileSize.y) + 16 do
            if isPointInsideCam(tileSize.x * x, tileSize.y * y) then
                love.graphics.draw(grassSpr, tileSize.x * x, tileSize.y * y, 0, 2, 2)
            end
        end
    end
end


function drawRoad()
    for i=0, (Push:getHeight() / carGridLockDist) - 1 do
        for x=-16, math.floor(800 / (roadSpr:getWidth() * 3)) + 16 do
            if isPointInsideCam(((roadSpr:getWidth() * 3) * x), (carGridLockDist * i)) then
                love.graphics.draw(roadSpr, ((roadSpr:getWidth() * 3) * x), (carGridLockDist * i), 0, 3, 3)
            end
        end
    end
end


function drawRoadSide()
    for x=-8, (800 / (roadSideSpr:getWidth() * 2)) + 16 do
        for y=0, (64 / (roadSideSpr:getHeight() * 2)) + 8 do
            local spr = roadSideSpr


            if y ~= 0 then spr = roadSideSprExtend end


            if isPointInsideCam((roadSideSpr:getWidth() * 2) * x, 600 - (roadSideSpr:getHeight() * 2)) then
                love.graphics.draw(spr, (roadSideSpr:getWidth() * 2) * x, (600 - (roadSideSpr:getHeight() * 2)) + (roadSideSpr:getHeight() * 2) * y, 0, 2, 2)
            end
        end
    end
end