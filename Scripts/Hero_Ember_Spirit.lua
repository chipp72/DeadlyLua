--<<Auto Q after W. Hold W (default) when ember uses fist>>

require("libs.Utils")
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("Hotkey", "W", config.TYPE_HOTKEY)
config:Load()

local key = config.Hotkey
local play = false


function EmberKey(msg,code)

	if code ~= key or client.chat then return end

	local me = entityList:GetMyHero() if not me then return end


	local enemy = entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive = true,team = (5-me.team),illusion = false})
	local w_ = me:GetAbility(1)
	if w_.state == -1 and me:DoesHaveModifier("modifier_ember_spirit_sleight_of_fist_caster") then
		for i,v in ipairs(enemy) do
			if v.health > 0 and not v:IsMagicDmgImmune() and me:GetDistance2D(v) < 400 then
				me:CastAbility(w_)
			end
		end
	end			

end


function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()	
		if me.classId == CDOTA_Unit_Hero_EmberSpirit then			
			play = true
			script:RegisterEvent(EVENT_KEY,EmberKey)
			script:UnregisterEvent(Load)
		else
			script:Disable()
		end
	end
end

function GameClose()	
	if play then
		script:UnregisterEvent(EmberKey)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_TICK,Load)
script:RegisterEvent(EVENT_CLOSE,GameClose)
