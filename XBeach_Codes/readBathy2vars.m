function [bathy] = readBathy2vars(varargin)
%Reads in bathy and converts to Grid
%   User supplies a bathy file and out pops the bathy in variables
%   User can also specify the limits of the bathy to save computational
%   time for making the grid
%   
%  Limits should be a structure with lower left(lx,ly)and upper right(rx,ry) points 


% Note other methods outside of ASCII need to be verified! NV 5/30/18
% Worked when I wrote it a while ago but need to verify with different DEMs

addpath C:\Functions_Matlab

bathy_file = varargin{1};
[~,~,ext] = fileparts(bathy_file); % Get type of file that DEM is

% ---------------- ASCII File
if strcmp(ext,'.asc') % ASCII File
    xyz = ascii2xyz(bathy_file); % Load in Bathy

% ---------------- XYZ File   
elseif strcmp(ext,'.xyz') % XYZ File
    fid = fopen(bathy_file);
    xyz = textscan(fid,'%f, %f, %f');
    fclose(fid);
    if length(xyz{1,2}) <= 1 % If the formatting is wrong reupload it with spaces instead of decimals.  - NOT SURE WHY I DO THIS N.V 5/30/18, will address when I have a .xyz file
        fid = fopen(bathy_file);
        xyz = textscan(fid,'%f %f %f');
        fclose(fid);
    end
    x = xyz{1};
    y = xyz{2};
    z = xyz{3};
    xyz = [x y z];
    
% ---------------- MAT File    
elseif strcmp(ext,'.mat') 
    load(bathy_file);
    xyz = [x y z];
    
% ---------------- BAG File     
elseif strcmp(ext,'.bag') 
    A = read_bag(bathy_file);
    [A.x, A.y] = meshgrid(A.x,A.y);
    xyz = [A.x A.y A.z];
end

% subsample is necessary
if nargin > 1
    limits = varargin{2};
    sub = xyz(:,1) >= limits.lx & xyz(:,1) <= limits.rx & xyz(:,2) >= limits.ly & xyz(:,2) <= limits.ry;
    x = xyz(:,1); y = xyz(:,2); z = xyz(:,3);
    x = x(sub); y = y(sub); z = z(sub);
    xyz = [x y z];
end

bathy = xyz;
end

