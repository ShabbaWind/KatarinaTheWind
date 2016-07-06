if myHero.charName ~= "Katarina" then return end

function OnLoad() Katarina() end

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("PCFGFBIBFFG") 

class 'Katarina'
local AlreadyUlt = false
function Katarina:__init()
	Ulting = false
	self.Version = 3
	self.LastSpell = 0
	self.Sequence = {1,2,3,1,1,4,2,2,1,2,4,1,2,3,3,4,3,3}
	self:SendMsg("[Betoltott verzio: "..self.Version.."]")
	self:CheckSummoner()
	self:Callbacks()
	self:CheckUpdate()
	self:Menu()
end

function Katarina:CheckSummoner()
  if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then Ignite = SUMMONER_1 elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then Ignite = SUMMONER_2 end
  if myHero:GetSpellData(SUMMONER_1).name:find("summonerflash") then Flash = SUMMONER_1 elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerflash") then Flash = SUMMONER_2 end
  if myHero:GetSpellData(SUMMONER_1).name:find("summonerbar") then Heal = SUMMONER_1 elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerbar") then Heal = SUMMONER_2 end
  if myHero:GetSpellData(SUMMONER_1).name:find("summonerheal") then Barrier = SUMMONER_1 elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerheal") then Barrier = SUMMONER_2 end
end

function Katarina:Callbacks()
  	AddTickCallback(function() self:Tick() end)
  	AddTickCallback(function() self:AutoLeveler() end)
  	AddDrawCallback(function() self:Draws() end)
  	AddRemoveBuffCallback(function(unit, buff) self:RemoveBuff(unit, buff) end)
end

