

grassSpr = love.graphics.newImage("Sprs/Bgs/Grass.png")
roadSpr = love.graphics.newImage("Sprs/Bgs/Road.png")
roadSideSpr = love.graphics.newImage("Sprs/Bgs/Grass2.png")


function drawGrass()
    local tileSize = {x = grassSpr:getWidth() * 2, y = grassSpr:getHeight() * 2}


    for x=-8, math.floor(800 / tileSize.x) + 8 do
        for y=-8, math.floor(600 / tileSize.y) + 8 do
            if isPointInsideCam(tileSize.x * x, tileSize.y * y) then
                love.graphics.draw(grassSpr, tileSize.x * x, tileSize.y * y, 0, 2, 2)
            end
        end
    end
end


function drawRoad()
    for i=0, (Push:getHeight() / carGridLockDist) - 1 do
        for x=-8, math.floor(800 / (roadSpr:getWidth() * 3)) + 8 do
            if isPointInsideCam(((roadSpr:getWidth() * 3) * x), (carGridLockDist * i)) then
                love.graphics.draw(roadSpr, ((roadSpr:getWidth() * 3) * x), (carGridLockDist * i), 0, 3, 3)
            end
        end
    end
end


function drawRoadSide()
    for x=-8, (800 / (roadSideSpr:getWidth() * 2)) + 8 do
        if isPointInsideCam((roadSideSpr:getWidth() * 2) * x, 600 - (roadSideSpr:getHeight() * 2)) then
            love.graphics.draw(roadSideSpr, (roadSideSpr:getWidth() * 2) * x, 600 - (roadSideSpr:getHeight() * 2), 0, 2, 2)
        end
    end
end