local ThisModPath = tostring(ModPath)
local ThisModIds = Idstring(ThisModPath):key()

local __Name = function(__id)
	return "A_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

local function __Is_Not_Init(__ClassFunc, __RequiredScript)
	if __ClassFunc and not _G[__Name(__RequiredScript)] then
		_G[__Name(__RequiredScript)] = true
		return true
	end
	return false
end

local __revives = __Name("self._revives")
local __downed_timer = __Name("self._downed_timer")
local __downed_timer_delay = __Name("self._downed_timer_delay")
local __downed_time = 10

local __delay_to_bleedout = __Name("__delay_to_bleedout")
local __check_medic_heal = __Name("CopDamage.check_medic_heal")

local __can_request_actions = __Name("CopMovement.can_request_actions")

local __BigList = __Name("__BigList")
_G[__BigList] = _G[__BigList] or {}

if __Is_Not_Init(CopDamage, RequiredScript) then
	Hooks:PostHook(CopDamage, "init", __Name(1), function(self)
		if self._unit and alive(self._unit) then
			self[__revives] = 1
			self[__downed_timer] = nil
			self[__downed_timer_delay] = nil
			_G[__BigList][__Name(self._unit:key())] = self
		end
	end)
	
	CopDamage[__check_medic_heal] = CopDamage[__check_medic_heal] or CopDamage.check_medic_heal	
	function CopDamage:check_medic_heal(...)
		if self[__revives] and type(self[__revives]) == "number" and self[__revives] > 0 and not self._dead and not self._immortal and self._unit:movement() then
			self[__revives] = self[__revives] - 1
			if self[__revives] <= 0 then
				self[__revives] = nil
			end
			self[__downed_timer] = __downed_time
			self[__delay_to_bleedout] = true
			self[__downed_timer_delay] = 1
			--self:do_medic_heal_and_action(true)
			self._health = self._HEALTH_INIT
			self._health_ratio = 1
			self._unit:network():send("sync_action_healed", true)
			return true
		else
			self._unit:movement().can_request_actions = function(this, ...)
				return this[__can_request_actions](this, ...)
			end
		end
		return self[__check_medic_heal](self, ...)
	end
end

if __Is_Not_Init(EnemyManager, RequiredScript) then
	Hooks:PostHook(EnemyManager, "update", __Name(2), function (self, __t, __dt, ...)
		local SelfBigList = _G[__BigList]
		for __key, __them in pairs(SelfBigList) do
			if not __them or not alive(__them._unit) or not self:is_enemy(__them._unit) then
				__them = nil
				_G[__BigList][__key] = nil
			else
				if __them and __them[__downed_timer] and type(__them[__downed_timer]) == "number" then
					__them[__downed_timer] = __them[__downed_timer] - __dt
					if __them[__downed_timer] <= 0 then
						__them[__downed_timer] = nil
					end
					if not __them[__downed_timer_delay] then
						__them[__downed_timer_delay] = 1
						pcall(function()
							__them:damage_simple({
								variant = "bullet",
								damage = (math.round(__them._HEALTH_INIT / __downed_time) + 0.01),
								pos = __them._unit:movement():m_head_pos(),
								attack_dir = math.UP
							})
						end)
					else
						__them[__downed_timer_delay] = __them[__downed_timer_delay] - __dt
						if __them[__downed_timer_delay] <= 0 then
							__them[__downed_timer_delay] = nil
						end
						if __them[__delay_to_bleedout] then
							__them[__delay_to_bleedout] = false
							__them._unit:movement()[__can_request_actions] = __them._unit:movement()[__can_request_actions] or __them._unit:movement().can_request_actions
							__them._unit:movement().can_request_actions = function(this, ...)
								this[__can_request_actions](this, ...)
								return false
							end
							__them._unit:movement():play_redirect("bleedout")
							managers.network:session():send_to_peers("play_distance_interact_redirect", __them._unit, "bleedout")
						end
					end
				end
			end
		end
	end)
end