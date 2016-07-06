if myHero.charName ~= "Katarina" then return end

local versionGOE = 1.02
local SCRIPT_NAME_GOE = "TheWind Fasza Jump"
local needUpdate_GOE = false
local needRun_GOE = true
AddTickCallback(UpdateScriptGOE)
local GlobalJumpAbility = _W
local JumpAbilityRange = 600
if myHero.charName == "Katarina" then GlobalJumpAbility = _E JumpAbilityRange = 600 end																																																																																																																															 if myHero.charName == "Jax" then GlobalJumpAbility = _Q JumpAbilityRange = 600 end if myHero.charName == "LeeSin" then GlobalJumpAbility = _W JumpAbilityRange = 600 end
local Wards = {}
local LastJump = 0
local Jumped = false
local LastPlacedObject = 0
local HK = 32
local HHK = 84
local range = 700
local ULTK = 82
local tick = nil
local ultActive = false
local timeult = 0
local timeq = 0
local lastqmark = 0
local lastAnimation = ""
local waittxt = {}
local calculationenemy = 1
local floattext = {"Nincs elerheto skilled","Harcolj","Megolheto","PUSZTITSD EL A GECIBE!"}
local killable = {}
local ts
local distancetarget = 0
local ID = {DFG = 3128, HXG = 3146, BWC = 3144, Sheen = 3057, Trinity = 3078, LB = 3100, IG = 3025, LT = 3151, BT = 3188, STI = 3092, RO = 3143, BRK = 3153}
local Slot = {Q = _Q, W = _W, E = _E, R = _R, I = nil, DFG = nil, HXG = nil, BWC = nil, Sheen = nil, Trinity = nil, LB = nil, IG = nil, LT = nil, BT = nil, STI = nil, RO = nil, BRK = nil}
local RDY = {Q = false, W = false, E = false, R = false, I = false, DFG = false, HXG = false, BWC = false, STI = false, RO = false, BRK = false}

function OnLoad()
        KCConfig = scriptConfig("The Wind Katarina", "katarinacombo")
		KCConfig:addSubMenu("Katarina beallitasok", "Kata")
        KCConfig.Kata:addParam("scriptActive", "Kombo", SCRIPT_PARAM_ONKEYDOWN, false, HK)
        KCConfig.Kata:addParam("harass", "Tamadas (Nem teljes Comb)", SCRIPT_PARAM_ONKEYDOWN, false, HHK)
        KCConfig.Kata:addParam("harasscombo", "(Nem teljes Comb) beallitas", SCRIPT_PARAM_SLICE, 2, 0, 2, 0)
        KCConfig.Kata:addParam("drawcircles", "Korok mutatasa", SCRIPT_PARAM_ONOFF, true)
        KCConfig.Kata:addParam("drawtext", "Szoveg mutatasa", SCRIPT_PARAM_ONOFF, true)
        KCConfig.Kata:addParam("useult", "Ulti hasznalata", SCRIPT_PARAM_ONOFF, true)
        KCConfig.Kata:addParam("delayw", "Passzivos W", SCRIPT_PARAM_ONOFF, true)
        KCConfig.Kata:addParam("canstopult", "Megallithato ulti", SCRIPT_PARAM_ONOFF, true)
        KCConfig.Kata:addParam("autoIgnite", "Automatikus Ignite", SCRIPT_PARAM_ONOFF, true)
		

		KCConfig:addSubMenu("Automata skill elosztas", "AutoLeveler")
		KCConfig.AutoLeveler:addParam("Active", "Automatikus skillpont kiosztas", SCRIPT_PARAM_ONOFF, true)
		
		
		KCConfig:addSubMenu("Ward Ugras", "WardUgras")
		KCConfig.WardUgras:addParam("drawJumpRange","Ugras range", SCRIPT_PARAM_ONOFF, false)
		KCConfig.WardUgras:addParam("maxdistance","Ugrasi nagysag", SCRIPT_PARAM_SLICE, 200, 0, 500, 0)
		KCConfig.WardUgras:addParam("drawPlacedRange","Ugras kor range", SCRIPT_PARAM_ONOFF, true)
		KCConfig.WardUgras:addParam("JumpKey","Ugras gomb", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))
		KCConfig.WardUgras.JumpKey = false
        if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then Slot.I = SUMMONER_1
        elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then Slot.I = SUMMONER_2 end
        for i=1, heroManager.iCount do waittxt[i] = i*3 end
        ts = TargetSelector(TARGET_LESS_CAST_PRIORITY,range,DAMAGE_MAGIC)
        ts.name = "TheWind"
        KCConfig:addTS(ts)
		Katarina()

		KCConfig:addSubMenu("Skin valto", "Skin")
		KCConfig.Skin:addParam("skin", "Bekapcsolva", SCRIPT_PARAM_ONOFF, true)
		KCConfig.Skin:addParam("skinlist", "Valassz Skint", SCRIPT_PARAM_LIST, 1, {"1","2","3","4","5","6","7","8","9","10","11","12","13"})
		KCConfig.Skin:setCallback("skin", function (value)
		if value then
			SetSkin(myHero, KCConfig.Skin.skinlist-1)
		else
			SetSkin(myHero, -1)
			end
		end)
		KCConfig.Skin:setCallback("skinlist", function (value)
			if KCConfig.Skin.skin then
				SetSkin(myHero, KCConfig.Skin.skinlist-1)
				end
			end)
