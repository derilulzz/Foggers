require("rectangle")


function createForg(_x, _y, _spr, _jumpSpr, _hp, _jumpTimerDef)
	if _hp == nil then _hp = 2 end


	local f = {
		pos = {x = _x, y = _y},
		spr = _spr,
		jumpSpr = _jumpSpr,
		targetPos = {x = _x, y = _y},
		jumpTimer = _jumpTimerDef,
		mspd = 64,
		scale = 2,
		jumping = false,
		col = createRectangle(_x, _y, 20, 20),
		rot = 0,
		hp = _hp,
		jumpTimerDef = _jumpTimerDef,
		hpAddFogg = 0,
		hpDivFogg = 1,
		hpMultFogg = 1,
		spdAddFogg = 0,
		spdDivFogg = 1,
		spdMultFogg = 1,
		alpha = 0,
	}


	function f:init()
		self.scale = 16


		Flux.to(self, 1, {alpha = 1, scale=2}):ease("expoout")
	end


	function f:update()
		if self.jumpTimer <= 0 then
			local jumpChanceX = math.random(0, 5)
			local jumpChanceY = math.random(0, 10)

			if jumpChanceX <= 0 then
				local xAdd = math.random(-1, 1)

				while xAdd == 0 do
					xAdd = math.random(-1, 1)
				end

				self.targetPos.x = self.targetPos.x + (self.mspd * xAdd)
				self.rot = 1.5 * xAdd
				self.scale = self.scale + 2
			elseif jumpChanceY > 5 then
				self.targetPos.y = self.targetPos.y - self.mspd
				self.rot = 0
				self.scale = self.scale + 2
			end


			self.jumpTimer = self.jumpTimerDef
		end


		self.jumping = self.scale > 2


		self.targetPos.x = Lume.clamp(self.targetPos.x, 0, 800)
		self.pos.x = Lume.clamp(self.pos.x, 0, 800)


		if ((self.hp + self.hpAddFogg) / self.hpDivFogg) * self.hpMultFogg <= 0 then
			self:die()
		end
		if self.pos.y <= -32 then
			table.remove(Foggs, tableFind(Foggs, self))
			recieveDamage(1, self.pos.x, self.pos.y)
		end


		self.col.x = self.pos.x
		self.col.y = self.pos.y
		self.col.w = self.spr.sprWidth * self.scale
		self.col.h = self.spr.sprHeight * self.scale


		self.pos.x = Lume.lerp(self.pos.x, self.targetPos.x, 0.2)
		self.pos.y = Lume.lerp(self.pos.y, self.targetPos.y, 0.2)
		self.scale = Lume.lerp(self.scale, 2, 0.2)
		self.jumpTimer = self.jumpTimer - ((((1 + self.spdAddFogg) / self.spdDivFogg) * self.spdMultFogg) * gameStuff.speed) * globalDt
	end


	function f:recieveDamage(amnt, x, y)
		self.hp = self.hp - amnt
		warningSfx:setPitch(1.5 * math.random())
		playSound(warningSfx)
		createDamageNum(amnt, self.pos.x, self.pos.y)


		if self.hp <= 0 then
			self:die()
		end

		
		if self ~= nil then
			local angleTo = math.atan2(y - self.pos.y, x - self.pos.x)


			self.targetPos.x = self.targetPos.x - (math.cos(angleTo) * 64)
			self.targetPos.y = self.targetPos.y - (math.sin(angleTo) * 64)
			self.pos.x = self.pos.x - (math.cos(angleTo) * 74)
			self.pos.y = self.pos.y - (math.sin(angleTo) * 74)
		end
	end


	function f:draw()
		love.graphics.setColor(1, 1, 1, self.alpha)
			if self.jumping then
				self.jumpSpr:draw(self.rot, self.pos.x, self.pos.y, self.scale, self.scale)
			else
				self.spr:draw(self.rot, self.pos.x, self.pos.y, self.scale, self.scale)
			end
		love.graphics.setColor(1, 1, 1, 1)
	end


	function f:die()
		money = money + (((100 * Lume.clamp(gameStuff.currentFoggGaved, 1, 999)) / moneyGainDiv) * moneyGainMult)
		createMoneyGainEffect((((100 * Lume.clamp(gameStuff.currentFoggGaved, 1, 999)) / moneyGainDiv) * moneyGainMult), self.pos.x, self.pos.y)
		createBlood(self.pos.x, self.pos.y)
		table.remove(Foggs, tableFind(Foggs, self))
	end


	f:init()


	return f
end


bloodSprs = {
	love.graphics.newImage("Sprs/Blood/Blood.png"),
	love.graphics.newImage("Sprs/Blood/Blood2.png"),
}


function createBlood(_x, _y)
	_y = Lume.clamp(_y, 0, 600)


	local b = {
		pos = {x = _x, y = _y},
		spr = bloodSprs[math.random(1, #bloodSprs)],
		scale = {x = 0, y = 0},
		drawBack = true,
		alpha = 1,
	}


	function b:update()
		if self.alpha <= 0 then
			table.remove(gameInstances, tableFind(gameInstances, self))
		end


		self.scale.x = Lume.lerp(self.scale.x, 4, 0.1)
		self.scale.y = Lume.lerp(self.scale.y, 4, 0.1)
		self.alpha = self.alpha - 0.1 * globalDt
	end


	function b:draw()
		love.graphics.setColor(1, 1, 1, self.alpha)
		love.graphics.draw(self.spr, self.pos.x, self.pos.y, 0, self.scale.x, self.scale.y, self.spr:getWidth() / 2, self.spr:getHeight() / 2)
	end


	table.insert(gameInstances, 1, b)
	return b
end