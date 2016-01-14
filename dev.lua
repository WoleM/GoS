function GetDistanceX(p1,p2)
    p1 = GetOrigin(p1) or p1
    p2 = GetOrigin(p2) or p2
    return math.sqrt(GetDistanceSqrX(p1,p2))
end

function GetDistanceSqrX(p1,p2)
    p2 = p2 or GetMyHeroPos()
    local dx = p1.x - p2.x
    local dz = (p1.z or p1.y) - (p2.z or p2.y)
    return dx*dx + dz*dz
end

OnObjectLoop(function(Object,myHero)
local Obj_Type = GetObjectType(Object);
if Obj_Type == Obj_AI_Hero then
	if IsVisible(Object) then
		if IsObjectAlive(Object) then
			local origin = GetOrigin(Object);
			local myscreenpos = WorldToScreen(1,origin.x,origin.y,origin.z);
			if myscreenpos.flag then
				DrawText(string.format("ChampName  = %s", GetObjectName(Object)),12,myscreenpos.x,myscreenpos.y,0xffffffff);
				DrawText(string.format("NetworkID     = 0x%X", GetNetworkID(Object)),12,myscreenpos.x,myscreenpos.y+10,0xffffffff);
				DrawText(string.format("Q________   = %s", GetCastName(Object,_Q)),12,myscreenpos.x,myscreenpos.y+20,0xffffffff);
				DrawText(string.format("W________  = %s", GetCastName(Object,_W)),12,myscreenpos.x,myscreenpos.y+30,0xffffffff);
				DrawText(string.format("E________    = %s", GetCastName(Object,_E)),12,myscreenpos.x,myscreenpos.y+40,0xffffffff);
				DrawText(string.format("R________    = %s", GetCastName(Object,_R)),12,myscreenpos.x,myscreenpos.y+50,0xffffffff);
				DrawText(string.format("SUMONER_1  = %s", GetCastName(Object,SUMMONER_1)),12,myscreenpos.x,myscreenpos.y+60,0xffffffff);
				DrawText(string.format("SUMONER_2  = %s", GetCastName(Object,SUMMONER_2)),12,myscreenpos.x,myscreenpos.y+70,0xffffffff);
				
				local yadder = 0;
				
				for i = 0,63 do
					if GetBuffCount(Object,i) > 0 then
						currbufname = GetBuffName(Object,i);
						currbufcount = GetBuffCount(Object,i);
						yadder = yadder + 10;
						DrawText(string.format("Buffstacks: %d for %s", currbufcount,currbufname),12,myscreenpos.x,myscreenpos.y+80+yadder,0xff00ff00);
						end
					end
				end
			end
		end
	else 
	local origin = GetOrigin(Object);
	local mousepoz = GetMousePos();
	if (GetDistanceX(origin,mousepoz) < 200) then
		local myscreenpos = WorldToScreen(1,origin.x,origin.y,origin.z);
		if myscreenpos.flag then
			DrawCircle(origin.x,origin.y,origin.z,30,0,10000,0xffffffff);
			DrawText(string.format("NetworkID = 0x%X", GetNetworkID(Object)),12,myscreenpos.x,myscreenpos.y,0xffffffff);
			DrawText(string.format("ObjType  = %s", GetObjectType(Object)),12,myscreenpos.x,myscreenpos.y+10,0xffffffff);
			DrawText(string.format("BaseName  = %s", GetObjectBaseName(Object)),12,myscreenpos.x,myscreenpos.y+20,0xffffffff);
			DrawText(string.format("Name  = %s", GetObjectName(Object)),12,myscreenpos.x,myscreenpos.y+30,0xffffffff);
			end
		end
	end
end)

OnTick(function(myHero)
origin = GetOrigin(myHero);
myscreenpos = WorldToScreen(1,origin.x,origin.y,origin.z);
if myscreenpos.flag then
	DrawText(string.format("ChampName  = %s", GetObjectName(myHero)),12,myscreenpos.x,myscreenpos.y,0xffffffff);
	DrawText(string.format("NetworkID     = 0x%X", GetNetworkID(myHero)),12,myscreenpos.x,myscreenpos.y+10,0xffffffff);
	DrawText(string.format("Q________   = %s", GetCastName(myHero,_Q)),12,myscreenpos.x,myscreenpos.y+20,0xffffffff);
	DrawText(string.format("W________  = %s", GetCastName(myHero,_W)),12,myscreenpos.x,myscreenpos.y+30,0xffffffff);
	DrawText(string.format("E________    = %s", GetCastName(myHero,_E)),12,myscreenpos.x,myscreenpos.y+40,0xffffffff);
	DrawText(string.format("R________    = %s", GetCastName(myHero,_R)),12,myscreenpos.x,myscreenpos.y+50,0xffffffff);
	DrawText(string.format("SUMONER_1  = %s", GetCastName(myHero,SUMMONER_1)),12,myscreenpos.x,myscreenpos.y+60,0xffffffff);
	DrawText(string.format("SUMONER_2  = %s", GetCastName(myHero,SUMMONER_2)),12,myscreenpos.x,myscreenpos.y+70,0xffffffff);	
	local yadder = 0;
	for i = 0,63 do
		if GetBuffCount(myHero,i) > 0 then
			currbufname = GetBuffName(myHero,i);
			currbufcount = GetBuffCount(myHero,i);
			yadder = yadder + 10;
			DrawText(string.format("Buffstacks: %d for %s", currbufcount,currbufname),12,myscreenpos.x,myscreenpos.y+80+yadder,0xff00ff00);
			end
		end
	end
end)

OnProcessSpell(function(unit,spell)
local Obj_Type = GetObjectType(unit);
if Obj_Type == Obj_AI_Hero then 
	PrintChat(string.format("'%s' casts '%s'; Windup: %.3f Animation: %.3f", GetObjectName(unit), spell.name, spell.windUpTime, spell.animationTime))
	end
end)
