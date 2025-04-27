function createCar(_name, _namePT, desc, descPT, _spr, _scl, _speed, _damage, _waveForce, _hp, _cost, _impactDiv, _explosiveMult, _explosionArea, especialPropertys)
	if _damage == nil then _damage = 1 end
	if _waveForce == nil then _waveForce = 1 end
	if _hp == nil then _hp = 1 end
	if _cost == nil then _cost = 100 end
	if _impactDiv == nil then _impactDiv = 1 end
	if _explosiveMult == nil then _explosiveMult = 1 end
	if _explosionArea == nil then _explosionArea = 128 end
	if especialPropertys == nil then especialPropertys = {} end


	local c = {
		name = _name,
		namePT = _namePT,
		desc = desc,
		descPT = descPT,
		spr = _spr,
		scale = _scl,
		spd = _speed,
		damage = _damage,
		waveForce = _waveForce,
		hp = _hp,
		cost = _cost,
		impactDiv = _impactDiv,
		explosionMult = _explosiveMult,
		explosionArea = _explosionArea,
		especialPropertys = especialPropertys,
	}


	return c
end


function createCarInstance(_inheritFrom, _x, _y)
	local c = {
		pos = {x = _x, y = _y},
		vel = {x = 0, y = 0},
		fromCar = _inheritFrom,
		sclYAdd = 0,
		rot = 0,
		driveParticle = love.graphics.newParticleSystem(love.graphics.newImage("Sprs/Particles/WhiteBall.png"), 100),
		col = createRectangle(_x, _y, 20, 20),
		angle = 0,
		hp = _inheritFrom.hp,
		spdAdd = math.random(-50, 50),
		drifiting = false,
		trailPoses = {},
		hpAddCar = 0,
		hpDivCar = 1,
		hpMultCar = 1,
		spdAddCar = 0,
		spdDivCar = 1,
		spdMultCar = 1,
		scaleAdd = 0,
		startSfx = love.audio.newSource("Sfxs/CarOn.mp3", "static"),
		walkSfx = love.audio.newSource("Sfxs/CarWalking.mp3", "static"),
		oldMoney = money,
		moneyGenerated = 0,
		timeUntilMoneyRecieve = 5,
	}
	

	function c:init()
		self.driveParticle:setSizes(2, 0)
		self.driveParticle:setLinearAcceleration(10, -500, 100, -200)
		self.driveParticle:setParticleLifetime(0.5, 1)
		self.driveParticle:setSpeed(0.85, 1)
		self.driveParticle:setEmissionRate(10)
		self.driveParticle:setColors({1, 1, 1, 1}, {1, 1, 1, 0})
		self.driveParticle:start()
		self.startSfx:play()
		self.walkSfx:setLooping(true)
		if gameStuff.speed > 0 then
			self.walkSfx:play()
		end
	end


	function c:update()
		self.vel.x = Lume.lerp(self.vel.x, (((-self.fromCar.spd + self.spdAdd) + self.spdAddCar) * self.spdMultCar) / self.spdDivCar, 0.1)
		self.vel.y = Lume.lerp(self.vel.y, 0, 0.1)


		self.driveParticle:setSpeed(gameStuff.speed - 0.1, gameStuff.speed)


		if self.startSfx ~= nil then
			if not self.startSfx:isPlaying() then
				self.startSfx:release()
				self.startSfx = nil
			end
		end


		self.drifiting = self.vel.y < -10 or self.vel.y > 10
		if self.drifiting then
			if #self.trailPoses > 0 then
				if Lume.distance(self.pos.x, self.pos.y, self.trailPoses[#self.trailPoses].x, self.trailPoses[#self.trailPoses].y) > 0 then
					table.insert(self.trailPoses, 1, {x = self.pos.x, y = self.pos.y, timer = 5})
				end
			else
				table.insert(self.trailPoses, 1, {x = self.pos.x, y = self.pos.y, timer = 5})
			end
		end
		for t=1, #self.trailPoses do
			if self.trailPoses[t].timer <= 0 then
				table.remove(self.trailPoses, t)
				break
			end


			self.trailPoses[t].timer = self.trailPoses[t].timer - 1 * globalDt
		end


		if gameStuff.speed > 0 then
			if self.walkSfx:isPlaying() == false then
				self.walkSfx:play()
			end
			self.walkSfx:setPitch(Lume.clamp(gameStuff.speed + 0.2 * math.cos(GlobalSinAngle * 2), 0.1, 99999))
			if self.startSfx ~= nil then
				self.startSfx:setPitch(Lume.clamp(gameStuff.speed + 0.2 * math.cos(GlobalSinAngle * 2), 0.1, 99999))
			end
		end


		if self.pos.x < -128 then
			self.pos.x = 800 + 128
		end
		if self.pos.x > 800 + 128 then
			self.pos.x = -128
		end
		if self.pos.y < (upBoxStuff.y + upBoxStuff.h) - 64 then
			self.pos.y = 600 + 64
		end
		if self.pos.y > 600 + 64 then
			self.pos.y = (upBoxStuff.y + upBoxStuff.h) - 64
		end



		if self.pos.y < (upBoxStuff.y + upBoxStuff.h) - 128 then
			self.vel.y = Lume.lerp(self.vel.y, 100, 0.2)
		end
		if self.pos.y > 600 + 128 then
			self.vel.y = Lume.lerp(self.vel.y, -100, 0.2)
		end


		self.col.x = self.pos.x
		self.col.y = self.pos.y
		self.col.w = self.fromCar.spr.sprWidth * (self.fromCar.scale + self.scaleAdd)
		self.col.h = self.fromCar.spr.sprHeight * (self.fromCar.scale + self.scaleAdd)


		for f=1, #Foggs do
			if self.col:checkCollision(Foggs[f].col) then
				Foggs[f]:recieveDamage(self.fromCar.damage, self.pos.x, self.pos.y)


				self.hp = self.hp - 1


				if self.hp > 0 then
					if Foggs[f] ~= nil then
						createCarImpact(Foggs[f].pos.x, Foggs[f].pos.y)
					end
				end


				return
			end
		end


		self.pos.x = self.pos.x + (self.vel.x * gameStuff.speed) * globalDt
		self.pos.y = self.pos.y + (self.vel.y * gameStuff.speed) * globalDt


		if ((self.hp + self.hpAddCar) * self.hpMultCar) / self.hpDivCar <= 0 then
			createExplosion(self.pos.x, self.pos.y, self)
			self.walkSfx:stop()
			if self.startSfx ~= nil then
				self.startSfx:stop()
			end
			table.remove(GameCarInstances, tableFind(GameCarInstances, self))
			return
		end
		

		if self.oldMoney ~= money then
			self.moneyGenerated = self.moneyGenerated + (self.oldMoney - money) * -1
		end


		self.sclYAdd = 0.25 * math.sin(self.angle * 8)
		self.rot = (0.1 - 0.1 * math.cos(self.angle * 16)) * self.fromCar.waveForce
		

		self.driveParticle:setPosition(self.pos.x + 16, self.pos.y + 24)
		self.driveParticle:update(globalDt)
		self.angle = self.angle + (1 * gameStuff.speed) * globalDt
		if self.fromCar.especialPropertys.seller then
			if self.fromCar.especialPropertys.recieveCooldown <= 0 then
				money = money + Lume.clamp(((self.moneyGenerated * 0.2) / moneyGainDiv) * moneyGainMult, 0, 9999)
				table.insert(gameInstances, 1, createMoneyRecievePerCar(tostring(Lume.clamp(((self.moneyGenerated * 0.2) / moneyGainDiv) * moneyGainMult, 0, 9999)), self.pos.x, self.pos.y))
				self.moneyGenerated = 0
				self.fromCar.especialPropertys.recieveCooldown = self.fromCar.especialPropertys.recieveCooldownDef
			end


			self.fromCar.especialPropertys.recieveCooldown = self.fromCar.especialPropertys.recieveCooldown - 1 * globalDt
		end


		self.oldMoney = money
	end


	function c:draw()
		--The particles gets drawn in the main.lua


		love.graphics.setColor(1, 1, 1, 1)
			self.fromCar.spr:draw(self.rot, self.pos.x, self.pos.y, self.fromCar.scale + self.scaleAdd, self.fromCar.scale + self.sclYAdd + self.scaleAdd, self.fromCar.spr.sprWidth / 2, self.fromCar.spr.sprHeight / 2, 4, {0, 0, 0})
	end


	c:init()
	table.insert(GameCarInstances, 1, c)


	return c
end



function createExplosion(_x, _y, _fromCar)
	local e = {
		pos = {x = _x, y = _y},
		spr = newAnimation(love.graphics.newImage("Sprs/Cars/Explosion.png"), 16, 16, 7, 30, 1),
	}


	explosionSfx:setPitch(2 * math.random())
	playSound(explosionSfx)
	enableScreenShake(25 * _fromCar.fromCar.explosionMult)
	for c=1, #GameCarInstances do
		local angleTo = math.atan2(e.pos.y - GameCarInstances[c].pos.y, e.pos.x - GameCarInstances[c].pos.x)
		

		if Lume.distance(e.pos.x, e.pos.y, GameCarInstances[c].pos.x, GameCarInstances[c].pos.y) <= _fromCar.fromCar.explosionArea then
			if GameCarInstances[c].pos.y == e.pos.y then
				GameCarInstances[c].vel.y = (GameCarInstances[c].vel.y - 800 * _fromCar.fromCar.explosionMult) / GameCarInstances[c].fromCar.impactDiv
			end


			GameCarInstances[c].vel.x = GameCarInstances[c].vel.x - ((800 * _fromCar.fromCar.explosionMult) * math.cos(angleTo)) / GameCarInstances[c].fromCar.impactDiv
			GameCarInstances[c].vel.y = GameCarInstances[c].vel.y - ((800 * _fromCar.fromCar.explosionMult) * math.sin(angleTo)) / GameCarInstances[c].fromCar.impactDiv
		end
	end


	function e:update()
		self.spr:update(globalDt)


		if self.spr.finished then
			table.remove(gameInstances, tableFind(gameInstances, self))
		end
	end


	function e:draw()
		self.spr:draw(0, self.pos.x, self.pos.y, 8 * (_fromCar.fromCar.explosionArea / 128), 8 * (_fromCar.fromCar.explosionArea / 128))
	end


	table.insert(gameInstances, 1, e)
end


function createCarImpact(_x, _y)
	local i = {
		pos = {x = _x, y = _y},
		spr = newAnimation(love.graphics.newImage("Sprs/Cars/Hit.png"), 16, 16, 3, 20, 1),
	}

	function i:update()
		self.spr:update(globalDt)


		if self.spr.finished then
			table.remove(gameInstances, tableFind(gameInstances, self))
		end
	end


	function i:draw()
		self.spr:draw(0, self.pos.x, self.pos.y, 4, 4)
	end


	table.insert(gameInstances, 1, i)
end