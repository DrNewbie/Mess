_G.HeistChaaaaaaaaaaaaain = _G.HeistChaaaaaaaaaaaaain or {}
HeistChaaaaaaaaaaaaain.Level_Num = 76
if not tweak_data then
	return
end
tweak_data.narrative.jobs["chaaaaaaaaaaaaain"] = {}
tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].name_id = "heist_chaaaaaaaaaaaaain"
tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].briefing_id = "heist_short1_stage1_crimenet"
tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].contact = "events"
tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].region = "street"
tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].jc = 10
tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].briefing_event = "pln_sh11_cbf_01"
tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].debrief_event = nil
tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].crimenet_callouts = {
	"pln_cs1_cnc_01",
	"pln_cs1_cnc_02",
	"pln_cs1_cnc_03"
}
tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].crimenet_videos = {
	"cn_branchbank1",
	"cn_branchbank2",
	"cn_branchbank3"
}
tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].payout = {0, 0, 0, 0, 0, 0, 0}
tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].contract_cost = {0, 0, 0, 0, 0, 0, 0}
tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].contract_visuals = {}
tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].contract_visuals.min_mission_xp = {0, 0, 0, 0, 0, 0, 0}
tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].contract_visuals.max_mission_xp = {0, 0, 0, 0, 0, 0, 0}
tweak_data.levels["chaaaaaaaaaaaaain"] = deep_clone(tweak_data.levels["branchbank"])
tweak_data.levels["chaaaaaaaaaaaaain"].name_id = "heist_chaaaaaaaaaaaaain"
table.insert(tweak_data.narrative._jobs_index, "chaaaaaaaaaaaaain")
table.insert(tweak_data.levels._level_index, "chaaaaaaaaaaaaain")
tweak_data.experience_manager.day_multiplier[1] = 1
tweak_data.experience_manager.pro_day_multiplier[1] = 1
tweak_data.experience_manager.stage_completion[1] = 1
tweak_data.experience_manager.job_completion[1] = 1
tweak_data.experience_manager.day_multiplier[1] = 1
tweak_data.experience_manager.day_multiplier[2] = 1
tweak_data.experience_manager.pro_day_multiplier[2] = 1
tweak_data.experience_manager.stage_completion[2] = 1
tweak_data.experience_manager.job_completion[2] = 1
tweak_data.experience_manager.day_multiplier[2] = 1
tweak_data.experience_manager.day_multiplier[3] = 1
tweak_data.experience_manager.pro_day_multiplier[3] = 1
tweak_data.experience_manager.stage_completion[3] = 1
tweak_data.experience_manager.job_completion[3] = 1
tweak_data.experience_manager.day_multiplier[3] = 1
tweak_data.experience_manager.day_multiplier[4] = 1
tweak_data.experience_manager.pro_day_multiplier[4] = 1
tweak_data.experience_manager.stage_completion[4] = 1
tweak_data.experience_manager.job_completion[4] = 1
tweak_data.experience_manager.day_multiplier[4] = 1
tweak_data.experience_manager.day_multiplier[5] = 1
tweak_data.experience_manager.pro_day_multiplier[5] = 1
tweak_data.experience_manager.stage_completion[5] = 1
tweak_data.experience_manager.job_completion[5] = 1
tweak_data.experience_manager.day_multiplier[5] = 1
tweak_data.experience_manager.day_multiplier[6] = 1
tweak_data.experience_manager.pro_day_multiplier[6] = 1
tweak_data.experience_manager.stage_completion[6] = 1
tweak_data.experience_manager.job_completion[6] = 1
tweak_data.experience_manager.day_multiplier[6] = 1
tweak_data.experience_manager.day_multiplier[7] = 1
tweak_data.experience_manager.pro_day_multiplier[7] = 1
tweak_data.experience_manager.stage_completion[7] = 1
tweak_data.experience_manager.job_completion[7] = 1
tweak_data.experience_manager.day_multiplier[7] = 1
tweak_data.experience_manager.day_multiplier[8] = 1
tweak_data.experience_manager.pro_day_multiplier[8] = 1
tweak_data.experience_manager.stage_completion[8] = 1
tweak_data.experience_manager.job_completion[8] = 1
tweak_data.experience_manager.day_multiplier[8] = 1
tweak_data.experience_manager.day_multiplier[9] = 1
tweak_data.experience_manager.pro_day_multiplier[9] = 1
tweak_data.experience_manager.stage_completion[9] = 1
tweak_data.experience_manager.job_completion[9] = 1
tweak_data.experience_manager.day_multiplier[9] = 1
tweak_data.experience_manager.day_multiplier[10] = 1
tweak_data.experience_manager.pro_day_multiplier[10] = 1
tweak_data.experience_manager.stage_completion[10] = 1
tweak_data.experience_manager.job_completion[10] = 1
tweak_data.experience_manager.day_multiplier[10] = 1
tweak_data.experience_manager.day_multiplier[11] = 1
tweak_data.experience_manager.pro_day_multiplier[11] = 1
tweak_data.experience_manager.stage_completion[11] = 1
tweak_data.experience_manager.job_completion[11] = 1
tweak_data.experience_manager.day_multiplier[11] = 1
tweak_data.experience_manager.day_multiplier[12] = 1
tweak_data.experience_manager.pro_day_multiplier[12] = 1
tweak_data.experience_manager.stage_completion[12] = 1
tweak_data.experience_manager.job_completion[12] = 1
tweak_data.experience_manager.day_multiplier[12] = 1
tweak_data.experience_manager.day_multiplier[13] = 1
tweak_data.experience_manager.pro_day_multiplier[13] = 1
tweak_data.experience_manager.stage_completion[13] = 1
tweak_data.experience_manager.job_completion[13] = 1
tweak_data.experience_manager.day_multiplier[13] = 1
tweak_data.experience_manager.day_multiplier[14] = 1
tweak_data.experience_manager.pro_day_multiplier[14] = 1
tweak_data.experience_manager.stage_completion[14] = 1
tweak_data.experience_manager.job_completion[14] = 1
tweak_data.experience_manager.day_multiplier[14] = 1
tweak_data.experience_manager.day_multiplier[15] = 1
tweak_data.experience_manager.pro_day_multiplier[15] = 1
tweak_data.experience_manager.stage_completion[15] = 1
tweak_data.experience_manager.job_completion[15] = 1
tweak_data.experience_manager.day_multiplier[15] = 1
tweak_data.experience_manager.day_multiplier[16] = 1
tweak_data.experience_manager.pro_day_multiplier[16] = 1
tweak_data.experience_manager.stage_completion[16] = 1
tweak_data.experience_manager.job_completion[16] = 1
tweak_data.experience_manager.day_multiplier[16] = 1
tweak_data.experience_manager.day_multiplier[17] = 1
tweak_data.experience_manager.pro_day_multiplier[17] = 1
tweak_data.experience_manager.stage_completion[17] = 1
tweak_data.experience_manager.job_completion[17] = 1
tweak_data.experience_manager.day_multiplier[17] = 1
tweak_data.experience_manager.day_multiplier[18] = 1
tweak_data.experience_manager.pro_day_multiplier[18] = 1
tweak_data.experience_manager.stage_completion[18] = 1
tweak_data.experience_manager.job_completion[18] = 1
tweak_data.experience_manager.day_multiplier[18] = 1
tweak_data.experience_manager.day_multiplier[19] = 1
tweak_data.experience_manager.pro_day_multiplier[19] = 1
tweak_data.experience_manager.stage_completion[19] = 1
tweak_data.experience_manager.job_completion[19] = 1
tweak_data.experience_manager.day_multiplier[19] = 1
tweak_data.experience_manager.day_multiplier[20] = 1
tweak_data.experience_manager.pro_day_multiplier[20] = 1
tweak_data.experience_manager.stage_completion[20] = 1
tweak_data.experience_manager.job_completion[20] = 1
tweak_data.experience_manager.day_multiplier[20] = 1
tweak_data.experience_manager.day_multiplier[21] = 1
tweak_data.experience_manager.pro_day_multiplier[21] = 1
tweak_data.experience_manager.stage_completion[21] = 1
tweak_data.experience_manager.job_completion[21] = 1
tweak_data.experience_manager.day_multiplier[21] = 1
tweak_data.experience_manager.day_multiplier[22] = 1
tweak_data.experience_manager.pro_day_multiplier[22] = 1
tweak_data.experience_manager.stage_completion[22] = 1
tweak_data.experience_manager.job_completion[22] = 1
tweak_data.experience_manager.day_multiplier[22] = 1
tweak_data.experience_manager.day_multiplier[23] = 1
tweak_data.experience_manager.pro_day_multiplier[23] = 1
tweak_data.experience_manager.stage_completion[23] = 1
tweak_data.experience_manager.job_completion[23] = 1
tweak_data.experience_manager.day_multiplier[23] = 1
tweak_data.experience_manager.day_multiplier[24] = 1
tweak_data.experience_manager.pro_day_multiplier[24] = 1
tweak_data.experience_manager.stage_completion[24] = 1
tweak_data.experience_manager.job_completion[24] = 1
tweak_data.experience_manager.day_multiplier[24] = 1
tweak_data.experience_manager.day_multiplier[25] = 1
tweak_data.experience_manager.pro_day_multiplier[25] = 1
tweak_data.experience_manager.stage_completion[25] = 1
tweak_data.experience_manager.job_completion[25] = 1
tweak_data.experience_manager.day_multiplier[25] = 1
tweak_data.experience_manager.day_multiplier[26] = 1
tweak_data.experience_manager.pro_day_multiplier[26] = 1
tweak_data.experience_manager.stage_completion[26] = 1
tweak_data.experience_manager.job_completion[26] = 1
tweak_data.experience_manager.day_multiplier[26] = 1
tweak_data.experience_manager.day_multiplier[27] = 1
tweak_data.experience_manager.pro_day_multiplier[27] = 1
tweak_data.experience_manager.stage_completion[27] = 1
tweak_data.experience_manager.job_completion[27] = 1
tweak_data.experience_manager.day_multiplier[27] = 1
tweak_data.experience_manager.day_multiplier[28] = 1
tweak_data.experience_manager.pro_day_multiplier[28] = 1
tweak_data.experience_manager.stage_completion[28] = 1
tweak_data.experience_manager.job_completion[28] = 1
tweak_data.experience_manager.day_multiplier[28] = 1
tweak_data.experience_manager.day_multiplier[29] = 1
tweak_data.experience_manager.pro_day_multiplier[29] = 1
tweak_data.experience_manager.stage_completion[29] = 1
tweak_data.experience_manager.job_completion[29] = 1
tweak_data.experience_manager.day_multiplier[29] = 1
tweak_data.experience_manager.day_multiplier[30] = 1
tweak_data.experience_manager.pro_day_multiplier[30] = 1
tweak_data.experience_manager.stage_completion[30] = 1
tweak_data.experience_manager.job_completion[30] = 1
tweak_data.experience_manager.day_multiplier[30] = 1
tweak_data.experience_manager.day_multiplier[31] = 1
tweak_data.experience_manager.pro_day_multiplier[31] = 1
tweak_data.experience_manager.stage_completion[31] = 1
tweak_data.experience_manager.job_completion[31] = 1
tweak_data.experience_manager.day_multiplier[31] = 1
tweak_data.experience_manager.day_multiplier[32] = 1
tweak_data.experience_manager.pro_day_multiplier[32] = 1
tweak_data.experience_manager.stage_completion[32] = 1
tweak_data.experience_manager.job_completion[32] = 1
tweak_data.experience_manager.day_multiplier[32] = 1
tweak_data.experience_manager.day_multiplier[33] = 1
tweak_data.experience_manager.pro_day_multiplier[33] = 1
tweak_data.experience_manager.stage_completion[33] = 1
tweak_data.experience_manager.job_completion[33] = 1
tweak_data.experience_manager.day_multiplier[33] = 1
tweak_data.experience_manager.day_multiplier[34] = 1
tweak_data.experience_manager.pro_day_multiplier[34] = 1
tweak_data.experience_manager.stage_completion[34] = 1
tweak_data.experience_manager.job_completion[34] = 1
tweak_data.experience_manager.day_multiplier[34] = 1
tweak_data.experience_manager.day_multiplier[35] = 1
tweak_data.experience_manager.pro_day_multiplier[35] = 1
tweak_data.experience_manager.stage_completion[35] = 1
tweak_data.experience_manager.job_completion[35] = 1
tweak_data.experience_manager.day_multiplier[35] = 1
tweak_data.experience_manager.day_multiplier[36] = 1
tweak_data.experience_manager.pro_day_multiplier[36] = 1
tweak_data.experience_manager.stage_completion[36] = 1
tweak_data.experience_manager.job_completion[36] = 1
tweak_data.experience_manager.day_multiplier[36] = 1
tweak_data.experience_manager.day_multiplier[37] = 1
tweak_data.experience_manager.pro_day_multiplier[37] = 1
tweak_data.experience_manager.stage_completion[37] = 1
tweak_data.experience_manager.job_completion[37] = 1
tweak_data.experience_manager.day_multiplier[37] = 1
tweak_data.experience_manager.day_multiplier[38] = 1
tweak_data.experience_manager.pro_day_multiplier[38] = 1
tweak_data.experience_manager.stage_completion[38] = 1
tweak_data.experience_manager.job_completion[38] = 1
tweak_data.experience_manager.day_multiplier[38] = 1
tweak_data.experience_manager.day_multiplier[39] = 1
tweak_data.experience_manager.pro_day_multiplier[39] = 1
tweak_data.experience_manager.stage_completion[39] = 1
tweak_data.experience_manager.job_completion[39] = 1
tweak_data.experience_manager.day_multiplier[39] = 1
tweak_data.experience_manager.day_multiplier[40] = 1
tweak_data.experience_manager.pro_day_multiplier[40] = 1
tweak_data.experience_manager.stage_completion[40] = 1
tweak_data.experience_manager.job_completion[40] = 1
tweak_data.experience_manager.day_multiplier[40] = 1
tweak_data.experience_manager.day_multiplier[41] = 1
tweak_data.experience_manager.pro_day_multiplier[41] = 1
tweak_data.experience_manager.stage_completion[41] = 1
tweak_data.experience_manager.job_completion[41] = 1
tweak_data.experience_manager.day_multiplier[41] = 1
tweak_data.experience_manager.day_multiplier[42] = 1
tweak_data.experience_manager.pro_day_multiplier[42] = 1
tweak_data.experience_manager.stage_completion[42] = 1
tweak_data.experience_manager.job_completion[42] = 1
tweak_data.experience_manager.day_multiplier[42] = 1
tweak_data.experience_manager.day_multiplier[43] = 1
tweak_data.experience_manager.pro_day_multiplier[43] = 1
tweak_data.experience_manager.stage_completion[43] = 1
tweak_data.experience_manager.job_completion[43] = 1
tweak_data.experience_manager.day_multiplier[43] = 1
tweak_data.experience_manager.day_multiplier[44] = 1
tweak_data.experience_manager.pro_day_multiplier[44] = 1
tweak_data.experience_manager.stage_completion[44] = 1
tweak_data.experience_manager.job_completion[44] = 1
tweak_data.experience_manager.day_multiplier[44] = 1
tweak_data.experience_manager.day_multiplier[45] = 1
tweak_data.experience_manager.pro_day_multiplier[45] = 1
tweak_data.experience_manager.stage_completion[45] = 1
tweak_data.experience_manager.job_completion[45] = 1
tweak_data.experience_manager.day_multiplier[45] = 1
tweak_data.experience_manager.day_multiplier[46] = 1
tweak_data.experience_manager.pro_day_multiplier[46] = 1
tweak_data.experience_manager.stage_completion[46] = 1
tweak_data.experience_manager.job_completion[46] = 1
tweak_data.experience_manager.day_multiplier[46] = 1
tweak_data.experience_manager.day_multiplier[47] = 1
tweak_data.experience_manager.pro_day_multiplier[47] = 1
tweak_data.experience_manager.stage_completion[47] = 1
tweak_data.experience_manager.job_completion[47] = 1
tweak_data.experience_manager.day_multiplier[47] = 1
tweak_data.experience_manager.day_multiplier[48] = 1
tweak_data.experience_manager.pro_day_multiplier[48] = 1
tweak_data.experience_manager.stage_completion[48] = 1
tweak_data.experience_manager.job_completion[48] = 1
tweak_data.experience_manager.day_multiplier[48] = 1
tweak_data.experience_manager.day_multiplier[49] = 1
tweak_data.experience_manager.pro_day_multiplier[49] = 1
tweak_data.experience_manager.stage_completion[49] = 1
tweak_data.experience_manager.job_completion[49] = 1
tweak_data.experience_manager.day_multiplier[49] = 1
tweak_data.experience_manager.day_multiplier[50] = 1
tweak_data.experience_manager.pro_day_multiplier[50] = 1
tweak_data.experience_manager.stage_completion[50] = 1
tweak_data.experience_manager.job_completion[50] = 1
tweak_data.experience_manager.day_multiplier[50] = 1
tweak_data.experience_manager.day_multiplier[51] = 1
tweak_data.experience_manager.pro_day_multiplier[51] = 1
tweak_data.experience_manager.stage_completion[51] = 1
tweak_data.experience_manager.job_completion[51] = 1
tweak_data.experience_manager.day_multiplier[51] = 1
tweak_data.experience_manager.day_multiplier[52] = 1
tweak_data.experience_manager.pro_day_multiplier[52] = 1
tweak_data.experience_manager.stage_completion[52] = 1
tweak_data.experience_manager.job_completion[52] = 1
tweak_data.experience_manager.day_multiplier[52] = 1
tweak_data.experience_manager.day_multiplier[53] = 1
tweak_data.experience_manager.pro_day_multiplier[53] = 1
tweak_data.experience_manager.stage_completion[53] = 1
tweak_data.experience_manager.job_completion[53] = 1
tweak_data.experience_manager.day_multiplier[53] = 1
tweak_data.experience_manager.day_multiplier[54] = 1
tweak_data.experience_manager.pro_day_multiplier[54] = 1
tweak_data.experience_manager.stage_completion[54] = 1
tweak_data.experience_manager.job_completion[54] = 1
tweak_data.experience_manager.day_multiplier[54] = 1
tweak_data.experience_manager.day_multiplier[55] = 1
tweak_data.experience_manager.pro_day_multiplier[55] = 1
tweak_data.experience_manager.stage_completion[55] = 1
tweak_data.experience_manager.job_completion[55] = 1
tweak_data.experience_manager.day_multiplier[55] = 1
tweak_data.experience_manager.day_multiplier[56] = 1
tweak_data.experience_manager.pro_day_multiplier[56] = 1
tweak_data.experience_manager.stage_completion[56] = 1
tweak_data.experience_manager.job_completion[56] = 1
tweak_data.experience_manager.day_multiplier[56] = 1
tweak_data.experience_manager.day_multiplier[57] = 1
tweak_data.experience_manager.pro_day_multiplier[57] = 1
tweak_data.experience_manager.stage_completion[57] = 1
tweak_data.experience_manager.job_completion[57] = 1
tweak_data.experience_manager.day_multiplier[57] = 1
tweak_data.experience_manager.day_multiplier[58] = 1
tweak_data.experience_manager.pro_day_multiplier[58] = 1
tweak_data.experience_manager.stage_completion[58] = 1
tweak_data.experience_manager.job_completion[58] = 1
tweak_data.experience_manager.day_multiplier[58] = 1
tweak_data.experience_manager.day_multiplier[59] = 1
tweak_data.experience_manager.pro_day_multiplier[59] = 1
tweak_data.experience_manager.stage_completion[59] = 1
tweak_data.experience_manager.job_completion[59] = 1
tweak_data.experience_manager.day_multiplier[59] = 1
tweak_data.experience_manager.day_multiplier[60] = 1
tweak_data.experience_manager.pro_day_multiplier[60] = 1
tweak_data.experience_manager.stage_completion[60] = 1
tweak_data.experience_manager.job_completion[60] = 1
tweak_data.experience_manager.day_multiplier[60] = 1
tweak_data.experience_manager.day_multiplier[61] = 1
tweak_data.experience_manager.pro_day_multiplier[61] = 1
tweak_data.experience_manager.stage_completion[61] = 1
tweak_data.experience_manager.job_completion[61] = 1
tweak_data.experience_manager.day_multiplier[61] = 1
tweak_data.experience_manager.day_multiplier[62] = 1
tweak_data.experience_manager.pro_day_multiplier[62] = 1
tweak_data.experience_manager.stage_completion[62] = 1
tweak_data.experience_manager.job_completion[62] = 1
tweak_data.experience_manager.day_multiplier[62] = 1
tweak_data.experience_manager.day_multiplier[63] = 1
tweak_data.experience_manager.pro_day_multiplier[63] = 1
tweak_data.experience_manager.stage_completion[63] = 1
tweak_data.experience_manager.job_completion[63] = 1
tweak_data.experience_manager.day_multiplier[63] = 1
tweak_data.experience_manager.day_multiplier[64] = 1
tweak_data.experience_manager.pro_day_multiplier[64] = 1
tweak_data.experience_manager.stage_completion[64] = 1
tweak_data.experience_manager.job_completion[64] = 1
tweak_data.experience_manager.day_multiplier[64] = 1
tweak_data.experience_manager.day_multiplier[65] = 1
tweak_data.experience_manager.pro_day_multiplier[65] = 1
tweak_data.experience_manager.stage_completion[65] = 1
tweak_data.experience_manager.job_completion[65] = 1
tweak_data.experience_manager.day_multiplier[65] = 1
tweak_data.experience_manager.day_multiplier[66] = 1
tweak_data.experience_manager.pro_day_multiplier[66] = 1
tweak_data.experience_manager.stage_completion[66] = 1
tweak_data.experience_manager.job_completion[66] = 1
tweak_data.experience_manager.day_multiplier[66] = 1
tweak_data.experience_manager.day_multiplier[67] = 1
tweak_data.experience_manager.pro_day_multiplier[67] = 1
tweak_data.experience_manager.stage_completion[67] = 1
tweak_data.experience_manager.job_completion[67] = 1
tweak_data.experience_manager.day_multiplier[67] = 1
tweak_data.experience_manager.day_multiplier[68] = 1
tweak_data.experience_manager.pro_day_multiplier[68] = 1
tweak_data.experience_manager.stage_completion[68] = 1
tweak_data.experience_manager.job_completion[68] = 1
tweak_data.experience_manager.day_multiplier[68] = 1
tweak_data.experience_manager.day_multiplier[69] = 1
tweak_data.experience_manager.pro_day_multiplier[69] = 1
tweak_data.experience_manager.stage_completion[69] = 1
tweak_data.experience_manager.job_completion[69] = 1
tweak_data.experience_manager.day_multiplier[69] = 1
tweak_data.experience_manager.day_multiplier[70] = 1
tweak_data.experience_manager.pro_day_multiplier[70] = 1
tweak_data.experience_manager.stage_completion[70] = 1
tweak_data.experience_manager.job_completion[70] = 1
tweak_data.experience_manager.day_multiplier[70] = 1
tweak_data.experience_manager.day_multiplier[71] = 1
tweak_data.experience_manager.pro_day_multiplier[71] = 1
tweak_data.experience_manager.stage_completion[71] = 1
tweak_data.experience_manager.job_completion[71] = 1
tweak_data.experience_manager.day_multiplier[71] = 1
tweak_data.experience_manager.day_multiplier[72] = 1
tweak_data.experience_manager.pro_day_multiplier[72] = 1
tweak_data.experience_manager.stage_completion[72] = 1
tweak_data.experience_manager.job_completion[72] = 1
tweak_data.experience_manager.day_multiplier[72] = 1
tweak_data.experience_manager.day_multiplier[73] = 1
tweak_data.experience_manager.pro_day_multiplier[73] = 1
tweak_data.experience_manager.stage_completion[73] = 1
tweak_data.experience_manager.job_completion[73] = 1
tweak_data.experience_manager.day_multiplier[73] = 1
tweak_data.experience_manager.day_multiplier[74] = 1
tweak_data.experience_manager.pro_day_multiplier[74] = 1
tweak_data.experience_manager.stage_completion[74] = 1
tweak_data.experience_manager.job_completion[74] = 1
tweak_data.experience_manager.day_multiplier[74] = 1
tweak_data.experience_manager.day_multiplier[75] = 1
tweak_data.experience_manager.pro_day_multiplier[75] = 1
tweak_data.experience_manager.stage_completion[75] = 1
tweak_data.experience_manager.job_completion[75] = 1
tweak_data.experience_manager.day_multiplier[75] = 1
tweak_data.experience_manager.day_multiplier[76] = 1
tweak_data.experience_manager.pro_day_multiplier[76] = 1
tweak_data.experience_manager.stage_completion[76] = 1
tweak_data.experience_manager.job_completion[76] = 1
tweak_data.experience_manager.day_multiplier[76] = 1
tweak_data.narrative.jobs.chaaaaaaaaaaaaain.chain = {
	{level_id = "hox_3", type_id = "heist_type_assault", type = "d"},
	{level_id = "wwh", type_id = "heist_type_assault", type = "d"},
	{level_id = "arena", type_id = "heist_type_assault", type = "d"},
	{level_id = "fex", type_id = "heist_type_assault", type = "d"},
	{level_id = "hox_1", type_id = "heist_type_assault", type = "d"},
	{level_id = "mad", type_id = "heist_type_assault", type = "d"},
	{level_id = "flat", type_id = "heist_type_assault", type = "d"},
	{level_id = "crojob3", type_id = "heist_type_assault", type = "d"},
	{level_id = "friend", type_id = "heist_type_assault", type = "d"},
	{level_id = "nmh", type_id = "heist_type_assault", type = "d"},
	{level_id = "brb", type_id = "heist_type_assault", type = "d"},
	{level_id = "bph", type_id = "heist_type_assault", type = "d"},
	{level_id = "branchbank", type_id = "heist_type_assault", type = "d"},
	{level_id = "arm_und", type_id = "heist_type_assault", type = "d"},
	{level_id = "dinner", type_id = "heist_type_assault", type = "d"},
	{level_id = "sand", type_id = "heist_type_assault", type = "d"},
	{level_id = "chca", type_id = "heist_type_assault", type = "d"},
	{level_id = "arm_hcm", type_id = "heist_type_assault", type = "d"},
	{level_id = "run", type_id = "heist_type_assault", type = "d"},
	{level_id = "dark", type_id = "heist_type_assault", type = "d"},
	{level_id = "nightclub", type_id = "heist_type_assault", type = "d"},
	{level_id = "rvd2", type_id = "heist_type_assault", type = "d"},
	{level_id = "pines", type_id = "heist_type_assault", type = "d"},
	{level_id = "chas", type_id = "heist_type_assault", type = "d"},
	{level_id = "rvd1", type_id = "heist_type_assault", type = "d"},
	{level_id = "mus", type_id = "heist_type_assault", type = "d"},
	{level_id = "pal", type_id = "heist_type_assault", type = "d"},
	{level_id = "ukrainian_job", type_id = "heist_type_assault", type = "d"},
	{level_id = "sah", type_id = "heist_type_assault", type = "d"},
	{level_id = "shoutout_raid", type_id = "heist_type_assault", type = "d"},
	{level_id = "chill_combat", type_id = "heist_type_assault", type = "d"},
	{level_id = "arm_for", type_id = "heist_type_assault", type = "d"},
	{level_id = "help", type_id = "heist_type_assault", type = "d"},
	{level_id = "rat", type_id = "heist_type_assault", type = "d"},
	{level_id = "pex", type_id = "heist_type_assault", type = "d"},
	{level_id = "cane", type_id = "heist_type_assault", type = "d"},
	{level_id = "glace", type_id = "heist_type_assault", type = "d"},
	{level_id = "pbr2", type_id = "heist_type_assault", type = "d"},
	{level_id = "cage", type_id = "heist_type_assault", type = "d"},
	{level_id = "arm_cro", type_id = "heist_type_assault", type = "d"},
	{level_id = "des", type_id = "heist_type_assault", type = "d"},
	{level_id = "crojob2", type_id = "heist_type_assault", type = "d"},
	{level_id = "hvh", type_id = "heist_type_assault", type = "d"},
	{level_id = "born", type_id = "heist_type_assault", type = "d"},
	{level_id = "ranc", type_id = "heist_type_assault", type = "d"},
	{level_id = "nail", type_id = "heist_type_assault", type = "d"},
	{level_id = "peta2", type_id = "heist_type_assault", type = "d"},
	{level_id = "arm_fac", type_id = "heist_type_assault", type = "d"},
	{level_id = "vit", type_id = "heist_type_assault", type = "d"},
	{level_id = "crojob3_night", type_id = "heist_type_assault", type = "d"},
	{level_id = "trai", type_id = "heist_type_assault", type = "d"},
	{level_id = "spa", type_id = "heist_type_assault", type = "d"},
	{level_id = "bex", type_id = "heist_type_assault", type = "d"},
	{level_id = "jewelry_store", type_id = "heist_type_assault", type = "d"},
	{level_id = "kosugi", type_id = "heist_type_assault", type = "d"},
	{level_id = "red2", type_id = "heist_type_assault", type = "d"},
	{level_id = "chew", type_id = "heist_type_assault", type = "d"},
	{level_id = "big", type_id = "heist_type_assault", type = "d"},
	{level_id = "four_stores", type_id = "heist_type_assault", type = "d"},
	{level_id = "jolly", type_id = "heist_type_assault", type = "d"},
	{level_id = "pent", type_id = "heist_type_assault", type = "d"},
	{level_id = "arm_par", type_id = "heist_type_assault", type = "d"},
	{level_id = "kenaz", type_id = "heist_type_assault", type = "d"},
	{level_id = "mex", type_id = "heist_type_assault", type = "d"},
	{level_id = "haunted", type_id = "heist_type_assault", type = "d"},
	{level_id = "moon", type_id = "heist_type_assault", type = "d"},
	{level_id = "mallcrasher", type_id = "heist_type_assault", type = "d"},
	{level_id = "man", type_id = "heist_type_assault", type = "d"},
	{level_id = "tag", type_id = "heist_type_assault", type = "d"},
	{level_id = "peta", type_id = "heist_type_assault", type = "d"},
	{level_id = "pbr", type_id = "heist_type_assault", type = "d"},
	{level_id = "family", type_id = "heist_type_assault", type = "d"},
	{level_id = "dah", type_id = "heist_type_assault", type = "d"},
	{level_id = "gallery", type_id = "heist_type_assault", type = "d"},
	{level_id = "hox_2", type_id = "heist_type_assault", type = "d"},
	{level_id = "fish", type_id = "heist_type_assault", type = "d"}
}
