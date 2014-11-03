--<< Display a lot of information about enemy heroes, glyph cooldown, courer, rune and visibe by enemy status>>
require("libs.Res")
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("manaBar", true)
config:SetParameter("overlaySpell", true)
config:SetParameter("overlayItem", true)
config:SetParameter("topPanel", true)
config:SetParameter("glypPanel", true)
config:SetParameter("ShowRune", true)
config:SetParameter("ShowCourier", true)
config:SetParameter("ShowIfVisible", true)
config:Load()

local manaBar = config.manaBar
local overlaySpell = config.overlaySpell
local overlayItem = config.overlayItem
local topPanel = config.topPanel
local glypPanel = config.glypPanel
local ShowRune = config.ShowRune
local ShowCourier = config.ShowCourier
local ShowIfVisible = config.ShowIfVisible

local item = {} local hero = {} local spell = {} local panel = {} local mana = {} local cours = {}local eff = {} local mod = {} local rune = {} 
local sleeptick = 0 local last = 0

print(math.floor(client.screenRatio*100))

--Config.
--If u have some problem with positioning u can add screen ration(64 line) and create config for yourself.
if math.floor(client.screenRatio*100) == 177 then
testX = 1600
testY = 900
tpanelHeroSize = 55
tpanelHeroDown = 25.714
tpanelHeroSS = 22
tmanaSize = 83
tmanaX = 42
tmanaY = 18
tglyphX = 1.0158
tglyphY = 1.03448
txxB = 2.527
txxG = 3.47
elseif math.floor(client.screenRatio*100) == 166 then
testX = 1280
testY = 768
tpanelHeroSize = 47
tpanelHeroDown = 25.714
tpanelHeroSS = 22
tmanaSize = 70
tmanaX = 36
tmanaY = 14
tglyphX = 1.0180
tglyphY = 1.03448
txxB = 2.558
txxG = 3.62
elseif math.floor(client.screenRatio*100) == 160 then
testX = 1280
testY = 800
tpanelHeroSize = 48.5
tpanelHeroDown = 25.714
tpanelHeroSS = 22
tmanaSize = 74
tmanaX = 38
tmanaY = 15
tglyphX = 1.0180
tglyphY = 1.03448
txxB = 2.579
txxG = 3.735
elseif math.floor(client.screenRatio*100) == 133 then
testX = 1024
testY = 768
tpanelHeroSize = 47
tpanelHeroDown = 25.714
tpanelHeroSS = 22
tmanaSize = 72
tmanaX = 37
tmanaY = 14
tglyphX = 1.021
tglyphY = 1.03448
txxB = 2.747
txxG = 4.54
elseif math.floor(client.screenRatio*100) == 125 then
testX = 1280
testY = 1024
tpanelHeroSize = 58
tpanelHeroDown = 25.714
tpanelHeroSS = 23
tmanaSize = 97
tmanaX = 48
tmanaY = 21
tglyphX = 1.021
tglyphY = 1.03448
txxB = 2.747
txxG = 4.54
else
testX = 1600
testY = 900
tpanelHeroSize = 55
tpanelHeroDown = 25.714
tpanelHeroSS = 22
tmanaSize = 83
tmanaX = 42
tmanaY = 18
tglyphX = 1.0158
tglyphY = 1.03448
txxB = 2.527
txxG = 3.47
end

local rate = 1920/testX
local con = 1920/1600
if con < 1 then	con = 1 end
--top panel coordinate
local x_ = tpanelHeroSize*(client.screenSize.x/testX)
local y_ = client.screenSize.y/tpanelHeroDown
local ss = tpanelHeroSS*(client.screenSize.x/testX)

--manabar coordinate
local manaSizeW = client.screenSize.x/testX*tmanaSize
local manaX = client.screenSize.x/testX*tmanaX
local manaY = client.screenSize.y/testY*tmanaY

