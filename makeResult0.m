% annual average layer water age of 2020 and meiji
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

% tda_2020 = load("ncfile_TDA_2020.mat");
% tda_2020 = tda_2020.TDA;
tda_2020 = load("/Volumes/Yulong/GitHub/paper_case/low_resolution_2020/run/mScripts/ncfile_TD.mat");
tda_2020 = tda_2020.TD;
% tda_meji = load("ncfile_TDA_meiji.mat");
% tda_meji = tda_meji.TDA;
tda_meiji = load("/Volumes/Yulong/GitHub/paper_case/low_resolution_meiji/run/mScripts/ncfile_TD.mat");
tda_meiji = tda_meiji.TD;
%%
layer = 16;

% data1 = double(tda_2020.age00(:,layer));
% data1 = filloutliers(data1,'nearest','mean');
% data_2020.intp = scatteredInterpolant(...
%     tda_2020.lon,...
%     tda_2020.lat,...
%     data1,...
%     'natural');
% data_2020.lonint = (139.14:0.001:140.39)';
% data_2020.latint = (34.85:0.001:35.70)';
% data_2020.ageint = data_2020.intp({data_2020.lonint,data_2020.latint});

data2 = double(tda_meji.age00(:,layer));
data2 = filloutliers(data2,'nearest','mean');
data_meji.intp = scatteredInterpolant(...
    tda_meji.lon,...
    tda_meji.lat,...
    data2,...
    'natural');
data_meji.lonint = (139.14:0.001:140.39)';
data_meji.latint = (34.85:0.001:35.70)';
data_meji.ageint = data_meji.intp({data_meji.lonint,data_meji.latint});

% data = data_2020.ageint;% - data_meji.ageint;
data = data_meji.ageint;
data = filloutliers(data,'nearest','mean');

%%
% Create figure
figure1 = figure(1);
clf
% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');
% image(data_2020.lonint,data_2020.latint,data');
% contourf(data_2020.lonint,data_2020.latint,data',[-20,-15,-10,-5,0,5,10,15,20],'ShowText','on');
% [C,h] = contourf(data_2020.lonint,data_2020.latint,data',[0,5,10,15,20,25,30,35,40,45,50,55,60]);
[C,h] = contourf(data_meji.lonint,data_meji.latint,data',[0,5,10,15,20,25,30,35,40,45,50,55,60]);
v = [0,5,10,15,20,25,30,35,40,45,50,55,60];
clabel(C,h,v,'FontSize',12,'FontName','Times','Color','black');
% hold on;
% ss = shaperead("boundary.shp");
% mapshow(ss);
% hold on;
% file = "/Users/yulong/GitHub/OceanMesh2D/datasets/C23-06_TOKYOBAY.shp";
% file = "/Users/yulong/GitHub/OceanMesh2D/datasets/C23-06_TOKYOBAY_1886.shp";
% s = shaperead(file);
% mapshow(s);
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

%%
% saveas(gcf,'result.png');
print(gcf,'result_layer_meiji_20.png','-dpng','-r600');
savefig('result_layer_meiji_20.fig');

%%
