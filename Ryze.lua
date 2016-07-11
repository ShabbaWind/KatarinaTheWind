require "SxOrbWalk"
if (myHero.charName ~= "Ryze") then return end

local ts = TargetSelector(TARGET_LOW_HP_PRIORITY, 600)
function OnLoad()

	config = scriptConfig ("TheWind Ryze", "TheWind Ryze")

	config:addSubMenu("Korok", "Draw")
	config.Draw:addParam("DrawR", "Auto Attack Range Kor", SCRIPT_PARAM_ONOFF, true)
	config.Draw:addParam("DrawQ", "Q Range kor", SCRIPT_PARAM_ONOFF, true)
	config.Draw:addParam("DrawE", "E-W Range kor", SCRIPT_PARAM_ONOFF, true)

	config:addSubMenu("Kombo", "Combo")
	config.Combo:addParam("Combo", "Kombo modok", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
	config.Combo:addParam("Poke", "Poke", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))

	config:addSubMenu("Orbwalker", "SxOrbWalk")
	SxOrb:LoadToMenu(config.SxOrbWalk)
end

class 'Ryze'

function Ryze:__init()
	self.Version = 1.1
	self:SendMsg("[Betoltott verzio: "..self.Version.."]")
	self:CheckUpdate()
end

function Ryze:SendMsg(msg)
	PrintChat("<font color=\"#831928\"><b>[The Wind Ryze Script]</b></font> ".."<font color=\"#00D2FF\"><b>"..msg.."</b></font>")
end

function OnTick()
	ts:update()
	Poke()
	Combo()
end

function OnDraw( ... )
	if (myHero.dead) then return end
	if (config.Draw.DrawQ) then 
	    if (myHero:CanUseSpell(_Q) == READY) then
		    DrawCircle(myHero.x, myHero.y, myHero.z, 900, 0xFF33CC)
		end
	end
	if (config.Draw.DrawE) then 
		if (myHero:CanUseSpell(_E) == READY) then 
			DrawCircle(myHero.x, myHero.y, myHero.z, 600, 0xFF6633)
		end
	end
	if (config.Draw.DrawR) then 
		DrawCircle(myHero.x, myHero.y, myHero.z, 610, 0xFF3366)
	end
end

function Poke()
	if (ts.target ~= nil) and not (ts.target.dead) and (ts.target.visible) then
		if (config.Combo.Poke) then
			if (myHero:GetDistance(ts.target) <= 600) then 
				if (myHero:CanUseSpell(_W) == READY) then
					CastSpell(_W, ts.target)
				end
				if (myHero:CanUseSpell(_Q) == READY) then
					CastSpell(_Q, ts.target.x,ts.target.z)
				end
				if (myHero:CanUseSpell(_E) == READY) then
					CastSpell(_E, ts.target)
				end
			end
		end
	end
end

function Combo()
	if (ts.target ~= nil) and not (ts.target.dead) and (ts.target.visible) then
		if (config.Combo.Combo) then
			if (myHero:GetDistance(ts.target) <= 600) then
				if (myHero:CanUseSpell(_R) == READY) then
					CastSpell(_R)
				end
				if (myHero:CanUseSpell(_W) == READY) then
					CastSpell(_W, ts.target)
				end
				if (myHero:CanUseSpell(_Q) == READY) then
					CastSpell(_Q, ts.target.x,ts.target.z)
				end
				if (myHero:CanUseSpell(_E) == READY) then
					CastSpell(_E, ts.target)
				end
			end
		end
	end
end

local serveradress = "raw.githubusercontent.com"
local scriptadress = "/ShabbaWind/KatarinaTheWind/master"
local scriptname = "Ryze"
function Ryze:CheckUpdate()
  	local ServerVersionDATA = GetWebResult(serveradress , scriptadress.."/"..scriptname..".version")
		if ServerVersionDATA then
    local ServerVersion = tonumber(ServerVersionDATA)
		if ServerVersion then
			if ServerVersion > tonumber(self.Version) then
			self:SendMsg("<font color=\"#00D2FF\"><b>Nyomj 2x F9-et a frissiteshez!</b></font>")
		self:DownloadUpdate()
    else
		self:SendMsg("<font color=\"#00D2FF\"><b>Neked a legujabb verziod van! :) Kellemes scriptelest..</b></font>")
    end
    else
		self:SendMsg("<font color=\"#00D2FF\"><b>Valami hiba tortent a letoltes soran!</b></font>")
    end
  	else
		self:SendMsg("<font color=\"#00D2FF\"><b>Nem sikerult csatlakozni a szerverhez!</b></font>")
	end
end

function Ryze:DownloadUpdate()
	DownloadFile("http://"..serveradress..scriptadress.."/"..scriptname..".lua",SCRIPT_PATH..scriptname..".lua", function ()
		self:SendMsg("<font color=\"#00D2FF\"><b>Nyomj 2x F9-et a frissiteshez!</b></font>")
  	end)
end