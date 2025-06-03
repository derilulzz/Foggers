

function getRandomNumber(minNumber, maxNumber)
    return (maxNumber * math.random()) - (minNumber * math.random())
end
function colorLerp(cStart, cEnd, force)
    local c = cStart or {1, 1, 1, 1}
    local cE = cEnd or {1, 1, 1, 1}

    c[1] = Lume.lerp(c[1], cE[1], force)
    c[2] = Lume.lerp(c[2], cE[2], force)
    c[3] = Lume.lerp(c[3], cE[3], force)
    c[4] = Lume.lerp(c[4], cE[4], force)


    return c
end