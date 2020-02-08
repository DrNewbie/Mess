local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local nma_original_huskplayermovement_syncmeleestart = HuskPlayerMovement.sync_melee_start
function HuskPlayerMovement:sync_melee_start(hand)
	local profile = NoMA:GetPlayerProfileByUnit(self._unit)
	if profile then
		profile.start_t = TimerManager:game():time()
	end

	nma_original_huskplayermovement_syncmeleestart(self, hand)
end

local nma_original_huskplayermovement_syncmeleedischarge = HuskPlayerMovement.sync_melee_discharge
function HuskPlayerMovement:sync_melee_discharge()
	local profile = NoMA:GetPlayerProfileByUnit(self._unit)
	if profile then
		profile.discharge_t = TimerManager:game():time()
	end

	nma_original_huskplayermovement_syncmeleedischarge(self)
end



-- doesn't work well enough, sometimes gets inverted :/
do return end

local nma_original_huskplayermovement_syncactionchangerun = HuskPlayerMovement.sync_action_change_run
function HuskPlayerMovement:sync_action_change_run(is_running)
	nma_original_huskplayermovement_syncactionchangerun(self, is_running)
	self.nma_ignore_next_stance_change = true
end

local nma_original_huskplayermovement_syncstance = HuskPlayerMovement.sync_stance
function HuskPlayerMovement:sync_stance(stance_code)
	--[[
		VR players use 2 and 3
		non VR players only use 2 for init when dropping in or running, then 3 3 3 3 3...
		that's since U150: "Players should always be in the weapon raised state"
		which made function PlayerStandard:_end_action_steelsight() to set_stance always to 3 instead of 2
	--]]
	if self.nma_ignore_next_stance_change then
		self.nma_ignore_next_stance_change = false
	elseif stance_code == 3 then
		local droping_in = self.nma_in_steelsight == nil and not Global.statistics_manager.playing_from_start
		if droping_in then
			self.nma_in_steelsight = true
		elseif self._stance.owner_stance_code == 3 then
			self.nma_in_steelsight = not self.nma_in_steelsight
		else
			self.nma_in_steelsight = false
		end
	end

	nma_original_huskplayermovement_syncstance(self, stance_code)
end
