function[] = ScatteWithSpine(v1, v2, opt1)


if(nargin == 3)
    
    is_red = opt1;
else
   is_red = false(size(v1)); 
end

if(1)
    min_max_range = [nanmin(nanmin([v1 v2])) nanmax(nanmax([v1 v2]))];
else
    min_max_range = .6*[-1 1];
end
plot_range = min_max_range;
plot_center = [0 0];
plot(plot_range + [-5 5], plot_range +  [-5 5], '-k');
hold on;

plot(plot_range +  [-5 5], plot_center, '--k');
plot(plot_center, plot_range +  [-5 5], '--k');
scatter(v1(~is_red), v2(~is_red), '*b');
scatter(v1(is_red), v2(is_red), '*r');

if(sum(isfinite(plot_range))>0)
    xlim(plot_range);
    ylim(plot_range);
    
end
%plot_range = [min(min(v1), min(v2)) max(max(v1), max(v2))];
