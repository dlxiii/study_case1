% present observation data

clear all;
clearvars; clc;

DO_sur = load("/Volumes/Yulong/GitHub/database_tokyobay/公共用水域水質測定データ/2014-2015_merged_tokyobay_export_DO_surface.mat");
DO_bot = load("/Volumes/Yulong/GitHub/database_tokyobay/公共用水域水質測定データ/2014-2015_merged_tokyobay_export_DO_bottom.mat");
DO_mix = load("/Volumes/Yulong/GitHub/database_tokyobay/公共用水域水質測定データ/2014-2015_merged_tokyobay_export_DO_mixed.mat");

DO_sur = DO_sur.mergedtokyobayexportDOsurface;
DO_bot = DO_bot.mergedtokyobayexportDObottom;
DO_mix = DO_mix.mergedtokyobayexportDOmixed;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find we have which days data
date_bot = unique(DO_bot.DATE);
date_sur = unique(DO_sur.DATE);
date_mix = unique(DO_mix.DATE);

% discard the date early than 2014-07-01
log_bot = date_bot >= datetime(mjuliandate(2014,07,01), ...
    'ConvertFrom', 'modifiedjuliandate', 'Format', 'yyyy-MM-dd');
log_sur = date_sur >= datetime(mjuliandate(2014,07,01), ...
    'ConvertFrom', 'modifiedjuliandate', 'Format', 'yyyy-MM-dd');
log_mix = date_mix >= datetime(mjuliandate(2014,07,01), ...
    'ConvertFrom', 'modifiedjuliandate', 'Format', 'yyyy-MM-dd');
date_bot = date_bot(log_bot);
date_sur = date_sur(log_sur);
date_mix = date_mix(log_mix);
clear log*

% discard the date late than 2014-07-01
log_bot = date_bot < datetime(mjuliandate(2016,01,01), ...
    'ConvertFrom', 'modifiedjuliandate', 'Format', 'yyyy-MM-dd');
log_sur = date_sur < datetime(mjuliandate(2016,01,01), ...
    'ConvertFrom', 'modifiedjuliandate', 'Format', 'yyyy-MM-dd');
log_mix = date_mix < datetime(mjuliandate(2016,01,01), ...
    'ConvertFrom', 'modifiedjuliandate', 'Format', 'yyyy-MM-dd');
date_bot = date_bot(log_bot);
date_sur = date_sur(log_sur);
date_mix = date_mix(log_mix);
clear log*

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now we know 136 days data is collected we can extract them
DO_bot_new = DO_bot(...
    DO_bot.DATE >= datetime(mjuliandate(2014,07,01), ...
    'ConvertFrom', 'modifiedjuliandate', 'Format', 'yyyy-MM-dd') &...
    DO_bot.DATE  < datetime(mjuliandate(2016,01,01), ...
    'ConvertFrom', 'modifiedjuliandate', 'Format', 'yyyy-MM-dd'),:);
DO_sur_new = DO_sur(...
    DO_sur.DATE >= datetime(mjuliandate(2014,07,01), ...
    'ConvertFrom', 'modifiedjuliandate', 'Format', 'yyyy-MM-dd') &...
    DO_sur.DATE  < datetime(mjuliandate(2016,01,01), ...
    'ConvertFrom', 'modifiedjuliandate', 'Format', 'yyyy-MM-dd'),:);
DO_mix_new = DO_mix(...
    DO_mix.DATE >= datetime(mjuliandate(2014,07,01), ...
    'ConvertFrom', 'modifiedjuliandate', 'Format', 'yyyy-MM-dd') &...
    DO_mix.DATE  < datetime(mjuliandate(2016,01,01), ...
    'ConvertFrom', 'modifiedjuliandate', 'Format', 'yyyy-MM-dd'),:);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now we know 1385, 1377 and 27 data avaiable, locate where are they