--rune
rune[-2272] = drawMgr:CreateRect(0,0,20*con,20*con,0x000000ff) rune[-2272].visible = false
rune[3008] = drawMgr:CreateRect(0,0,20*con,20*con,0x000000ff) rune[3008].visible = false

--font
local F10 = drawMgr:CreateFont("F10","Arial",10*con,500)
local F11 = drawMgr:CreateFont("F11","Arial",11*con,500)
local F12 = drawMgr:CreateFont("F12","Arial",12*con,500)
local F13 = drawMgr:CreateFont("F13","Arial",13*con,500)
local F14 = drawMgr:CreateFont("F14","Arial",14*con,500)

--gliph coordinate
local glyph = drawMgr:CreateText(client.screenSize.x/tglyphX,client.screenSize.y/tglyphY,0xFFFFFF60,"",F13)
glyph.visible = false

function Tick(tick)

	if not client.connected or client.loading or client.console or tick < sleeptick then return end

	sleeptick = tick + 200

	local me = entityList:GetMyHero()

	if not me then return end

	if ShowRune then
		Rune()
	end
	
	if ShowCourier then
		Courier(me)
	end

	local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO})
	local player = entityList:GetEntities({classId=CDOTA_PlayerResource})[1]
	
	if ShowIfVisible then
		VisibleByEnemy(me,enemies)
	end
	
	for i = 1, #enemies do
		local v = enemies[i]
		if not v.illusion then
			local hand = v.handle
			if v.team ~= me.team then
				local offset = v.healthbarOffset

				if offset == -1 then return end
				
				if not hero[hand] then hero[hand] = {}
					hero[hand].manar1 = drawMgr:CreateRect(-manaX-1,-manaY,manaSizeW+2,6,0x010102ff,true) hero[hand].manar1.visible = false hero[hand].manar1.entity = v hero[hand].manar1.entityPosition = Vector(0,0,offset)
					hero[hand].manar2 = drawMgr:CreateRect(-manaX,-manaY+1,0,4,0x5279FFff) hero[hand].manar2.visible = false hero[hand].manar2.entity = v hero[hand].manar2.entityPosition = Vector(0,0,offset)
					hero[hand].manar3 = drawMgr:CreateRect(0,-manaY+1,0,4,0x00175Fff) hero[hand].manar3.visible = false hero[hand].manar3.entity = v hero[hand].manar3.entityPosition = Vector(0,0,offset)
				end

				--ManaBar
				if manaBar then
				
					for d= 1, v.maxMana/100 do
						if not not mana[d] then mana[d] = {} end
						if not hero[hand].mana then hero[hand].mana = {} end
						if not hero[hand].mana[d] then hero[hand].mana[d] = {}
						hero[hand].mana[d].cage = drawMgr:CreateRect(0,-manaY+1,1,5,0x0D1453ff,true) hero[hand].mana[d].cage.visible = false hero[hand].mana[d].cage.entity = v hero[hand].mana[d].cage.entityPosition = Vector(0,0,v.healthbarOffset)
						end
						if offset ~= -1 and v.visible and v.alive then
							hero[hand].mana[d].cage.visible = true hero[hand].mana[d].cage.x = -manaX+manaSizeW/v.maxMana*100*d
						elseif hero[hand].mana[d].cage.visible then
							hero[hand].mana[d].cage.visible = false
						end
					end

					if v.visible and v.alive then
						local manaPercent = v.mana/v.maxMana
						local printMe = string.format("%i",math.floor(v.mana))
						hero[hand].manar1.visible = true
						hero[hand].manar2.visible = true hero[hand].manar2.w = manaSizeW*manaPercent
						hero[hand].manar3.visible = true hero[hand].manar3.x = -manaX+manaSizeW*manaPercent hero[hand].manar3.w = manaSizeW*(1-manaPercent)
					elseif hero[hand].manar1.visible then
						hero[hand].manar1.visible = false
						hero[hand].manar2.visible = false
						hero[hand].manar3.visible = false
					end
					
				end
				--Spell
				if overlaySpell then				
					for a= 1, 7 do
						if not spell[a] then spell[a] = {} end
						if not hero[hand].spell then hero[hand].spell = {} end

						if not hero[hand].spell[a] then hero[hand].spell[a] = {}
							hero[hand].spell[a].bg = drawMgr:CreateRect(a*18*con-54*con,81,16*con,14*con,0x00000095) hero[hand].spell[a].bg.visible = false hero[hand].spell[a].bg.entity = v hero[hand].spell[a].bg.entityPosition = Vector(0,0,offset)
							hero[hand].spell[a].nl = drawMgr:CreateRect(a*18*con-55*con,80,18*con,16*con,0xCE131399,true) hero[hand].spell[a].nl.visible = false hero[hand].spell[a].nl.entity = v hero[hand].spell[a].nl.entityPosition = Vector(0,0,offset)
							hero[hand].spell[a].lvl1 = drawMgr:CreateRect(a*18*con-52*con,80+12*con,2*con,2*con,0xFFFF00FF) hero[hand].spell[a].lvl1.visible = false hero[hand].spell[a].lvl1.entity = v hero[hand].spell[a].lvl1.entityPosition = Vector(0,0,offset)
							hero[hand].spell[a].lvl2 = drawMgr:CreateRect(a*18*con-49*con,80+12*con,2*con,2*con,0xFFFF00FF) hero[hand].spell[a].lvl2.visible = false hero[hand].spell[a].lvl2.entity = v hero[hand].spell[a].lvl2.entityPosition = Vector(0,0,offset)
							hero[hand].spell[a].lvl3 = drawMgr:CreateRect(a*18*con-46*con,80+12*con,2*con,2*con,0xFFFF00FF) hero[hand].spell[a].lvl3.visible = false hero[hand].spell[a].lvl3.entity = v hero[hand].spell[a].lvl3.entityPosition = Vector(0,0,offset)
							hero[hand].spell[a].lvl4 = drawMgr:CreateRect(a*18*con-43*con,80+12*con,2*con,2*con,0xFFFF00FF) hero[hand].spell[a].lvl4.visible = false hero[hand].spell[a].lvl4.entity = v hero[hand].spell[a].lvl4.entityPosition = Vector(0,0,offset)
							hero[hand].spell[a].textT = drawMgr:CreateText(0,80,0xFFFFFFAA,"",F13) hero[hand].spell[a].textT.visible = false hero[hand].spell[a].textT.entity = v hero[hand].spell[a].textT.entityPosition = Vector(0,0,offset)
						end

						local Spell = v:GetAbility(a)

						if v.alive and v.visible and Spell ~= nil and Spell.name ~= "attribute_bonus" and not Spell.hidden then
							hero[hand].spell[a].bg.visible = true
							if (v.classId == CDOTA_Unit_Hero_DoomBringer and a == 4) or (v.classId == CDOTA_Unit_Hero_Rubick and a == 5)then
								hero[hand].spell[a].bg.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
							end					
							if Spell.state == 16 then
								hero[hand].spell[a].nl.visible = true hero[hand].spell[a].nl.textureId = drawMgr:GetTextureId("NyanUI/other/spell_nolearn")
								hero[hand].spell[a].textT.visible = false
							elseif Spell.state == -1 then
								hero[hand].spell[a].nl.visible = true hero[hand].spell[a].nl.textureId = drawMgr:GetTextureId("NyanUI/other/spell_ready")
								hero[hand].spell[a].textT.visible = false					
							elseif Spell.cd > 0 then
								local cooldown = math.ceil(Spell.cd)
								local shift1 = nil
								if cooldown > 99 then cooldown = "99" shift1 = 1 elseif cooldown < 10 then shift1 = 4 else shift1 = 2 end
								hero[hand].spell[a].nl.visible = true hero[hand].spell[a].nl.textureId = drawMgr:GetTextureId("NyanUI/other/spell_cooldown")
								hero[hand].spell[a].textT.visible = true hero[hand].spell[a].textT.x = a*18*con-53*con+shift1 hero[hand].spell[a].textT.text = ""..cooldown hero[hand].spell[a].textT.color = 0xFFFFFFff
							elseif Spell.state == 17 then
								hero[hand].spell[a].nl.visible = true hero[hand].spell[a].nl.textureId = drawMgr:GetTextureId("NyanUI/other/spell_passive")
								hero[hand].spell[a].textT.visible = false
							elseif v.mana - Spell.manacost < 0 and Spell.cd == 0 then
								local ManaCost = math.floor(math.ceil(Spell.manacost) - v.mana)
								local shift2 = nil
								if ManaCost > 99 then ManaCost = "99" shift2 = 1 elseif ManaCost < 10 then shift2 = 4 else shift2 = 2 end
								hero[hand].spell[a].nl.visible = true hero[hand].spell[a].nl.textureId = drawMgr:GetTextureId("NyanUI/other/spell_nomana")
								hero[hand].spell[a].textT.visible = true hero[hand].spell[a].textT.x = a*18*con-53*con+shift2 hero[hand].spell[a].textT.text = ""..ManaCost hero[hand].spell[a].textT.color = 0xBBA9EEff
							elseif hero[hand].spell[a].nl.visible then
								hero[hand].spell[a].nl.visible = false
								hero[hand].spell[a].textT.visible = false
							end

							if Spell.level == 1 then
								hero[hand].spell[a].lvl1.visible = true
							elseif Spell.level == 2 then
								hero[hand].spell[a].lvl1.visible = true
								hero[hand].spell[a].lvl2.visible = true
							elseif Spell.level == 3 then
								hero[hand].spell[a].lvl1.visible = true
								hero[hand].spell[a].lvl2.visible = true
								hero[hand].spell[a].lvl3.visible = true
							elseif Spell.level >= 4 then
								hero[hand].spell[a].lvl1.visible = true
								hero[hand].spell[a].lvl2.visible = true
								hero[hand].spell[a].lvl3.visible = true
								hero[hand].spell[a].lvl4.visible = true
							elseif hero[hand].spell[a].lvl1.visible then
								hero[hand].spell[a].lvl1.visible = false
								hero[hand].spell[a].lvl2.visible = false
								hero[hand].spell[a].lvl3.visible = false
								hero[hand].spell[a].lvl4.visible = false
							end
						elseif hero[hand].spell[a].bg.visible then
							hero[hand].spell[a].bg.visible = false
							hero[hand].spell[a].nl.visible = false
							hero[hand].spell[a].lvl1.visible = false
							hero[hand].spell[a].lvl2.visible = false
							hero[hand].spell[a].lvl3.visible = false
							hero[hand].spell[a].lvl4.visible = false
							hero[hand].spell[a].textT.visible = false
						end
					end
				end
				
				--Items
				if overlayItem then
					enemies[v.classId] = 0

					for c = 1, 6 do

						if not item[c] then item[c] = {} end
						if not hero[hand].item then hero[hand].item = {} end

						if not hero[hand].item[c] then hero[hand].item[c] = {}
							hero[hand].item[c].gem = drawMgr:CreateRect(0,-manaY+7,18*con,16*con,0x7CFC0099) hero[hand].item[c].gem.visible = false hero[hand].item[c].gem.entity = v hero[hand].item[c].gem.entityPosition = Vector(0,0,offset)
							hero[hand].item[c].dust = drawMgr:CreateRect(0,-manaY+6,18*con,16*con,0x7CFC0099) hero[hand].item[c].dust.visible = false hero[hand].item[c].dust.entity = v hero[hand].item[c].dust.entityPosition = Vector(0,0,offset)
							hero[hand].item[c].sentryImg = drawMgr:CreateRect(0,-manaY+7,16*con,14*con,0x7CFC0099) hero[hand].item[c].sentryImg.visible = false hero[hand].item[c].sentryImg.entity = v hero[hand].item[c].sentryImg.entityPosition = Vector(0,0,offset)
							hero[hand].item[c].sentryTxt = drawMgr:CreateText(0,-manaY+10,0xffffffFF,"",F11) hero[hand].item[c].sentryTxt.visible = false hero[hand].item[c].sentryTxt.entity = v hero[hand].item[c].sentryTxt.entityPosition = Vector(0,0,offset)					
							hero[hand].item[c].sphereImg = drawMgr:CreateRect(0,-manaY+7,16*con,14*con,0x7CFC0099) hero[hand].item[c].sphereImg.visible = false hero[hand].item[c].sphereImg.entity = v hero[hand].item[c].sphereImg.entityPosition = Vector(0,0,offset)
							hero[hand].item[c].sphereTxt = drawMgr:CreateText(0,-manaY+7,0xffffffFF,"",F13) hero[hand].item[c].sphereTxt.visible = false hero[hand].item[c].sphereTxt.entity = v hero[hand].item[c].sphereTxt.entityPosition = Vector(0,0,offset)						
						end

						local Items = v:GetItem(c)

						if v.alive and v.visible and Items ~= nil then
						
							if Items.name == "item_gem" then
								enemies[v.classId] = enemies[v.classId]  + 20*con
								hero[hand].item[c].gem.visible = true hero[hand].item[c].gem.x = enemies[v.classId]-manaX-18*con hero[hand].item[c].gem.textureId = drawMgr:GetTextureId("NyanUI/other/O_gem")						
							else
								hero[hand].item[c].gem.visible = false
							end
							if Items.name == "item_dust" then
								enemies[v.classId] = enemies[v.classId]  + 20*con
								hero[hand].item[c].dust.visible = true hero[hand].item[c].dust.x = enemies[v.classId]-manaX-18*con hero[hand].item[c].dust.textureId = drawMgr:GetTextureId("NyanUI/other/O_dust")	
							else
								hero[hand].item[c].dust.visible = false
							end
							if Items.name == "item_ward_sentry" then
								enemies[v.classId] = enemies[v.classId]  + 20*con
								local charg = Items.charges
								hero[hand].item[c].sentryImg.visible = true hero[hand].item[c].sentryImg.x = enemies[v.classId]-manaX-18*con hero[hand].item[c].sentryImg.textureId = drawMgr:GetTextureId("NyanUI/other/O_sentry")
								hero[hand].item[c].sentryTxt.visible = true hero[hand].item[c].sentryTxt.x = enemies[v.classId]-manaX-8*con hero[hand].item[c].sentryTxt.text = ""..charg
							else
								hero[hand].item[c].sentryImg.visible = false
								hero[hand].item[c].sentryTxt.visible = false
							end

							if Items.name == "item_sphere" then
								enemies[v.classId] = enemies[v.classId]  + 20*con
								hero[hand].item[c].sphereImg.visible = true hero[hand].item[c].sphereImg.x = enemies[v.classId]-manaX-16*con hero[hand].item[c].sphereImg.textureId = drawMgr:GetTextureId("NyanUI/other/O_sphere")
								if Items.cd ~= 0 then
									local cdL = math.ceil(Items.cd)
									local shift4 = nil
									if cdL < 10 then shift4 = 2 else shift4 = 0 end
									hero[hand].item[c].sphereTxt.visible = true hero[hand].item[c].sphereTxt.x = enemies[v.classId]-manaX-14*con + shift4 hero[hand].item[c].sphereTxt.text = ""..cdL
								else
									hero[hand].item[c].sphereTxt.visible = false
								end
							else
								hero[hand].item[c].sphereTxt.visible = false
								hero[hand].item[c].sphereImg.visible = false
							end

						else					
							hero[hand].item[c].gem.visible = false
							hero[hand].item[c].dust.visible = false
							hero[hand].item[c].sentryImg.visible = false
							hero[hand].item[c].sentryTxt.visible = false
							hero[hand].item[c].sphereTxt.visible = false
							hero[hand].item[c].sphereImg.visible = false						
						end

					end
				end
				
			end
		
		--ulti panel
			if topPanel then
			
				local xx = GetXX(v)
				local color = Color(v,me)
				local handId = v.playerId
				
				if not panel[handId] then panel[handId] = {}
					panel[handId].hpINB = drawMgr:CreateRect(0,y_,x_-1,8,0x000000D0) panel[handId].hpINB.visible = false
					panel[handId].hpIN = drawMgr:CreateRect(0,y_,0,8,color) panel[handId].hpIN.visible = false				
					panel[handId].hpB = drawMgr:CreateRect(0,y_,x_-1,8,0x000000ff,true) panel[handId].hpB.visible = false
					
					panel[handId].ulti = drawMgr:CreateRect(0,y_-9,14*rate*con,15*con,0x0EC14A80) panel[handId].ulti.visible = false		
					panel[handId].ultiCDT = drawMgr:CreateText(0,y_-9,0xFFFFFF99,"",F13) panel[handId].ultiCDT.visible = false	
					panel[handId].lh = drawMgr:CreateText(xx-20+x_*handId,y_-30,-1,"",F10)
				end		
				
				local lasthits = player:GetLasthits(handId)
				local denies = player:GetDenies(handId)
				panel[handId].lh.text = " "..lasthits.." / "..denies
				
				for d = 4,8 do
					local ult = v:GetAbility(d)
					if ult ~= nil then
						if ult.abilityType == 1 then						
							panel[handId].ulti.x = xx-2+x_*handId
							if ult.cd > 0 then
								local cooldownUlti = math.ceil(ult.cd)
								if cooldownUlti > 99 then cooldownUlti = "99" shift3 = -2 elseif cooldownUlti < 10 then shift3 = 0 else shift3 = -2 end							
								panel[handId].ulti.visible = true 
								panel[handId].ulti.textureId = drawMgr:GetTextureId("NyanUI/other/ulti_cooldown")
								panel[handId].ultiCDT.visible = true panel[handId].ultiCDT.x = xx+x_*handId + shift3 panel[handId].ultiCDT.text = ""..cooldownUlti
							elseif ult.state == LuaEntityAbility.STATE_READY or ult.state == 17 then
								panel[handId].ulti.visible = true 
								panel[handId].ulti.textureId = drawMgr:GetTextureId("NyanUI/other/ulti_ready")
								panel[handId].ultiCDT.visible = false						
							elseif ult.state == LuaEntityAbility.STATE_NOMANA then								
								panel[handId].ulti.textureId = drawMgr:GetTextureId("NyanUI/other/ulti_nomana")
								panel[handId].ultiCDT.visible = false						
							end
						end
					end
				end
				if v.respawnTime < 1 then
					local health = string.format("%i",math.floor(v.health))
					local healthPercent = v.health/v.maxHealth
					local manaPercent = v.mana/v.maxMana
					panel[handId].hpINB.visible = true panel[handId].hpINB.x = xx-ss+x_*handId
					panel[handId].hpIN.visible = true panel[handId].hpIN.x = xx-ss+x_*handId panel[handId].hpIN.w = (x_-2)*healthPercent
					panel[handId].hpB.visible = true panel[handId].hpB.x = xx-ss+x_*handId
				elseif panel[handId].hpINB.visible then
					panel[handId].hpINB.visible = false
					panel[handId].hpIN.visible = false
					panel[handId].hpB.visible = false
				end
			end
		end
	end
	--gliph cooldown
	local team = 5 - me.team
	local Time = client:GetGlyphCooldown(team)
	local sms = nil
	if Time == 0 then sms = "Ry" else sms = Time end
	glyph.visible = true glyph.text = ""..sms

