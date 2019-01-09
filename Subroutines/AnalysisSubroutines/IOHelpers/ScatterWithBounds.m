function[] = ScatteWithBounds(x, y)


if(1)
    x_min_max_range = [nanmin(x) nanmax(x)];
    y_min_max_range = [nanmin(y) nanmax(y)];
else
    
end
plot_center = [0 0];

plot(plot_center, y_min_max_range, '--k');
hold on;

plot(x_min_max_range, plot_center, '--k');

scatter(x, y, '*b');

xlim(x_min_max_range);
ylim(y_min_max_range);
%plot_range = [min(min(v1), min(v2)) max(max(v1), max(v2))];