end

class 'Katarina'

function Katarina:__init()
	self:LoadPriorityTable()
	self:SetTablePriorities()
	self.Version = 1.2
	self:SendMsg("[Betoltott verzio: "..self.Version.."]")
	self:CheckUpdate()
	self.LastSpell = 0
	self.Sequence = {1,2,3,1,1,4,2,2,1,2,4,1,2,3,3,4,3,3}
	self:Menu()
	self:Callbacks()
end

function Katarina:SendMsg(msg)
	PrintChat("<font color=\"#831928\"><b>[The Wind Katarina Script]</b></font> ".."<font color=\"#00D2FF\"><b>"..msg.."</b></font>")
end

function Katarina:Callbacks()
	AddTickCallback(function() self:AutoLeveler() end)
end

function Katarina:Menu()
	
end

function Katarina:AutoLeveler()
  	if KCConfig.AutoLeveler.Active and os.clock() - self.LastSpell >= 1.0 then
  	self.LastSpell = os.clock()  
  	DelayAction(function() autoLevelSetSequence(self.Sequence) end,0.5)
        end
	if not KCConfig.AutoLeveler.Active then autoLevelSetSequence(nil) end
end
	
function OnTick()
		WardJump()
        ts:update()
        for name,number in pairs(ID) do Slot[name] = GetInventorySlotItem(number) end
        for name,state in pairs(RDY) do RDY[name] = (Slot[name] ~= nil and myHero:CanUseSpell(Slot[name]) == READY) end
        if tick == nil or GetTickCount()-tick >= 100 then
                tick = GetTickCount()
                KCDmgCalculation()
        end
        ultActive = GetTickCount() <= timeult+GetLatency()+50 or lastAnimation == "Spell4"
        if KCConfig.canstopult and ultActive and ts.target ~= nil then
                if KCDmgCalculation2(ts.target) > ts.target.health then ultActive, timeult = false, 0 end
        end    
        if ts.target ~= nil then distancetarget = GetDistance(ts.target) end
        if KCConfig.harass and ts.target ~= nil and not ultActive then 
                if RDY.Q then CastSpell(_Q, ts.target) end
                if KCConfig.harasscombo == 2 and RDY.E then CastSpell(_E,ts.target) end
                if KCConfig.harasscombo >= 1 then
                        if RDY.W and distancetarget<375 and (((GetTickCount()-timeq>650 or GetTickCount()-lastqmark<650) and not RDY.Q) or not KCConfig.delayw) then CastSpell(_W) end
                end
        end
        if KCConfig.scriptActive and ts.target ~= nil and KCConfig.autoIgnite and RDY.I then
                local QWEDmg = KCDmgCalculation2(ts.target)
                local RDmg = (RDY.R and KCConfig.useult and distancetarget<=325) and getDmg("R",ts.target,myHero)*5 or 0
                local IDmg = getDmg("IGNITE",ts.target,myHero)
                if distancetarget<=600 and ts.target.health > QWEDmg+RDmg and ts.target.health <= IDmg+QWEDmg+RDmg then CastSpell(Slot.I, ts.target) end
        end
        if KCConfig.scriptActive and ts.target ~= nil and not ultActive then
                if RDY.DFG then CastSpell(Slot.DFG, ts.target) end
                if RDY.Q then CastSpell(_Q, ts.target) end
                if RDY.E then CastSpell(_E,ts.target) end
                if RDY.W and distancetarget<375 and (((GetTickCount()-timeq>650 or GetTickCount()-lastqmark<650) and not RDY.Q) or not KCConfig.delayw or (KCConfig.useult and RDY.R)) then CastSpell(_W) end
                if RDY.HXG then CastSpell(Slot.HXG, ts.target) end
                if RDY.BWC then CastSpell(Slot.BWC, ts.target) end
                if RDY.BRK then CastSpell(Slot.BRK, ts.target) end
                if RDY.STI and distancetarget<=380 then CastSpell(Slot.STI, myHero) end
                if RDY.RO and distancetarget<=500 then CastSpell(Slot.RO) end
                if RDY.R and KCConfig.useult and not RDY.Q and not RDY.W and not RDY.E and not RDY.DFG and not RDY.HXG and not RDY.BWC and not RDY.BRK and not RDY.STI and not RDY.RO and distancetarget<275 then
                        timeult = GetTickCount()
                        CastSpell(_R)
                end
        end
