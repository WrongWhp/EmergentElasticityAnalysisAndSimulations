function [total_x_moment, total_y_moment, total_count] = MomentFromCOM(cond_COM)

 
ok_firing_fields = and(abs(cond_COM.base_x)<30, abs(cond_COM.base_y)<30);
ok_firing_fields = and(ok_firing_fields, cond_COM.count>0);
total_x_moment = sum((cond_COM.x(ok_firing_fields) - cond_COM.base_x(ok_firing_fields)).*cond_COM.count(ok_firing_fields));
total_y_moment = sum((cond_COM.y(ok_firing_fields) - cond_COM.base_y(ok_firing_fields)).*cond_COM.count(ok_firing_fields));
total_count = sum(cond_COM.count(ok_firing_fields));

    
 