


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
		alpha = 1,
		visible = true,
		disabled = false,
	}


	function b:update(hoverdown)
		buttonUpdate(self, hoverdown == false)
	end


	function b:draw()
		buttonDraw(self, nil, self.alpha)
	end


	table.insert(UiStuff, 1, b)


	return b
end
function createDropDownButton(_x, _y, _w, _h, _text, additionalText, _fixedToScreen, childUis)
	local b = {
		pos = {
			x = _x,
			y = _y,
		},
		size = {
			w = _w,
			h = _h,
		},
		wantedSize = {
			w = _w,
			h = _h,
		},
		text = _text,
		addText = additionalText,
		pressed = false,
		hovered = false,
		oldHovered = false,
		hoverTime = 0,
		visible = true,
		disabled = false,
		fixedToScreen = _fixedToScreen,
		childUis = childUis,
		showChilds = false,
	}



	function b:update(hoverdown)
		for c=1, #self.childUis do
			if tableFind(UiStuff, self.childUis[c]) > 0 then table.remove(UiStuff, tableFind(UiStuff, self.childUis[c])) end
		end


		buttonUpdate(self, hoverdown == false)


		if self.pressed then
			self.showChilds = not self.showChilds
			self.pressed = false
		end


		if self.showChilds then
			for b=1, #self.childUis do
				self.childUis[b]:update()
			end
		end
	end


	function b:draw()
		if self.showChilds then
			for b=1, #self.childUis do
				if self.childUis[b].pos and self.childUis[b].size then
					self.childUis[b].pos.y = self.pos.y + (self.childUis[b].size.h / 2) + 8 + (self.childUis[b].size.w * b + 1)
				end
				self.childUis[b]:draw()
			end
		end


		buttonDraw(self)
	end


	table.insert(UiStuff, 1, b)


	return b
end
function createNumberInsertButton(_x, _y, _w, _h, _text, additionalText, _fixedToScreen, _onlyNumbers)
	_onlyNumbers = _onlyNumbers or false
	
	
	local b = {
		pos = {
			x = _x,
			y = _y,
		},
		size = {
			w = _w,
			h = _h,
		},
		wantedSize = {
			w = _w,
			h = _h,
		},
		text = _text,
		textedText = "",
		onlyNumbers = _onlyNumbers,
		addText = additionalText,
		pressed = false,
		hovered = false,
		oldHovered = false,
		hoverTime = 0,
		visible = true,
		alpha = 1,
		disabled = false,
		fixedToScreen = _fixedToScreen,
		texting = false,
	}



	function b:update(hoverdown)
		if not self.texting then
			buttonUpdate(self, hoverdown == false)
		else
			buttonUpdate(self, true)
		end


		if self.pressed then
			self.texting = not self.texting
			self.pressed = false
		end
		if not self.hovered and love.mouse.isDown(1) and LastLeftMouseButton == false then
			self.texting = false
		end


		if self.texting then
			if keyboardWasPressed then
				if lastKeyPressed == "return" or lastKeyPressed == "kpenter" then
					if self.onlyNumbers then
						self.texting = false
					else
						self.textedText = self.textedText .. "\n"
					end
					return
				end
				if lastKeyPressed == "tab" then
					self.textedText = self.textedText .. "\t"
					return
				end
				if lastKeyPressed == "space" then
					self.textedText = self.textedText .. " "
					return
				end
				if lastKeyPressed == "escape" then
					self.texting = false
				end
				if lastKeyPressed == "backspace" then
					self.textedText = string.sub(self.textedText, 1, string.len(self.textedText) - 1)
					return
				end
				if lastKeyPressed == "lshift" or lastKeyPressed == "rshift" or lastKeyPressed == "lctrl" or lastKeyPressed == "rctrl" or lastKeyPressed == "capslock" or lastKeyPressed == "lalt" or lastKeyPressed == "mode" then
					return
				end
				local pos = {string.find(lastKeyPressed, "kp")}
				if pos[1] ~= nil and pos[2] ~= nil then
					lastKeyPressed = string.sub(lastKeyPressed, pos[2] + 1, string.len(lastKeyPressed))
				end


				if self.onlyNumbers then
					if lastKeyPressed == "1" or lastKeyPressed == "2" or lastKeyPressed == "3" or lastKeyPressed == "4" or lastKeyPressed == "5" or lastKeyPressed == "6" or lastKeyPressed == "7" or lastKeyPressed == "8" or lastKeyPressed == "9" or lastKeyPressed == "0" then
						self.textedText = self.textedText .. lastKeyPressed
					end
				else
					self.textedText = self.textedText .. lastKeyPressed
				end
			end
		end
	end


	function b:draw()
		local usedText = self.text
		
		
		if self.textedText ~= "" then
			usedText = self.textedText
		end


		buttonDraw(self, usedText)
	end


	table.insert(UiStuff, 1, b)


	return b
