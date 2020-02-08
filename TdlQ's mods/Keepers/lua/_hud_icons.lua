DB:create_entry(
	Idstring('texture'),
	Idstring('guis/textures/pd2/kpr_assist'),
	ModPath .. 'assets/assist.texture'
)
tweak_data.hud_icons.kpr_assist = {
	texture = 'guis/textures/pd2/kpr_assist',
	texture_rect = { 0, 0, 64, 64 }
}
tweak_data.hud_icons.kpr_stationary = {
	texture = 'guis/textures/pd2/skilltree/icons_atlas',
	texture_rect = { 0*64, 5*64, 64, 64 }
}
tweak_data.hud_icons.kpr_patrol = {
	texture = 'guis/textures/pd2/skilltree/icons_atlas',
	texture_rect = { 7*64, 10*64, 64, 64 }
}
tweak_data.hud_icons.kpr_camera = {
	texture = 'units/gui/camera_indicator_df',
	texture_rect = { 0, 0, 255, 255 }
}
