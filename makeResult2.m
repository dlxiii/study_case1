% cross sections of annually water age variability

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

matfile = '/Volumes/Yulong/GitHub/paper_case/low_resolution_2020/run/mScripts/mobj.mat';
Mobj1 = load(matfile);
Mobj1 = Mobj1.Mobj;
fprintf(['mat file at:',matfile,'\n']);
matfile = '/Volumes/Yulong/GitHub/paper_case/low_resolution_meiji/run/mScripts/mobj.mat';
Mobj2 = load(matfile);
Mobj2 = Mobj2.Mobj;
fprintf(['mat file at:',matfile,'\n']);

% k1 = find(ncfile.time == mjuliandate(2014,12,01));
% k2 = find(ncfile.time == mjuliandate(2015,11,30));

%% present annually sections
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,2,3,4,5,6,7,8,9,10,...
    11,12,13,14,15,16,17,18,19,20];
month = {...
    'age14_12',...
    'age15_01','age15_02','age15_03','age15_04','age15_05','age15_06',...
    'age15_07','age15_08','age15_09','age15_10','age15_11'};

data1 = zeros(size(double(td_2020.(month{1}))));
for m = 1:length(month)
    data1 = data1 + double(td_2020.(month{m}));
end
data1 = data1/length(month);

idx =[...
    7,23;24,36;37,43;44,61;...
    62,107;108,117;118,137;...
    ];
for ii = 1:length(idx)
    ra = [idx(ii,1):idx(ii,2)];
    crs_node_temp1 = [];
    for i = 1:length(ra)
        crs_node_temp1(i) = Mobj1.stations{1,ra(i)}{1,4};
        temp(i,:) = data1(crs_node_temp1(i),:);
        depth1(i,:) = Mobj1.h(crs_node_temp1(i))*td_2020.siglay(1,:);
        index_temp(i,:) = i * ones(1,length(td_2020.siglay(1,:)));
    end
    crs_node{1,ii} = crs_node_temp1';
    depth{1,ii} = depth1;
    data{ii} = temp;
    index{ii} = index_temp;
    clear crs_node_temp* ra i temp depth1 depth2 index_temp
end

for ii = 1:length(idx)
    ra = [idx(ii,1):idx(ii,2)];
    for i = 1:length(ra)
        tda.age00(crs_node{1,ii}(i),:) = data{1,ii}(i,:);
    end
end
tda.Times = '0000-00';

for ii = 1:length(idx)
    plot_nc_cross_TS(1+ii, Mobj1, tda, 1+1, crs_node{1,ii}, {'age00'});
    hold on;
    set(gca,'FontSize',16,'FontName','Times');
    set(gca,'xticklabel',[]);
    set(gca,'xtick',[])
%     [C,h] = contour(index{1,ii}+0.5,depth{1,ii},data{1,ii},[-5,0,5,10,15,20,25]);
%     v = [-5,0,5,10,15,20,25];
    [C,h] = contour(index{1,ii}+0.5,depth{1,ii},data{1,ii},...
        [0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80]);
    v = [0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80];
    clabel(C,h,v,'FontSize',16,'FontName','Times','Color','black');
    h.LineColor = 'black';
    h.LineWidth = 1.0;
    h.LineStyle = '-';
    
    print(gcf,['result_2020_crs_0',num2str(ii),'.png'],'-dpng','-r300');
    savefig(['result_2020_crs_0',num2str(ii),'.fig']);
    print(gcf,['Results/present/annually_sections/',...
        'present_annually_section',num2str(ii),'.png'],'-dpng','-r600');
    savefig(['Results/present/annually_sections/',...
        'present_annually_section',num2str(ii),'.fig']);
end

%% meiji annually sections
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,2,3,4,5,6,7,8,9,10,...
    11,12,13,14,15,16,17,18,19,20];
month = {...
    'age14_12',...
    'age15_01','age15_02','age15_03','age15_04','age15_05','age15_06',...
    'age15_07','age15_08','age15_09','age15_10','age15_11'};

data1 = zeros(size(double(td_2020.(month{1}))));
for m = 1:length(month)
    data1 = data1 + double(td_2020.(month{m}));
end
data1 = data1/length(month);

data2 = zeros(size(double(td_meiji.(month{1}))));
for m = 1:length(month)
    data2 = data2 + double(td_meiji.(month{m}));
end
data2 = data2/length(month);

idx =[...
    7,23;24,36;37,43;44,61;...
    62,107;108,117;118,137;...
    ];
for ii = 1:length(idx)
    ra = [idx(ii,1):idx(ii,2)];
    crs_node_temp1 = [];
    crs_node_temp2 = [];
    for i = 1:length(ra)
        crs_node_temp1(i) = Mobj1.stations{1,ra(i)}{1,4};
        crs_node_temp2(i) = Mobj2.stations{1,ra(i)}{1,4};
        temp(i,:) = data2(crs_node_temp2(i),:);
        depth1(i,:) = Mobj1.h(crs_node_temp1(i))*td_2020.siglay(1,:);
        depth2(i,:) = Mobj2.h(crs_node_temp2(i))*td_meiji.siglay(1,:);
        index_temp(i,:) = i * ones(1,length(td_2020.siglay(1,:)));
    end
    crs_node{1,ii} = crs_node_temp1';
    crs_node{2,ii} = crs_node_temp2';
    depth{1,ii} = depth1;
    depth{2,ii} = depth2;
    data{ii} = temp;
    index{ii} = index_temp;
    clear crs_node_temp* ra i temp depth1 depth2 index_temp
