BulletDecapitations = BulletDecapitations or {}
BulletDecapitations.cop_decapitation = BulletDecapitations.cop_decapitation or {}
 
if not BulletDecapitations.tweak_data then
	BulletDecapitations.tweak_data = {}
end

local ThisModPath = tostring(ModPath)
local ThisModIds = Idstring(ThisModPath):key()

local __Name = function(__id)
	return "K_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
 
-- [[ BD Settings ]]
-- Change which weapons can decapitate enemies and stuff...
-- Set to either: 'true' or 'nil' (false).
BulletDecapitations.tweak_data.allowed_weapons = {
	["assault_rifle"] = true, -- Assault Rifle
	["pistol"] = true, -- Pistol
	["smg"] = true, -- SMG
	["shotgun"] = true, -- Shotgun
	["saw"] = true, -- OVE9000 Saw
	["lmg"] = true, -- LMG
	["snp"] = true, -- Sniper Rifle
	["akimbo"] = true, -- Akimbo Pistols
	["minigun"] = true -- Minigun
}

BulletDecapitations.tweak_data.enable_bullet_cops = true -- Enable decapitations for all allowed weapons, disable if you want want just want tasers or cloakers
BulletDecapitations.tweak_data.twitch = true -- Enable body twitching on decapitations. Value 'true' by default.
BulletDecapitations.tweak_data.blood_time = 20 -- Determines how long a decapitated body will bleed.
BulletDecapitations.tweak_data.twitch_rate = 1 -- The interval at which a body twitches.

-- "all" - Cloakers can be cut from head to torso. | "head" - Cloakers can be dismembered in the head only. | "body" - Cloakers can be dismembered in the body only. | "none" - Cloakers do not use the 'true' dismemberment system.
BulletDecapitations.tweak_data.cloaker_decapitations = "all"
BulletDecapitations.tweak_data.taser_decapitations = true -- Enables the special decapitation for tasers when headshotted.

-- [[ End of BD Settings ]]
BulletDecapitations.cop_decapitation = {
	t = {},
	interval = {},
	attack_data = {},
	vfx = {},
	ragdoll = {},
	parts = {}
}

function BulletDecapitations:BD_SpawnBleedEffect(__key, __object)
	__key = __Name(__key)
	if not __object then
		if self.cop_decapitation.vfx[__key] then
			if self.cop_decapitation.vfx[__key].effect_id then
				World:effect_manager():kill(tostring(self.cop_decapitation.vfx[__key].effect_id))
			end
			self.cop_decapitation.vfx[__key] = nil
		end
	else
		self.cop_decapitation.vfx[__key] = {
			effect_id = World:effect_manager():spawn({
				effect = Idstring("effects/payday2/particles/impacts/blood/blood_tendrils"),
				position = __object:position(),
				rotation = __object:rotation()
			}),
			now_time = TimerManager:game():time()
		}
	end
	return
end

