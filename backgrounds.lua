

grassSpr = love.graphics.newImage("Sprs/Bgs/Grass.png")
roadSpr = love.graphics.newImage("Sprs/Bgs/Road.png")
roadSideSpr = love.graphics.newImage("Sprs/Bgs/Grass2.png")
roadSideSprExtend = love.graphics.newImage("Sprs/Bgs/Grass2Continue.png")
grassCanvas = love.graphics.newCanvas(800 * 1.5, 600 * 1.5)
roadCanvas = love.graphics.newCanvas(800 * 1.5, 600 * 1.5)
roadSideCanvas = love.graphics.newCanvas(800 * 1.5, 600 * 1.5)


function initBackgronds()
    love.graphics.setCanvas(grassCanvas)
        drawGrassToCanvas()
    love.graphics.setCanvas()
    love.graphics.setCanvas(roadCanvas)
        drawRoadToCanvas()
    love.graphics.setCanvas()
    love.graphics.setCanvas(roadSideCanvas)
        drawRoadSideToCanvas()
    love.graphics.setCanvas()
end


function drawGrass()
    love.graphics.draw(grassCanvas)
end


function drawGrassToCanvas()
    local tileSize = {x = grassSpr:getWidth() * 2, y = grassSpr:getHeight() * 2}


    for x=-8, math.floor(grassCanvas:getWidth() / tileSize.x) + 16 do
        for y=-8, math.floor(grassCanvas:getHeight() / tileSize.y) + 16 do
            if isPointInsideCam(tileSize.x * x, tileSize.y * y) then
                love.graphics.draw(grassSpr, tileSize.x * x, tileSize.y * y, 0, 2, 2)
            end
        end
    end
end


function drawRoad()
    love.graphics.draw(roadCanvas)
end


function drawRoadToCanvas()
    for i=0, (Push:getHeight() / carGridLockDist) - 1 do
        for x=-16, math.floor(roadCanvas:getWidth() / (roadSpr:getWidth() * 3)) + 16 do
            if isPointInsideCam(((roadSpr:getWidth() * 3) * x), (carGridLockDist * i)) then
                love.graphics.draw(roadSpr, ((roadSpr:getWidth() * 3) * x), (carGridLockDist * i), 0, 3, 3)
            end
        end
    end
end


function drawRoadSide()
    love.graphics.draw(roadSideCanvas)
end


function drawRoadSideToCanvas()
    for x=-8, (roadSideCanvas:getWidth() / (roadSideSpr:getWidth() * 2)) + 16 do
        for y=0, (64 / (roadSideSpr:getHeight() * 2)) + 8 do
            local spr = roadSideSpr


            if y ~= 0 then spr = roadSideSprExtend end


            if isPointInsideCam((roadSideSpr:getWidth() * 2) * x, roadSideCanvas:getHeight() - (roadSideSpr:getHeight() * 2)) then
                love.graphics.draw(spr, (roadSideSpr:getWidth() * 2) * x, (roadSideCanvas:getHeight() - (roadSideSpr:getHeight() * 2)) + (roadSideSpr:getHeight() * 2) * y, 0, 2, 2)
            end
        end
    end
end