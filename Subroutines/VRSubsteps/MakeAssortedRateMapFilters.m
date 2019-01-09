sam_border_rate_map_filter.session_type = 'gain_manip';
sam_border_rate_map_filter.gain_value = 1.5;
sam_border_rate_map_filter.grid_score_bounds = [-100 100.2 ];
sam_border_rate_map_filter.border_score_bounds = [.2 100];


malcolm_border_rate_filter.session_type = 'gain_manip';
malcolm_border_rate_filter.gain_value = 1.5;
malcolm_border_rate_filter.border_score_bounds = [.5 100];
malcolm_border_rate_filter.mean_rate_bounds = [0 10];


sam_grid_rate_map_filter.session_type = 'gain_manip';
sam_grid_rate_map_filter.gain_value = 1.5;
sam_grid_rate_map_filter.grid_score_bounds = [.2 100];
sam_grid_rate_map_filter.border_score_bounds = [-100 .2];



malcolm_grid_rate_map_filter.session_type = 'gain_manip';
malcolm_grid_rate_map_filter.gain_value = 1.5;
malcolm_grid_rate_map_filter.grid_score_bounds = [.35 100];
malcolm_grid_rate_map_filter.mean_rate_bounds = [0 10];



any_gain_manip_filter.session_type = 'gain_manip';