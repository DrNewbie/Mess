Hooks:PostHook(PlayerStandard, "init", "ThrowBackInit_Load_concussion_resource", function(self)
	local data = tweak_data.blackmarket.projectiles["concussion"]
	if data then
		local unit_name = Idstring(not Network:is_server() and data.local_unit or data.unit)
		if not managers.dyn_resource:is_resource_ready(Idstring("unit"), unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
			managers.dyn_resource:load(Idstring("unit"), unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE)
			return
		end
	end	
end)

if Network:is_client() then
	return
end

function PlayerStandard:ThrowBack(t)
	t = t or TimerManager:game():time()
	local data = tweak_data.blackmarket.projectiles["concussion"]
	if data then
		local unit_name = Idstring(not Network:is_server() and data.local_unit or data.unit)
		if not managers.dyn_resource:is_resource_ready(Idstring("unit"), unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
			managers.dyn_resource:load(Idstring("unit"), unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE, callback(self, self, "ThrowBack"))
			return
		end
	end	
	local from = self._unit:movement():m_head_pos()
	local to = from + self._unit:movement():m_head_rot():y() * 35 + Vector3(0, 0, 0)
	local unit = ProjectileBase.spawn("units/pd2_crimefest_2016/fez1/weapons/wpn_fps_gre_pressure/wpn_third_gre_pressure", to, Rotation())
	unit:base():throw({
		dir = self._unit:movement():m_head_rot():y(),
		owner = self._unit
	})
end

local ThrowBack_PlayerStandard_do_melee_damage = PlayerStandard._do_melee_damage

function PlayerStandard:_do_melee_damage(t, ...)
	local col_ray = ThrowBack_PlayerStandard_do_melee_damage(self, t, ...)
	if col_ray and col_ray.unit and alive(col_ray.unit) and col_ray.unit:name() == Idstring("units/payday2/weapons/wpn_frag_flashbang/wpn_frag_flashbang") then
		if col_ray.unit:base()._armed then
			self:ThrowBack(t)
		end
	end
	return col_ray
end