% station_bot = unique(DO_bot_new.id_station);
% station_sur = unique(DO_sur_new.id_station);
% station_mix = unique(DO_mix_new.id_station);
% station_uni = union(station_bot,station_sur);
% station_uni = union(station_uni,station_mix);
% 
% for i = 1:length(station_bot)
%     lonlat_bot = table2array(DO_bot_new(~cellfun(@isempty, strfind(DO_bot_new.id_station,station_bot(i))),9:10));
% end
% for i = 1:length(station_sur)
%     lonlat_sur = table2array(DO_sur_new(~cellfun(@isempty, strfind(DO_sur_new.id_station,station_sur(i))),9:10));
% end
% for i = 1:length(station_mix)
%     lonlat_mix = table2array(DO_mix_new(~cellfun(@isempty, strfind(DO_mix_new.id_station,station_mix(i))),9:10));
% end
% 
% for i = 1:length(station_uni)
%     lonlat_bot = table2array(DO_bot_new(~cellfun(@isempty, strfind(DO_bot_new.id_station,station_uni(i))),9:10));
%     lonlat_sur = table2array(DO_sur_new(~cellfun(@isempty, strfind(DO_sur_new.id_station,station_uni(i))),9:10));
%     lonlat_mix = table2array(DO_mix_new(~cellfun(@isempty, strfind(DO_mix_new.id_station,station_uni(i))),9:10));
% end
lonlat_bot = [DO_bot_new.id_stati_1,DO_bot_new.id_stati_2];
[ulonlat_bot,ia_bot,ic_bot] = unique(lonlat_bot(:,1:2),'rows');
lonlat_sur = [DO_sur_new.id_stati_1,DO_sur_new.id_stati_2];
[ulonlat_sur,ia_sur,ic_sur] = unique(lonlat_sur(:,1:2),'rows');
save('DO_station_bot.mat','ulonlat_bot','-v7.3','-nocompression');
save('DO_station_sur.mat','ulonlat_sur','-v7.3','-nocompression');
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% extract data from the present case result
load("/Volumes/Yulong/GitHub/paper_case/low_resolution_2020/run/mScripts/ncfile.mat");
age_bot = [];
for i = 1:length(date_bot)
    tt = find(ncfile.time == mjuliandate(date_bot(i)));
    age_bot(:,i) = ncfile.age(:,16,tt);
end
age_sur = [];
for i = 1:length(date_sur)
    tt = find(ncfile.time == mjuliandate(date_sur(i)));
    age_sur(:,i) = ncfile.age(:,1,tt);
end
save('DO_age_bot.mat','age_bot','-v7.3','-nocompression');
save('DO_age_sur.mat','age_sur','-v7.3','-nocompression');
save('DO_bot.mat','DO_bot_new','-v7.3','-nocompression');
save('DO_sur.mat','DO_sur_new','-v7.3','-nocompression');
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data extracted by time, location are prepared, extract point data from
% simulation
% 1st interpolate to ulonlat
for i = 1:size(age_bot,2)
    age_data = filloutliers(age_bot(:,i),'nearest','mean');
    age_bot_intp = scatteredInterpolant(...
        ncfile.lon,...
        ncfile.lat,...
        age_data,...
        'natural');
    DO_bot_sim(:,i) = age_bot_intp([ulonlat_bot(:,2),ulonlat_bot(:,1)]);
end
for i = 1:size(age_sur,2)
    age_data = filloutliers(age_sur(:,i),'nearest','mean');
    age_sur_intp = scatteredInterpolant(...
        ncfile.lon,...
        ncfile.lat,...
        age_data,...
        'natural');
    DO_sur_sim(:,i) = age_sur_intp([ulonlat_sur(:,2),ulonlat_sur(:,1)]);
end

DO_bot_sim = DO_bot_sim';
DO_sur_sim = DO_sur_sim';

% for i = 1:length(ia_bot)
% %     i                           % No column of DO_bot_sim
% %     ia_bot(i)                   % No row in DO_bot_new
% %     DO_bot_new.DATE(ia_bot(i))  % Value of the datetime
% %     find(date_bot == DO_bot_new.DATE(ia_bot(i))); % No row of the datetime in date_bot
%     DO_bot = DO_bot_sim(find(date_bot == DO_bot_new.DATE(ia_bot(i))),i);
% end

clear DO_bot_new2 DO_sur_new2
for i = 1:length(DO_bot_new.TIME)
    % i: the row No index in DO_bot_new
    % ic_bot(i): row No index in ulonlat_bot
    % find(date_bot == DO_bot_new.DATE(i)): 
    DO_bot_new2(i,1) = DO_bot_sim(find(date_bot == DO_bot_new.DATE(i)),ic_bot(i));
end
for i = 1:length(DO_sur_new.TIME)
    DO_sur_new2(i,1) = DO_sur_sim(find(date_sur == DO_sur_new.DATE(i)),ic_sur(i));
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Comp_bot = table(...
    DO_bot_new.TIME,...
    DO_bot_new.DATE,...
    DO_bot_new.DO_2,...
    DO_bot_new2,...
    DO_bot_new.DO_3,...
    DO_bot_new.id_station,...
    DO_bot_new.id_stati_1,...
    DO_bot_new.id_stati_2);
Comp_bot.Properties.VariableNames = {'TIME';'DATE';'DO_obs';'AGE_sim';...
    'DO_flag';...
    'STATION';'Lat';'Lon'};
