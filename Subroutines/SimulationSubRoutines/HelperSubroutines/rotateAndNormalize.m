function[output] = rotateAndNormalize(vec)

vec_rot = vec;
vec_rot(2) = -vec(1);
vec_rot(1) = vec(2);

output = vec_rot/norm(vec_rot);