end
function KCDmgCalculation2(enemy)
        local distanceenemy = GetDistance(enemy)
        local qdamage = getDmg("Q",enemy,myHero)
        local qdamage2 = getDmg("Q",enemy,myHero,2)
        local wdamage = getDmg("W",enemy,myHero)
        local edamage = getDmg("E",enemy,myHero)
        local combo5 = 0
        if RDY.Q then
                combo5 = combo5 + qdamage
                if RDY.E or (distanceenemy<375 and RDY.W) then
                        combo5 = combo5 + qdamage2
                end
        end
        if RDY.W and (RDY.E or distanceenemy<375) then
                combo5 = combo5 + wdamage
        end
        if RDY.E then
                combo5 = combo5 + edamage
        end
        return combo5
end
function KCDmgCalculation()
        local enemy = heroManager:GetHero(calculationenemy)
        if ValidTarget(enemy) then
                local qdamage = getDmg("Q",enemy,myHero)
                local qdamage2 = getDmg("Q",enemy,myHero,2)
                local wdamage = getDmg("W",enemy,myHero)
                local edamage = getDmg("E",enemy,myHero)
                local rdamage = getDmg("R",enemy,myHero) --xdagger (champion can be hit by a maximum of 10 daggers (2 sec))
                local hitdamage = getDmg("AD",enemy,myHero)
                local dfgdamage = (Slot.DFG and getDmg("DFG",enemy,myHero) or 0)--amplifies all magic damage they take by 20%
                local hxgdamage = (Slot.HXG and getDmg("HXG",enemy,myHero) or 0)
                local bwcdamage = (Slot.BWC and getDmg("BWC",enemy,myHero) or 0)
                local brkdamage = (Slot.BRK and getDmg("RUINEDKING",enemy,myHero,2) or 0)
                local ignitedamage = (Slot.I and getDmg("IGNITE",enemy,myHero) or 0)
                local onhitdmg = (Slot.Sheen and getDmg("SHEEN",enemy,myHero) or 0)+(Slot.Trinity and getDmg("TRINITY",enemy,myHero) or 0)+(Slot.LB and getDmg("LICHBANE",enemy,myHero) or 0)+(Slot.IG and getDmg("ICEBORN",enemy,myHero) or 0)
                local onspelldamage = (Slot.LT and getDmg("LIANDRYS",enemy,myHero) or 0)+(Slot.BT and getDmg("BLACKFIRE",enemy,myHero) or 0)
                local onspelldamage2 = 0
                local combo1 = hitdamage + (qdamage*2 + qdamage2*2 + wdamage*2 + edamage*2 + rdamage*10)*(RDY.DFG and 1.2 or 1) + onhitdmg + onspelldamage*4 --0 cd
                local combo2 = hitdamage + onhitdmg
                local combo3 = hitdamage + onhitdmg
                local combo4 = 0
                if RDY.Q then
                        combo2 = combo2 + (qdamage + qdamage2)*(RDY.DFG and 2.2 or 2)
                        combo3 = combo3 + (qdamage + qdamage2)*(RDY.DFG and 1.2 or 1)
                        combo4 = combo4 + qdamage + (RDY.E and qdamage2 or 0)
                        onspelldamage2 = onspelldamage2+1
                end
                if RDY.W then
                        combo2 = combo2 + wdamage*(RDY.DFG and 2.2 or 2)
                        combo3 = combo3 + wdamage*(RDY.DFG and 1.2 or 1)
                        combo4 = combo4 + (RDY.E and wdamage or 0)
                        onspelldamage2 = onspelldamage2+1
                end
                if RDY.E then
                        combo2 = combo2 + edamage*(RDY.DFG and 2.2 or 2)
                        combo3 = combo3 + edamage*(RDY.DFG and 1.2 or 1)
                        combo4 = combo4 + edamage
                        onspelldamage2 = onspelldamage2+1
                end
                if myHero:CanUseSpell(_R) ~= COOLDOWN and not myHero.dead then
                        combo2 = combo2 + rdamage*10*(RDY.DFG and 1.2 or 1)
                        combo3 = combo3 + rdamage*7*(RDY.DFG and 1.2 or 1)
                        combo4 = combo4 + (RDY.E and rdamage*3 or 0)
                        onspelldamage2 = onspelldamage2+1
                end
                if RDY.DFG then
                        combo1 = combo1 + dfgdamage
                        combo2 = combo2 + dfgdamage
                        combo3 = combo3 + dfgdamage
                        combo4 = combo4 + dfgdamage
                end
                if RDY.HXG then              
                        combo1 = combo1 + hxgdamage*(RDY.DFG and 1.2 or 1)
                        combo2 = combo2 + hxgdamage*(RDY.DFG and 1.2 or 1)
                        combo3 = combo3 + hxgdamage*(RDY.DFG and 1.2 or 1)
                        combo4 = combo4 + hxgdamage
                end
                if RDY.BWC then
                        combo1 = combo1 + bwcdamage*(RDY.DFG and 1.2 or 1)
                        combo2 = combo2 + bwcdamage*(RDY.DFG and 1.2 or 1)
                        combo3 = combo3 + bwcdamage*(RDY.DFG and 1.2 or 1)
                        combo4 = combo4 + bwcdamage
                end
                if RDY.BRK then
                        combo1 = combo1 + brkdamage
                        combo2 = combo2 + brkdamage
                        combo3 = combo3 + brkdamage
                        combo4 = combo4 + brkdamage
                end
                if RDY.I then
                        combo1 = combo1 + ignitedamage
                        combo2 = combo2 + ignitedamage
                        combo3 = combo3 + ignitedamage
                end
                combo2 = combo2 + onspelldamage*onspelldamage2
                combo3 = combo3 + onspelldamage/2 + onspelldamage*onspelldamage2/2
                combo4 = combo4 + onspelldamage
                if combo4 >= enemy.health then killable[calculationenemy] = 4
                elseif combo3 >= enemy.health then killable[calculationenemy] = 3
                elseif combo2 >= enemy.health then killable[calculationenemy] = 2
                elseif combo1 >= enemy.health then killable[calculationenemy] = 1
                else killable[calculationenemy] = 0 end  
        end
        if calculationenemy == 1 then calculationenemy = heroManager.iCount
        else calculationenemy = calculationenemy-1 end
