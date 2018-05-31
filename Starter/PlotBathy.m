% Code to Plot Bathymetry ASCII File

clearvars
addpath C:\Functions_Matlab
addpath C:\Functions_Matlab\mapping\kml

% File Name and Location for Bathy/DEM
bathy_fol = 'E:\Abbas\Modeling Resources\PS_DEM\Ruston_Way\CONED\';
fname = 'ruston_ascii.asc';

% Load in WA Coastline File 
load('C:\Users\ahooshmand\Desktop\PS_COSMOS\Salish_Model_Resources\WA_Spatial_Data\WA_coast_UTM.mat');
wa_x = data.X;
wa_y = data.Y;
clear data

tic
xyz = ascii2xyz([bathy_fol fname]); % ~2min
toc

x = xyz(:,1)';
y = xyz(:,2)';
z = xyz(:,3)';
save('RustonWayCONED_DEM','x','y','z')
clear xyz 
% load('RustonWayCONED_DEM.mat');

%% Plot Bathymetry & Subset to AOI
dem_lim = x >= 5.33*10^5 & x <= 5.375*10^5 & y >= 5.2385*10^6 & y <= 5.2426*10^6;
x_s = x(dem_lim);
y_s = y(dem_lim);
z_s = z(dem_lim);


sub = 1000;
x_sub = x_s(1:sub:end);
y_sub = y_s(1:sub:end);
z_sub = z_s(1:sub:end);

plot(x_sub,y_sub,'*')
axis equal
hold on 
plot(wa_x,wa_y,'k')

save('OwenBeach_CONED_Subset','x_s','y_s','z_s');
% 
% load('OwenBeach_CONED_Subset')

