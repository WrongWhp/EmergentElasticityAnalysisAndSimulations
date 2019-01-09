function [log_likelihood coverage] = RateMapCompLogLikelyHood(rate_map_struct1, rate_map_struct2, crop_inds1, crop_inds2)



t1 = rate_map_struct1.mouse_count(crop_inds1.iY, crop_inds1.iX);
y1 = rate_map_struct1.spike_count(crop_inds1.iY, crop_inds1.iX);

t2 = rate_map_struct2.mouse_count(crop_inds2.iY, crop_inds2.iX);
y2 = rate_map_struct2.spike_count(crop_inds2.iY, crop_inds2.iX);

log_likelihood = TimeEventLogLikelihood(t1, t2, y1, y2);
coverage = sum(and(t1(:) > 0, t2(:) > 0));