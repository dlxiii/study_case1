% read dye age for showing their distribution.

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

%%%------------------------------------------------------------------------
%%%                          INPUT CONFIGURATION
%%%------------------------------------------------------------------------

ncfile.name = '../../otp/tokyobay_0001.nc';
fprintf(['NC file at:',ncfile.name,'\n']);
% ncfile.info = ncdisp(ncfile.name);

matfile = '../../inp/varb/Mobj_02.mat';
load(matfile);
fprintf(['mat file at:',matfile,'\n']);

% jj = 4345;
jj = 1;

ti = 1; %Time interval 6 hours.
start = jj;%0*24+1;
extent = Inf;% number or 'Inf'

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
% DYE:       passive tracer concentration      -                [node,siglay,time]
% DYE_AGE:   passive tracer concentration age  sec              [node,siglay,time]
%=================================================================================

% if exist('dyefile.mat','file') == 0
	vartoread = {'x','y','lon','lat','h','nv','siglay'};%'lonc','latc'
    vartoread1d = {'time','Times'};
    %vartoread2d = {'zeta'};% 'ua','va'
    vartoread3d = {'DYE','DYE_AGE'};%'temperature'，'salinity'
	for i = 1:length(vartoread)
	    ncfile.(vartoread{i}) = ncread(ncfile.name,vartoread{i});
        ncfile.(vartoread{i}) = double(ncfile.(vartoread{i}));
	    fprintf(['Read 0d var ',vartoread{i},'.\n']);
    end
    ncfile.xy           = [ncfile.x, ncfile.y];
    ncfile.lonlat       = [ncfile.lon, ncfile.lat];
    ncfile.tri_xy       = triangulation(ncfile.nv,ncfile.xy);
    ncfile.tri_lonlat   = triangulation(ncfile.nv,ncfile.lonlat);
    ncfile.tri          = ncfile.tri_xy.ConnectivityList;
    ncfile.tri(:,[2 3]) = ncfile.tri(:,[3 2]);
    if exist('vartoread1d','var') == 1
        % 1d time dimension
        ncfile.time = ncread(ncfile.name,'time',[start],[extent]);
        ncfile.Times = ncread(ncfile.name,'Times',[1, start],[Inf, extent]);
        % Minor change array of ncfile.Times
        ncfile.Times = ncfile.Times';
        fprintf(['Read 1d var ','time and Times','.\n']);
    end
    if exist('vartoread2d','var') == 1
        % 2d variables
        for i = 1:length(vartoread2d)
            ncfile.(vartoread2d{i}) = ncread(ncfile.name,vartoread2d{i},[1, start],[Inf, extent]);
            fprintf(['Read 2d var ',vartoread2d{i},'.\n']);
        end
    end
    if exist('vartoread3d','var') == 1
        % 3d variables
        for i = 1:length(vartoread3d)
            ncfile.(vartoread3d{i}) = ncread(ncfile.name,vartoread3d{i},[1, 1, start],[Inf, Inf, extent]);
            fprintf(['Read 3d var ',vartoread3d{i},'.\n']);
        end
        if ismember('DYE',vartoread3d) && ismember('DYE_AGE',vartoread3d)
            % water_mask = squeeze(ncfile.DYE<=1E-6);
            % water_age = squeeze(ncfile.DYE_AGE./ncfile.DYE);
            water_mask = ncfile.DYE<=1E-6;
            water_age = ncfile.DYE_AGE./ncfile.DYE;
            water_age(water_mask)=nan;
            water_age=water_age/24/60;
            ncfile.age=water_age;
            clear water_*
        end
    end
	% clear ncfile.temp;
	fprintf(['NC file reading finished.\n']);
	save('ncfile.mat','ncfile','-v7.3','-nocompression');
% elseif exist('ncfile.mat','file') == 2
% 	load ('dyefile.mat');
% 	fprintf(['NC file loading finished.\n']);
% end
save('mobj.mat','Mobj','-v7.3','-nocompression');

%% 
%%%------------------------------------------------------------------------
%%%           MONTHLY WATER AGE SURFACE & SECTION LAYER PLOTTING
%%%------------------------------------------------------------------------
idx =[...
    7,23;24,36;37,43;44,61;...
    62,107;108,117;118,137;...
    ];
clear TD;
yidx = {'14','14','14','14','14','14','14','14','14','14','14','14',...
    '15','15','15','15','15','15','15','15','15','15','15','15'};
midx = {'01','02','03','04','05','06','07','08','09','10','11','12',...
    '01','02','03','04','05','06','07','08','09','10','11','12'};
