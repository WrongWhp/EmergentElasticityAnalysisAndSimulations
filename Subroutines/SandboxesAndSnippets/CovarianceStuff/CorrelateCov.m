for data_ind = 1:length(maps_to_do)
   eigs_of_cov_matrix = eig(cov_matrix{data_ind});
   sam_ellipticities(data_ind) = abs(log(eigs_of_cov_matrix(1) / eigs_of_cov_matrix(2)));
   
    
end