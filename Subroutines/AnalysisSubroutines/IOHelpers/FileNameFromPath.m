function[file_name] =FileNameFromPath(file_path_string)
[a, b, c] = fileparts(file_path_string);
file_name = b;

%system(sprintf('mkdir -p %s', fileparts(file_path_string)));

%foo = fileparts(file_path_string);
%fprintf('Making file path for %s \n', foo);