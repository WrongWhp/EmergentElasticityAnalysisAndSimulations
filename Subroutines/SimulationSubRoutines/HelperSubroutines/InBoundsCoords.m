function[is_in_bounds] = InBoundsCoords(coords, array_size)


is_in_bounds = true;

for i = 1:length(coords)
   is_in_bounds = and(is_in_bounds, coords(i) >=1);
   is_in_bounds = and(is_in_bounds, coords(i) <=array_size(i));
end