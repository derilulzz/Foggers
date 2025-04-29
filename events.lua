

function startEvent()
    createEventStartText()
end


function createEventStartText()
    local t = {
        text = "EVENT STARTED",
        scale = 0,
        rot = 6,
        alpha = 0,
    }


    function t:init()
        Flux.to(self, 1, {scale=5, rot=0, alpha=1}):after(self, 1, {scale=0, rot=-6, alpha=0}):delay(1):oncomplete(t.destroy)
    end


    function t:destroy()
        table.remove(gameInstances, tableFind(gameInstances, t))
    end


    function t:draw()
        drawOutlinedText(self.text, 800 / 2, 600 / 2, self.rot, self.scale, self.scale, love.graphics.getFont():getWidth(self.text) / 2, love.graphics.getFont():getHeight(self.text) / 2, 8, {0, 0, 0})
    end


    t:init()


    table.insert(gameInstances, 1, t)
end