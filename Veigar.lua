if GetObjectName(GetMyHero()) ~= "Veigar" then return end

require("Inspired")
require("Collision")

local Config = Menu("Veigar", "Veigar")
Config:SubMenu("c", "Combo")
Config.c:Boolean("Q", "Use Q", true)
Config.c:Boolean("W", "Use W", true)
Config.c:Boolean("AW", "Auto W on immobile", true)
Config.c:Boolean("E", "Use E", true)
Config.c:Boolean("R", "Use R", true)
Config.c:Boolean("AR", "Auto use R", true)

Config:SubMenu("f", "Farm")
Config.f:Boolean("AQ", "Auto Q farm", true)

Config:SubMenu("m", "Misc")
Config.m:Boolean("D" , "Enable Drawings", true)


local myHero=GetMyHero()
RDmg=0 

OnTick(function (myHero)
	if not IsDead(myHero) then
	local unit=GetCurrentTarget()
		KS()
		AutoW(unit)
		Combo(unit)
		FarmQ()
	end
end)

OnDraw(function (myHero)
	local unit=GetCurrentTarget()
	if Ready(_R) and ValidTarget(unit,1500) then
		DrawDmgOverHpBar(unit,GetCurrentHP(unit),0,RDmg,0xffffffff)
	end
end)

function Combo(unit)
	if IOW:Mode() == "Combo" then
			
		if Config.c.R:Value() and CanUseSpell(myHero,_R) == READY and ValidTarget(unit, GetCastRange(myHero,_R)) then
			local RPercent=GetCurrentHP(unit)/CalcDamage(myHero, unit, 0, (125*GetCastLevel(myHero,_R)+GetBonusAP(myHero)+125+GetBonusAP(unit)*0.8))
			if RPercent<1 and RPercent>0.2 then 
				CastTargetSpell(unit,_R)
			end
		end	
	
		if Config.c.Q:Value() and CanUseSpell(myHero,_Q) == READY and ValidTarget(unit, GetCastRange(myHero,_Q)+10) then
			local QPred = GetPredictionForPlayer(GetOrigin(myHero),unit,GetMoveSpeed(unit),1200,GetCastRange(myHero,_Q),550,80,true,false)
			if QPred.HitChance == 1 then				
				CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
			end
		end	
		
		if Config.c.W:Value() and CanUseSpell(myHero,_W) == READY and ValidTarget(unit, GetCastRange(myHero,_W)) then
			local WPred = GetPredictionForPlayer(GetOrigin(myHero),unit,GetMoveSpeed(unit)-10,math.huge,GetCastRange(myHero,_W),550,80,false,false)
			if WPred.HitChance == 1 then				
				CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
			end
		end	
		castE(unit)
	end
end

function KS()
	for _,unit in pairs(GetEnemyHeroes()) do
		if Config.c.AR:Value() and CanUseSpell(myHero,_R) == READY and ValidTarget(unit, GetCastRange(myHero,_R)) then
			local RPercent=GetCurrentHP(unit)/CalcDamage(myHero, unit, 0, (125*GetCastLevel(myHero,_R)+GetBonusAP(myHero)+125+GetBonusAP(unit)*0.8))
			if RPercent<1 and RPercent>0.2 then 
				CastTargetSpell(unit,_R)
			end
		end	
		if Config.m.D:Value() and CanUseSpell(myHero,_R)==READY and ValidTarget(unit,1500) then
			local unit=GetCurrentTarget()
			RDmg=CalcDamage(myHero, unit, 0, (125*GetCastLevel(myHero,_R) + 125 + (GetBonusAP(myHero) + 0.8*(GetBonusAP(unit)))))
			if RDmg>=GetCurrentHP(unit) then
				RDmg=GetCurrentHP(unit)
			end
		end
	end
end

function AutoW(unit)
	if Config.c.AW:Value() and ValidTarget(unit,GetCastRange(myHero,_W)) and GotBuff(unit, "veigareventhorizonstun") > 0 and (GotBuff(unit, "snare") > 0 or GotBuff(unit, "taunt") > 0 or GotBuff(unit, "suppression") > 0 or GotBuff(unit, "stun")) then
	local WPred = GetPredictionForPlayer(GetOrigin(myHero),unit,GetMoveSpeed(unit),math.huge,550,GetCastRange(myHero,_W),80,false,false)
		if WPred.HitChance == 1 then
			CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
		end
	end
end

function castE(unit)
	if Config.c.E:Value() and CanUseSpell(myHero,_E) == READY and ValidTarget(unit, GetCastRange(myHero,_E)) then
		local targetPos=GetOrigin(unit)
		local EPred = GetPredictionForPlayer(GetOrigin(myHero),unit,GetMoveSpeed(unit),math.huge,600,GetCastRange(myHero,_E),80,false,false)
		EPred.PredPos=Vector(EPred.PredPos)+((GetOrigin(myHero)-Vector(EPred.PredPos)):normalized()*325)
		CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
	end
end


function FarmQ()
	if Config.f.AQ:Value() and CanUseSpell(myHero,_Q)==READY and IOW:Mode() ~= "Combo" then
		for i,creep in pairs(minionManager.objects) do
			if GetTeam(creep)== MINION_ENEMY and ValidTarget(creep,GetCastRange(myHero,_Q)) and GetCurrentHP(creep)<CalcDamage(myHero, creep, 0, (40*GetCastLevel(myHero,_Q)+25+GetBonusAP(myHero)*0.6)) then
				CreepOrigin=GetOrigin(creep)
				if Config.m.D:Value() then	DrawCircle(CreepOrigin.x,CreepOrigin.y,CreepOrigin.z,75,0,3,0xffffff00) end
				QCol=Collision(GetCastRange(myHero,_Q),1200,925,70)
				local state,Objects=QCol:__GetMinionCollision(myHero,creep,ENEMY)
				local hitcount=0
				
				for i,unit in ipairs(Objects) do 
					hitcount=hitcount+1
				end
							
				if hitcount<=1 then
				CastSkillShot(_Q,CreepOrigin.x,CreepOrigin.y,CreepOrigin.z)
				end
			end
		end
	end
end

print("Veigar injected")