Comp_sur = table(...
    DO_sur_new.TIME,...
    DO_sur_new.DATE,...
    DO_sur_new.DO_2,...
    DO_sur_new2,...
    DO_sur_new.DO_3,...
    DO_sur_new.id_station,...
    DO_sur_new.id_stati_1,...
    DO_sur_new.id_stati_2);
Comp_sur.Properties.VariableNames = {'TIME';'DATE';'DO_obs';'AGE_sim';...
    'DO_flag';...
    'STATION';'Lat';'Lon'};

X1 = bot_spr(:,2);
Y1 = bot_spr(:,1);
S1 = 20;
C1 = [0 1 0];
X2 = bot_sum(:,2);
Y2 = bot_sum(:,1);
C2 = [1 0.600000023841858 0.7843137383461];
X3 = bot_aut(:,2);
Y3 = bot_aut(:,1);
C3 = [0.749019622802734 0.749019622802734 0];
X4 = bot_win(:,2);
Y4 = bot_win(:,1);
C4 = [0.678431391716003 0.921568632125854 1];
X5 = [-58:160];
Y5 = 0.0495*X5+2.8607;

PlotAgeDO(X1, Y1, S1, C1, ...
    X2, Y2, C2, ...
    X3, Y3, C3, ...
    X4, Y4, C4, ...
    X5, Y5);
% saveas(gcf,'result.png');
print(gcf,['Results/present/',...
    'Age_DO.png'],'-dpng','-r600');
savefig(['Results/present/',...
    'Age_DO.fig']);
% scatter(bot_spr(:,2),bot_spr(:,1),'c');
% hold on;
% scatter(bot_sum(:,2),bot_sum(:,1),'r');
% hold on;
% scatter(bot_aut(:,2),bot_aut(:,1),'g');
% hold on;
% scatter(bot_win(:,2),bot_win(:,1),'k');
% hold on;
% x = [0:160];
% plot(x,0.0495*x+2.8607);
% xlim([0,180]);
% ylim([0,14]);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
name = {...
    '20140701';...
    %2014,07,08,2014,07,08;...
    '20140715';...
    %2014,07,22,2014,07,24;...
    %2014,07,28,2014,07,29;...
    '20140808';...
    '20140819';...
    '20140825';...
    '20140901';...
    '20140909';...
    '20140916';...
    %2014,09,23,2014,09,24;...
    '20141001';...
    %2014,10,08,2014,10,08;...
    '20141020';...
    %2014,10,27,2014,10,28;...
    '20141106';...
    %2014,11,25,2014,11,25;...
    '20141209';...
    '20141219';...
    '20150507';...
    '20150518';...
    '20150526';...
    '20150601';...
    %2015,06,15,2015,06,16;...
    %2015,06,23,2015,06,24;...
    %2015,06,29,2015,06,30;...
    '20150706';...
    '20150721';...
    %2015,07,28,2015,07,28;...
    '20150803';...
    %2015,08,11,2015,08,12;...
    '20150820';...
    %2015,08,25,2015,08,25;...
    '20150901';...
    %2015,09,10,2015,09,10;...
    '20150915';...
    %2015,09,24,2015,09,24;...
    '20150929';...
    %2015,10,05,2015,10,05;...
    %2015,10,13,2015,10,13;...
    %2015,10,19,2015,10,19;...
    %2015,10,27,2015,10,27;...
    '20151104';...
    '20151116';...
    %2015,11,30,2015,11,30;...
    %2015,12,07,2015,12,07;...
    };
