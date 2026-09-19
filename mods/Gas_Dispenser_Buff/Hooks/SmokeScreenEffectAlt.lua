SmokeScreenEffectAltAlt = SmokeScreenEffectAltAlt or class(SmokeScreenEffect)

function SmokeScreenEffectAltAlt:init(position, normal, __time)
	self._timer = TimerManager:game():time() + __time
	self._position = position
	self._radius = 1
	self._unit_list = {}
	self._dodge_bonus = 0.25
	self._sound_source = SoundDevice:create_source("ExplosionManager")

	self._sound_source:set_position(position)
	self._sound_source:post_event("lung_explode")

	self._effect = World:effect_manager():spawn({
		effect = Idstring("effects/particles/explosions/smoke_screen"),
		position = position,
		normal = normal
	})
	self._variant = "smoke_screen_grenade"
	self._mine = false
end

function SmokeScreenEffectAltAlt:update(t, dt)
	if self._timer and t > self._timer then
		self._timer = nil
		self._sound_killed = true
		World:effect_manager():fade_kill(self._effect)
		self._sound_source:post_event("lung_loop_end")
		managers.enemy:add_delayed_clbk("SmokeScreenEffectAltAlt", callback(ProjectileBase, ProjectileBase, "_dispose_of_sound", {
			sound_source = self._sound_source
		}), t + 4)
	end
	self._unit_list = {}
	local nearby_units = World:find_units_quick("sphere", self._position, self._radius, managers.slot:get_mask("persons"))
	for _, unit in ipairs(nearby_units) do
		self._unit_list[unit:key()] = true
	end
end