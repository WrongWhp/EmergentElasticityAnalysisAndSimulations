function [best_theta] = EstimateRotationMatrix(matrix_to_estimate)

%We take the phase of the eigenvalues and pick one based on the
%off-diagonal entries.

%Assumes the entries are X, Y.

if(1)
%    my_vec = [matrix_to_estimate(1, 1) matrix_to_estimate(2,2)];
    
%    norm_matrix  = matrix_to_estimate ./ sqrt(my_vec' * my_vec);
    matrix_to_estimate
    
    eig_list = eigs(matrix_to_estimate);
    
    approx_angle = cart2pol(real(eig_list(1)), imag(eig_list(1)));
    
    best_theta = approx_angle;
    
    
    %
    if(xor(matrix_to_estimate(2,1) < 0, best_theta < 0))
        best_theta = -best_theta;
    end
else
    
    
end
