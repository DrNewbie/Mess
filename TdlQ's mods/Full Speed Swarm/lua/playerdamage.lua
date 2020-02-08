local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_original_playerdamage_init = PlayerDamage.init
function PlayerDamage:init(...)
	self._current_max_health = managers.player.fs_current_max_health * managers.modifiers:modify_value('PlayerDamage:GetMaxHealth', 1)
	fs_original_playerdamage_init(self, ...)
end

local fs_original_playerdamage_sethealth = PlayerDamage.set_health
function PlayerDamage:set_health(health)
	local result = fs_original_playerdamage_sethealth(self, health)
	self._not_full_life = self:get_real_health() < self:_max_health()
	return result
end

function PlayerDamage:_raw_max_health()
	return self._current_max_health
end

function PlayerDamage:_check_update_max_health()
	local max_health_no_cs = (self._HEALTH_INIT + managers.player:health_skill_addend()) * managers.player:health_skill_multiplier()
	local max_health = max_health_no_cs * managers.modifiers:modify_value('PlayerDamage:GetMaxHealth', 1)
	self._current_max_health = self._current_max_health or max_health

	if self._current_max_health ~= max_health then
		local ratio = max_health / self._current_max_health
		local health = math.clamp(self:get_real_health() * ratio, 0, max_health)
		self._health = Application:digest_value(health, true)
		self._current_max_health = max_health
		managers.player.fs_current_max_health = max_health_no_cs -- PlayerManager:body_armor_skill_addend() ignores CS

		self:update_armor_stored_health()
	end
end

function PlayerDamage:_upd_health_regen(t, dt)
	if self._health_regen_update_timer then
		self._health_regen_update_timer = self._health_regen_update_timer - dt
		if self._health_regen_update_timer <= 0 then
			self._health_regen_update_timer = nil
		end
	end
	if not self._health_regen_update_timer then
		if self._not_full_life then
			local player = managers.player
			local regen_rate = player:health_regen()
			if regen_rate > 0 then
				self:restore_health(regen_rate, false)
			end
			self:restore_health(player:fixed_health_regen(self:health_ratio()), true)
			self._health_regen_update_timer = 5
		end
	end
	if #self._damage_to_hot_stack > 0 then
		repeat
			local next_doh = self._damage_to_hot_stack[1]
			local done = not next_doh or next_doh.next_tick > TimerManager:game():time()
			if not done then
				local regen_rate = managers.player:upgrade_value('player', 'damage_to_hot', 0)
				self:restore_health(regen_rate, true)
				next_doh.ticks_left = next_doh.ticks_left - 1
				if next_doh.ticks_left == 0 then
					table.remove(self._damage_to_hot_stack, 1)
				else
					next_doh.next_tick = next_doh.next_tick + (self._doh_data.tick_time or 1)
				end
				table.sort(self._damage_to_hot_stack, function(x, y)
					return x.next_tick < y.next_tick
				end)
			end
		until done
	end
end

local math_abs = math.abs
local math_lerp = math.lerp
local math_min = math.min
function PlayerDamage:_update_armor_hud(t, dt)
	local real_armor = self:get_real_armor()
	self._current_armor_fill = math.lerp(self._current_armor_fill, real_armor, 10 * dt)
	if math_abs(self._current_armor_fill - real_armor) > 0.01 then
		local total_armor = self:_max_armor()
		managers.hud:set_player_armor({
			current = self._current_armor_fill,
			total = total_armor,
			max = total_armor
		})
	end
	if self._hurt_value then
		self._hurt_value = math_min(1, self._hurt_value + dt)
	end
end

function PlayerDamage:_raw_max_armor()
	local mplayer = managers.player
	local base_max_armor = self._ARMOR_INIT + mplayer:body_armor_value('armor') + mplayer:body_armor_skill_addend()
	local mul = mplayer:body_armor_skill_multiplier()
	mul = managers.modifiers:modify_value('PlayerDamage:GetMaxArmor', mul)
	return base_max_armor * mul
end

local fs_original_playerdamage_ondowned = PlayerDamage.on_downed
function PlayerDamage:on_downed()
	fs_original_playerdamage_ondowned(self)

	local u_mov = self._unit:movement()
	if u_mov then
		u_mov.fs_stamina_tick = 0
		u_mov:_change_stamina(0)
	end
end
