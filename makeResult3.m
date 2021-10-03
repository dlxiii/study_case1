% monthly, seasonal and annually water age variability

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

td_2020 = load("/Volumes/Yulong/GitHub/paper_case/low_resolution_2020/run/mScripts/ncfile_TD.mat");
td_2020 = td_2020.TD;
td_meiji = load("/Volumes/Yulong/GitHub/paper_case/low_resolution_meiji/run/mScripts/ncfile_TD.mat");
td_meiji = td_meiji.TD;

%% present monthly layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,8,16];
month = {'age14_01','age14_02','age14_03','age14_04','age14_05','age14_06',...
    'age14_07','age14_08','age14_09','age14_10','age14_11','age14_12',...
    'age15_01','age15_02','age15_03','age15_04','age15_05','age15_06',...
    'age15_07','age15_08','age15_09','age15_10','age15_11','age15_12'};
for l = 1:3
    layer = layerlist(l);
for m = 1:length(month)
    data1 = double(td_2020.(month{m})(:,layer));
    data1 = filloutliers(data1,'nearest','mean');
    data_2020.intp = scatteredInterpolant(...
        td_2020.lon,...
        td_2020.lat,...
        data1,...
        'natural');
    data_2020.lonint = (139.14:0.001:140.39)';
    data_2020.latint = (34.85:0.001:35.70)';
    data_2020.ageint = data_2020.intp({data_2020.lonint,data_2020.latint});

    data = data_2020.ageint;
    data = filloutliers(data,'nearest','mean');

    % Create figure
    figure1 = figure(1);
    clf
    % Create axes
    axes1 = axes('Parent',figure1);
    hold(axes1,'on');
    % image(data_2020.lonint,data_2020.latint,data');
    % contourf(data_2020.lonint,data_2020.latint,data',[-25,-20,-15,-10,-5,0,5,10,15,20],'ShowText','on');
    [C,h] = contourf(data_2020.lonint,data_2020.latint,data',...
        [0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80]);
    v = [0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80];
    clabel(C,h,v,'FontSize',12,'FontName','Times','Color','black');
    % hold on;
    % ss = shaperead("boundary.shp");
    % mapshow(ss);
    hold on;
    file = "/Users/yulong/GitHub/OceanMesh2D/datasets/C23-06_TOKYOBAY.shp";
    s = shaperead(file);
    mapshow(s);
    % Uncomment the following line to preserve the X-limits of the axes
    xlim(axes1,[139.3 140.3]);
    % Uncomment the following line to preserve the Y-limits of the axes
    ylim(axes1,[34.85 35.75]);
    % Create ylabel
    ylabel('Latitude (degree)');
    % Create xlabel
    xlabel('Longtitude (degree)');
    % Create title
    % title([DateString, ': ', 'water ',NAME_ITEM, ' of ', NAME_LOCATION, ' ', item]);
    box(axes1,'on');

    print(gcf,['./Results/present/monthly_layers/',...
        'present_monthly_',month{m},'_layer',num2str(layer),'.png'],'-dpng','-r600');
    savefig(['./Results/present/monthly_layers/',...
        'present_monthly_',month{m},'_layer',num2str(layer),'.fig']);
end
end

%% meiji monthly layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,8,16];
month = {'age14_01','age14_02','age14_03','age14_04','age14_05','age14_06',...
    'age14_07','age14_08','age14_09','age14_10','age14_11','age14_12',...
    'age15_01','age15_02','age15_03','age15_04','age15_05','age15_06',...
    'age15_07','age15_08','age15_09','age15_10','age15_11','age15_12'};
for l = 1:3
    layer = layerlist(l);
for m = 1:length(month)
    data2 = double(td_meiji.(month{m})(:,layer));
    data2 = filloutliers(data2,'nearest','mean');
    data_meiji.intp = scatteredInterpolant(...
        td_meiji.lon,...
        td_meiji.lat,...
        data2,...
        'natural');
    data_meiji.lonint = (139.14:0.001:140.39)';
    data_meiji.latint = (34.85:0.001:35.70)';
    data_meiji.ageint = data_meiji.intp({data_meiji.lonint,data_meiji.latint});

    data = data_meiji.ageint;
    data = filloutliers(data,'nearest','mean');

    % Create figure
    figure1 = figure(1);
    clf
    % Create axes
    axes1 = axes('Parent',figure1);
    hold(axes1,'on');
    % image(data_2020.lonint,data_2020.latint,data');
    % contourf(data_2020.lonint,data_2020.latint,data',[-25,-20,-15,-10,-5,0,5,10,15,20],'ShowText','on');
    [C,h] = contourf(data_meiji.lonint,data_meiji.latint,data',...
        [0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80]);
    v = [0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80];
    clabel(C,h,v,'FontSize',12,'FontName','Times','Color','black');
    % hold on;
    % ss = shaperead("boundary.shp");
    % mapshow(ss);
%     hold on;
%     file = "/Users/yulong/GitHub/OceanMesh2D/datasets/C23-06_TOKYOBAY_1886.dxf";
%     s = shaperead(file);
%     mapshow(s);
    % Uncomment the following line to preserve the X-limits of the axes
    xlim(axes1,[139.3 140.3]);
    % Uncomment the following line to preserve the Y-limits of the axes
    ylim(axes1,[34.85 35.75]);
    % Create ylabel
    ylabel('Latitude (degree)');
    % Create xlabel
    xlabel('Longtitude (degree)');
    % Create title
    % title([DateString, ': ', 'water ',NAME_ITEM, ' of ', NAME_LOCATION, ' ', item]);
    box(axes1,'on');

    print(gcf,['./Results/meiji/monthly_layers/',...
        'meiji_',month{m},'_layer',num2str(layer),'.png'],'-dpng','-r600');
    savefig(['./Results/meiji/monthly_layers/',...
        'meiji_',month{m},'_layer',num2str(layer),'.fig']);
end
end
%% change of present-meiji monthly layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,8,16];
month = {'age14_01','age14_02','age14_03','age14_04','age14_05','age14_06',...
    'age14_07','age14_08','age14_09','age14_10','age14_11','age14_12',...
    'age15_01','age15_02','age15_03','age15_04','age15_05','age15_06',...
    'age15_07','age15_08','age15_09','age15_10','age15_11','age15_12'};
for l = 1:3
    layer = layerlist(l);
for m = 1:length(month)
    data1 = double(td_2020.(month{m})(:,layer));
    data1 = filloutliers(data1,'nearest','mean');
    data_2020.intp = scatteredInterpolant(...
        td_2020.lon,...
        td_2020.lat,...
        data1,...
        'natural');
    data_2020.lonint = (139.14:0.001:140.39)';
    data_2020.latint = (34.85:0.001:35.70)';
    data_2020.ageint = data_2020.intp({data_2020.lonint,data_2020.latint});

    data2 = double(td_meiji.(month{m})(:,layer));
    data2 = filloutliers(data2,'nearest','mean');
    data_meiji.intp = scatteredInterpolant(...
        td_meiji.lon,...
        td_meiji.lat,...
        data2,...
        'natural');
    data_meiji.lonint = (139.14:0.001:140.39)';
    data_meiji.latint = (34.85:0.001:35.70)';
    data_meiji.ageint = data_meiji.intp({data_meiji.lonint,data_meiji.latint});

    data = data_2020.ageint - data_meiji.ageint;
    data = filloutliers(data,'nearest','mean');

    % Create figure
    figure1 = figure(1);
    clf
    % Create axes
    axes1 = axes('Parent',figure1);
    hold(axes1,'on');
    % image(data_2020.lonint,data_2020.latint,data');
    % contourf(data_2020.lonint,data_2020.latint,data',[-25,-20,-15,-10,-5,0,5,10,15,20],'ShowText','on');
    [C,h] = contourf(data_2020.lonint,data_2020.latint,data',[-40,-35,-30,-25,-20,-15,-10,-5,0,5,10,15,20,25,30,35,40]);
    v = [-40,-35,-30,-25,-20,-15,-10,-5,0,5,10,15,20,25,30,35,40];
    clabel(C,h,v,'FontSize',12,'FontName','Times','Color','black');
    % hold on;
    % ss = shaperead("boundary.shp");
    % mapshow(ss);
    hold on;
    file = "/Users/yulong/GitHub/OceanMesh2D/datasets/C23-06_TOKYOBAY.shp";
    s = shaperead(file);
    mapshow(s);
    % Uncomment the following line to preserve the X-limits of the axes
    xlim(axes1,[139.3 140.3]);
    % Uncomment the following line to preserve the Y-limits of the axes
    ylim(axes1,[34.85 35.75]);
    % Create ylabel
    ylabel('Latitude (degree)');
    % Create xlabel
    xlabel('Longtitude (degree)');
    % Create title
    % title([DateString, ': ', 'water ',NAME_ITEM, ' of ', NAME_LOCATION, ' ', item]);
    box(axes1,'on');

    print(gcf,['./Results/change/monthly_layers/',...
        'change_',month{m},'_layer',num2str(layer),'.png'],'-dpng','-r600');
    savefig(['./Results/change/monthly_layers/',...
        'change_',month{m},'_layer',num2str(layer),'.fig']);
end
end
%% present seasonal layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,8,16];
gr.spring1 = {'age14_03','age14_04','age14_05'};
gr.summer1 = {'age14_06','age14_07','age14_08'};%%
gr.autumn1 = {'age14_09','age14_10','age14_11'};%%
gr.winter1 = {'age14_12','age15_01','age15_02'};%%
gr.spring2 = {'age15_03','age15_04','age15_05'};%%
gr.summer2 = {'age15_06','age15_07','age15_08'};%%
gr.autumn2 = {'age15_09','age15_10','age15_11'};%%
month = {'spring1',...
    'summer1','autumn1','winter1','spring2',...
    'summer2','autumn2'};

clear td_2020_season;
for l = 1:3
    layer = layerlist(l);
for m = 1:length(month)
    temp1 = double(td_2020.(gr.(month{m}){1})(:,layer));
    temp2 = double(td_2020.(gr.(month{m}){2})(:,layer));
    temp3 = double(td_2020.(gr.(month{m}){3})(:,layer));
    data1 = filloutliers((temp1+temp2+temp3)/3,'nearest','mean');
    data_2020.intp = scatteredInterpolant(...
        td_2020.lon,...
        td_2020.lat,...
        data1,...
        'natural');
    data_2020.lonint = (139.14:0.001:140.39)';
    data_2020.latint = (34.85:0.001:35.70)';
    data_2020.ageint = data_2020.intp({data_2020.lonint,data_2020.latint});
    data = data_2020.ageint;
    data = filloutliers(data,'nearest','mean');
    td_2020_seasonal.(month{m})(:,:,l) = data;
    
    % Create figure
    figure1 = figure(1);
    clf
    % Create axes
    axes1 = axes('Parent',figure1);
    hold(axes1,'on');
    % image(data_2020.lonint,data_2020.latint,data');
    % contourf(data_2020.lonint,data_2020.latint,data',[-25,-20,-15,-10,-5,0,5,10,15,20],'ShowText','on');
    [C,h] = contourf(data_2020.lonint,data_2020.latint,data',...
        [0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80]);
    v = [0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80];
    clabel(C,h,v,'FontSize',12,'FontName','Times','Color','black');
    % hold on;
    % ss = shaperead("boundary.shp");
    % mapshow(ss);
    hold on;
    file = "/Users/yulong/GitHub/OceanMesh2D/datasets/C23-06_TOKYOBAY.shp";
    s = shaperead(file);
    mapshow(s);
    % Uncomment the following line to preserve the X-limits of the axes
    xlim(axes1,[139.3 140.3]);
    % Uncomment the following line to preserve the Y-limits of the axes
    ylim(axes1,[34.85 35.75]);
    % Create ylabel
    ylabel('Latitude (degree)');
    % Create xlabel
    xlabel('Longtitude (degree)');
    % Create title
    % title([DateString, ': ', 'water ',NAME_ITEM, ' of ', NAME_LOCATION, ' ', item]);
    box(axes1,'on');

    print(gcf,['Results/present/seasonal_layers/',...
        'present_seasonal_',month{m},'_layer',num2str(layer),'.png'],'-dpng','-r600');
    savefig(['Results/present/seasonal_layers/',...
        'presnet_seasonal_',month{m},'_layer',num2str(layer),'.fig']);
end
end
save('ncfile_TD_present_seasonal.mat','td_2020_seasonal','-v7.3','-nocompression');

%% meiji seasonal layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,8,16];
gr.spring1 = {'age14_03','age14_04','age14_05'};
gr.summer1 = {'age14_06','age14_07','age14_08'};%%
gr.autumn1 = {'age14_09','age14_10','age14_11'};%%
gr.winter1 = {'age14_12','age15_01','age15_02'};%%
gr.spring2 = {'age15_03','age15_04','age15_05'};%%
gr.summer2 = {'age15_06','age15_07','age15_08'};%%
gr.autumn2 = {'age15_09','age15_10','age15_11'};%%
month = {'spring1',...
    'summer1','autumn1','winter1','spring2',...
    'summer2','autumn2'};

clear td_meiji_season;
clear td_2020_season;
clear td_change_season;
for l = 1:3
    layer = layerlist(l);
for m = 1:length(month)
    temp1 = double(td_meiji.(gr.(month{m}){1})(:,layer));
    temp2 = double(td_meiji.(gr.(month{m}){2})(:,layer));
    temp3 = double(td_meiji.(gr.(month{m}){3})(:,layer));
    data1 = filloutliers((temp1+temp2+temp3)/3,'nearest','mean');
    data_meiji.intp = scatteredInterpolant(...
        td_meiji.lon,...
        td_meiji.lat,...
        data1,...
        'natural');
    data_meiji.lonint = (139.14:0.001:140.39)';
    data_meiji.latint = (34.85:0.001:35.70)';
    data_meiji.ageint = data_meiji.intp({data_meiji.lonint,data_meiji.latint});
    data1 = data_meiji.ageint;
    data1 = filloutliers(data1,'nearest','mean');
    td_meiji_seasonal.(month{m})(:,:,l) = data1;
    
    data = data1;
%     td_change_seasonal.(month{m})(:,:,l) = data;
    
    % Create figure
    figure1 = figure(1);
    clf
    % Create axes
    axes1 = axes('Parent',figure1);
    hold(axes1,'on');
    % image(data_2020.lonint,data_2020.latint,data');
    % contourf(data_2020.lonint,data_2020.latint,data',[-25,-20,-15,-10,-5,0,5,10,15,20],'ShowText','on');
    [C,h] = contourf(data_meiji.lonint,data_meiji.latint,data',...
        [0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80]);
    v = [0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80];
    clabel(C,h,v,'FontSize',12,'FontName','Times','Color','black');
    % hold on;
    % ss = shaperead("boundary.shp");
    % mapshow(ss);
%     hold on;
%     file = "/Users/yulong/GitHub/OceanMesh2D/datasets/C23-06_TOKYOBAY.shp";
%     s = shaperead(file);
%     mapshow(s);
    % Uncomment the following line to preserve the X-limits of the axes
    xlim(axes1,[139.3 140.3]);
    % Uncomment the following line to preserve the Y-limits of the axes
    ylim(axes1,[34.85 35.75]);
    % Create ylabel
    ylabel('Latitude (degree)');
    % Create xlabel
    xlabel('Longtitude (degree)');
    % Create title
    % title([DateString, ': ', 'water ',NAME_ITEM, ' of ', NAME_LOCATION, ' ', item]);
    box(axes1,'on');

    print(gcf,['Results/meiji/seasonal_layers/',...
        'meiji_seasonal_',month{m},'_layer',num2str(layer),'.png'],'-dpng','-r600');
    savefig(['Results/meiji/seasonal_layers/',...
        'meiji_seasonal_',month{m},'_layer',num2str(layer),'.fig']);
end
end
% save('ncfile_TD_meiji_seasonal.mat','td_meiji_seasonal','-v7.3','-nocompression');
% save('ncfile_TD_change_seasonal.mat','td_change_seasonal','-v7.3','-nocompression');
%% present-meiji seasonal layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,8,16];
gr.spring1 = {'age14_03','age14_04','age14_05'};
gr.summer1 = {'age14_06','age14_07','age14_08'};%%
gr.autumn1 = {'age14_09','age14_10','age14_11'};%%
gr.winter1 = {'age14_12','age15_01','age15_02'};%%
gr.spring2 = {'age15_03','age15_04','age15_05'};%%
gr.summer2 = {'age15_06','age15_07','age15_08'};%%
gr.autumn2 = {'age15_09','age15_10','age15_11'};%%
month = {'spring1',...
    'summer1','autumn1','winter1','spring2',...
    'summer2','autumn2'};

clear td_meiji_season;
clear td_2020_season;
clear td_change_season;
for l = 1:3
    layer = layerlist(l);
for m = 1:length(month)
    temp1 = double(td_meiji.(gr.(month{m}){1})(:,layer));
    temp2 = double(td_meiji.(gr.(month{m}){2})(:,layer));
    temp3 = double(td_meiji.(gr.(month{m}){3})(:,layer));
    data1 = filloutliers((temp1+temp2+temp3)/3,'nearest','mean');
    data_meiji.intp = scatteredInterpolant(...
        td_meiji.lon,...
        td_meiji.lat,...
        data1,...
        'natural');
    data_meiji.lonint = (139.14:0.001:140.39)';
    data_meiji.latint = (34.85:0.001:35.70)';
    data_meiji.ageint = data_meiji.intp({data_meiji.lonint,data_meiji.latint});
    data1 = data_meiji.ageint;
    data1 = filloutliers(data1,'nearest','mean');
    td_meiji_seasonal.(month{m})(:,:,l) = data1;
    
    temp1 = double(td_2020.(gr.(month{m}){1})(:,layer));
    temp2 = double(td_2020.(gr.(month{m}){2})(:,layer));
    temp3 = double(td_2020.(gr.(month{m}){3})(:,layer));
    data2 = filloutliers((temp1+temp2+temp3)/3,'nearest','mean');
    data_2020.intp = scatteredInterpolant(...
        td_2020.lon,...
        td_2020.lat,...
        data2,...
        'natural');
    data_2020.lonint = (139.14:0.001:140.39)';
    data_2020.latint = (34.85:0.001:35.70)';
    data_2020.ageint = data_2020.intp({data_2020.lonint,data_2020.latint});
    data2 = data_2020.ageint;
    data2 = filloutliers(data2,'nearest','mean');
    td_2020_seasonal.(month{m})(:,:,l) = data2;
    
    data = data2 - data1;
    td_change_seasonal.(month{m})(:,:,l) = data;
    
    % Create figure
    figure1 = figure(1);
    clf
    % Create axes
    axes1 = axes('Parent',figure1);
    hold(axes1,'on');
    % image(data_2020.lonint,data_2020.latint,data');
    % contourf(data_2020.lonint,data_2020.latint,data',[-25,-20,-15,-10,-5,0,5,10,15,20],'ShowText','on');
    [C,h] = contourf(data_2020.lonint,data_2020.latint,data',...
        [-40,-35,-30,-25,-20,-15,-10,-5,0,5,10,15,20,25,30,35,40]);
    v = [-40,-35,-30,-25,-20,-15,-10,-5,0,5,10,15,20,25,30,35,40];
    clabel(C,h,v,'FontSize',12,'FontName','Times','Color','black');
    % hold on;
    % ss = shaperead("boundary.shp");
    % mapshow(ss);
    hold on;
    file = "/Users/yulong/GitHub/OceanMesh2D/datasets/C23-06_TOKYOBAY.shp";
    s = shaperead(file);
    mapshow(s);
    % Uncomment the following line to preserve the X-limits of the axes
    xlim(axes1,[139.3 140.3]);
    % Uncomment the following line to preserve the Y-limits of the axes
    ylim(axes1,[34.85 35.75]);
    % Create ylabel
    ylabel('Latitude (degree)');
    % Create xlabel
    xlabel('Longtitude (degree)');
    % Create title
    % title([DateString, ': ', 'water ',NAME_ITEM, ' of ', NAME_LOCATION, ' ', item]);
    box(axes1,'on');

    print(gcf,['Results/change/seasonal_layers/',...
        'change_seasonal_',month{m},'_layer',num2str(layer),'.png'],'-dpng','-r600');
    savefig(['Results/change/seasonal_layers/',...
        'change_seasonal_',month{m},'_layer',num2str(layer),'.fig']);
end
end
save('ncfile_TD_meiji_seasonal.mat','td_meiji_seasonal','-v7.3','-nocompression');
save('ncfile_TD_change_seasonal.mat','td_change_seasonal','-v7.3','-nocompression');
%% present annually layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,8,16];
month = {'spring1',...
    'summer1','autumn1','winter1','spring2',...
    'summer2','autumn2'};

load('ncfile_TD_present_seasonal.mat');
clear td_2020_annual;
for l = 1:3
    layer = layerlist(l);
for m = 1:4
    temp1 = td_2020_seasonal.(month{m+0})(:,:,l);
    temp2 = td_2020_seasonal.(month{m+1})(:,:,l);
    temp3 = td_2020_seasonal.(month{m+2})(:,:,l);
    temp4 = td_2020_seasonal.(month{m+3})(:,:,l);
    data_2020.lonint = (139.14:0.001:140.39)';
    data_2020.latint = (34.85:0.001:35.70)';
    data1 = filloutliers((temp1+temp2+temp3+temp4)/4,'nearest','mean');
    td_2020_annual.(month{m})(:,:,l) = data1;
    
    % Create figure
    figure1 = figure(1);
    clf
    % Create axes
    axes1 = axes('Parent',figure1);
    hold(axes1,'on');
    % image(data_2020.lonint,data_2020.latint,data');
    % contourf(data_2020.lonint,data_2020.latint,data',[-25,-20,-15,-10,-5,0,5,10,15,20],'ShowText','on');
    [C,h] = contourf(data_2020.lonint,data_2020.latint,data1',...
        [0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80]);
    v = [0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80];
    clabel(C,h,v,'FontSize',12,'FontName','Times','Color','black');
    % hold on;
    % ss = shaperead("boundary.shp");
    % mapshow(ss);
    hold on;
    file = "/Users/yulong/GitHub/OceanMesh2D/datasets/C23-06_TOKYOBAY.shp";
    s = shaperead(file);
    mapshow(s);
    % Uncomment the following line to preserve the X-limits of the axes
    xlim(axes1,[139.3 140.3]);
    % Uncomment the following line to preserve the Y-limits of the axes
    ylim(axes1,[34.85 35.75]);
    % Create ylabel
    ylabel('Latitude (degree)');
    % Create xlabel
    xlabel('Longtitude (degree)');
    % Create title
    % title([DateString, ': ', 'water ',NAME_ITEM, ' of ', NAME_LOCATION, ' ', item]);
    box(axes1,'on');

    print(gcf,['Results/present/annually_layers/',...
        'present_annually_',month{m},'_layer',num2str(layer),'.png'],'-dpng','-r600');
    savefig(['Results/present/annually_layers/',...
        'present_annually_',month{m},'_layer',num2str(layer),'.fig']);
end
end
save('ncfile_TD_present_annual.mat','td_2020_annual','-v7.3','-nocompression');

%% meiji annually layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,8,16];
month = {'spring1',...
    'summer1','autumn1','winter1','spring2',...
    'summer2','autumn2'};

% load('ncfile_TD_change_seasonal.mat');
load('ncfile_TD_meiji_seasonal.mat');
clear td_meiji_annual;
clear td_change_annual;
for l = 1:3
    layer = layerlist(l);
for m = 1:4
    temp1 = td_meiji_seasonal.(month{m+0})(:,:,l);
    temp2 = td_meiji_seasonal.(month{m+1})(:,:,l);
    temp3 = td_meiji_seasonal.(month{m+2})(:,:,l);
    temp4 = td_meiji_seasonal.(month{m+3})(:,:,l);
    data0 = filloutliers((temp1+temp2+temp3+temp4)/4,'nearest','mean');
%     td_meiji_annual.(month{m})(:,:,l) = data0;
    
%     temp1 = td_change_seasonal.(month{m+0})(:,:,l);
%     temp2 = td_change_seasonal.(month{m+1})(:,:,l);
%     temp3 = td_change_seasonal.(month{m+2})(:,:,l);
%     temp4 = td_change_seasonal.(month{m+3})(:,:,l);
%     data_2020.lonint = (139.14:0.001:140.39)';
%     data_2020.latint = (34.85:0.001:35.70)';
%     data = filloutliers((temp1+temp2+temp3+temp4)/4,'nearest','mean');
%     td_change_annual.(month{m})(:,:,l) = data;
    
    % Create figure
    figure1 = figure(1);
    clf
    % Create axes
    axes1 = axes('Parent',figure1);
    hold(axes1,'on');
    % image(data_2020.lonint,data_2020.latint,data');
    % contourf(data_2020.lonint,data_2020.latint,data',[-25,-20,-15,-10,-5,0,5,10,15,20],'ShowText','on');
    [C,h] = contourf(data_2020.lonint,data_2020.latint,data0',...
        [0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80]);
    v = [0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80];
    clabel(C,h,v,'FontSize',12,'FontName','Times','Color','black');
    % hold on;
    % ss = shaperead("boundary.shp");
    % mapshow(ss);
%     hold on;
%     file = "/Users/yulong/GitHub/OceanMesh2D/datasets/C23-06_TOKYOBAY.shp";
%     s = shaperead(file);
%     mapshow(s);
    % Uncomment the following line to preserve the X-limits of the axes
    xlim(axes1,[139.3 140.3]);
    % Uncomment the following line to preserve the Y-limits of the axes
    ylim(axes1,[34.85 35.75]);
    % Create ylabel
    ylabel('Latitude (degree)');
    % Create xlabel
    xlabel('Longtitude (degree)');
    % Create title
    % title([DateString, ': ', 'water ',NAME_ITEM, ' of ', NAME_LOCATION, ' ', item]);
    box(axes1,'on');

    print(gcf,['Results/meiji/annually_layers/',...
        'meiji_annually_',month{m},'_layer',num2str(layer),'.png'],'-dpng','-r600');
    savefig(['Results/meiji/annually_layers/',...
        'meiji_annually_',month{m},'_layer',num2str(layer),'.fig']);
end
end
%% present-meiji annually layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,8,16];
month = {'spring1',...
    'summer1','autumn1','winter1','spring2',...
    'summer2','autumn2'};

load('ncfile_TD_change_seasonal.mat');
load('ncfile_TD_meiji_seasonal.mat');
clear td_meiji_annual;
clear td_change_annual;
for l = 1:3
    layer = layerlist(l);
for m = 1:4
    temp1 = td_meiji_seasonal.(month{m+0})(:,:,l);
    temp2 = td_meiji_seasonal.(month{m+1})(:,:,l);
    temp3 = td_meiji_seasonal.(month{m+2})(:,:,l);
    temp4 = td_meiji_seasonal.(month{m+3})(:,:,l);
    data0 = filloutliers((temp1+temp2+temp3+temp4)/4,'nearest','mean');
    td_meiji_annual.(month{m})(:,:,l) = data0;
    
    temp1 = td_change_seasonal.(month{m+0})(:,:,l);
    temp2 = td_change_seasonal.(month{m+1})(:,:,l);
    temp3 = td_change_seasonal.(month{m+2})(:,:,l);
    temp4 = td_change_seasonal.(month{m+3})(:,:,l);
    data_2020.lonint = (139.14:0.001:140.39)';
    data_2020.latint = (34.85:0.001:35.70)';
    data = filloutliers((temp1+temp2+temp3+temp4)/4,'nearest','mean');
    td_change_annual.(month{m})(:,:,l) = data;
    
    % Create figure
    figure1 = figure(1);
    clf
    % Create axes
    axes1 = axes('Parent',figure1);
    hold(axes1,'on');
    % image(data_2020.lonint,data_2020.latint,data');
    % contourf(data_2020.lonint,data_2020.latint,data',[-25,-20,-15,-10,-5,0,5,10,15,20],'ShowText','on');
    [C,h] = contourf(data_2020.lonint,data_2020.latint,data',...
        [-40,-35,-30,-25,-20,-15,-10,-5,0,5,10,15,20,25,30,35,40]);
    v = [-40,-35,-30,-25,-20,-15,-10,-5,0,5,10,15,20,25,30,35,40];
    clabel(C,h,v,'FontSize',12,'FontName','Times','Color','black');
    % hold on;
    % ss = shaperead("boundary.shp");
    % mapshow(ss);
    hold on;
    file = "/Users/yulong/GitHub/OceanMesh2D/datasets/C23-06_TOKYOBAY.shp";
    s = shaperead(file);
    mapshow(s);
    % Uncomment the following line to preserve the X-limits of the axes
    xlim(axes1,[139.3 140.3]);
    % Uncomment the following line to preserve the Y-limits of the axes
    ylim(axes1,[34.85 35.75]);
    % Create ylabel
    ylabel('Latitude (degree)');
    % Create xlabel
    xlabel('Longtitude (degree)');
    % Create title
    % title([DateString, ': ', 'water ',NAME_ITEM, ' of ', NAME_LOCATION, ' ', item]);
    box(axes1,'on');

    print(gcf,['Results/change/annually_layers/',...
        'change_annually_',month{m},'_layer',num2str(layer),'.png'],'-dpng','-r600');
    savefig(['Results/change/annually_layers/',...
        'change_annually_',month{m},'_layer',num2str(layer),'.fig']);
end
end
save('ncfile_TD_meiji_annual.mat','td_meiji_annual','-v7.3','-nocompression');
save('ncfile_TD_change_annual.mat','td_change_annual','-v7.3','-nocompression');

%% calculate inner bay values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inner bay
file = "./shp_files/boundary_innerbay.shp";
s = shaperead(file);
mapshow(s);
innerbay.x = [s.X];
innerbay.y = [s.Y];
% [X_p,Y_p] = meshgrid(td_2020.lon,td_2020.lat);
% [in_p,~] = inpolygon(X_p,Y_p,innerbay.x,innerbay.y);
[in_p,~] = inpolygon(td_2020.lon,td_2020.lat,innerbay.x,innerbay.y);
% [X_m,Y_m] = meshgrid(td_meiji.lon,td_meiji.lat);
% [in_m,~] = inpolygon(X_m,Y_m,innerbay.x,innerbay.y);
[in_m,~] = inpolygon(td_meiji.lon,td_meiji.lat,innerbay.x,innerbay.y);
[X_interp,Y_interp] = meshgrid(data_2020.lonint,data_2020.latint);
[in_interp,~] = inpolygon(X_interp,Y_interp,innerbay.x,innerbay.y);
% make a figure
% figure;
% plot(innerbay.x,innerbay.y);
% axis equal;
% hold on;
% plot(X_interp(in_interp),Y_interp(in_interp),'r+');
% hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% monthly value
% monthly value, 6 month ahead discard
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
month = {'age14_01','age14_02','age14_03','age14_04','age14_05','age14_06',...
    'age14_07','age14_08','age14_09','age14_10','age14_11','age14_12',...
    'age15_01','age15_02','age15_03','age15_04','age15_05','age15_06',...
    'age15_07','age15_08','age15_09','age15_10','age15_11','age15_12'};
for l = 1:length(layerlist)
    layer = layerlist(l);
for m = 1:length(month)
    data1 = double(td_2020.(month{m})(:,layer));
    data2 = double(td_meiji.(month{m})(:,layer));
    % plot(td_2020.lon(in_p),td_2020.lat(in_p),'r+');
    mean_age_present.(month{m})(1,layer) = mean(data1(in_p),'omitnan');
    mean_age_meiji.(month{m})(1,layer) = mean(data2(in_m),'omitnan');
    mean_age_change.(month{m})(1,layer) = mean(data1(in_p)-mean(data2(in_m),'omitnan'),'omitnan');
end
end
save('mean_monthly_change.mat','mean_age_change','-v7.3','-nocompression');
save('mean_monthly_present.mat','mean_age_present','-v7.3','-nocompression');
save('mean_monthly_meiji.mat','mean_age_meiji','-v7.3','-nocompression');

%% calculate sanbanze values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sanbanze
file = "./shp_files/boundary_sanbanze.shp";
s = shaperead(file);
mapshow(s);
innerbay.x = [s.X];
innerbay.y = [s.Y];
% [X_p,Y_p] = meshgrid(td_2020.lon,td_2020.lat);
% [in_p,~] = inpolygon(X_p,Y_p,innerbay.x,innerbay.y);
[in_p,~] = inpolygon(td_2020.lon,td_2020.lat,innerbay.x,innerbay.y);
% [X_m,Y_m] = meshgrid(td_meiji.lon,td_meiji.lat);
% [in_m,~] = inpolygon(X_m,Y_m,innerbay.x,innerbay.y);
[in_m,~] = inpolygon(td_meiji.lon,td_meiji.lat,innerbay.x,innerbay.y);
[X_interp,Y_interp] = meshgrid(data_2020.lonint,data_2020.latint);
[in_interp,~] = inpolygon(X_interp,Y_interp,innerbay.x,innerbay.y);
% make a figure
% figure;
% plot(innerbay.x,innerbay.y);
% axis equal;
% hold on;
% plot(X_interp(in_interp),Y_interp(in_interp),'r+');
% hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% monthly value
% monthly value, 6 month ahead discard
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
month = {'age14_01','age14_02','age14_03','age14_04','age14_05','age14_06',...
    'age14_07','age14_08','age14_09','age14_10','age14_11','age14_12',...
    'age15_01','age15_02','age15_03','age15_04','age15_05','age15_06',...
    'age15_07','age15_08','age15_09','age15_10','age15_11','age15_12'};
for l = 1:length(layerlist)
    layer = layerlist(l);
for m = 1:length(month)
    data1 = double(td_2020.(month{m})(:,layer));
    data2 = double(td_meiji.(month{m})(:,layer));
    % plot(td_2020.lon(in_p),td_2020.lat(in_p),'r+');
    mean_age_present_san.(month{m})(1,layer) = mean(data1(in_p),'omitnan');
    mean_age_meiji_san.(month{m})(1,layer) = mean(data2(in_m),'omitnan');
    mean_age_change_san.(month{m})(1,layer) = mean(data1(in_p)-mean(data2(in_m),'omitnan'),'omitnan');
end
end
save('mean_monthly_change_san.mat','mean_age_change_san','-v7.3','-nocompression');
save('mean_monthly_present_san.mat','mean_age_present_san','-v7.3','-nocompression');
save('mean_monthly_meiji_san.mat','mean_age_meiji_san','-v7.3','-nocompression');

%% calculate sanbanze values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sanbanze
file = "./shp_files/boundary_banzu.shp";
s = shaperead(file);
mapshow(s);
innerbay.x = [s.X];
innerbay.y = [s.Y];
% [X_p,Y_p] = meshgrid(td_2020.lon,td_2020.lat);
% [in_p,~] = inpolygon(X_p,Y_p,innerbay.x,innerbay.y);
[in_p,~] = inpolygon(td_2020.lon,td_2020.lat,innerbay.x,innerbay.y);
% [X_m,Y_m] = meshgrid(td_meiji.lon,td_meiji.lat);
% [in_m,~] = inpolygon(X_m,Y_m,innerbay.x,innerbay.y);
[in_m,~] = inpolygon(td_meiji.lon,td_meiji.lat,innerbay.x,innerbay.y);
[X_interp,Y_interp] = meshgrid(data_2020.lonint,data_2020.latint);
[in_interp,~] = inpolygon(X_interp,Y_interp,innerbay.x,innerbay.y);
% make a figure
% figure;
% plot(innerbay.x,innerbay.y);
% axis equal;
% hold on;
% plot(X_interp(in_interp),Y_interp(in_interp),'r+');
% hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% monthly value
% monthly value, 6 month ahead discard
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
month = {'age14_01','age14_02','age14_03','age14_04','age14_05','age14_06',...
    'age14_07','age14_08','age14_09','age14_10','age14_11','age14_12',...
    'age15_01','age15_02','age15_03','age15_04','age15_05','age15_06',...
    'age15_07','age15_08','age15_09','age15_10','age15_11','age15_12'};
for l = 1:length(layerlist)
    layer = layerlist(l);
for m = 1:length(month)
    data1 = double(td_2020.(month{m})(:,layer));
    data2 = double(td_meiji.(month{m})(:,layer));
    % plot(td_2020.lon(in_p),td_2020.lat(in_p),'r+');
    mean_age_present_ban.(month{m})(1,layer) = mean(data1(in_p),'omitnan');
    mean_age_meiji_ban.(month{m})(1,layer) = mean(data2(in_m),'omitnan');
    mean_age_change_ban.(month{m})(1,layer) = mean(data1(in_p)-mean(data2(in_m),'omitnan'),'omitnan');
end
end
save('mean_monthly_change_ban.mat','mean_age_change_ban','-v7.3','-nocompression');
save('mean_monthly_present_ban.mat','mean_age_present_ban','-v7.3','-nocompression');
save('mean_monthly_meiji_ban.mat','mean_age_meiji_ban','-v7.3','-nocompression');

%% calculate futsu values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sanbanze
file = "./shp_files/boundary_futsu.shp";
s = shaperead(file);
mapshow(s);
innerbay.x = [s.X];
innerbay.y = [s.Y];
% [X_p,Y_p] = meshgrid(td_2020.lon,td_2020.lat);
% [in_p,~] = inpolygon(X_p,Y_p,innerbay.x,innerbay.y);
[in_p,~] = inpolygon(td_2020.lon,td_2020.lat,innerbay.x,innerbay.y);
% [X_m,Y_m] = meshgrid(td_meiji.lon,td_meiji.lat);
% [in_m,~] = inpolygon(X_m,Y_m,innerbay.x,innerbay.y);
[in_m,~] = inpolygon(td_meiji.lon,td_meiji.lat,innerbay.x,innerbay.y);
[X_interp,Y_interp] = meshgrid(data_2020.lonint,data_2020.latint);
[in_interp,~] = inpolygon(X_interp,Y_interp,innerbay.x,innerbay.y);
% make a figure
% figure;
% plot(innerbay.x,innerbay.y);
% axis equal;
% hold on;
% plot(X_interp(in_interp),Y_interp(in_interp),'r+');
% hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% monthly value
% monthly value, 6 month ahead discard
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
month = {'age14_01','age14_02','age14_03','age14_04','age14_05','age14_06',...
    'age14_07','age14_08','age14_09','age14_10','age14_11','age14_12',...
    'age15_01','age15_02','age15_03','age15_04','age15_05','age15_06',...
    'age15_07','age15_08','age15_09','age15_10','age15_11','age15_12'};
for l = 1:length(layerlist)
    layer = layerlist(l);
for m = 1:length(month)
    data1 = double(td_2020.(month{m})(:,layer));
    data2 = double(td_meiji.(month{m})(:,layer));
    % plot(td_2020.lon(in_p),td_2020.lat(in_p),'r+');
    mean_age_present_fut.(month{m})(1,layer) = mean(data1(in_p),'omitnan');
    mean_age_meiji_fut.(month{m})(1,layer) = mean(data2(in_m),'omitnan');
    mean_age_change_fut.(month{m})(1,layer) = mean(data1(in_p)-mean(data2(in_m),'omitnan'),'omitnan');
end
end
save('mean_monthly_change_fut.mat','mean_age_change_fut','-v7.3','-nocompression');
save('mean_monthly_present_fut.mat','mean_age_present_fut','-v7.3','-nocompression');
save('mean_monthly_meiji_fut.mat','mean_age_meiji_fut','-v7.3','-nocompression');
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Present monthly water age of layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,8,16];
month = {'age14_01','age14_02','age14_03','age14_04','age14_05','age14_06',...
    'age14_07','age14_08','age14_09','age14_10','age14_11','age14_12',...
    'age15_01','age15_02','age15_03','age15_04','age15_05','age15_06',...
    'age15_07','age15_08','age15_09','age15_10','age15_11','age15_12'};
plot_monthly_age_present = zeros(18,3);
for i = 7:length(month)
    for j = 1:3
        plot_monthly_age_present(i-6,j) = ...
            mean_age_present.(month{i})(1,layerlist(j));
    end
end
plotMonthlyAge(plot_monthly_age_present);
% saveas(gcf,'result.png');
print(gcf,['Results/present/',...
    'monthly_age_present.png'],'-dpng','-r600');
savefig(['Results/present/',...
    'monthly_age_present.fig']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Meiji monthly water age of layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,8,16];
month = {'age14_01','age14_02','age14_03','age14_04','age14_05','age14_06',...
    'age14_07','age14_08','age14_09','age14_10','age14_11','age14_12',...
    'age15_01','age15_02','age15_03','age15_04','age15_05','age15_06',...
    'age15_07','age15_08','age15_09','age15_10','age15_11','age15_12'};
plot_monthly_age_meiji = zeros(18,3);
for i = 7:length(month)
    for j = 1:3
        plot_monthly_age_meiji(i-6,j) = ...
            mean_age_meiji.(month{i})(1,layerlist(j));
    end
end
plotMonthlyAge(plot_monthly_age_meiji);
% saveas(gcf,'result.png');
print(gcf,['Results/meiji/',...
    'monthly_age_meiji.png'],'-dpng','-r600');
savefig(['Results/meiji/',...
    'monthly_age_meiji.fig']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Present seasonal water age of layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,8,16];
gr.spring1 = {'age14_03','age14_04','age14_05'};
gr.summer1 = {'age14_06','age14_07','age14_08'};%%
gr.autumn1 = {'age14_09','age14_10','age14_11'};%%
gr.winter1 = {'age14_12','age15_01','age15_02'};%%
gr.spring2 = {'age15_03','age15_04','age15_05'};%%
gr.summer2 = {'age15_06','age15_07','age15_08'};%%
gr.autumn2 = {'age15_09','age15_10','age15_11'};%%
month = {'spring1',...
    'summer1','autumn1','winter1','spring2',...
    'summer2','autumn2'};
plot_seasonal_age_present = zeros(5,3);
for i = 3:length(month)
    for j = 1:3
        plot_seasonal_age_present(i-2,j) = ...
           (mean_age_present.(gr.(month{i}){1})(1,layerlist(j)) + ...
            mean_age_present.(gr.(month{i}){2})(1,layerlist(j)) + ...
            mean_age_present.(gr.(month{i}){3})(1,layerlist(j)))/3;
    end
end
plotSeasonalAge(plot_seasonal_age_present);
% saveas(gcf,'result.png');
print(gcf,['Results/present/',...
    'seasonal_age_present.png'],'-dpng','-r600');
savefig(['Results/present/',...
    'seasonal_age_present.fig']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Present - Meiji monthly water age of layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,8,16];
month = {'age14_01','age14_02','age14_03','age14_04','age14_05','age14_06',...
    'age14_07','age14_08','age14_09','age14_10','age14_11','age14_12',...
    'age15_01','age15_02','age15_03','age15_04','age15_05','age15_06',...
    'age15_07','age15_08','age15_09','age15_10','age15_11','age15_12'};
plot_monthly_age_change = zeros(18,3);
for i = 7:length(month)
    for j = 1:3
        plot_monthly_age_change(i-6,j) = ...
            mean_age_change.(month{i})(1,layerlist(j));
    end
end
plotMonthlyAge(plot_monthly_age_change);
% saveas(gcf,'result.png');
print(gcf,['Results/change/',...
    'monthly_age_change.png'],'-dpng','-r600');
savefig(['Results/change/',...
    'monthly_age_change.fig']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Present - Meiji seasonal water age of layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,8,16];
gr.spring1 = {'age14_03','age14_04','age14_05'};
gr.summer1 = {'age14_06','age14_07','age14_08'};%%
gr.autumn1 = {'age14_09','age14_10','age14_11'};%%
gr.winter1 = {'age14_12','age15_01','age15_02'};%%
gr.spring2 = {'age15_03','age15_04','age15_05'};%%
gr.summer2 = {'age15_06','age15_07','age15_08'};%%
gr.autumn2 = {'age15_09','age15_10','age15_11'};%%
month = {'spring1',...
    'summer1','autumn1','winter1','spring2',...
    'summer2','autumn2'};
plot_seasonal_age_change = zeros(5,3);
for i = 3:length(month)
    for j = 1:3
        plot_seasonal_age_change(i-2,j) = ...
           (mean_age_change.(gr.(month{i}){1})(1,layerlist(j)) + ...
            mean_age_change.(gr.(month{i}){2})(1,layerlist(j)) + ...
            mean_age_change.(gr.(month{i}){3})(1,layerlist(j)))/3;
    end
end
plotSeasonalAge(plot_seasonal_age_change);
hold on;
ylim([0 30]);
hold off;
% saveas(gcf,'result.png');
print(gcf,['Results/change/',...
    'seasonal_age_change.png'],'-dpng','-r600');
savefig(['Results/change/',...
    'seasonal_age_change.fig']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Present - Meiji monthly water age of layers at Sanbanze
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,8,16];
month = {'age14_01','age14_02','age14_03','age14_04','age14_05','age14_06',...
    'age14_07','age14_08','age14_09','age14_10','age14_11','age14_12',...
    'age15_01','age15_02','age15_03','age15_04','age15_05','age15_06',...
    'age15_07','age15_08','age15_09','age15_10','age15_11','age15_12'};
plot_monthly_age_change_san = zeros(18,3);
for i = 7:length(month)
    for j = 1:3
        plot_monthly_age_change_san(i-6,j) = ...
            mean_age_change_san.(month{i})(1,layerlist(j));
    end
end
plotMonthlyAge(plot_monthly_age_change_san);
hold on;
ylim([-15 30]);
hold off;
% saveas(gcf,'result.png');
print(gcf,['Results/change/',...
    'monthly_age_change_san.png'],'-dpng','-r600');
savefig(['Results/change/',...
    'monthly_age_change_san.fig']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Present - Meiji monthly water age of layers at banzu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,8,16];
month = {'age14_01','age14_02','age14_03','age14_04','age14_05','age14_06',...
    'age14_07','age14_08','age14_09','age14_10','age14_11','age14_12',...
    'age15_01','age15_02','age15_03','age15_04','age15_05','age15_06',...
    'age15_07','age15_08','age15_09','age15_10','age15_11','age15_12'};
plot_monthly_age_change_ban = zeros(18,3);
for i = 7:length(month)
    for j = 1:3
        plot_monthly_age_change_ban(i-6,j) = ...
            mean_age_change_ban.(month{i})(1,layerlist(j));
    end
end
plotMonthlyAge(plot_monthly_age_change_ban);
hold on;
ylim([-15 30]);
hold off;
% saveas(gcf,'result.png');
print(gcf,['Results/change/',...
    'monthly_age_change_ban.png'],'-dpng','-r600');
savefig(['Results/change/',...
    'monthly_age_change_ban.fig']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Present - Meiji monthly water age of layers at futsu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,8,16];
month = {'age14_01','age14_02','age14_03','age14_04','age14_05','age14_06',...
    'age14_07','age14_08','age14_09','age14_10','age14_11','age14_12',...
    'age15_01','age15_02','age15_03','age15_04','age15_05','age15_06',...
    'age15_07','age15_08','age15_09','age15_10','age15_11','age15_12'};
plot_monthly_age_change_fut = zeros(18,3);
for i = 7:length(month)
    for j = 1:3
        plot_monthly_age_change_fut(i-6,j) = ...
            mean_age_change_fut.(month{i})(1,layerlist(j));
    end
end
plotMonthlyAge(plot_monthly_age_change_fut);
hold on;
ylim([-15 30]);
hold off;
% saveas(gcf,'result.png');
print(gcf,['Results/change/',...
    'monthly_age_change_fut.png'],'-dpng','-r600');
savefig(['Results/change/',...
    'monthly_age_change_fut.fig']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Present - Meiji monthly water age of layers all compare
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,8,16];
month = {'age14_01','age14_02','age14_03','age14_04','age14_05','age14_06',...
    'age14_07','age14_08','age14_09','age14_10','age14_11','age14_12',...
    'age15_01','age15_02','age15_03','age15_04','age15_05','age15_06',...
    'age15_07','age15_08','age15_09','age15_10','age15_11','age15_12'};
plot_monthly_age_change_all = zeros(18,4);
plot_monthly_age_change_all(:,1) = plot_monthly_age_change(:,3);
plot_monthly_age_change_all(:,2) = plot_monthly_age_change_san(:,3);
plot_monthly_age_change_all(:,3) = plot_monthly_age_change_ban(:,3);
plot_monthly_age_change_all(:,4) = plot_monthly_age_change_fut(:,3);
plotTidalFlatsAge(plot_monthly_age_change_all);
% saveas(gcf,'result.png');
print(gcf,['Results/change/',...
    'monthly_age_change_all.png'],'-dpng','-r600');
savefig(['Results/change/',...
    'monthly_age_change_all.fig']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Present - Meiji seasonal water age of layers all compare
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot_seasonal_age_change_all = zeros(5,4);
for i = 1:4
    for j = 1:5
        plot_seasonal_age_change_all(j,i) = ...
           (plot_monthly_age_change_all(j*3+0,i) + ...
            plot_monthly_age_change_all(j*3+1,i) + ...
            plot_monthly_age_change_all(j*3+2,i))/3;
    end
end
plotTidalFlatsAge1(plot_seasonal_age_change_all);
hold on;
ylim([-15 30]);
hold off;
% saveas(gcf,'result.png');
print(gcf,['Results/change/',...
    'seasonal_age_change_all.png'],'-dpng','-r600');
savefig(['Results/change/',...
    'seasonal_age_change_all.fig']);