end

function Rune()
	local runes = entityList:GetEntities({classId=CDOTA_Item_Rune})
	if #runes == last and math.floor(client.gameTime % 120) ~= 0 then return end last = #runes 
	rune[-2272].visible,rune[3008].visible = false,false
	for i,v in ipairs(runes) do
		local runeType = v.runeType
		local filename = ""
		local pos = v.position.x
		if runeType == 0 then
				filename = "doubledamage"
		elseif runeType == 1 then
				filename = "haste"
		elseif runeType == 2 then
				filename = "illusion"
		elseif runeType == 3 then
				filename = "invis"
		elseif runeType == 4 then
				filename = "regen"
		elseif runeType == 5 then
				filename = "bounty"
		end
		local runeMinimap = MapToMinimap(pos,v.position.y)
		rune[pos].visible = true
		rune[pos].x = runeMinimap.x-20/2
		rune[pos].y = runeMinimap.y-20/2
		rune[pos].textureId = drawMgr:GetTextureId("NyanUI/minirunes/translucent/"..filename.."_t75")
	end	
end

function Courier(me)		
	local enemyCours = entityList:FindEntities({classId = CDOTA_Unit_Courier,team = (5-me.team)})
	for i,v in ipairs(enemyCours) do
		local hand = v.handle
		if not cours[hand] then
			cours[hand] = drawMgr:CreateRect(0,0,location.minimap.px+3,location.minimap.px+3,0x000000FF) cours[hand].visible = false
		end
	
		if v.visible and v.alive then
			cours[hand].visible = true
			local courMinimap = MapToMinimap(v.position.x,v.position.y)
			cours[hand].x,cours[hand].y = courMinimap.x-10,courMinimap.y-6
			local flying = v:GetProperty("CDOTA_Unit_Courier","m_bFlyingCourier")
			if flying then
				cours[hand].textureId = drawMgr:GetTextureId("NyanUI/other/courier_flying")
				cours[hand].size = Vector2D(location.minimap.px+9,location.minimap.px+1)
			else
				cours[hand].textureId = drawMgr:GetTextureId("NyanUI/other/courier")		
			end
		elseif cours[hand].visible then
			cours[hand].visible = false
		end
	end  
