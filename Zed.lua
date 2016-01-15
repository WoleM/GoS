if GetObjectName(GetMyHero()) ~= "Zed" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua!") return end

local mainMenu = Menu("Zed | The Shadow", "Zed")
mainMenu:Menu("Combo", "Combo")
mainMenu.Combo:Boolean("useQ", "Use Q in combo", true)
mainMenu.Combo:Boolean("useW", "Use W in combo", true)
mainMenu.Combo:Boolean("gabW", "Use W to gapclose", true)
mainMenu.Combo:Boolean("useE", "Use E in combo", true)
mainMenu.Combo:Boolean("AutoE", "Use auto E", true)
mainMenu.Combo:Boolean("useR", "Use R", true)
mainMenu.Combo:Key("Combo1", "Combo", string.byte(" "))
-----------------------------------------------------------------
mainMenu:Menu("Harass", "Harass")
mainMenu.Harass:Boolean("hQ", "Use Q", true)
mainMenu.Harass:Boolean("hW", "Use W", true)
mainMenu.Harass:Boolean("hE", "Use E", true)
mainMenu.Harass:Key("Harass1", "Harass", string.byte("C"))
-----------------------------------------------------------------
mainMenu:Menu("Items", "Items")
mainMenu.Items:Boolean("useCut", "Bilgewater Cutlass", true)
mainMenu.Items:Boolean("useBork", "Blade of the Ruined King", true)
mainMenu.Items:Boolean("useGhost", "Youmuu's Ghostblade", true)
mainMenu.Items:Boolean("useHydra", "Ravenous Hydra | Tiamat", true)
mainMenu.Items:Slider("extraDelay","Extra Delay for AA reset", 10 , 0, 50, 1)
mainMenu.Items:Boolean("useRedPot", "Elixir of Wrath", true)
-----------------------------------------------------------------
mainMenu:Menu("Drawings", "Drawings")
mainMenu.Drawings:Boolean("DrawQ", "Draw Q range", false)
mainMenu.Drawings:Boolean("DrawW", "Draw W range", false)
mainMenu.Drawings:Boolean("DrawE", "Draw E range", false)
mainMenu.Drawings:Boolean("DrawR", "Draw R range", false)
mainMenu.Drawings:Boolean("DrawWShadow", "W - Shadow Drawings", false)
mainMenu.Drawings:Boolean("DrawRShadow", "R - Shadow Drawings", false)
mainMenu.Drawings:Boolean("DrawDMG", "Draw Damage", true)

local global_ticks = 0
local global_ticksRULT = 0
local global_ticksR = 0
local global_ticksW = 0
baseAS = GetBaseAttackSpeed(myHero)

-- Shadow
OnProcessSpell(function(unit, spell)
	if unit == myHero then
		
		if spell.name:lower():find("zedw") then
			WPos = Vector(spell.endPos.x,spell.endPos.y,spell.endPos.z)
			Wtime = 5000
		elseif spell.name:lower():find("zedw2") then
			WPos = Vector(spell.startPos.x,spell.startPos.y,spell.startPos.z)
		end  


		if spell.name:lower():find("zedr") then
			RPos = Vector(spell.startPos.x,spell.startPos.y,spell.startPos.z)
			Rtime = 7500

		elseif spell.name:lower():find("zedr2") then
			RPos = GetOrigin(myHero)
		end
	
local TickerR = GetTickCount()
	if (global_ticksR + 10) < TickerR then
		if Rtime == 7500 then
			DelayAction(function()
				Rtime = nil
				RPos = nil
			end, Rtime)
		end
	global_ticksR = TickerR
	end
	
local TickerW = GetTickCount()	
	if (global_ticksW + 10) < TickerW then
		if Wtime == 5000 then
			DelayAction(function()
				Wtime = nil
				WPos = nil
			end, Wtime)
		end	
	global_ticksW = TickerW
	end
	
	if mainMenu.Combo.Combo1:Value() and mainMenu.Items.useHydra:Value() then
	local hydra = GetItemSlot(myHero,3074)
	local tiamat = GetItemSlot(myHero,3077)
		if spell.name:lower():find("attack") then
			if tiamat ~= nil and tiamat >= 1 and CanUseSpell(myHero,GetItemSlot(myHero,3077)) == READY then
				DelayAction(function()
					CastSpell(GetItemSlot(myHero,3077))
				end, GetWindUp(myHero)*baseAS*(1000/GetAttackSpeed(myHero))+ GetLatency()+30*GetAttackSpeed(myHero) + mainMenu.Items.extraDelay:Value())
			elseif hydra ~= nil and hydra >= 1 and CanUseSpell(myHero,GetItemSlot(myHero,3074)) == READY then
				DelayAction(function()
					CastSpell(GetItemSlot(myHero,3074))
				end, GetWindUp(myHero)*baseAS*(1000/GetAttackSpeed(myHero))+ GetLatency()+30*GetAttackSpeed(myHero) + mainMenu.Items.extraDelay:Value())
			end
		end
	end
	end
end)

