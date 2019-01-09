function [folder_name] =  CorrFolderNamer(path_cond, shift_struct)
cond_type_string = path_cond.type;

if(strcmp(shift_struct, 'x') + strcmp(shift_struct, 'y'))
    par_ortho_string = myTern(strcmp(path_cond.axis, 'NS') == strcmp(shift_struct, 'y') , 'Parr', 'Ortho');
    folder_name = [cond_type_string par_ortho_string];
else
    %cond_type_string = path_cond.type;
    par_ortho_string = myTern(strcmp(path_cond.axis, shift_struct.axis), 'Parr', 'Ortho');
    folder_name = [cond_type_string par_ortho_string];
end