end

for ii = 1:length(idx)
    ra = [idx(ii,1):idx(ii,2)];
    for i = 1:length(ra)
        tda.age00(crs_node{2,ii}(i),:) = data{1,ii}(i,:);
    end
end
tda.Times = '0000-00';

for ii = 1:length(idx)
    plot_nc_cross_TS(1+ii, Mobj2, tda, 1+1, crs_node{2,ii}, {'age00'});
    hold on;
    set(gca,'FontSize',16,'FontName','Times');
    set(gca,'xticklabel',[]);
    set(gca,'xtick',[])
    [C,h] = contour(index{1,ii}+0.5,depth{2,ii},data{1,ii},...
        [-40,-35,-30,-25,-20,-15,-10,-5,0,5,10,15,20,25,30,35,40]);
    v = [-40,-35,-30,-25,-20,-15,-10,-5,0,5,10,15,20,25,30,35,40];
    clabel(C,h,v,'FontSize',16,'FontName','Times','Color','black');
    h.LineColor = 'black';
    h.LineWidth = 1.0;
    h.LineStyle = '-';
    
    print(gcf,['Results/meiji/annually_sections/',...
        'meiji_annually_section',num2str(ii),'.png'],'-dpng','-r600');
    savefig(['Results/meiji/annually_sections/',...
        'meiji_annually_section',num2str(ii),'.fig']);
end

%% present-meiji annually sections
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
layerlist = [1,2,3,4,5,6,7,8,9,10,...
    11,12,13,14,15,16,17,18,19,20];
month = {...
    'age14_12',...
    'age15_01','age15_02','age15_03','age15_04','age15_05','age15_06',...
    'age15_07','age15_08','age15_09','age15_10','age15_11'};

data1 = zeros(size(double(td_2020.(month{1}))));
for m = 1:length(month)
    data1 = data1 + double(td_2020.(month{m}));
end
data1 = data1/length(month);

data2 = zeros(size(double(td_meiji.(month{1}))));
for m = 1:length(month)
    data2 = data2 + double(td_meiji.(month{m}));
end
data2 = data2/length(month);

idx =[...
    7,23;24,36;37,43;44,61;...
    62,107;108,117;118,137;...
    ];
for ii = 1:length(idx)
    ra = [idx(ii,1):idx(ii,2)];
    crs_node_temp1 = [];
    crs_node_temp2 = [];
    for i = 1:length(ra)
        crs_node_temp1(i) = Mobj1.stations{1,ra(i)}{1,4};
        crs_node_temp2(i) = Mobj2.stations{1,ra(i)}{1,4};
        temp(i,:) = data1(crs_node_temp1(i),:) - ...
            data2(crs_node_temp2(i),:);
        depth1(i,:) = Mobj1.h(crs_node_temp1(i))*td_2020.siglay(1,:);
        depth2(i,:) = Mobj2.h(crs_node_temp2(i))*td_meiji.siglay(1,:);
        index_temp(i,:) = i * ones(1,length(td_2020.siglay(1,:)));
    end
    crs_node{1,ii} = crs_node_temp1';
    crs_node{2,ii} = crs_node_temp2';
    depth{1,ii} = depth1;
    depth{2,ii} = depth2;
    data{ii} = temp;
    index{ii} = index_temp;
    clear crs_node_temp* ra i temp depth1 depth2 index_temp
end

for ii = 1:length(idx)
    ra = [idx(ii,1):idx(ii,2)];
    for i = 1:length(ra)
        tda.age00(crs_node{1,ii}(i),:) = data{1,ii}(i,:);
    end
end
tda.Times = '0000-00';

for ii = 1:length(idx)
    plot_nc_cross_TS(1+ii, Mobj1, tda, 1+1, crs_node{1,ii}, {'age00'});
    hold on;
    set(gca,'FontSize',16,'FontName','Times');
    set(gca,'xticklabel',[]);
    set(gca,'xtick',[])
    [C,h] = contour(index{1,ii}+0.5,depth{1,ii},data{1,ii},...
        [-40,-35,-30,-25,-20,-15,-10,-5,0,5,10,15,20,25,30,35,40]);
    v = [-40,-35,-30,-25,-20,-15,-10,-5,0,5,10,15,20,25,30,35,40];
    clabel(C,h,v,'FontSize',16,'FontName','Times','Color','black');
    h.LineColor = 'black';
    h.LineWidth = 1.0;
    h.LineStyle = '-';
    
    print(gcf,['Results/change/annually_sections/',...
        'change_annually_section',num2str(ii),'.png'],'-dpng','-r600');
    savefig(['Results/change/annually_sections/',...
        'change_annually_section',num2str(ii),'.fig']);
end