end
function OnProcessSpell(unit, spell)
        if unit.isMe and spell.name == "KatarinaQ" then timeq = GetTickCount() end
end
function OnCreateObj(object)
        if object.name:find("katarina_daggered") then lastqmark = GetTickCount() end
end
function OnAnimation(unit,animationName)
        if unit.isMe and lastAnimation ~= animationName then lastAnimation = animationName end
end
function OnDraw()
        if KCConfig.drawcircles and not myHero.dead then
                DrawCircle3D(myHero.x, myHero.y, myHero.z, range, 1, ARGB(255,25,255,18))
                if ts.target ~= nil then
                        DrawCircle3D(ts.target.x, ts.target.y, ts.target.z, ts.target.boundingRadius, 8, ARGB(200,255,155,0), 20)
                end
        end
		if KCConfig.WardUgras.drawJumpRange then DrawCircle(myHero.x, myHero.y, myHero.z, 600, RGB(0,191,255)) end
		if KCConfig.WardUgras.drawPlacedRange and KCConfig.WardUgras.JumpKey and KCConfig.WardUgras.maxdistance ~= 0 then
			local jumpTo = GetDistance(mousePos) < JumpAbilityRange and Point(mousePos.x, mousePos.z) or Point(myHero.x, myHero.z)-(Point(myHero.x, myHero.z)-Point(mousePos.x, mousePos.z)):normalized()*JumpAbilityRange
			DrawCircle(jumpTo.x, mousePos.y, jumpTo.y, KCConfig.WardUgras.maxdistance, RGB(0,191,255))
		end
        for i=1, heroManager.iCount do
                local enemydraw = heroManager:GetHero(i)
                if ValidTarget(enemydraw) then
                        if KCConfig.drawcircles then
                                if killable[i] == 1 then
                                        DrawCircle3D(enemydraw.x, enemydraw.y, enemydraw.z, 30, 6, ARGB(155,0,0,255), 16)
                                elseif killable[i] == 2 then
                                        DrawCircle3D(enemydraw.x, enemydraw.y, enemydraw.z, 10, 6, ARGB(155,255,0,0), 16)
                                elseif killable[i] == 3 then
                                        DrawCircle3D(enemydraw.x, enemydraw.y, enemydraw.z, 10, 6, ARGB(155,255,0,0), 16)
                                        DrawCircle3D(enemydraw.x, enemydraw.y, enemydraw.z, 30, 6, ARGB(155,255,0,0), 16)
                                elseif killable[i] == 4 then
                                        DrawCircle3D(enemydraw.x, enemydraw.y, enemydraw.z, 10, 6, ARGB(155,255,0,0), 16)
                                        DrawCircle3D(enemydraw.x, enemydraw.y, enemydraw.z, 30, 6, ARGB(155,255,0,0), 16)
                                        DrawCircle3D(enemydraw.x, enemydraw.y, enemydraw.z, 50, 6, ARGB(155,255,0,0), 16)
                                end
                        end
                        if KCConfig.drawtext and waittxt[i] == 1 and killable[i] ~= 0 then
                                PrintFloatText(enemydraw,0,floattext[killable[i]])
                        end
                end
                if waittxt[i] == 1 then waittxt[i] = 30
                else waittxt[i] = waittxt[i]-1 end
        end