OnDraw(function(myHero)
-- local myHeroP = GetOrigin(myHero)
-- R Drawings
if mainMenu.Drawings.DrawRShadow:Value() then
if RPos ~= nil and CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_E) == READY then
	DrawCircle(RPos, GetCastRange(myHero,_Q),1,50,0xff0ffff0)
	DrawCircle(RPos, GetCastRange(myHero,_E),1,50,0xff0ffff0)
	DrawCircle(RPos, 50,3,50,0xff0ffff0)
elseif RPos ~= nil and CanUseSpell(myHero,_Q) == READY then
	DrawCircle(RPos, GetCastRange(myHero,_Q),1,50,0xff0ffff0)
	DrawCircle(RPos, 50,3,50,0xff0ffff0)
elseif RPos ~= nil and CanUseSpell(myHero,_E) == READY then
	DrawCircle(RPos, GetCastRange(myHero,_E),1,50,0xff0ffff0)
	DrawCircle(RPos, 50,3,50,0xff0ffff0)	
elseif RPos ~= nil then
	DrawCircle(RPos, 50,3,50,0xff0ffff0)	
end	
end
-- W Drawings
if mainMenu.Drawings.DrawWShadow:Value() then
if WPos ~= nil and CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_E) == READY then
	DrawCircle(WPos, GetCastRange(myHero,_Q),1,50,0xff0ffff0)
	DrawCircle(WPos, GetCastRange(myHero,_E),1,50,0xff0ffff0)
	DrawCircle(WPos, 50,3,50,0xff0ffff0)
elseif WPos ~= nil and CanUseSpell(myHero,_Q) == READY then
	DrawCircle(WPos, GetCastRange(myHero,_Q),1,50,0xff0ffff0)
	DrawCircle(WPos, 50,3,50,0xff0ffff0)
elseif WPos ~= nil and CanUseSpell(myHero,_E) == READY then
	DrawCircle(WPos, GetCastRange(myHero,_E),1,50,0xff0ffff0)
	DrawCircle(WPos, 50,3,50,0xff0ffff0)	
elseif WPos ~= nil then
	DrawCircle(WPos, 50,3,50,0xff0ffff0)	
end	
end
-- myHero Drawings
Drawings()

-- DMG Draw
if mainMenu.Drawings.DrawDMG:Value() then
local target = GetCurrentTarget()
	if CanUseSpell(myHero,_R) == READY and GotBuff(target, "zedrtargetmark") == 0 and trueDMGr~= nil and ValidTarget(target, 2000) then
		DrawDmgOverHpBar(target,GetCurrentHP(target),trueDMGr,0,0xff00ff00)
	elseif GotBuff(target, "zedrtargetmark") == 1 and ValidTarget(target, 2000) and MarkDMG ~= nil then
		DrawDmgOverHpBar(target,GetCurrentHP(target),MarkDMG,0,0xff00ff00)
	elseif DPS~= nil and ValidTarget(target, 1500) and GotBuff(target, "zedrtargetmark") == 0 then
		DrawDmgOverHpBar(target,GetCurrentHP(target),DPS,0,0xff00ff00)
	end
end

end)

