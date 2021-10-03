clear all;
clearvars; clc;

% delete('diary')
% diary on;
% Which system am I using?
if ismac        % On Mac
    basedir = '/Users/yulong/GitHub/';
    addpath([basedir,'fvcomtoolbox/custom/']);
    addpath([basedir,'fvcomtoolbox/utilities/']);
elseif isunix	% Unix?
    basedir = '/home/usr0/n70110d/';
    addpath([basedir,'github/fvcomtoolbox/custom/']);
    addpath([basedir,'github/fvcomtoolbox/utilities/']);
elseif ispc     % Or Windows?
    basedir = 'C:/Users/Yulong WANG/Documents/GitHub/';      
    addpath([basedir,'fvcom-toolbox/custom/']);
    addpath([basedir,'fvcom-toolbox/utilities/']);
end

global plot_contour;
plot_contour = 1;

%%%------------------------------------------------------------------------
%%%                          INPUT CONFIGURATION
%%%------------------------------------------------------------------------

ncfile.name = '../../otp/tokyobay_0001.nc';
fprintf(['NC file at:',ncfile.name,'\n']);
% ncfile.info = ncdisp(ncfile.name);

matfile = '../../inp/varb/Mobj_02.mat';
load(matfile);
fprintf(['mat file at:',matfile,'\n']);

ti = 6; %Time interval 6 hours.
start = 100*24+1;
extent = 30*24;% number or 'Inf'
%=================================================================================
% variable   long name                         units             dimensions
%=================================================================================
% x:         nodal x-coordinate                meters           [node]
% y:         nodal y-coordinate                meters           [node]
% lon:	     nodal longitude                   degrees_east     [node]
% lat:	     nodal latitude                    degrees_north    [node]
% xc:        zonal x-coordinate                meters           [nele]
% yc:        zonal y-coordinate                meters           [nele]
% lonc:	     zonal longitude                   degrees_east     [nele]
% latc:	     zonal latitude                    degrees_north    [nele]
% siglay:    Sigma Layers                      -                [node,siglay]
% nv:        nodes surrounding element         -                [nele,three]
% Times:     time                              -                [time]
% zeta:      Water Surface Elevation           meters           [node,time]
% ua:        Vertically Averaged x-velocity    meters s-1       [nele,time]
% va:        Vertically Averaged y-velocity    meters s-1       [nele,time]
% temp:      temperature                       degrees_C        [node,siglay,time]
% salinity:  salinity                          1e-3             [node,siglay,time]
%=================================================================================

if exist('ncfile.mat','file') == 0
	vartoread = {'lon','lat','h','nv','siglay'};%'lonc','latc'
    % vartoread1d = {'time','Times'};
    vartoread2d = {'zeta'};% 'ua','va'
    vartoread3d = {'temp','salinity'};
	for i = 1:length(vartoread)
	    ncfile.(vartoread{i}) = ncread(ncfile.name,vartoread{i});
	    fprintf(['Read ',vartoread{i},'.\n']);
    end
    % 1d time dimension
    ncfile.time = ncread(ncfile.name,'time',[start],[extent]);
    ncfile.Times = ncread(ncfile.name,'Times',[1, start],[Inf, extent]);
	% Minor change array of ncfile.Times
	ncfile.Times = ncfile.Times';
    % 2d variables
	for i = 1:length(vartoread2d)
	    ncfile.(vartoread2d{i}) = ncread(ncfile.name,vartoread2d{i},[1, start],[Inf, extent]);
	    fprintf(['Read ',vartoread2d{i},'.\n']);
    end
    % 3d variables
	for i = 1:length(vartoread3d)
	    ncfile.(vartoread3d{i}) = ncread(ncfile.name,vartoread3d{i},[1, 1, start],[Inf, 1, extent]);
	    fprintf(['Read ',vartoread3d{i},'.\n']);
    end
	% Change name of variables
	ncfile.temperature = ncfile.temp;
	% clear ncfile.temp;
	fprintf(['NC file reading finished.\n']);
	save('ncfile.mat','ncfile','-v7.3','-nocompression');