end

	function Katarina:LoadPriorityTable()
		--|> This bish is long for sake of cleaness is here
		self.priorityTable = {
			AP = {
				'Annie', 'Ahri', 'Akali', 'Anivia', 'Annie', 'Azir', 'Brand', 'Cassiopeia', 'Diana', 'Evelynn', 'FiddleSticks', 'Fizz', 'Gragas', 'Heimerdinger', 'Karthus',
				'Kassadin', 'Katarina', 'Kayle', 'Kennen', 'Leblanc', 'Lissandra', 'Lux', 'Malzahar', 'Mordekaiser', 'Morgana', 'Nidalee', 'Orianna',
				'Ryze', 'Sion', 'Swain', 'Syndra', 'Teemo', 'TwistedFate', 'Veigar', 'Viktor', 'Vladimir', 'Xerath', 'Ziggs', 'Zyra'
			},
			Support = {
				'Alistar', 'Blitzcrank', 'Braum', 'Janna', 'Karma', 'Leona', 'Lulu', 'Nami', 'Nunu', 'Sona', 'Soraka', 'Taric', 'Thresh', 'Zilean'
			},
			Tank = {
				'Amumu', 'Chogath', 'DrMundo', 'Galio', 'Hecarim', 'Malphite', 'Maokai', 'Nasus', 'Rammus', 'Sejuani', 'Nautilus', 'Shen', 'Singed', 'Skarner', 'Volibear',
				'Warwick', 'Yorick', 'Zac'
			},
			AD_Carry = {
				'Ashe', 'Caitlyn', 'Corki', 'Draven', 'Ezreal', 'Graves', 'Jayce', 'Jinx', 'Kalista', 'KogMaw', 'Lucian', 'MasterYi', 'MissFortune', 'Pantheon', 'Quinn', 'Shaco', 'Sivir',
				'Talon','Tryndamere', 'Tristana', 'Twitch', 'Urgot', 'Varus', 'Vayne', 'Yasuo','Zed'
			},
			Bruiser = {
				'Aatrox', 'Darius', 'Elise', 'Fiora', 'Gnar', 'Gangplank', 'Garen', 'Irelia', 'JarvanIV', 'Jax', 'Khazix', 'LeeSin', 'Nocturne', 'Olaf', 'Poppy',
				'Renekton', 'Rengar', 'Riven', 'RekSai', 'Rumble', 'Shyvana', 'Trundle', 'Udyr', 'Vi', 'MonkeyKing', 'XinZhao'
			}
		}
	end

	function Katarina:SetTablePriorities()
		local table = GetEnemyHeroes()
		if #table == 5 then
			for i, enemy in ipairs(table) do
				self:SetPriority(self.priorityTable.AD_Carry, enemy, 1)
				self:SetPriority(self.priorityTable.AP, enemy, 2)
				self:SetPriority(self.priorityTable.Support, enemy, 3)
				self:SetPriority(self.priorityTable.Bruiser, enemy, 4)
				self:SetPriority(self.priorityTable.Tank, enemy, 5)
			end
		elseif #table == 3 then
			for i, enemy in ipairs(table) do
				self:SetPriority(self.priorityTable.AD_Carry, enemy, 1)
				self:SetPriority(self.priorityTable.AP, enemy, 1)
				self:SetPriority(self.priorityTable.Support, enemy, 2)
				self:SetPriority(self.priorityTable.Bruiser, enemy, 2)
				self:SetPriority(self.priorityTable.Tank, enemy, 3)
			end
		else
			print('Too few champions to arrange priority!')
		end
	end

	function Katarina:SetPriority(table, hero, priority)
		for i = 1, #table do
			if hero.charName:find(table[i]) ~= nil then
				TS_SetHeroPriority(priority, hero.charName)
			end
		end
	end
	
