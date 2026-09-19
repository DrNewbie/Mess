tweak_data.experience_manager.levels[101] = tweak_data.experience_manager.levels[100]

for i = 1, 99 do
	tweak_data.experience_manager.levels[101].points = Application:digest_value(Application:digest_value(tweak_data.experience_manager.levels[101].points, false) + Application:digest_value(tweak_data.experience_manager.levels[i].points, false), true)
end

tweak_data.experience_manager.levels[101].points = Application:digest_value(Application:digest_value(tweak_data.experience_manager.levels[101].points, false) * 2, true)
