function [total_x_moment, total_y_moment, total_count] = MomentFromSpikeAndMouseCOM(spk_COM, mouse_COM)

 
ok_firing_fields = and(abs(spk_COM.base_x)<30, abs(spk_COM.base_y)<30);
ok_firing_fields = and(ok_firing_fields, spk_COM.count>0);



total_x_moment = sum((spk_COM.x(ok_firing_fields) - mouse_COM.x(ok_firing_fields)).*spk_COM.count(ok_firing_fields));
total_y_moment = sum((spk_COM.y(ok_firing_fields) - mouse_COM.y(ok_firing_fields)).*spk_COM.count(ok_firing_fields));
total_count = sum(spk_COM.count(ok_firing_fields));




    
 