for id = 1:length(yidx)
    timetoplot = {['age',yidx{id},'_',midx{id}]};
    TD.Times = ['20',yidx{id},'_',midx{id}];
    k1 = find(ncfile.time == mjuliandate(str2num(['20',yidx{id}]),str2num(midx{id}),01));
    try
        k2 = find(ncfile.time == mjuliandate(str2num(['20',yidx{id+1}]),str2num(midx{id+1}),01))-1;
    catch
        k2 = length(ncfile.time)-1;
    end
    TD.(['age',yidx{id},'_',midx{id}]) = mean(ncfile.age(:,:,k1:k2),3,'omitnan');
    
    for ii = 1:length(idx)
        Num = 30+ii-1;
        ra = [idx(ii,1):idx(ii,2)];
        crs_node_temp = [];
        for i = 1:length(ra)
            crs_node_temp(i) = Mobj.stations{1,ra(i)}{1,4};
        end
        crs_node = crs_node_temp';
        plot_nc_cross_TS(Num, Mobj, TD, ti+1, crs_node, timetoplot);
    end
end

% timetoplot = {'age00'};
% TD.age00 = mean(ncfile.age,3,'omitnan');
% TD.Times = '0000-00';
TD.lon = ncfile.lon;
TD.lat = ncfile.lat;
TD.nv = ncfile.nv;
TD.siglay = ncfile.siglay;
save('ncfile_TD.mat','TD','-v7.3','-nocompression');

for ii = 1:length(idx)
    Num = 30+ii-1;
    ra = [idx(ii,1):idx(ii,2)];
    crs_node_temp = [];
    for i = 1:length(ra)
        crs_node_temp(i) = Mobj.stations{1,ra(i)}{1,4};
    end
    crs_node = crs_node_temp';
    plot_nc_cross_TS(Num, Mobj, TD, ti+1, crs_node, timetoplot);
    lidx = [1,8,16,20];
    for ll = 1:length(lidx)
        Num = 40+ll-1;
        plot_nc_layer_TS(Num, TD, ti+ 1, [lidx(ll)], timetoplot);
    end
end

%% 
%%%------------------------------------------------------------------------
%%%                          DYE SURFACE LAYER PLOTTING
%%%------------------------------------------------------------------------
% vartoplot = {'DYE'};
% Num = 10;
% %%{
% % result after 13336 (2015-07-10 15:00:00) is null
% layer=1;
% k=1;
% fig = figure(Num+k);
% jj = 4345;
% for j = jj:1:jj+8760
%     plot_VALUE(Num+k, [ncfile.lon, ncfile.lat], ncfile.nv, ncfile.(vartoplot{k})(:,layer,j),...
%         vartoplot{k}, ['layer No.',num2str(layer,'%02.2i')],...
%         0,...%minval,...
%         1,...%maxval,...
%         [ncfile.Times(j,1:10),' ',ncfile.Times(j,12:19)]);
% 
%         drawnow
%         frame = getframe(fig);
%         im{j} = frame2im(frame);
%         fprintf([vartoplot{k},': ',num2str(j),' of time ',num2str(length(ncfile.Times)),'\n']);
% end
% filename = ['plot_NC_layer_',num2str(layer,'%02.2i'),'_',vartoplot{k},'.gif']; % Specify the output file name
% for j = jj:1:jj+8760
%     [A,map] = rgb2ind(im{j},256);
%     if j == jj
%         imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',1);
%     else
%         imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',1/24);
%     end
% end
%%}
%{
plot_nc_layer_TS(Num, ncfile, ti+ 1, [1], vartoplot);
plot_nc_layer_TS(Num, ncfile, ti+ 1, [8], vartoplot);
plot_nc_layer_TS(Num, ncfile, ti+ 1, [16], vartoplot);
plot_nc_layer_TS(Num, ncfile, ti+ 1, [20], vartoplot);
%}
%% 
%%%------------------------------------------------------------------------
%%%           REALTIME WATER AGE SURFACE & SECTION LAYER PLOTTING
%%%------------------------------------------------------------------------
vartoplot = {'age'};

%{
% manually debug
zz=11;
fig = figure(02);
for tt = 1:length(ncfile.time)
    plotMesh(02, [ncfile.lon, ncfile.lat], ncfile.tri, water_age(:,tt),...
        'time',ncfile.Times(tt,1:19),...
        'dye age',{'Time (day)',[0,50]});
    drawnow
    frame = getframe(fig);
    im{tt} = frame2im(frame);
end
%}

%{
ra = [7:23];%16
ra = [24:36];%12
ra = [37:43];%6
ra = [44:61];%17
ra = [62:107];%45
ra = [108:117];%9
ra = [118:137];%19
%}
%{
idx =[...
    7,23;...
    24,36;...
    37,43;...
    44,61;...
    62,107;...
    108,117;...
    118,137;...
    ];
for ii = 1:length(idx)
    Num = 20+ii-1;
    ra = [idx(ii,1):idx(ii,2)];
    crs_node_temp = [];
    for i = 1:length(ra)
        crs_node_temp(i) = Mobj.stations{1,ra(i)}{1,4};
    end
    crs_node = crs_node_temp';
    plot_nc_cross_TS(Num, Mobj, ncfile, ti+ 1, crs_node, vartoplot);
end
%}