function BulletDecapitations:BD_ToApplyBody(them, attack_data, is_explosion)
	if not attack_data or not them then
		return
	end
	local body = nil
	if attack_data.body_name then
		body = attack_data.body_name
	elseif attack_data.col_ray and attack_data.col_ray.body then
		body = attack_data.col_ray.body:name()
	end
	if is_explosion then
		local __possible_body = {
			Idstring("head"),
			Idstring("hit_LeftArm"),
			Idstring("hit_RightArm"),
			Idstring("hit_LeftUpLeg"),
			Idstring("hit_RightUpLeg")
		}		
		body = table.random(__possible_body)
	end
	if not body then
		return
	end	
	if not attack_data.attacker_unit then
		attack_data.attacker_unit = managers.player:player_unit()
	end
	if not them._dead or not attack_data.attacker_unit or not alive(attack_data.attacker_unit) or (attack_data.attacker_unit:inventory() and self.tweak_data.allowed_weapons[tweak_data.weapon[attack_data.attacker_unit:inventory():equipped_unit():base():get_name_id()].category] ~= true) then
	
	else
		if them._unit:base()._tweak_table == "spooc" then
			if (body:key() == Idstring("head"):key() or body:key() == Idstring("hit_Head"):key() or body:key() == Idstring("rag_Head"):key()) and (self.tweak_data.cloaker_decapitations == "all" or self.tweak_data.cloaker_decapitations == "head") or body:key() == Idstring("hit_Head"):key() or body:key() == Idstring("rag_Head"):key() and (self.tweak_data.cloaker_decapitations == "all" or self.tweak_data.cloaker_decapitations == "head") then
				them._unit:sound():play("split_gen_head")
				them._unit:damage():run_sequence_simple("dismember_head")
			else
				if (self.tweak_data.cloaker_decapitations == "all" or self.tweak_data.cloaker_decapitations == "body") then
					them._unit:sound():play("split_gen_body")
					them._unit:damage():run_sequence_simple("dismember_body_top")
				end
            end
        end
		if them._unit:base()._tweak_table == "taser" then
			if (body:key() == Idstring("head"):key() or body:key() == Idstring("hit_Head"):key() or body:key() == Idstring("rag_Head"):key()) and self.tweak_data.taser_decapitations then
				them._unit:sound():play("split_gen_head")
				them._unit:damage():run_sequence_simple("kill_tazer_headshot")
				return
            end
        end
		if self.tweak_data.enable_bullet_cops then
			if body:key() then
				if not self.cop_decapitation.parts[them._unit] then
					self.cop_decapitation.parts[them._unit] = {}
				end			
				them._unit:movement():enable_update()
				them._unit:movement()._frozen = nil
				if them._unit:movement()._active_actions[1] and them._unit:movement()._active_actions[1]:type() == "hurt" then
					them._unit:movement()._active_actions[1]:force_ragdoll(true)
				end				
				local bone_head = them._unit:get_object(Idstring("Head"))
				local bone_body = them._unit:get_object(Idstring("Spine1"))				
				if body:key() == Idstring("head"):key() or body:key() == Idstring("hit_Head"):key() or body:key() == Idstring("rag_Head"):key() then
					self:BD_SpawnBleedEffect(them._unit:key(), them._unit:get_object(Idstring("Neck")))
					self.cop_decapitation.parts[them._unit].Head = "Head"
					if type(them._spawn_head_gadget) == "function" then
						them:_spawn_head_gadget({
							position = bone_head:position(),
							rotation = bone_head:rotation(),
							dir = -them._unit:movement():m_head_rot():y()
						})
					end
				elseif body:key() == Idstring("hit_LeftArm"):key() or body:key() == Idstring("hit_LeftForeArm"):key() or body:key() == Idstring("rag_LeftArm"):key() or body:key() == Idstring("rag_LeftForeArm"):key() then
					self.cop_decapitation.parts[them._unit].LeftArm = "LeftArm"
				elseif body:key() == Idstring("hit_RightArm"):key() or body:key() == Idstring("hit_RightForeArm"):key() or body:key() == Idstring("rag_RightArm"):key() or body:key() == Idstring("rag_RightForeArm"):key() then
					self.cop_decapitation.parts[them._unit].RightArm = "RightArm"
				elseif body:key() == Idstring("hit_LeftUpLeg"):key() or body:key() == Idstring("hit_LeftLeg"):key() or body:key() == Idstring("rag_LeftUpLeg"):key() or body:key() == Idstring("rag_LeftLeg"):key() then
					self.cop_decapitation.parts[them._unit].LeftLeg = "LeftLeg"
				elseif body:key() == Idstring("hit_RightUpLeg"):key() or body:key() == Idstring("hit_RightLeg"):key() or body:key() == Idstring("rag_RightUpLeg"):key() or body:key() == Idstring("rag_RightLeg"):key() then
					self.cop_decapitation.parts[them._unit].RightLeg = "RightLeg"
				else
				
				end
				self.cop_decapitation.attack_data[them._unit] = attack_data
				self.cop_decapitation.ragdoll[them._unit] = them._unit
				self.cop_decapitation.t[them._unit] = Application:time() + self.tweak_data.blood_time
				self.cop_decapitation.interval[them._unit] = Application:time() + self.tweak_data.twitch_rate
			end
		end
	end
end

Hooks:PostHook(CopDamage, "damage_explosion", __Name(100), function(self, attack_data)
	BulletDecapitations:BD_ToApplyBody(self, attack_data, true)
end)

Hooks:PostHook(CopDamage, "damage_bullet", __Name(101), function(self, attack_data)
	BulletDecapitations:BD_ToApplyBody(self, attack_data)
end)

local is_bool_dt = false

