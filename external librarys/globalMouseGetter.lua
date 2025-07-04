-- desktop coordinate related functions
-- by zorg @ 2015-2016
-- license: ISC


--CODE PASSED THRO DEEP SEEK BECAUSE IM TOO DUMB TO USE SDL2 AND C WITH LUA. -Deri LULZZ :)


local ffi = require("ffi")
local sdl_handle = false  -- Will hold loaded SDL2 handle

-- Define all needed SDL functions
ffi.cdef[[
    typedef uint32_t Uint32;
    typedef int32_t Sint32;
    
    typedef struct SDL_Rect
    {
        Sint32 x, y;
        Sint32 w, h;
    } SDL_Rect;

    Uint32 SDL_GetGlobalMouseState(int *x, int *y);
    int SDL_GetNumVideoDisplays(void);
    int SDL_GetDisplayBounds(int displayIndex, SDL_Rect* rect);
    int SDL_WarpMouseGlobal(int x, int y);
]]

-- Platform-specific SDL2 library names
local function load_sdl()
    if sdl_handle ~= false then  -- Already attempted loading?
        return sdl_handle ~= nil
    end

    local libnames = {
        Windows = {"SDL2.dll"},
        OSX = {"libSDL2-2.0.dylib", "libSDL2.dylib", "SDL2.framework/SDL2"},
        Other = {"libSDL2-2.0.so.0", "libSDL2-2.0.so", "libSDL2.so", "SDL2"}
    }

    local names = libnames[ffi.os] or libnames.Other
    for _, name in ipairs(names) do
        local ok, lib = pcall(ffi.load, name)
        if ok then
            sdl_handle = lib
            return true
        end
    end

    sdl_handle = nil
    return false
end

-- Function holder table
local t = {}

-- Convert display-local coords to desktop-space
t.toGlobalPosition = function(D, x, y, d)
    assert(D[d], "Given display index doesn't exist!")
    return D[d][1] + x, D[d][2] + y
end

-- Convert desktop coords to display-local
t.toScreenPosition = function(D, x, y)
    local minx, miny, maxx, maxy = math.huge, math.huge, -math.huge, -math.huge
    local w, h = love.graphics.getDimensions()

    -- Calculate desktop bounds
    for i = 1, #D do
        minx = math.min(minx, D[i][1])
        miny = math.min(miny, D[i][2])
        maxx = math.max(maxx, D[i][1] + D[i][3])
        maxy = math.max(maxy, D[i][2] + D[i][4])
    end

    -- Boundary checks
    if x < minx then return -1, 0, false end
    if x > maxx then return 1, 0, false end
    if y < miny then return 0, -1, false end
    if y > maxy then return 0, 1, false end

    -- Find containing display
    for i = 1, #D do
        local disp = D[i]
        if x >= disp[1] and x < disp[1] + disp[3] and
           y >= disp[2] and y < disp[2] + disp[4] then
            return x - disp[1], y - disp[2], i
        end
    end

    return 0, 0, false  -- Shouldn't happen
end


t.setGlobalMousePosition = function(self, x, y)
    if not load_sdl() then return false end
    
    -- Add type checking and conversion
    if type(x) ~= "number" then
        x = tonumber(x) or 0
    end
    if type(y) ~= "number" then
        y = tonumber(y) or 0
    end
    
    return sdl_handle.SDL_WarpMouseGlobal(x, y) == 0
end


-- Get desktop mouse position
t.getGlobalMousePosition = function()
    if not load_sdl() then return false end  -- SDL load failed
    local x, y = ffi.new("int[1]"), ffi.new("int[1]")
    sdl_handle.SDL_GetGlobalMouseState(x, y)
    return x[0], y[0]
end

local mt = {__index = t}

-- Constructor
local new = function()
    local D = {}
    
    -- Load SDL if not already loaded
    if not load_sdl() then
        error("Could not load SDL2 library for display info")
    end

    -- Get number of displays (SDL uses 0-based index)
    local displayCount = sdl_handle.SDL_GetNumVideoDisplays()
    if displayCount < 1 then
        error("No displays found")
    end

    -- Get bounds for each display
    for i = 0, displayCount - 1 do
        local rect = ffi.new("SDL_Rect")
        if sdl_handle.SDL_GetDisplayBounds(i, rect) == 0 then
            D[#D + 1] = {rect.x, rect.y, rect.w, rect.h}
        else
            print("Warning: Failed to get bounds for display " .. tostring(i))
        end
    end

    return setmetatable(D, mt)
end

return new