OnTick(function(myHero)

local target = GetCurrentTarget()
local myHeroP = GetOrigin(myHero)

-- Items
local CutBlade = GetItemSlot(myHero,3144)
local bork = GetItemSlot(myHero,3153)
local ghost = GetItemSlot(myHero,3142)
local redpot = GetItemSlot(myHero,2140)

-- DAMAGEEEEEEEEEEEE!
if mainMenu.Drawings.DrawDMG:Value() or mainMenu.Combo.useR:Value() then
	
	if CanUseSpell(myHero,_Q) == READY then 
			qDMG = CalcDamage(myHero, target, (24*GetCastLevel(myHero,_Q)+21+(0.6*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))), 0)
			qDMGpre = (24*GetCastLevel(myHero,_Q)+21+(0.6*(GetBaseDamage(myHero) + GetBonusDmg(myHero))))
	else 	qDMG = 0
			qDMGpre = 0
	end
			
	if CanUseSpell(myHero,_E) == READY then 
			eDMG = CalcDamage(myHero, target, (30*GetCastLevel(myHero,_E)+30+(0.8*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))), 0)
			eDMGpre = (30*GetCastLevel(myHero,_E)+30+(0.8*(GetBaseDamage(myHero) + GetBonusDmg(myHero))))
	else 	eDMG = 0
			eDMGpre = 0
	end
			DPS = qDMG + eDMG
			DPSpre = qDMGpre + eDMGpre
			
	if CanUseSpell(myHero,_R) == READY then
					AADMG = CalcDamage(myHero, target, (GetBaseDamage(myHero) + GetBonusDmg(myHero)), 0)
					trueDMGr = CalcDamage(myHero, target, ((0.15*GetCastLevel(myHero,_R) + 0.05) * DPSpre ) + (GetBaseDamage(myHero) + GetBonusDmg(myHero)), 0) + AADMG + DPS
	else trueDMGr = 0
	end

	if GotBuff(target, "zedrtargetmark") == 1 then
	local TickerRULT = GetTickCount()
		if (global_ticksRULT + 10000) < TickerRULT then
			DelayAction(function()
					StartHP = GetCurrentHP(target)
					-- PrintChat("StartHP: "..StartHP)
			end,10)
			global_ticksRULT = TickerRULT
		end
	end
	
	if GotBuff(target,"zedrtargetmark") == 1 and StartHP~= nil then
		local EndHP = GetCurrentHP(target)
		local ArmorTarget = GetArmor(target)
		local ArmorA = (100/(100+GetArmor(target)))-1
		local Reduction = math.sqrt(math.pow(ArmorA,2)) + 1
		local extraDMG = StartHP - EndHP
		MarkDMG = CalcDamage(myHero, target, ((0.15*GetCastLevel(myHero,_R) + 0.05) * (Reduction * extraDMG)) + (GetBaseDamage(myHero) + GetBonusDmg(myHero)), 0)
	end
	
end

-- Auto E
if mainMenu.Combo.AutoE:Value() then
	if CanUseSpell(myHero,_E) == READY and ValidTarget(target, 284) and mainMenu.Combo.AutoE:Value() then
		CastSpell(_E)
	end
-- W _E	
	if CanUseSpell(myHero,_E) == READY and mainMenu.Combo.AutoE:Value() and WPos ~= nil then
		local wEPred = GetPredictionForPlayer(WPos,target,GetMoveSpeed(target),math.huge,50,284,0,false,false)
			if wEPred.HitChance == 1 then
				CastSpell(_E)
			end
	end
-- R _E	
	if CanUseSpell(myHero,_E) == READY and mainMenu.Combo.AutoE:Value() and RPos ~= nil then
		local rEPred = GetPredictionForPlayer(RPos,target,GetMoveSpeed(target),math.huge,50,284,0,false,false)
			if rEPred.HitChance == 1 then
				CastSpell(_E)
			end
	end	
end

