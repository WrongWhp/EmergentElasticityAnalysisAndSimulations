function [rateMap, rm_struct, cond_met_indices] = ComputeRateMapFromIndsTrajCond(binned_indices,fr, traj, cond )





if(length(strfind(cond.type, 'Controlled'))> 0)
            base_cond_met_indices = pathConditionSwitchboard(traj, cond.base_cond);
            controlled_cond_met_indices = pathConditionSwitchboard(traj, cond.controlled_for_cond);

            [rateMap, rm_1] = ComputeRateMapFromBinnedIndices(binned_indices, fr, intersect(base_cond_met_indices, controlled_cond_met_indices));
            [rateMap, rm_2] = ComputeRateMapFromBinnedIndices(binned_indices, fr, setdiff(base_cond_met_indices, controlled_cond_met_indices));
            
            rm_struct.stens_firing_rate = .5 * (rm_1.stens_firing_rate + rm_2.stens_firing_rate);
            rm_struct.purely_binned_rate = .5 * (rm_1.purely_binned_rate + rm_2.purely_binned_rate);
            rm_struct.cm_smoothed_rate = .5 * (rm_1.cm_smoothed_rate + rm_2.cm_smoothed_rate);
            
            
            rm_struct.mouse_count = min(rm_1.mouse_count, rm_2.mouse_count);
            rm_struct.streak_count = min(rm_1.streak_count, rm_2.streak_count);
            
            rm_struct.spike_count = rm_struct.mouse_count;
            
            cond_met_indices = [];
else
        cond_met_indices = pathConditionSwitchboard(traj, cond);
        [rateMap, rm_struct] = ComputeRateMapFromBinnedIndices(binned_indices, fr, cond_met_indices);
end