end


function buttonUpdate(self, hoverOverride)
	if self.visible == false then return end


	local realPos = {x = self.pos.x - self.size.w / 2, y = self.pos.y - self.size.h / 2}
	local usedMousePos = PushsInGameMousePosNoTransform


	if not hoverOverride then
		self.hovered = usedMousePos.x >= realPos.x and usedMousePos.x <= realPos.x + self.size.w and usedMousePos.y >= realPos.y and usedMousePos.y <= realPos.y + self.size.h
	else
		self.hovered = true
	end
	

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


function buttonDraw(self, modText, alpha)
	alpha = alpha or 1
	modText = modText or self.text


	if self.visible == false then return end


	local realPos = {x = self.pos.x - self.size.w / 2, y = self.pos.y - self.size.h / 2}
	love.graphics.setColor({1, 1, 1, alpha})
	love.graphics.rectangle("fill", realPos.x, realPos.y, self.size.w, self.size.h)
	love.graphics.setColor({0, 0, 0, alpha})
	love.graphics.rectangle("line", realPos.x, realPos.y, self.size.w, self.size.h)


	local fnt = love.graphics.getFont()
	local sizeAdd = (self.size.w / self.wantedSize.w) + (self.size.h / self.wantedSize.h)
	local wrap = {fnt:getWrap(modText, self.size.w / 2)}
	local txtHeight = fnt:getHeight() * #wrap[2]
	drawOutlinedTextF(modText, realPos.x + (self.size.w / 2), (realPos.y + self.size.h / 2), self.size.w / 2, "center", 0, 1 * sizeAdd, 1 * sizeAdd, (self.size.w / 2) / 2, txtHeight / 2, 2 * sizeAdd, {1, 1, 1})


	if self.hoverTime >= 1 and self.addText ~= "" then
		local wrap = {fnt:getWrap(self.addText, self.size.w / 2)}
		local txtHeight = fnt:getHeight() * #wrap[2]
		love.graphics.setColor({0, 0, 0, alpha})
			love.graphics.rectangle("fill", PushsInGameMousePosNoTransform.x + 32, PushsInGameMousePosNoTransform.y + 32, (self.size.w) + 16, ((txtHeight) * 2) + 16)
		love.graphics.setColor({1, 1, 1, alpha})
			love.graphics.rectangle("line", PushsInGameMousePosNoTransform.x + 32, PushsInGameMousePosNoTransform.y + 32, (self.size.w) + 16, ((txtHeight) * 2) + 16)
			drawOutlinedTextF(self.addText, PushsInGameMousePosNoTransform.x + 32 + 8 + ((self.size.w / 4) * 2), PushsInGameMousePosNoTransform.y + 32 + 8 + ((txtHeight / 2) * 2), self.size.w / 2, "center", 0, 2, 2, self.size.w / 4, txtHeight / 2, 4, {0, 0, 0})
	end
end