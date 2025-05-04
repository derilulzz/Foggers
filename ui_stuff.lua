


function createButton(_x, _y, _w, _h, _text, additionalText, _fixedToScreen)
	local b = {
		pos = {x = _x, y = _y},
		size = {w = _w, h = _h},
		wantedSize = {w = _w, h = _h},
		text = _text,
		fixedToScreen = _fixedToScreen,
		hovered = false,
		pressed = false,
		addText = additionalText,
		oldHovered = false,
		hoverTime = 0,
		disabled = false,
	}


	function b:update(dt)
		local realPos = {x = self.pos.x - self.size.w / 2, y = self.pos.y - self.size.h / 2}
		local usedMousePos = PushsInGameMousePosNoTransform


		self.hovered = usedMousePos.x >= realPos.x and usedMousePos.x <= realPos.x + self.size.w and usedMousePos.y >= realPos.y and usedMousePos.y <= realPos.y + self.size.h
		

		if self.oldHovered == false and self.hovered then
			self.size.w = self.size.w * 2
			self.size.h = self.size.h * 2
		end
		if self.oldHovered and self.hovered == false then
			self.size.w = self.size.w / 2
			self.size.h = self.size.h / 2
		end


		if self.hovered then
			if love.mouse.isDown(1) then
				self.size.w = Lume.lerp(self.size.w, self.wantedSize.w, 0.2)
				self.size.h = Lume.lerp(self.size.h, self.wantedSize.h, 0.2)
			else
				self.size.w = Lume.lerp(self.size.w, self.wantedSize.w * 1.5, 0.2)
				self.size.h = Lume.lerp(self.size.h, self.wantedSize.h * 1.5, 0.2)
			end


			if not self.disabled then
				if love.mouse.isDown(1) == false and LastLeftMouseButton then
					self.pressed = true
					interactSfx:setPitch(2 * math.random())
					playSound(interactSfx)
					self.size.w = self.size.w * 2
					self.size.h = self.size.h * 2
				end
			end


			self.hoverTime = self.hoverTime + 1 * globalDt
		else
			self.hoverTime = 0
			self.size.w = Lume.lerp(self.size.w, self.wantedSize.w, 0.2)
			self.size.h = Lume.lerp(self.size.h, self.wantedSize.h, 0.2)
		end


		self.oldHovered = self.hovered
	end


	function b:draw()
		local realPos = {x = self.pos.x - self.size.w / 2, y = self.pos.y - self.size.h / 2}
		love.graphics.setColor({1, 1, 1})
		love.graphics.rectangle("fill", realPos.x, realPos.y, self.size.w, self.size.h)
		love.graphics.setColor({0, 0, 0})
		love.graphics.rectangle("line", realPos.x, realPos.y, self.size.w, self.size.h)


		local fnt = love.graphics.getFont()
		local sizeAdd = (self.size.w / self.wantedSize.w) + (self.size.h / self.wantedSize.h)
		local wrap = {fnt:getWrap(self.text, self.size.w / 2)}
		local txtHeight = fnt:getHeight() * #wrap[2]
		love.graphics.printf(self.text, realPos.x + (self.size.w / 2), (realPos.y + self.size.h / 2), self.size.w / 2, "center", 0, 1 * sizeAdd, 1 * sizeAdd, (self.size.w / 2) / 2, txtHeight / 2)


		if self.hoverTime >= 1 and self.addText ~= "" then
			local wrap = {fnt:getWrap(self.addText, self.size.w / 2)}
			local txtHeight = fnt:getHeight() * #wrap[2]
			love.graphics.setColor({0, 0, 0})
				love.graphics.rectangle("fill", PushsInGameMousePosNoTransform.x, PushsInGameMousePosNoTransform.y, (self.size.w) + 16, ((txtHeight) * 2) + 16)
			love.graphics.setColor({1, 1, 1})
				love.graphics.rectangle("line", PushsInGameMousePosNoTransform.x, PushsInGameMousePosNoTransform.y, (self.size.w) + 16, ((txtHeight) * 2) + 16)
				drawOutlinedTextF(self.addText, PushsInGameMousePosNoTransform.x + 8 + ((self.size.w / 4) * 2), PushsInGameMousePosNoTransform.y + 8 + ((txtHeight / 2) * 2), self.size.w / 2, "center", 0, 2, 2, self.size.w / 4, txtHeight / 2, 4, {0, 0, 0})
		end
	end


	table.insert(UiStuff, 1, b)


	return b
end