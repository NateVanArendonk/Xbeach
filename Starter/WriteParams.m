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
