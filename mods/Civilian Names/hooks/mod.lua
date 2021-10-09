local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook1 = "F_"..Idstring("Hook1::"..ThisModIds):key()
local Hook2 = "F_"..Idstring("Hook2::"..ThisModIds):key()
local Hook3 = "F_"..Idstring("Hook3::"..ThisModIds):key()
local Hook4 = "F_"..Idstring("Hook4::"..ThisModIds):key()
local Func1 = "F_"..Idstring("Func1::"..ThisModIds):key()
local Bool1 = "F_"..Idstring("Bool1::"..ThisModIds):key()
local Bool2 = "F_"..Idstring("Bool2::"..ThisModIds):key()
local Bool3 = "F_"..Idstring("Bool3::"..ThisModIds):key()
local Func2 = "F_"..Idstring("hide_nick_name::"..ThisModIds):key()
local Func3 = "F_"..Idstring("show_nick_name::"..ThisModIds):key()
local __Dt1 = "F_"..Idstring("__Dt1::"..ThisModIds):key()

if CivilianBase and RequiredScript == "lib/units/civilians/civilianbase" then
	CivilianBase[Func2] = function(self)
		if self[Bool3] then
			managers.hud:_remove_name_label(self[Bool3])
			self[Bool3] = nil
		end
	end

	CivilianBase[Func3] = function(self)
		if not self[Bool3] then
			self[Bool3] = managers.hud:_add_name_label({
				name = self:nick_name(),
				unit = self._unit
			})
		end
	end

	function CivilianBase:nick_name()
		if not self[Func1] then
			return " "
		end
		return self[Func1]
	end

	Hooks:PostHook(CivilianBase, "post_init", Hook1, function(self)
		if type(_G[Bool2]) == "table" and type(_G[Bool2].results) == "table" then
			local rnd_date = _G[Bool2].results[math.random(#_G[Bool2].results)]
			if type(rnd_date) == "table" and type(rnd_date.name) == "table" then
				self[Func1] = rnd_date.name["first"].." "..rnd_date.name["last"]
			end
		end
	end)
end

if RequiredScript == "lib/managers/menumanagerpd2" then
	Hooks:Add("MenuManagerOnOpenMenu", Hook2, function(self, menu)
		if not Global[Bool1] and (menu == "menu_main" or menu == "lobby") then
			DelayedCalls:Add(Hook3, 1, function()
				dohttpreq("https://randomuser.me/api/?inc=name&nat=us&page="..math.random(1, 5).."&results=300", 
					function (__json_result)
						__json_result = tostring(__json_result)
						local NamesSaveToThis = io.open(ThisModPath.."__temp_names.json", "w+")
						NamesSaveToThis:write(__json_result)
						NamesSaveToThis:close()
						NamesSaveToThis = nil
						Global[Bool1] = true
					end
				)
			end)
		end
	end)

	local ReadFromNamesSave = io.open(ThisModPath.."__temp_names.json", "r")
	_G[Bool2] = json.decode(ReadFromNamesSave:read("*all"))
	ReadFromNamesSave:close()
	ReadFromNamesSave = nil
end

if RequiredScript == "lib/units/beings/player/playercamera" then
	local __tmp_vec1 = Vector3()
	
	local function __angle_chk(my_head_fwd, my_pos, attention_pos, dis)
		mvector3.direction(__tmp_vec1, my_pos, attention_pos)
		local angle = mvector3.angle(my_head_fwd, __tmp_vec1)
		local angle_max = math.lerp(180, 54, math.clamp((dis - 150) / 700, 0, 1))
		return angle_max > angle
	end
	
	local function __visible_chk(my_pos, attention_pos)
		local near_vis_ray = World:raycast("ray", my_pos, attention_pos, "slot_mask", managers.slot:get_mask("AI_visibility"), "ray_type", "ai_vision", "report")
		return not near_vis_ray
	end
	
	Hooks:PostHook(PlayerCamera, "update", Hook4, function(self)
		if not self[__Dt1] then
			self[__Dt1] = true
			local __all_civilians = managers.enemy:all_civilians()
			local __my_pos = self:position()
			for __u_key, __u_data in pairs(__all_civilians) do
				if __u_data and __u_data.unit and alive(__u_data.unit) then
					local __c_unit = __u_data.unit
					local __enemy_pos = __c_unit:movement():m_head_pos()
					local __dis = mvector3.distance(__my_pos, __enemy_pos)
					
					local __is_dis_ok = __dis < 1200
					local __is_angle_ok = __angle_chk(self:forward(), __my_pos, __enemy_pos, __dis)
					local __is_see_ok = __visible_chk(__my_pos, __enemy_pos)
					
					if __is_dis_ok and __is_see_ok and __is_angle_ok then
						__c_unit:base()[Func3](__c_unit:base())
					else
						__c_unit:base()[Func2](__c_unit:base())
					end
				end
			end
		else
			self[__Dt1] = false
		end
	end)
end