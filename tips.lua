

function createTipRect()
    local t = {
        pos = {x = 800, y = 600 / 2},
        size = {w = 256, h = 128},
        text = "",
        textHeight = 0,
        tips = {
            "Press shift to quickly speed up or down the game",
            "You can use the numbers in your keyboard to quickly select cars",
            "This game is bad",
        },
        tipsPT = {
            "Aperte shift para rapidamente acelerar ou desacelerar o jogo",
            "Voce pode usar os numeros no seu teclado para rapidamente selecionar carros",
            "Esse jogo e ruim",
        },
        alpha = 1,
    }


    function t:init()
        if gameStuff.lang == "pt-br" then
            self.text = self.tipsPT[math.random(1, #self.tipsPT)]
        else
            self.text = self.tips[math.random(1, #self.tips)]
        end


        local wrap = {love.graphics.getFont():getWrap(self.text, self.size.w / 2)}
        self.textHeight = love.graphics.getFont():getHeight() * #wrap[2]
        self.size.h = (self.textHeight * 2) + 32 + 16 + 8


        self.pos.y = (600 / 2) - (self.size.h / 2)

        
        Flux.to(self.pos, 1, {x = 800 - self.size.w}):ease("expoout"):after(self, 1, {alpha = 0}):delay(2):ease("expoin"):oncomplete(t.destroy)
    end


    function t:destroy()
        table.remove(onTopGameInstaces, tableFind(onTopGameInstaces, t))
    end


    function t:draw()
        love.graphics.setColor({1, 1, 1, self.alpha})
        drawOutlinedRect(self.pos.x, self.pos.y, self.size.w, self.size.h, {0, 0, 0, self.alpha})


        love.graphics.setColor({1, 1, 1, self.alpha})
        local text = "Tip"
        if gameStuff.lang == "pt-br" then text = "Dica" end
        drawOutlinedText(text, self.pos.x + self.size.w / 2, self.pos.y + 8, 0, 2, 2, nil, 0, 4, {0, 0, 0, self.alpha})


        love.graphics.setColor({1, 1, 1, self.alpha})
        drawOutlinedTextF(self.text, self.pos.x, self.pos.y + 32 + 8, self.size.w / 2, "center", 0, 2, 2, 0, 0, 4, {0, 0, 0, self.alpha})
    end


    t:init()


    table.insert(onTopGameInstaces, 1, t)
end