
if(sysparams.verbose.output_system_states)
    final_state_path = sprintf('%s/SystemStates/FinalState.mat', sysparams.folder_path);
    MakeFilePath(final_state_path);
    save(final_state_path);
end
