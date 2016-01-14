if GetObjectName(GetMyHero()) ~= "TwistedFate" then return end

require('Inspired')
require('DeftLib')
require('DamageLib')

AutoUpdate("/WoleM/GoS/new/master/TwistedFate.lua","/WoleM/GoS/new/master/TwistedFate.version","TwistedFate.lua",1)

local TwistedFate = MenuConfig("TwistedFate", "TwistedFate")
TwistedFate:Menu("Combo", "Combo")
TwistedFate.Combo:Boolean("W", "PickACard", true)
TwistedFate.Combo:Boolean("Killable", "Can be killed", true)

local selected = "goldcardlock";
local int LastPick, LastPick2 = 0, 0;
local myHero = GetMyHero();
local wready = false;

PrintChat(string.format("<font color='#1244EA'>TwistedFate:</font> <font color='#FFFFFF'> By WoleM Loaded! </font>")) 
PrintChat("HF sucking dicks noob scripter: " ..GetObjectBaseName(myHero)) 

OnTick(function(myHero)
	wready = CanUseSpell(myHero, _W);
	
	PrintChat(KeyIsDown);
	if Config.Killable then
		Killable()
	end	
	if wready == 0 and GetTickCount() - LastPick <= 2300 then
		if GetCastName(myHero, _W) == selected then
			CastSpell(_W);
		end
	end
	if wready == 0 and GetCastName(myHero, _W) == "PickACard" and GetTickCount() - LastPick2 >= 2400 and GetTickCount() - LastPick >= 500 then
		if KeyIsDown(90) then
			selected = "goldcardlock";
		elseif KeyIsDown(69) then
			selected = "bluecardlock";
		elseif KeyIsDown(88) then
			selected = "redcardlock";
		else return
		end
		CastSpell(_W);
		LastPick = GetTickCount();
	end
end)


OnProcessSpell(function(unit,spell)
	if unit == myHero and spell.name == "PickACard" then
		LastPick2 = GetTickCount();
	end
end)

function Killable()
local ad = GetBonusDmg(myHero) + GetBaseDamage(myHero)
local Wlevel = GetCastLevel(myHero,_W) - 1
local Qlevel = GetCastLevel(myHero,_Q) - 1	
local bcard = (40 + (20 * Wlevel) + (ad) + (GetBonusAP(myHero) * 0.5 ))		
local ycard = (15 + (7.5 * Wlevel) + (ad) + (GetBonusAP(myHero) * 0.5 ))
local qdmg = (60 + (50 * Qlevel) + (GetBonusAP(myHero) * 0.65 ))

	for _,unit in pairs(GetEnemyHeroes()) do
		if not IsDead(unit) and ValidTarget(unit,6500) then
		local hp = GetCurrentHP(unit)
		local Ydmg = CalcDamage(myHero, unit, 0, ycard + qdmg) or 0
		local Bdmg = CalcDamage(myHero, unit, 0, bcard + qdmg) or 0
				
			if Ydmg > hp and tickwarn < GetTickCount() then
			local HPBARPOS = GetHPBarPos(myHero)
				if HPBARPOS.x > 0 then
					if HPBARPOS.y > 0 then				
						DrawText(string.format("You can kill %s(YellowCard)",GetObjectName(unit)),12,HPBARPOS.x,HPBARPOS.y - 30,0xffffff00)						
					end
				end
				tickwarn = GetTickCount() + 5000
				return
			elseif Bdmg > hp then
			local HPBARPOS = GetHPBarPos(myHero)
				if HPBARPOS.x > 0 then
					if HPBARPOS.y > 0 then				
						DrawText(string.format("You can kill %s(BlueCard)",GetObjectName(unit)),12,HPBARPOS.x,HPBARPOS.y - 30,0xffffff00)
					end
				end					
				tickwarn = GetTickCount() + 5000
				return
			end
		end
	end
end
