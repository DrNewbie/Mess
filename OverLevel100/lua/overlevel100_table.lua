if not tweak_data then
	return
end

for i = 101, 10000 do
	tweak_data.experience_manager.levels[i] = tweak_data.experience_manager.levels[100]
end