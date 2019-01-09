

if(0)
    %Y Boundaries
    sysparams.bound_list{length(sysparams.bound_list) + 1} = {'linear', [1 0], [2 0]};
    sysparams.bound_list{length(sysparams.bound_list) + 1} = {'linear', [-1 0], [8 0]};
    
    %X Boundaries
    sysparams.bound_list{length(sysparams.bound_list) + 1} = {'linear', [0 1], [0 1]};
    sysparams.bound_list{length(sysparams.bound_list) + 1} = {'linear', [0 -1], [0 8]};
    
    %Diag Boundary
    sysparams.bound_list{length(sysparams.bound_list) + 1} = {'linear', [3 1], [2 5]};

    %sysparams.bound_list{length(sysparams.bound_list) + 1} = {'linear', [2 1], [2 15]};
    
    %sysparams.bound_list{length(sysparams.bound_list) + 1} = {'linear', [5 1], [2 10]};
    %sysparams.bound_list{length(sysparams.bound_list) + 1} = {'linear', [-5 1], [8 10]};
end

if(1)
    %Lightly sloped ceiling for testing hexagonal run
    %Y Boundaries
    sysparams.bound_list{length(sysparams.bound_list) + 1} = {'linear', [1 0], [1 0]};
    sysparams.bound_list{length(sysparams.bound_list) + 1} = {'linear', [-1 0], [4 0]};
    
    %X Boundaries
    sysparams.bound_list{length(sysparams.bound_list) + 1} = {'linear', [0 1], [0 1]};
    sysparams.bound_list{length(sysparams.bound_list) + 1} = {'linear', [0 -1], [0 4]};
    
    %Diag Boundary
%    sysparams.bound_list{length(sysparams.bound_list) + 1} = {'linear', [5 1], [2 5]};

%    sysparams.bound_list{length(sysparams.bound_list) + 1} = {'linear', [3 1], [2 4.5]};


end


