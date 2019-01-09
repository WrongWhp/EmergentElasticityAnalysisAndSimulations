    
    if(sysparams.verbose.output_system_states)
        OutputSystemState
    end
    
    if(sysparams.verbose.output_z_fields)
        OutputAllZFiringFields
        OutputZPhaseSlices
    end
    
    if(sysparams.verbose.output_landmark_states)
                OutputLandmarkCellZFields
    end

    
    
    OutputCenterOfBoxCondRH;
    if(sysparams.verbose.output_rh_dists)
            
        OutputAllRhFiringFields
        if(sysparams.verbose.output_landmark_states)
            OutputLandmarkCellRhDists%Requires results of UpdateForcingArray
        end
    end
    
    
