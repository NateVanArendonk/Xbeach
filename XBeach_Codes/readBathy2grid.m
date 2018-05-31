function [xgrid,ygrid,zgrid,x_b,y_b,z_b] = readBathy2grid(bathy_file,res,left_lim,right_lim,down_lim,up_lim)
%Reads in bathy and converts to Grid
%   User supplies a bathy file and specs on grid and the function creates a
%   grid for the user.  
%   User can also specify the limits of the bathy to save computational
%   time for making the grid
addpath C:\Functions_Matlab

[~,~,ext] = fileparts(bathy_file);
if strcmp(ext,'.asc') % ASCII File
    xyz = ascii2xyz(bathy_file); % Load in Bathy
    x = xyz(:,1);
    y = xyz(:,2);
    z = xys(:,3);   
elseif strcmp(ext,'.xyz') % XYZ File
    fid = fopen(bathy_file);
    T = textscan(fid,'%f, %f, %f');
    fclose(fid);
    if length(T{1,2}) <= 1 % If the formatting is wrong reupload it with spaces instead of decimals.  
        fclose(fid);
        fid = fopen(bathy_file);
        T = textscan(fid,'%f %f %f');
        fclose(fid);
    end
    % Grab specific parts 
    x = T{1};
    y = T{2};
    z = T{3};
end
    
% Subsample
if ~isempty(left_lim)
    inds = find(x >= left_lim & x<= right_lim & y >= down_lim & y <= up_lim);
    x = x(inds);
    y = y(inds);
    z = z(inds);
end

xg = min(x):res:max(x); % Create x vector for gird
yg = min(y):res:max(y); % Create y vector for grid

[myX, myY] = meshgrid(xg,yg); % Gridify!
myZ = griddata(x,y,z,myX,myY); % Interp Grid for Depth values

xgrid = myX;
ygrid = myY;
zgrid = myZ;
x_b = x;
y_b = y;
z_b = z;
end

