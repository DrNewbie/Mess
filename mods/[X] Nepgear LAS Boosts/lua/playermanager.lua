LegendaryArmours = LegendaryArmours or {}

Hooks:PostHook(PlayerManager, "init_finalize", "F_"..Idstring("PostHook:PlayerManager:init_finalize:NepgearLASBoosts"):key(), function(self)
	local las = tostring(managers.blackmarket:equipped_armor_skin())
	if LegendaryArmours[las] and las == "nopgrear" then
		self._is_las_nopgrear = true
	else
		self._is_las_nopgrear = nil
	end
end)

function PlayerManager:Is_LAS_Nepgear()
	return self._is_las_nopgrear
end

local NepgearLASBoostsSpeedBoost = PlayerManager.movement_speed_multiplier

function PlayerManager:movement_speed_multiplier(...)
	local Ans = NepgearLASBoostsSpeedBoost(self, ...)
	if self:Is_LAS_Nepgear() and managers.trade and managers.trade:num_in_trade_queue() > 0 then
		Ans = Ans * math.pow(1.15, managers.trade:num_in_trade_queue())
	end
	return Ans
end

local NepgearLASBoostsArmorBoost = PlayerManager.body_armor_skill_multiplier

function PlayerManager:body_armor_skill_multiplier(...)
	local Ans = NepgearLASBoostsArmorBoost(self, ...)
	if self:Is_LAS_Nepgear() and managers.trade and managers.trade:num_in_trade_queue() > 0 then
		Ans = Ans * math.pow(2, managers.trade:num_in_trade_queue())
	end
	return Ans
end

local NepgearLASBoostsHPBoost = PlayerManager.health_skill_multiplier

function PlayerManager:health_skill_multiplier(...)
	local Ans = NepgearLASBoostsHPBoost(self, ...)
	if self:Is_LAS_Nepgear() and managers.trade and managers.trade:num_in_trade_queue() > 0 then
		Ans = Ans * math.pow(2, managers.trade:num_in_trade_queue())
	end
	return Ans
end