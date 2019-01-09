        mat_file_path = sprintf('%s/SystemStates/StateOfRun%d.mat',sysparams.folder_path, run_num);
        MakeFilePath(mat_file_path);
        save(mat_file_path, 'sysparams', 'system', 'landmark_cell_list')
