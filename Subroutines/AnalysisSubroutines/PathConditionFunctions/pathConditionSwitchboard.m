function [cond_met_indices] = pathConditionSwitchboard(traj, path_cond)



if(length(strfind(path_cond.type, 'Controlled'))> 0 )
    base_cond_met_indices = pathConditionSwitchboard(traj, path_cond.base_cond);
    controlled_cond_met_indices = pathConditionSwitchboard(traj, path_cond.controlled_for_cond);
    cond_met_indices = orthogonalizePathConditionIndices(base_cond_met_indices, controlled_cond_met_indices, traj.N);
elseif(length(strfind(path_cond.type, 'Intersection'))> 0 )
    cond_met_1 = pathConditionSwitchboard(traj, path_cond.cond_1);
    cond_met_2 = pathConditionSwitchboard(traj, path_cond.cond_2);
    cond_met_indices = intersect(cond_met_1, cond_met_2);
elseif(length(strfind(path_cond.type,  'OrigHeadDir'))> 0 )
    cond_met_indices = origHeadDirectionCondition(traj, path_cond);
elseif(length(strfind(path_cond.type,  'HD'))> 0 )
    cond_met_indices = headDirectionCondition(traj, path_cond);
elseif(length(strfind(path_cond.type,  'Last Wall NonExclusive'))> 0 )
    cond_met_indices =  lastHitWallDirectionCondition(traj, path_cond);
elseif(length(strfind(path_cond.type, 'PrevPosition'))> 0 )
    cond_met_indices = cameFromDirectionCondition(traj, path_cond);
elseif(length(strfind(path_cond.type, 'FuturePosition'))> 0 )
    cond_met_indices = willBeInDirectionCondition(traj, path_cond);
elseif(length(strfind(path_cond.type, 'Velocity'))> 0 )
    cond_met_indices = velocityPathCondition(traj, path_cond);
elseif(length(strfind(path_cond.type, 'TimeSinceWallSym'))> 0 )
    cond_met_indices = TimeSinceWallSymCondition(traj, path_cond);
    
else
    input(sprintf('PROBLEM-PATH COND DOESNT HAVE ACCEPIBLE TYPE: TYPE GIVEN IS: %s', path_cond.type));
    cond_met_indices = [];
end
%Make all conditions be the same
%cond_met_indices = 1:traj.N;
