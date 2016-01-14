require('Inspired')

AutoUpdate("/WoleM/GoS/new/master/GANK.lua","/WoleM/GoS/new/master/GANK.version","GANK.lua",1)

PrintChat(string.format("<font color='#1244EA'>Gank Notifier</font> <font color='#FFFFFF'> By WoleM Loaded! </font>"))

OnTick(function(myHero)
local myHero = GetMyHero()
local myHeroPos = GetOrigin(myHero)
	if EnemiesAround(myHeroPos, 2000) > 0 then
	local hero_origin = myHeroPos
	local myscreenpos = WorldToScreen(1,hero_origin.x,hero_origin.y,hero_origin.z)
		if myscreenpos.flag then
			if EnemiesAround(myHeroPos, 2000) > AlliesAround(myHeroPos,2000)+1 then
				DrawText(string.format("GANKED"),24,myscreenpos.x,myscreenpos.y,0xffff0000)
			end
		end
	end
end)

function AlliesAround(pos, range)
    local c = 0
    if pos == nil then return 0 end
    for k,v in pairs(GetAllyHeroes()) do 
        if v and GetDistanceSqr(pos,GetOrigin(v)) < range*range then
            c = c + 1
        end
    end
    return c
end