end

function VisibleByEnemy(me,ent)

	local effectDeleted = false
	for _,v in ipairs(ent) do 
		if v.alive and v.team == me.team then
			local OnScreen = client:ScreenPosition(v.position)	
			if OnScreen then
				local hand = v.handle
				local effect = nil
				if hand == me.handle then -- comparing handles
					effect = "aura_shivas" 
				else 
					effect = "ambient_gizmo_model" 
				end
				local visible = v.visibleToEnemy
				if eff[hand] == nil and visible then						    
					eff[hand] = Effect(v,effect)
					eff[hand]:SetVector(1,Vector(0,0,0))
				elseif not visible and eff[hand] ~= nil then
					eff[hand] = nil
					effectDeleted = true
				end
			end
		end
	end

	if effectDeleted then -- only call it once even when 1000 effects are deleted
		collectgarbage("collect")
	end

end

function GetXX(ent)
	local team = ent.team
	if team == 2 then		
		return client.screenSize.x/txxG + 2 
	elseif team == 3 then
		return client.screenSize.x/txxB
	end
end

function Color(ent,me)
	local team = ent.team
	if team ~= me.team then
		return 0x960018FF
	else
		return 0x008000FF
	end
end
	
function GameClose()
	sleeptick = 0
	eff = {}
	mana = {}
	spell = {}
	item = {}
	hero = {}
	panel = {}
	cours = {}
	last = 0
	rune[-2272].visible,rune[3008].visible = false,false	
	glyph.visible = false
	collectgarbage("collect")
end

script:RegisterEvent(EVENT_CLOSE, GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
