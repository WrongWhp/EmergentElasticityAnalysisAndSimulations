
if(min(system.mesh.iX(system.in_bounds)) == min(system.mesh.iX(:)))
    fprintf('No X lower bound!')
    abort()
end

if(max(system.mesh.iX(system.in_bounds)) == max(system.mesh.iX(:)))
    fprintf('No X upper bound!')
    abort()
end


if(min(system.mesh.iY(system.in_bounds)) == min(system.mesh.iY(:)))
    fprintf('No Y lower bound!')
    abort()
end

if(max(system.mesh.iY(system.in_bounds)) == max(system.mesh.iY(:)))
    fprintf('No Y upper bound!')
    abort()
end


