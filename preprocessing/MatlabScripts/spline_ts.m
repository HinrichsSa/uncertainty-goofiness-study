velocity  = distance/(1/1000);
vel_mean = nanmean(velocity);
total_time = length(distance(~isnan(distance)))*(1/1000);
time = distance/vel_mean;
time = cumsum(time);

x = time;
y = X(:,4);
scatter(x, y);

xx = 0:.0001:total_time;
yy = spline(x,y,xx);
scatter(xx, yy);