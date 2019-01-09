
function []  = spitOutImageScFlipped(image_to_show, file_string, opt1)


flipped_image = flipud(image_to_show);


%iY_label_array =1:2:size(flipped_image, 1);



MakeFilePath(file_string);
if(nargin  == 3)
    param_struct = opt1;
else
    param_struct = struct();
end


if(isfield(param_struct, 'range'))%If we want to crop the image. 
    if(max(param_struct.range) > 0)
        imagesc(flipped_image, param_struct.range);
    else
        imagesc(flipped_image);
    end
else
    imagesc(flipped_image);
end

colormap jet;
colorbar;

hold on;

should_make_dots = isnan(flipped_image);


if(isfield(param_struct, 'make_dots'))
    should_make_dots = should_make_dots + flipud(param_struct.make_dots);
end

[ii jj] = find(should_make_dots);
%[ii jj] = find(isnan(should_make_dots));
%ii
%jj
%scatter(jj,ii,'ok','MarkerEdgeColor', 0*[1 1 1],'MarkerFaceColor',[0 0 0],'LineWidth',2,'SizeData',100)
scatter(jj,ii,'ok','MarkerEdgeColor', 0*[1 1 1],'MarkerFaceColor',[0 0 0],'LineWidth',2,'SizeData',100, 'MarkerFaceAlpha', .05)

set(gca, 'YTickLabel', flip(get(gca, 'YTickLabel')))

if(isfield(param_struct, 'title'));
    title(param_struct.title);
    
end

saveas(1, file_string);
saveas(1, strrep(file_string, '.png', '.fig'));


close all