rows = [...
    1,59;...%2014,07,01,2014,07,02;...
    %2014,07,08,2014,07,08;...
    75,93;...%2014,07,15,2014,07,15;...
    %2014,07,22,2014,07,24;...
    %2014,07,28,2014,07,29;...
    106,116;...%2014,08,08,2014,08,08;...
    132,149;...%2014,08,19,2014,08,19;...
    170,173;...%2014,08,25,2014,08,26;...
    174,183;...%2014,09,01,2014,09,01;...
    227,238;...%2014,09,09,2014,09,10;...
    239,245;...%2014,09,16,2014,09,17;...
    %2014,09,23,2014,09,24;...
    246,279;...%2014,10,01,2014,10,01;...
    %2014,10,08,2014,10,08;...
    313,316;...%2014,10,20,2014,10,20;...
    %2014,10,27,2014,10,28;...
    357,361;...%2014,11,06,2014,11,08;...
    %2014,11,25,2014,11,25;...
    425,453;...%2014,12,09,2014,12,10;...
    454,458;...%2014,12,19,2014,12,19;...
    778,785;...%2015,05,07,2015,05,08;...
    820,824;...%2015,05,18,2015,05,20;...
    838,847;...%2015,05,26,2015,05,26;...
    848,874;...%2015,06,01,2015,06,02;...
    %2015,06,15,2015,06,16;...
    %2015,06,23,2015,06,24;...
    %2015,06,29,2015,06,30;...
    947,954;...%2015,07,06,2015,07,06;...
    986,1001;...%2015,07,21,2015,07,22;...
    %2015,07,28,2015,07,28;...
    1021,1065;...%2015,08,03,2015,08,05;...
    %2015,08,11,2015,08,12;...
    1080,1085;...%2015,08,20,2015,08,20;...
    %2015,08,25,2015,08,25;...
    1092,1114;...%2015,09,01,2015,09,02;...
    %2015,09,10,2015,09,10;...
    1140,1150;...%2015,09,15,2015,09,15;...
    %2015,09,24,2015,09,24;...
    1157,1163;...%2015,09,29,2015,09,29;...
    %2015,10,05,2015,10,05;...
    %2015,10,13,2015,10,13;...
    %2015,10,19,2015,10,19;...
    %2015,10,27,2015,10,27;...
    1235,1246;...%2015,11,04,2015,11,04;...
    1302,1306;...%2015,11,16,2015,11,16;...
    %2015,11,30,2015,11,30;...
    %2015,12,07,2015,12,07;...
    ];
for i = 1:length(name)
    data = scatteredInterpolant(...
        Comp_bot.Lon(rows(i,1):rows(i,2)),...
        Comp_bot.Lat(rows(i,1):rows(i,2)),...
        Comp_bot.DO_obs(rows(i,1):rows(i,2)),...
        'natural');
    lonint = (139.14:0.001:140.39)';
    latint = (34.85:0.001:35.70)';
    DOvint = data({lonint,latint});

    % Create figure
    figure1 = figure(1);
    clf
    % Create axes
    axes1 = axes('Parent',figure1);
    hold(axes1,'on');
    [C,h] = contourf(...
        lonint,...
        latint,...
        DOvint',...
        [0,1,2,3,4,5,6,7,8,9,10,11,12]);
    v = [0,1,2,3,4,5,6,7,8,9,10,11,12];
    clabel(C,h,v,'FontSize',12,'FontName','Times','Color','black');
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

    print(gcf,['./Results/present/Age_DO/',...
        'DO_',name{i},'.png'],'-dpng','-r600');
    savefig(['./Results/present/Age_DO/',...
        'DO_',name{i},'.fig']);

    data = scatteredInterpolant(...
        Comp_bot.Lon(rows(i,1):rows(i,2)),...
        Comp_bot.Lat(rows(i,1):rows(i,2)),...
        Comp_bot.AGE_sim(rows(i,1):rows(i,2)),...
        'natural');
    lonint = (139.14:0.001:140.39)';
    latint = (34.85:0.001:35.70)';
    DOvint = data({lonint,latint});
end

%%
% scatter(Comp_bot.AGE_sim(1:59),Comp_bot.DO_obs(1:59),'k');
% hold on;
% scatter(Comp_bot.AGE_sim(246:279),Comp_bot.DO_obs(246:279),'r');
% hold on;
% scatter(Comp_bot.AGE_sim(848:874),Comp_bot.DO_obs(848:874),'b');
% hold on;
% x1 = [10:100];
% x2 = [10:100];
% x3 = [10:100];
% plot(x1,-0.0469*x1+5.3614,'k');
% hold on;
% plot(x2,-0.0443*x2+6.5455,'r');
% hold on;
% plot(x2,-0.0338*x3+8.0090,'b');
% hold off;
% xlim([0,110]);
% ylim([0,14]);
X1 = Comp_bot.AGE_sim(1:59);
Y1 = Comp_bot.DO_obs(1:59);
S1 = 20;
C1 = [0 1 0];
X2 = Comp_bot.AGE_sim(246:279);
Y2 = Comp_bot.DO_obs(246:279);
C2 = [1 0.600000023841858 0.7843137383461];
X3 = Comp_bot.AGE_sim(848:874);
Y3 = Comp_bot.DO_obs(848:874);
C3 = [0.749019622802734 0.749019622802734 0];
X4 = [10,100];
YMatrix1 = [-0.0469*X4+5.3614;-0.0443*X4+6.5455;-0.0338*X4+8.009];
plotAgeDo2(X1, Y1, S1, C1, X2, Y2, C2, X3, Y3, C3, X4, YMatrix1);
% saveas(gcf,'result.png');
print(gcf,['Results/present/',...
    'Age_DO2.png'],'-dpng','-r600');
savefig(['Results/present/',...
    'Age_DO2.fig']);