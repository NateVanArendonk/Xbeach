% Load in Bathy File and 
clearvars
addpath C:\Functions_Matlab
addpath C:\Functions_Matlab\mapping\kml
% ADD OPEN EARTH TOOLS!!!!!!!!
%% KML Extract/Creation from Bathy set and Google Earth Transect
% Load Bathy
location = 'Ruston';
switch location
    case 'Ruston'
        bathy_fol = 'C:\Users\ahooshmand\Desktop\Modeling Resources\PS_DEM\Ruston_Way\Bathy\1_meter\';
        bathy_nm = '1_meter_bathy.mat';
        bathy_file = [bathy_fol bathy_nm];
        kml_fol = '..\ExtractTransects\Ruston\';
        kml_nm = 'Ruston_t1.kml';
    case 'Bham'
        bathy_fol = 'C:\Users\ahooshmand\Desktop\Modeling Resources\PS_DEM\Bellingham_Bay\';
        bathy_file = 'nkmos1.asc';
        bathy_nm = [bathy_fol bathy_nm];
        kml_fol = '..\ExtractTransects\Bham\';
        kml_nm = 'Bham_transects.kml';
end

tic
B = readBathy2vars(bathy_file);
toc

% Load kml
addpath C:\Functions_Matlab\mapping\kml % idk why but Matlab just has to have this here or else it will throw an error
T = kml2struct([kml_fol kml_nm]); % load in KML
% Create Transect from Bathy
KML_Transect_Extractor(T,B);
mkdir(sprintf('../%s',location))% Make Location Folder 
for ii = 1:length(T)
    fname = T(ii).Name;
    movefile([fname '_xyz.mat'],sprintf('../%s',location))
end
%% Create Grids for Xbeach

% Load Transect Bathy Points
switch location
    case 'Ruston'
        load('..\Ruston\Ruston_t1_xyz.mat');
    case 'Bham'
        load('Bham_Bay\SqualicumBeach_xyz.mat')
end