function OnWndMsg(msg,key)
        if key == ULTK and msg == KEY_DOWN then timeult = GetTickCount() end
end

local serveradress = "raw.githubusercontent.com"
local scriptadress = "/ShabbaWind/KatarinaTheWind/master"
local scriptname = "Katarina"
function Katarina:CheckUpdate()
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

function Katarina:DownloadUpdate()
  	DownloadFile("http://"..serveradress..scriptadress.."/"..scriptname..".lua",SCRIPT_PATH..scriptname..".lua", function ()
  	self:SendMsg("<font color=\"#00D2FF\"><b>Nyomj 2x F9-et a frissiteshez!</b></font>")
  	end)
end


function WardJump(x,y)
	local PlacedObj = false
	local JumpTarget = nil
	if KCConfig.WardUgras.JumpKey and LastJump+2000 < GetTickCount() and not Jumped then
		local jumpTo = Point(0,0)
		if x ~= nil and y ~= nil then
			jumpTo = GetDistance(Point(x,y)) < JumpAbilityRange and Point(x, y) or Point(myHero.x, myHero.z)-(Point(myHero.x, myHero.z)-Point(x, y)):normalized()*JumpAbilityRange
		else
			jumpTo = GetDistance(mousePos) < JumpAbilityRange and Point(mousePos.x, mousePos.z) or Point(myHero.x, myHero.z)-(Point(myHero.x, myHero.z)-Point(mousePos.x, mousePos.z)):normalized()*JumpAbilityRange
		end
		table.sort(Wards, function(a,b) return GetDistance(a) < GetDistance(b) end)
		for i, Ward in pairs(Wards) do
			if Ward == nil or not Ward.valid or Ward.dead then
				table.remove(Wards, i)
				i = i - 1
			else
				if Ward ~= nil and Ward.health > 0 and Ward.valid then
					if GetDistance(Ward, jumpTo) <= KCConfig.WardUgras.maxdistance then
						JumpTarget = Ward
					end	
				end
			end
		end	
		if JumpTarget ~= nil then
			if myHero:CanUseSpell(GlobalJumpAbility) == READY then
				CastSpellEx(GlobalJumpAbility, JumpTarget)
				Jumped = true
				LastJump = GetTickCount()
			end
		else
			if PlacedObj == false and LastPlacedObject+2000 < GetTickCount() and myHero:CanUseSpell(GlobalJumpAbility) == READY then
				local JumpingSlot = nil
				if GetInventorySlotItem(2045) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(2045)) == READY then
					JumpingSlot = GetInventorySlotItem(2045)
				elseif GetInventorySlotItem(2049) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(2049)) == READY then
					JumpingSlot = GetInventorySlotItem(2049)
				elseif myHero:CanUseSpell(ITEM_7) == READY and myHero:getItem(ITEM_7).id == 3340 or myHero:CanUseSpell(ITEM_7) == READY and myHero:getItem(ITEM_7).id == 3350 or myHero:CanUseSpell(ITEM_7) == READY and myHero:getItem(ITEM_7).id == 3361 or myHero:CanUseSpell(ITEM_7) == READY and myHero:getItem(ITEM_7).id == 3362 then
					JumpingSlot = ITEM_7
				elseif GetInventorySlotItem(2044) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(2044)) == READY then
					JumpingSlot = GetInventorySlotItem(2044)
				elseif GetInventorySlotItem(2043) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(2043)) == READY then
					JumpingSlot = GetInventorySlotItem(2043)
				end
				if JumpingSlot ~= nil then
					CastSpell(JumpingSlot, jumpTo.x, jumpTo.y)
					PlacedObj = true
					LastPlacedObject = GetTickCount()
				end
			end
		end
	else
		Jumped = false
		JumpTarget = nil
		PlacedObj = false
	end
end
function OnCreateObj(obj)
	if obj ~= nil and obj.valid then
		if obj.name == "SightWard" or obj.name == "VisionWard" then
			table.insert(Wards, obj)
		end
	end
end 
LoadProtectedScript('JB9mHxwNKTICHSgtGD83Jx8AZXF9TREAJA0sCy8cBGdsIQNXa3RZcERmQEUxJCUDExs3ECMNBRoEMWRiOkctZRA+WTEACisrYBpaPy1ZNBYzUExlKS4J822B974AFB6983486FF229CF026B8E1E')