--[Combo
if mainMenu.Combo.Combo1:Value() then
	-- PrintChat("Energy: "..GetCastMana(myHero,_W,GetCastLevel(myHero,_W)))
--- Items
	if CutBlade >= 1 and ValidTarget(target,550) and CanUseSpell(myHero,GetItemSlot(myHero,3144)) == READY and mainMenu.Items.useCut:Value() then
		CastTargetSpell(target, GetItemSlot(myHero,3144))
	elseif bork >= 1 and ValidTarget(target,550) and (GetMaxHP(myHero) / GetCurrentHP(myHero)) >= 1.25 and CanUseSpell(myHero,GetItemSlot(myHero,3153)) == READY and mainMenu.Items.useBork:Value() then 
		CastTargetSpell(target,GetItemSlot(myHero,3153))
	end

	if ghost >= 1 and ValidTarget(target,500) and CanUseSpell(myHero,GetItemSlot(myHero,3142)) == READY and mainMenu.Items.useGhost:Value() then
		CastSpell(GetItemSlot(myHero,3142))
	end
	
	if redpot >= 1 and ValidTarget(target,550) and CanUseSpell(myHero,GetItemSlot(myHero,2140)) == READY and mainMenu.Items.useRedPot:Value() then
		CastSpell(GetItemSlot(myHero,2140))
	end
---

-- R
if mainMenu.Combo.useR:Value() then
	if CanUseSpell(myHero,_R) == READY and ValidTarget(target, GetCastRange(myHero,_R)) and GetCurrentHP(target) < trueDMGr then
		if GetCurrentHP(target) > DPS then
		if CanUseSpell(myHero,_Q) == READY or CanUseSpell(myHero,_E) == READY then
		CastTargetSpell(target, _R)
		trueDMGr = 0
		end
		end
	end
end

-- W
if mainMenu.Combo.useW:Value() then
	if CanUseSpell(myHero,_W) == READY and ValidTarget(target, GetCastRange(myHero,_W)+GetRange(myHero)) and not IsInDistance(target, GetCastRange(myHero,_E)) and mainMenu.Combo.gabW:Value() then
		local WPred = GetPredictionForPlayer(myHeroP,target,GetMoveSpeed(target),300,300,GetCastRange(myHero,_W)+GetRange(myHero),250,false,false)
            if WPred.HitChance == 1 then
				CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
			end
	elseif CanUseSpell(myHero,_W) == READY and GotBuff(myHero,"zedwhandler") == 0 and ValidTarget(target, GetCastRange(myHero,_W)+GetRange(myHero)) and not IsInDistance(target, GetRange(myHero)) and not mainMenu.Combo.gabW:Value() then
		 local Ticker = GetTickCount()
		 local WPred = GetPredictionForPlayer(myHeroP,target,GetMoveSpeed(target),300,300,GetCastRange(myHero,_W)+GetRange(myHero),250,false,false)
			if (global_ticks + 5000) < Ticker then
				if WPred.HitChance == 1 then
					CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
					-- PrintChat("!")
					global_ticks = Ticker
				end
			end
	end
end	
	
-- Q
if mainMenu.Combo.useQ:Value() then
	useQ(target, mainMenu.Combo.useQ:Value())
end
-- E
if mainMenu.Combo.useE:Value() then
	useE(target, mainMenu.Combo.useE:Value())
end
end -- Combo]

-- [Harass
if mainMenu.Harass.Harass1:Value() then

MoveToXYZ(GetMousePos())
-- W
if mainMenu.Harass.hW:Value() and GetCurrentMana(myHero) >= GetCastMana(myHero,_W,GetCastLevel(myHero,_W)) + GetCastMana(myHero,_Q,GetCastLevel(myHero,_Q)) + GetCastMana(myHero,_E,GetCastLevel(myHero,_E)) then
	if CanUseSpell(myHero,_W) == READY and GotBuff(myHero,"zedwhandler") == 0 and ValidTarget(target, GetCastRange(myHero,_W)+GetRange(myHero)) and not IsInDistance(target, GetRange(myHero)) then
		 local Ticker = GetTickCount()
		 local WPred = GetPredictionForPlayer(myHeroP,target,GetMoveSpeed(target),300,300,GetCastRange(myHero,_W)+GetRange(myHero),250,false,false)
			if (global_ticks + 5000) < Ticker then
				if WPred.HitChance == 1 then
					CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
					-- PrintChat("!")
					global_ticks = Ticker
				end
			end
	end	
	
	if mainMenu.Harass.hQ:Value() and mainMenu.Harass.hW:Value() and WPos ~= nil then
		useQ(target, mainMenu.Harass.hQ:Value())
	end
	if mainMenu.Harass.hE:Value() and mainMenu.Harass.hW:Value() and WPos ~= nil then
		useE(target, mainMenu.Harass.hE:Value())
	end
	
end


if not mainMenu.Harass.hW:Value() or CanUseSpell(myHero,_W) == ONCOOLDOWN then

if mainMenu.Harass.hQ:Value() then
	useQ(target, mainMenu.Harass.hQ:Value())
end

if mainMenu.Harass.hE:Value() then
	useE(target, mainMenu.Harass.hE:Value())
end

end

end --Harass]

end)