% --------------------- Inputs -----------------------------------
% Generates our grid spacing in x
xin = s; % Vector with cross-shore coordinates; increasing from zero - Likely the Transect
zin = z; % Vector with bed levels; positive up
tm_val = 4/1.1; % Incident short wave period (used to determine grid size at offshore boundary [s]
nonh_val = 1; % Creates a non-hydrostatic model grid
ppwl_val = 50; % Number of points per wave length - around 30 if domain is 1-2 wave lengths, otherwise use 100 for large domain 
wl_val = 4; % Water level elevation relative to bathymetry used to estimate depth [m]
dx_inc = .15; % Minimum required cross shore grid size (usually over land) [m]
dry_size = 2; % Grid size for dry points [m]
dry_dist = 330; % Cross-shore distance from which points are dry [m]

% Generate Xbeach X Grid 
[sgr, zgr] = xb_grid_xgrid(s, z, 'Tm', 4/1.1, 'nonh', 1, 'ppwl', 50, 'wl', 4, 'dxmin', .15, 'dxdry', 2, 'xdry',330);

% Convert s to x,y
xgr = interp1(s,x,sgr);
ygr = interp1(s,y,sgr);

% Save grd files
save([fname '_x.grd'],'xgr','-ascii')
save([fname '_y.grd'],'ygr','-ascii')
save([fname '_z.grd'],'zgr','-ascii')

plotting = 1;
if plotting
    clf
    hold on
    plot(s,z)
    plot(sgr,zgr,'*')
    plot(sgr(2:end),diff(sgr),'ro')
    
    pause
    clf
    scatter(xgr,ygr,[],zgr)
    colorbar
end
%%  Write Params File 
fname_param = [fname '_param.txt.'];
fid = fopen(fname_param,'w');

fprintf(fid,'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
fprintf(fid,'%%% XBeach parameter settings input file                                     %%%\n');
fprintf(fid,'%%% date:%s                                                                  %%%\n',datestr(datetime('now')));
fprintf(fid,'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');

fprintf(fid,'\n\n');

fprintf(fid,'%%% Model physics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
fprintf(fid,'swave 		= 0\n');
fprintf(fid,'flow       = 1\n');
fprintf(fid,'nonh       = %d\n',nonh_val);
fprintf(fid,'sedtrans   = 0\n');
fprintf(fid,'morphology = 0\n');
fprintf(fid,'nonhq3d    = 1\n');

fprintf(fid,'\n\n');

fprintf(fid,'%%% Bed composition parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
fprintf(fid,'D50          = 0.000200\n');
fprintf(fid,'D90          = 0.000300\n');

fprintf(fid,'\n\n');

fprintf(fid,'%%% Flow boundary condition parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
fprintf(fid,'front        = nonh_1d\n');
fprintf(fid,'back         = abs_1d\n');

fprintf(fid,'\n\n');

fprintf(fid,'%%% Flow parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
fprintf(fid,'C            = 55\n'); % C is bed friction

fprintf(fid,'\n\n');

fprintf(fid,'%%% Grid parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
fprintf(fid,'depfile      = z.grd\n');
fprintf(fid,'posdwn       = 0\n');
fprintf(fid,'alfa         0\n');
fpritnf(fid,'thetamin     200\n');
fprintf(fid,'thetamax     300\n');
fprintf(fid,'dtheta       20\n');
fprintf(fid,'thetanaut    1\n');
fprintf(fid,'gridform     = xbeach\n');
fprintf(fid,'xyfile       xy.grd\n');
fprintf(fid,'xfile		 = x.grd\n');
fprintf(fid,'yfile        = y.grd \n'); 
fprintf(fid,'vardx        = 1\n');
fpritnf(fid,'nx           = %d\n',VARIABLE); % Note one less than vector size
fprintf(fid,'ny           = 0\n');

fprintf(fid,'\n\n');

fprintf(fid,'%%% Model time %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
% want a couple hundred waves for a result 
fprintf(fid,'tstop        = 1200\n');  % MAYBE MAKE VARIABLE 

fprintf(fid,'\n\n');

fprintf(fid,'%%% Morphology parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
fprintf(fid,'morfac       1\n');
fprintf(fid,'wetslp       0.150000\n');
fprintf(fid,'dryslp       1\n');
fprintf(fid,'struct       0\n');
fprintf(fid,'ne_layer     nebed.dep\n');

fprintf(fid,'\n\n');

fprintf(fid,'%%% Tide boundary conditions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
fprintf(fid,'zs0file      = tide.txt\n');
fprintf(fid,'tideloc      = 2\n');

fprintf(fid,'\n\n');

fprintf(fid,'%%% Wave boundary condition parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
fprintf(fid,'instat       = jons\n');
fprintf(fid,'wbcversion   = 3\n');

fprintf(fid,'\n\n');

fprintf(fid,'%%% Wave-spectrum boundary condition parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
% Random turns on/off random seed
% rt can be less than tsop, but for run-up statistics, no better
% Trick is to use time series for jonswap spec and turn random on,
% Hilbert transform is exponential in computation, rt is 600 is 1/4 time rt is 1200
fprintf(fid,'bcfile       = jonswap\n');
fprintf(fid,'random       = 0\n');
fprintf(fid,'rt           = 1200\n');
fprintf(fid,'dtbc         1\n');

fprintf(fid,'\n\n');

fprintf(fid,'%%% Output variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
% tstart should be greater than zero, let the model "burn in"
% for run up stats want to sample at smallish fraction of wave period
fprintf(fid,'outputformat = netcdf\n');
fprintf(fid,'tintm        = 300\n');
fprintf(fid,'tintg        = 1\n');
fprintf(fid,'tstart       = 0\n');
fprintf(fid,'tintp		 = 0.25\n');
fprintf(fid,'\n');

fprintf(fid,'nglobalvar   = 4\n');
fprintf(fid,'zb\n');
fprintf(fid,'zs\n');
fprintf(fid,'u\n');
fprintf(fid,'qx\n');
fprintf(fid,'\n');

fprintf(fid,'nmeanvar     = 3\n');
fprintf(fid,'zs\n');
fprintf(fid,'u\n');
fprintf(fid,'qx\n');
fprintf(fid,'\n');

fprintf(fid,'npointvar    = 3\n');
fprintf(fid,'zs\n');
fprintf(fid,'u\n');
fprintf(fid,'hh\n');
fprintf(fid,'\n');

fprintf(fid,'nrugauge     = 1\n');
fprintf(fid,'0 0 runup\n');

fprintf(fid,'npoints      = 2\n');
fprintf(fid,'%1.15f %1.15f',crest1, crest2);
fprintf(fid,'%1.15f %1.15f',toe1, toe2);
%%
xgr_i = interp1(s,x,xp); % xp?
ygr_i = interp1(s,y,yp);