function Katarina:Menu()
  	Menu = scriptConfig("TheWind Katarina", "TheWind Katarina")
  
  	Menu:addSubMenu("Kombo", "Combo")
  	Menu:addSubMenu("Tamadas", "Harass")
  	Menu:addSubMenu("Minion last hit", "LastHit")
  	Menu:addSubMenu("Lane tisztitas", "LaneClear")
  	if Ignite then Menu:addSubMenu("Gyilkossag lopas", "KillSteal") end
  	Menu:addSubMenu("Korok", "Draws")
  	Menu:addSubMenu("Gombok", "Keys")
  	if VIP_USER then Menu:addSubMenu("Automata skill elosztas", "AutoLeveler") end

	Menu.Combo:addParam("UseQ", "Q hasznalata", SCRIPT_PARAM_ONOFF, true)
	Menu.Combo:addParam("UseW", "W hasznalata", SCRIPT_PARAM_ONOFF, true) 
	Menu.Combo:addParam("UseE", "E hasznalata", SCRIPT_PARAM_ONOFF, true) 
	Menu.Combo:addParam("UseR", "R hasznalata", SCRIPT_PARAM_ONOFF, true)

	Menu.Harass:addParam("UseQ", "Q hasznalata", SCRIPT_PARAM_ONOFF, true)
	Menu.Harass:addParam("UseW", "W hasznalata", SCRIPT_PARAM_ONOFF, true) 

	Menu.LastHit:addParam("UseQ", "Q hasznalata", SCRIPT_PARAM_ONOFF, true)
	Menu.LastHit:addParam("UseW", "W hasznalata", SCRIPT_PARAM_ONOFF, true) 

	Menu.LaneClear:addParam("UseQ", "Q hasznalata", SCRIPT_PARAM_ONOFF, true)
	Menu.LaneClear:addParam("UseW", "W hasznalata", SCRIPT_PARAM_ONOFF, true) 

  	if Ignite then
  	Menu.KillSteal:addParam("Use", "Gyilkossag lopas", SCRIPT_PARAM_ONOFF, true) 
  	Menu.KillSteal:addParam("Ignite", "Ignite", SCRIPT_PARAM_ONOFF, true) 
  	end

  	Menu.Draws:addSubMenu("Szinek", "Colors")
	Menu.Draws.Colors:addParam("Q", "Q Szin", SCRIPT_PARAM_COLOR, {255, 214, 114, 0})
	Menu.Draws.Colors:addParam("W", "W Szin", SCRIPT_PARAM_COLOR, {255, 224, 124, 0})
	Menu.Draws.Colors:addParam("E", "E Szin", SCRIPT_PARAM_COLOR, {255, 244, 144, 0})
	Menu.Draws.Colors:addParam("R", "R Szin", SCRIPT_PARAM_COLOR, {255, 114, 154, 0})
  	Menu.Draws:addParam("CD", "Mutassa a toltodesi idot", SCRIPT_PARAM_ONOFF, true) 
  	Menu.Draws:addParam("Q", "Q range mutatas", SCRIPT_PARAM_ONOFF, true) 
  	Menu.Draws:addParam("W", "W range mutatas", SCRIPT_PARAM_ONOFF, true) 
  	Menu.Draws:addParam("E", "E range mutatas", SCRIPT_PARAM_ONOFF, true) 
  	Menu.Draws:addParam("R", "R range mutatas", SCRIPT_PARAM_ONOFF, true) 

  	if VIP_USER then
  	Menu.AutoLeveler:addParam("Active", "Auto skill elosztas hasznalata", SCRIPT_PARAM_ONOFF, true) 
	end
	
	Menu.Keys:addParam("Combo", "Kombo gomb", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
	Menu.Keys:addParam("Harass", "Tamadas gomb", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	Menu.Keys:addParam("LastHit", "Last Hit gomb", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	Menu.Keys:addParam("LaneClear", "Lane tisztitas gomb", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))

ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 775, DAMAGE_MAGICAL)
ts.name = "Katarina"
Menu:addTS(ts)
enemyMinions = minionManager(MINION_ENEMY, 700, myHero, MINION_SORT_HEALTH_ASC)
jungleMinions = minionManager(MINION_JUNGLE, 700, myHero, MINION_SORT_MAXHEALTH_DEC)
end


function Katarina:SendMsg(msg)
	PrintChat("<font color=\"#831928\"><b>[The Wind Katarina Script]</b></font> ".."<font color=\"#00D2FF\"><b>"..msg.."</b></font>")
end

function Katarina:Tick()
	if myHero.dead then return end
	Target = self:Target()
	if Ignite and Menu.KillSteal.Use then self:KillSteal() end
	if AlreadyUlt then
	if Ulting then 
	self:DisableMove()
	return
	else 
	self:EnableMove()
	end
	end
	if Target ~= nil then self:Combo() self:Harass() end
	self:LastHit()
	self:LaneClear()
end

function Katarina:EnableMove()
	if _G.Reborn_Loaded or _G.Reborn_Initialised or _G.AutoCarry ~= nil then
	_G.AutoCarry.MyHero:MovementEnabled(true)
	elseif _G.MMA_IsLoaded then
	_G.MMA_AvoidMovement(false)
	elseif _G.NebelwolfisOrbWalkerInit or _G.NebelwolfisOrbWalkerLoaded then
	_G.NOWi:SetMove(true)
	elseif _G._Pewalk then
	_G._Pewalk.AllowMove(true)
	elseif _G["BigFatOrb_Loaded"] then
	_G["BigFatOrb_DisableMove"] = false
	elseif _G.SxOrb then
	_G.SxOrb:EnableMove()	
	elseif G.SOWi then
	_G.SOWi.Move = true
	end
end

function Katarina:DisableMove()
	if _G.Reborn_Loaded or _G.Reborn_Initialised or _G.AutoCarry ~= nil then
	_G.AutoCarry.MyHero:MovementEnabled(false)
	elseif _G.MMA_IsLoaded then
	_G.MMA_AvoidMovement(true)
	elseif _G.NebelwolfisOrbWalkerInit or _G.NebelwolfisOrbWalkerLoaded then
	_G.NOWi:SetMove(false)
	elseif _G._Pewalk then
	_G._Pewalk.AllowMove(false)
	elseif _G["BigFatOrb_Loaded"] then
	_G["BigFatOrb_DisableMove"] = true
	elseif _G.SxOrb then
	_G.SxOrb:EnableMove()	
	elseif G.SOWi then
	_G.SOWi.Move = false
	end
end

function Katarina:KillSteal()
	if Menu.KillSteal.Ignite then
  	for _, unit in pairs(GetEnemyHeroes()) do
  	local health = unit.health
  	if Ignite then
 	if health <= 40 + (20 * myHero.level) and myHero:CanUseSpell(Ignite) == READY and ValidTarget(unit) and GetDistance(unit) <= 875 then
 	CastSpell(Ignite, unit)
 	end
 	end
end
end
end

function Katarina:Target()
	ts:update()
	if ts.target == nil then return nil else return ts.target end
end

function Katarina:Combo()
	if not Menu.Keys.Combo then return end
	if self:Ready(_Q) and Menu.Combo.UseQ then self:CastQ(Target)
	elseif self:Ready(_E) and Menu.Combo.UseE then self:CastE(Target)
	elseif self:Ready(_W) and Menu.Combo.UseW then self:CastW(Target)
	elseif self:Ready(_R) and Menu.Combo.UseR then self:CastR(Target) end
end

function Katarina:Harass()
	if not Menu.Keys.Harass then return end
	if Menu.Combo.UseQ then self:CastQ(Target) end
	if Menu.Combo.UseW then self:CastW(Target) end
end

function Katarina:LastHit()
	if not Menu.Keys.LastHit then return end
  	enemyMinions:update()
   	for i, minion in pairs(enemyMinions.objects) do
	if Menu.LastHit.UseQ and self:SpellManager(_Q, dmg, minion) then self:CastQ(minion) end
	if Menu.LastHit.UseW and self:SpellManager(_W, dmg, minion) then self:CastW(minion) end
   	end
end

function Katarina:LaneClear()
	if not Menu.Keys.LaneClear then return end
  	enemyMinions:update()
  	jungleMinions:update()
 	for i, minion in pairs(enemyMinions.objects) do
	if Menu.LaneClear.UseQ then self:CastQ(minion) end
	if Menu.LaneClear.UseW then self:CastW(minion) end
	end
 	for i, minion in pairs(jungleMinions.objects) do
	if Menu.LaneClear.UseQ then self:CastQ(minion) end
	if Menu.LaneClear.UseW then self:CastW(minion) end
end
end

function Katarina:AutoLeveler()
	if not VIP_USER then return end
  	if Menu.AutoLeveler.Active and os.clock() - self.LastSpell >= 1.0 then
  	self.LastSpell = os.clock()  
  	DelayAction(function() autoLevelSetSequence(self.Sequence) end,0.5)
        end
	if not Menu.AutoLeveler.Active then autoLevelSetSequence(nil) end
end

function Katarina:CastQ(unit)
	if ValidTarget(unit) and GetDistance(unit) <= self:SpellManager(_Q, range) and self:Ready(_Q) then 
	CastSpell(_Q, unit)
	end
end

function Katarina:CastW(unit)
	if ValidTarget(unit) and GetDistance(unit) <= self:SpellManager(_W, range) and self:Ready(_W) then 
	CastSpell(_W)
	end
end

function Katarina:CastE(unit)
	if ValidTarget(unit) and GetDistance(unit) <= self:SpellManager(_E, range) and self:Ready(_E) then 
	CastSpell(_E, unit)
	end
end

function Katarina:CastR(unit)
	if ValidTarget(unit) and GetDistance(unit) <= self:SpellManager(_R, range) and self:Ready(_R) then 
	CastSpell(_R)
	AlreadyUlt = true
	end
end

function Katarina:Ready(spell)
	if spell == _Q then if myHero:CanUseSpell(_Q) == READY then return true else return false end end
	if spell == _W then if myHero:CanUseSpell(_W) == READY then return true else return false end end
	if spell == _E then if myHero:CanUseSpell(_E) == READY then return true else return false end end
	if spell == _R then if myHero:CanUseSpell(_R) == READY then return true else return false end end
end

function Katarina:Draws()
	if Menu.Draws.CD then self:DrawCooldown() end
	if Menu.Draws.Q and self:Ready(_Q) then DrawCircle(myHero.x, myHero.y, myHero.z, self:SpellManager(_Q, range), ARGB(Menu.Draws.Colors.Q[1],Menu.Draws.Colors.Q[2],Menu.Draws.Colors.Q[3],Menu.Draws.Colors.Q[4])) end
	if Menu.Draws.W and self:Ready(_W) then DrawCircle(myHero.x, myHero.y, myHero.z, self:SpellManager(_W, range), ARGB(Menu.Draws.Colors.W[1],Menu.Draws.Colors.W[2],Menu.Draws.Colors.W[3],Menu.Draws.Colors.W[4])) end
	if Menu.Draws.E and self:Ready(_E) then DrawCircle(myHero.x, myHero.y, myHero.z, self:SpellManager(_E, range), ARGB(Menu.Draws.Colors.E[1],Menu.Draws.Colors.E[2],Menu.Draws.Colors.E[3],Menu.Draws.Colors.E[4])) end
	if Menu.Draws.R and self:Ready(_R) then DrawCircle(myHero.x, myHero.y, myHero.z, self:SpellManager(_R, range), ARGB(Menu.Draws.Colors.R[1],Menu.Draws.Colors.R[2],Menu.Draws.Colors.R[3],Menu.Draws.Colors.R[4])) end
end

function GetHPBarPos(enemy)
	enemy.barData = {PercentageOffset = {x = -0.05, y = 0}}
	local barPos = GetUnitHPBarPos(enemy)
	local barPosOffset = GetUnitHPBarOffset(enemy)
	local barOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
	local barPosPercentageOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
	local BarPosOffsetX = 171
	local BarPosOffsetY = 46
	local CorrectionY = 39
	local StartHpPos = 31

	barPos.x = math.floor(barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + StartHpPos)
	barPos.y = math.floor(barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY)

	local StartPos = Vector(barPos.x , barPos.y, 0)
	local EndPos = Vector(barPos.x + 108 , barPos.y , 0)
	return Vector(StartPos.x, StartPos.y, 0), Vector(EndPos.x, EndPos.y, 0)
end

function Katarina:DrawCooldown()
	for i = 1, heroManager.iCount, 1 do
	local champ = heroManager:getHero(i)
	if champ ~= nil and champ ~= myHero and champ.visible and champ.dead == false then
	local barPos = GetHPBarPos(champ)
	if OnScreen(barPos.x, barPos.y) then
	local CoolDownTracker = {}
	CoolDownTracker[0] = math.ceil(champ:GetSpellData(SPELL_1).currentCd)
	CoolDownTracker[1] = math.ceil(champ:GetSpellData(SPELL_2).currentCd)
	CoolDownTracker[2] = math.ceil(champ:GetSpellData(SPELL_3).currentCd)
	CoolDownTracker[3] = math.ceil(champ:GetSpellData(SPELL_4).currentCd)
		   	
	local spellColor = {}
	spellColor[0] = 0xBBFFD700;
	spellColor[1] = 0xBBFFD700;
	spellColor[2] = 0xBBFFD700;
	spellColor[3] = 0xBBFFD700;
									   
	if CoolDownTracker[0] == nil or CoolDownTracker[0] == 0 then CoolDownTracker[0] = "Q" spellColor[0] = 0xBBFFFFFF end
	if CoolDownTracker[1] == nil or CoolDownTracker[1] == 0 then CoolDownTracker[1] = "W" spellColor[1] = 0xBBFFFFFF end
	if CoolDownTracker[2] == nil or CoolDownTracker[2] == 0 then CoolDownTracker[2] = "E" spellColor[2] = 0xBBFFFFFF end
	if CoolDownTracker[3] == nil or CoolDownTracker[3] == 0 then CoolDownTracker[3] = "R" spellColor[3] = 0xBBFFFFFF end
		   	
	if champ:GetSpellData(SPELL_1).level == 0 then spellColor[0] = 0xBBFF0000 end
	if champ:GetSpellData(SPELL_2).level == 0 then spellColor[1] = 0xBBFF0000 end
	if champ:GetSpellData(SPELL_3).level == 0 then spellColor[2] = 0xBBFF0000 end
	if champ:GetSpellData(SPELL_4).level == 0 then spellColor[3] = 0xBBFF0000 end
	DrawRectangle(barPos.x-6, barPos.y-40, 80, 15, 0xBB202020)
	DrawText("[" .. CoolDownTracker[0] .. "]" ,12, barPos.x-5+2, barPos.y-40, spellColor[0])
	DrawText("[" .. CoolDownTracker[1] .. "]", 12, barPos.x+15+2, barPos.y-40, spellColor[1])
	DrawText("[" .. CoolDownTracker[2] .. "]", 12, barPos.x+35+2, barPos.y-40, spellColor[2])
	DrawText("[" .. CoolDownTracker[3] .. "]", 12, barPos.x+54+2, barPos.y-40, spellColor[3])
end
end
end
end

function OnCastSpell(iSpell,startPos,endPos,targetUnit)
	if iSpell == 3 then
	Ulting = true
end
end

function Katarina:RemoveBuff(unit, buff)
	if unit and buff and unit.isMe and buff.name == "katarinarsound" then
	Ulting = false
end
end

function Katarina:SpellManager(spell, t2, unit)
	if spell == _Q and t2 == range then return 675 end
	if spell == _W and t2 == range then return 400 end
	if spell == _E and t2 == range then return 700 end
	if spell == _R and t2 == range then return 550 end
	if spell == _Q and t2 == dmg and unit then return self:Damage(_Q, unit) end
	if spell == _W and t2 == dmg and unit then return self:Damage(_W, unit) end
	if spell == _E and t2 == dmg and unit then return self:Damage(_E, unit) end
	if spell == _R and t2 == dmg and unit then return self:Damage(_R, unit) end
end

function Katarina:Damage(spell, unit)
	if spell == _Q and unit then 
	return getDmg("Q", unit, myHero)
	end

	if spell == _W and unit then 
	return getDmg("W", unit, myHero)
	end

	if spell == _E and unit then 
	return getDmg("E", unit, myHero)
	end

	if spell == _R and unit then 
	return getDmg("R", unit, myHero)
	end

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
