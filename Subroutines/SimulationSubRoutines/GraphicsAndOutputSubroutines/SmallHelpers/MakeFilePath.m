function[] = MakeFilePath(file_path_string)
%Ensures a file path exists

path_to_add = fileparts(file_path_string);
if(strfind(getenv('OS'), 'Wind'))
    path_to_add = strrep(path_to_add, '/', '\')
    system(sprintf('mkdir %s', path_to_add));    
else    
    system(sprintf('mkdir -p %s', path_to_add));
end
%foo = fileparts(file_path_string);
%fprintf('Making file path for %s \n', foo);