function Drawings()
myHeroP = GetOrigin(myHero)
if CanUseSpell(myHero, _Q) == READY and mainMenu.Drawings.DrawQ:Value() then DrawCircle(myHeroP.x,myHeroP.y,myHeroP.z,GetCastRange(myHero,_Q),1,100,0xff00ff00)
	elseif CanUseSpell(myHero, _Q) == ONCOOLDOWN and mainMenu.Drawings.DrawQ:Value() then DrawCircle(myHeroP.x,myHeroP.y,myHeroP.z,GetCastRange(myHero,_Q),1,100,0xffff0000)
	end
if CanUseSpell(myHero, _W) == READY and mainMenu.Drawings.DrawW:Value() then DrawCircle(myHeroP.x,myHeroP.y,myHeroP.z,GetCastRange(myHero,_W)+GetRange(myHero),1,100,0xff00ff00)
	elseif CanUseSpell(myHero, _W) == ONCOOLDOWN and mainMenu.Drawings.DrawW:Value() then DrawCircle(myHeroP.x,myHeroP.y,myHeroP.z,GetCastRange(myHero,_W)+GetRange(myHero),1,100,0xffff0000)
	end
if CanUseSpell(myHero, _E) == READY and mainMenu.Drawings.DrawE:Value() then DrawCircle(myHeroP.x,myHeroP.y,myHeroP.z,GetCastRange(myHero,_E),1,100,0xff00ff00) 
	elseif CanUseSpell(myHero, _E) == ONCOOLDOWN and mainMenu.Drawings.DrawE:Value() then DrawCircle(myHeroP.x,myHeroP.y,myHeroP.z,GetCastRange(myHero,_E),1,100,0xffff0000)
	end
if CanUseSpell(myHero, _R) == READY and mainMenu.Drawings.DrawR:Value() then DrawCircle(myHeroP.x,myHeroP.y,myHeroP.z,GetCastRange(myHero,_R),1,100,0xff00ff00) 
	elseif CanUseSpell(myHero, _R) == ONCOOLDOWN and mainMenu.Drawings.DrawR:Value() then DrawCircle(myHeroP.x,myHeroP.y,myHeroP.z,GetCastRange(myHero,_R),1,100,0xffff0000)
	end
end

function useQ(target, mode)
-- Q
	if CanUseSpell(myHero,_Q) == READY and ValidTarget(target, GetCastRange(myHero,_Q)) and mode then
		local QPred = GetPredictionForPlayer(myHeroP,target,GetMoveSpeed(target),1700,250,GetCastRange(myHero,_Q),50,false,false)
			if QPred.HitChance == 1 then
				CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
			end
	end
-- QW
	if CanUseSpell(myHero,_Q) == READY and WPos ~= nil and ValidTarget(target, 4000) and mode then
		local wQPred = GetPredictionForPlayer(WPos,target,GetMoveSpeed(target),1700,250,GetCastRange(myHero,_Q),50,false,false)
			if wQPred.HitChance == 1 then
				CastSkillShot(_Q,wQPred.PredPos.x,wQPred.PredPos.y,wQPred.PredPos.z)
			end
	end
-- QR
	if CanUseSpell(myHero,_Q) == READY and RPos ~= nil and ValidTarget(target, 4000) and mode then
		local rQPred = GetPredictionForPlayer(RPos,target,GetMoveSpeed(target),1700,250,GetCastRange(myHero,_Q),50,false,false)
			if rQPred.HitChance == 1 then
				CastSkillShot(_Q,rQPred.PredPos.x,rQPred.PredPos.y,rQPred.PredPos.z)
			end
	end
end

function useE(target, mode)
-- E
	if CanUseSpell(myHero,_E) == READY and ValidTarget(target, GetCastRange(myHero,_E)) and IsInDistance(target, 284) and mode then
		CastSpell(_E)
	end
-- EW
	if CanUseSpell(myHero,_E) == READY and WPos ~= nil and ValidTarget(target, 4000) and mode then
		local wEPred = GetPredictionForPlayer(WPos,target,GetMoveSpeed(target),math.huge,250,284,0,false,false)
			if wEPred.HitChance == 1 then
				CastSpell(_E)
			end
	end
-- ER
	if CanUseSpell(myHero,_E) == READY and RPos ~= nil and ValidTarget(target, 4000) and mode then
		local rEPred = GetPredictionForPlayer(RPos,target,GetMoveSpeed(target),math.huge,250,284,0,false,false)
			if rEPred.HitChance == 1 then
				CastSpell(_E)
			end
	end
end

PrintChat("Zed - The Shadow loaded.")
PrintChat("by Noddy")