elseif exist('ncfile.mat','file') == 2
	load ('ncfile.mat');
	fprintf(['NC file loading finished.\n']);
end
save('mobj.mat','Mobj','-v7.3','-nocompression');

%% 
%%%------------------------------------------------------------------------
%%%                          NCFILE OPENBOUNDARY PLOTTING
%%%------------------------------------------------------------------------

% vartoplot = {'temperature','salinity'};
% Num = 00;
% timestep = 4;
% % plot_obj_obc_TS(Num, Mobj, vartoplot);
% plot_nc_obc_TS(Num, Mobj, ncfile, timestep, vartoplot{1});

%% 
%%%------------------------------------------------------------------------
%%%                          NCFILE SURFACE LAYER PLOTTING
%%%------------------------------------------------------------------------
vartoplot = {'temperature','salinity'};
Num = 10;
plot_nc_layer_TS(Num, ncfile, ti+ 1, [1], vartoplot);
%{
plot_nc_layer_TS(Num, ncfile, ti+ 1, [8], vartoplot);
plot_nc_layer_TS(Num, ncfile, ti+ 1, [16], vartoplot);
plot_nc_layer_TS(Num, ncfile, ti+ 1, [20], vartoplot);

%% 
%%%------------------------------------------------------------------------
%%%                          NCFILE CROSS SECTION PLOTTING
%%%------------------------------------------------------------------------
x = Mobj.lon;
y = Mobj.lat;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ra = [7:23];%16
crs_node_temp = [];
for i = 1:length(ra)
    crs_node_temp(i) = Mobj.stations{1,ra(i)}{1,4};
end
crs_node = crs_node_temp';

plotMesh(21, [Mobj.lon, Mobj.lat], Mobj.tri, Mobj.h_backup_1);
hold on;
title('Cross section nodes (Tokyo Bay 01)');
plot(x(crs_node), y(crs_node), 'go');
saveas(gcf,'plot_NC_cross_yoko01.png');
savefig('plot_NC_cross_yoko01.fig');

Num = 31;
vartoplot = {'temperature'};
plot_nc_cross_TS(Num, Mobj, ncfile, ti+ 1, crs_node, vartoplot);
Num = 32;
vartoplot = {'salinity'};
plot_nc_cross_TS(Num, Mobj, ncfile, ti+ 1, crs_node, vartoplot);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ra = [24:36];%12
crs_node_temp = [];
for i = 1:length(ra)
    crs_node_temp(i) = Mobj.stations{1,ra(i)}{1,4};
end
crs_node = crs_node_temp';

plotMesh(21, [Mobj.lon, Mobj.lat], Mobj.tri, Mobj.h_backup_1);
hold on;
title('Cross section nodes (Tokyo Bay 02)');
plot(x(crs_node), y(crs_node), 'go');
saveas(gcf,'plot_NC_cross_yoko02.png');
savefig('plot_NC_cross_yoko02.fig');

Num = 31;
vartoplot = {'temperature'};
plot_nc_cross_TS(Num, Mobj, ncfile, ti+ 1, crs_node, vartoplot);
Num = 32;
vartoplot = {'salinity'};
plot_nc_cross_TS(Num, Mobj, ncfile, ti+ 1, crs_node, vartoplot);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ra = [37:43];%6
crs_node_temp = [];
for i = 1:length(ra)
    crs_node_temp(i) = Mobj.stations{1,ra(i)}{1,4};
end
crs_node = crs_node_temp';

plotMesh(21, [Mobj.lon, Mobj.lat], Mobj.tri, Mobj.h_backup_1);
hold on;
title('Cross section nodes (Tokyo Bay 03)');
plot(x(crs_node), y(crs_node), 'go');
saveas(gcf,'plot_NC_cross_yoko03.png');
savefig('plot_NC_cross_yoko03.fig');

Num = 31;
vartoplot = {'temperature'};
plot_nc_cross_TS(Num, Mobj, ncfile, ti+ 1, crs_node, vartoplot);
Num = 32;
vartoplot = {'salinity'};
plot_nc_cross_TS(Num, Mobj, ncfile, ti+ 1, crs_node, vartoplot);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ra = [44:61];%17
crs_node_temp = [];
for i = 1:length(ra)
    crs_node_temp(i) = Mobj.stations{1,ra(i)}{1,4};
end
crs_node = crs_node_temp';

plotMesh(21, [Mobj.lon, Mobj.lat], Mobj.tri, Mobj.h_backup_1);
hold on;
title('Cross section nodes (Tokyo Bay 04)');
plot(x(crs_node), y(crs_node), 'go');
saveas(gcf,'plot_NC_cross_yoko04.png');
savefig('plot_NC_cross_yoko04.fig');

Num = 31;
vartoplot = {'temperature'};
plot_nc_cross_TS(Num, Mobj, ncfile, ti+ 1, crs_node, vartoplot);
Num = 32;
vartoplot = {'salinity'};
plot_nc_cross_TS(Num, Mobj, ncfile, ti+ 1, crs_node, vartoplot);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ra = [62:107];%45
crs_node_temp = [];
for i = 1:length(ra)
    crs_node_temp(i) = Mobj.stations{1,ra(i)}{1,4};
end
crs_node = crs_node_temp';

plotMesh(21, [Mobj.lon, Mobj.lat], Mobj.tri, Mobj.h_backup_1);
hold on;
title('Cross section nodes (Tokyo Bay 05)');
plot(x(crs_node), y(crs_node), 'go');
saveas(gcf,'plot_NC_cross_tate01.png');
savefig('plot_NC_cross_tate01.fig');

Num = 31;
vartoplot = {'temperature'};
plot_nc_cross_TS(Num, Mobj, ncfile, ti+ 1, crs_node, vartoplot);
Num = 32;
vartoplot = {'salinity'};
plot_nc_cross_TS(Num, Mobj, ncfile, ti+ 1, crs_node, vartoplot);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ra = [108:117];%9
crs_node_temp = [];
for i = 1:length(ra)
    crs_node_temp(i) = Mobj.stations{1,ra(i)}{1,4};
end
crs_node = crs_node_temp';

plotMesh(21, [Mobj.lon, Mobj.lat], Mobj.tri, Mobj.h_backup_1);
hold on;
title('Cross section nodes (Tokyo Bay 06)');
plot(x(crs_node), y(crs_node), 'go');
saveas(gcf,'plot_NC_cross_tate02.png');
savefig('plot_NC_cross_tate02.fig');

Num = 31;
vartoplot = {'temperature'};
plot_nc_cross_TS(Num, Mobj, ncfile, ti+ 1, crs_node, vartoplot);
Num = 32;
vartoplot = {'salinity'};
plot_nc_cross_TS(Num, Mobj, ncfile, ti+ 1, crs_node, vartoplot);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ra = [118:137];%19
crs_node_temp = [];
for i = 1:length(ra)
    crs_node_temp(i) = Mobj.stations{1,ra(i)}{1,4};
end
crs_node = crs_node_temp';

plotMesh(21, [Mobj.lon, Mobj.lat], Mobj.tri, Mobj.h_backup_1);
hold on;
title('Cross section nodes (Tokyo Bay 07)');
plot(x(crs_node), y(crs_node), 'go');
saveas(gcf,'plot_NC_cross_tate03.png');
savefig('plot_NC_cross_tate03.fig');

Num = 31;
vartoplot = {'temperature'};
plot_nc_cross_TS(Num, Mobj, ncfile, ti+ 1, crs_node, vartoplot);
Num = 32;
vartoplot = {'salinity'};
plot_nc_cross_TS(Num, Mobj, ncfile, ti+ 1, crs_node, vartoplot);

%%
%}
diary off;