Hooks:PostHook(PlayerManager, "update", __Name(102), function(self, t, dt)
	if is_bool_dt then
		is_bool_dt = false
		return
	else
		is_bool_dt = true
	end
	if not CopDamage or not BulletDecapitations then
	
	else
		if BulletDecapitations.cop_decapitation then
			if BulletDecapitations.cop_decapitation.vfx then
				BulletDecapitations._data = BulletDecapitations._data or {}
				if BulletDecapitations._data.BodyBleedTime and type(BulletDecapitations._data.BodyBleedTime) == "number" and BulletDecapitations._data.BodyBleedTime >= 0 then
					local how_long_for_bleed = math.max(BulletDecapitations._data.BodyBleedTime, -1)
					local this_now_time = TimerManager:game():time()
					for __id, __data in pairs(BulletDecapitations.cop_decapitation.vfx) do
						if __data and type(__data) == "table" and __data.effect_id and __data.now_time and type(__data.now_time) == "number" and this_now_time >= __data.now_time + how_long_for_bleed then
							BulletDecapitations:BD_SpawnBleedEffect(__id, nil)
						end					
					end
				end
			end
			local __spawn_BD = function(__unit, __object)
				if __unit and __unit:get_object(Idstring(__object)) then
					BulletDecapitations:BD_SpawnBleedEffect(__unit:key(), __unit:get_object(Idstring(__object)))
				end
				return
			end
			for unit, val in pairs(BulletDecapitations.cop_decapitation.ragdoll) do
				if alive(unit) then
				
				else
					BulletDecapitations.cop_decapitation.ragdoll[unit] = nil
					BulletDecapitations.cop_decapitation.parts[unit] = nil
				end
			end
			for unit, val in pairs(BulletDecapitations.cop_decapitation.t) do
				if alive(unit) then
					for part , _ in pairs(BulletDecapitations.cop_decapitation.parts[unit]) do
						if part == "Head" then
							__spawn_BD(unit, "Neck")
						elseif part == "LeftArm" then
							__spawn_BD(unit, "LeftShoulder")
						elseif part == "LeftLeg" then
							__spawn_BD(unit, "LeftUpLeg")
						elseif part == "RightArm" then
							__spawn_BD(unit, "RightShoulder")
						elseif part == "RightLeg" then
							__spawn_BD(unit, "RightUpLeg")
						else
							
						end
						if part == "Head" then
							if Application:time() < val then
								if Application:time() >= BulletDecapitations.cop_decapitation.interval[unit] then
									BulletDecapitations.cop_decapitation.interval[unit] = Application:time() + BulletDecapitations.tweak_data.twitch_rate
									local splatter_from = unit:get_object(Idstring("Neck")):position()
									local splatter_to = splatter_from + unit:get_object(Idstring("Neck")):rotation():y() * 100
									local splatter_ray = unit:raycast("ray", splatter_from, splatter_to, "slot_mask", managers.slot:get_mask("world_geometry"))
									if splatter_ray then
										World:project_decal(Idstring("blood_spatter"), splatter_ray.position, splatter_ray.ray, splatter_ray.unit, nil, splatter_ray.normal)
									end
									if unit:movement()._active_actions[1] and unit:movement()._active_actions[1]:type() == "hurt" then
										unit:movement()._active_actions[1]:force_ragdoll(true)
									end
									local scale = BulletDecapitations.tweak_data.twitch and 0.075 or 0
									local height = 1
									local twist_dir = math.random(2) == 1 and 1 or -1
									local rot_acc = (math.UP * (0.5 * twist_dir)) * -0.5
									local rot_time = 1 + math.rand(2)
									local nr_u_bodies = unit:num_bodies()
									local i_u_body = 0
									while nr_u_bodies > i_u_body do
										local u_body = unit:body(i_u_body)
										if u_body:enabled() and u_body:dynamic() then
											local body_mass = u_body:mass()
											World:play_physic_effect(Idstring("physic_effects/body_explosion"), u_body, math.UP * 600 * scale, 4 * body_mass / math.random(2), rot_acc, rot_time)
										end
										i_u_body = i_u_body + 1
									end
								end
							else
								BulletDecapitations.cop_decapitation.t[unit] = nil
								BulletDecapitations.cop_decapitation.interval[unit] = nil
								BulletDecapitations.cop_decapitation.attack_data[unit] = nil
							end
						end
					end
				else
					BulletDecapitations.cop_decapitation.t[unit] = nil
					BulletDecapitations.cop_decapitation.interval[unit] = nil
					BulletDecapitations.cop_decapitation.attack_data[unit] = nil
				end
			end
		end	
	end	
end)