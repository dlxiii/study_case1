clear all;
clearvars; clc;

% delete('diary')
% diary on;
% Which system am I using?
if ismac        % On Mac
    basedir = '/Users/yulong/GitHub/';
    addpath([basedir,'fvcomtoolbox/custom/']);
    addpath([basedir,'fvcomtoolbox/utilities/']);
    addpath([basedir,'fvcomtoolbox/fvcom_prepro/']);
    addpath([basedir,'tide/scr/']);
    addpath([basedir,'water/data/monitoring_post/case_2014_2017/layers/']);
elseif isunix	% Unix?
    basedir = '/home/usr0/n70110d/';
    addpath([basedir,'github/fvcomtoolbox/custom/']);
    addpath([basedir,'github/fvcomtoolbox/utilities/']);
    addpath([basedir,'github/fvcomtoolbox/fvcom_prepro/']);
elseif ispc     % Or Windows?
    basedir = 'C:/Users/Yulong WANG/Documents/GitHub/';      
    addpath([basedir,'fvcom-toolbox/custom/']);
    addpath([basedir,'fvcom-toolbox/utilities/']);
    addpath([basedir,'fvcom-toolbox/fvcom_prepro/']);
end

%%%------------------------------------------------------------------------
%%%                          INPUT CONFIGURATION
%%%------------------------------------------------------------------------

ncfile.name = '../../otp/tokyobay_station_timeseries.nc';
% ncfile.name = '/Users/yulong/Desktop/tokyobay_station_timeseries.nc';
fprintf(['NC file at:',ncfile.name,'\n']);
% ncfile.info = ncdisp(ncfile.name);

matfile = '../../inp/varb/Mobj_02.mat';
load(matfile);
fprintf(['mat file at:',matfile,'\n']);

% outputFiles.base = [basedir,'works/hsi_case/test_tide_small_mesh/'];
tideObserve.base = [basedir,'/water/data/monitoring_post/case_2014_2017/layers/'];

% tideObserve.stationName = {...
%     'MA15','tokyo';...
%     'HD06','chiba';...
%     'HD29','yokohamashinko';...
%     '3002','dainikaiho';...
%     '0161','kurihamako';...
%     };

%% 
%%%------------------------------------------------------------------------
%%%                          READ NC STATION FILE
%%%------------------------------------------------------------------------

% tideObserve.readYear = '2014';
% tideObserve.readMonth = '07';
plotdata.startDate = [2014,03,31,12,00,00];
plotdata.endDate = [2015,03,31,12,00,00];
plotdata.startDateMJD = greg2mjulian(plotdata.startDate(1),...
    plotdata.startDate(2),plotdata.startDate(3),plotdata.startDate(4),...
    plotdata.startDate(5),plotdata.startDate(6));
plotdata.endDateMJD = greg2mjulian(plotdata.endDate(1),...
    plotdata.endDate(2),plotdata.endDate(3),plotdata.endDate(4),...
    plotdata.endDate(5),plotdata.endDate(6));
% list.month = {'01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12'};
% list.day1 = {'31';'28';'31';'30';'31';'30';'31';'31';'30';'31';'30';'31'};
% list.day2 = {'31';'29';'31';'30';'31';'30';'31';'31';'30';'31';'30';'31'};

% ncdisp tokyobay_station_timeseries.nc
day = 30+31+30+31+31+30+31+30+31+31+28+31+30+31+30+31+31+30+31+30+31;%31+31+30+31+30+31;%31+28+31+30+31+30+31+31+30+31+30+31;%31+31+30+31+30+31;
start = (31+28+31)*24+1-12;%1;%(31+28+31+30+31+30)*24+1;
extent = (day)*24+1;
sim.salt = ncread(ncfile.name,'salinity',[1, 1, start],[Inf, Inf, extent]);
sim.temp = ncread(ncfile.name,'temp',[1, 1, start],[Inf, Inf, extent]);
sim.time = ncread(ncfile.name,'time',[start],[extent]);
sim.atem = ncread(ncfile.name,'MET_air_temp',[1, start],[Inf, extent]);
sim.datetime = plotdata.startDateMJD:1/24:plotdata.endDateMJD;
sim.datetime = sim.datetime';
sim.TimeDT_backup = datetime(sim.datetime, 'ConvertFrom', 'modifiedjuliandate', 'Format', 'yyyy-MM-dd hh:mm:ss');
sim.TimeDT = datetime(sim.time, 'ConvertFrom', 'modifiedjuliandate', 'Format', 'yyyy-MM-dd hh:mm:ss');

%% 
%%%------------------------------------------------------------------------
%%%                          READ OBSERVATION DATA
%%%------------------------------------------------------------------------

tlayers = {'a01','a02','a03','a04','a05','a06','a07','a08','a09','a10','a11','a12','a13'};
nlayers = {'01','02','03','04','05','06','07','08','09','10','11','12','13'};
for i = 1:length(tlayers)
    water.(tlayers{i}) = csv_reader(['water_',nlayers{i},'.csv']);
end

%% 
%%%------------------------------------------------------------------------
%%%                       ASSIMILITE OBSERVATION DATA
%%%------------------------------------------------------------------------
figure1 = figure(1);
axes1 = axes('Parent',figure1);
hold(axes1,'on');
clear X1 Y1 XX1 YY1
CM = autumn(20);
for i = 1:20
  X = sim.TimeDT;
  Y = squeeze(sim.temp(2,i,:));
  plot(X, movmean(double(Y),6),'.','color',CM(i,:));
  hold on;
end
hold off;
xlim([X(1), X(end)]);
ylim(axes1,[10 35]);
ylabel({'Water temperature (deg)'});
hold on;
CM = winter(20);
for i = 1:20
  X = sim.TimeDT;
  Y = squeeze(sim.salt(2,i,:));
  yyaxis right
  plot(X, movmean(double(Y),6),'.','color',CM(i,:));
  hold on;
end
hold off;
xlim([X(1), X(end)]);
ylim(axes1,[10 35]);
ylabel({'Water salinity (psu)'});
xlabel({'Time'});
box(axes1,'on');
set(axes1,'FontSize',14,'FontName','Times New Roman');

figure2 = figure(2);
axes2 = axes('Parent',figure2);
hold(axes2,'on');
CM = winter(13);
for i = 1:13
    XX1 = water.(tlayers{i}).DATETIME;
    XX1 = datetime(XX1-678942, 'ConvertFrom', 'modifiedjuliandate', 'Format', 'yyyy-MM-dd hh:mm:ss');
    YY1 = water.(tlayers{i}).SALpsu;
    plot(XX1, YY1,'.','color',CM(i,:));
    hold on;
end
hold off;
xlim([X(1), X(end)]);
ylim(axes2,[10 35]);
ylabel({'Water temperature (deg)'});
hold on;
CM = autumn(13);
for i = 1:13
    XX1 = water.(tlayers{i}).DATETIME;
    XX1 = datetime(XX1-678942, 'ConvertFrom', 'modifiedjuliandate', 'Format', 'yyyy-MM-dd hh:mm:ss');
    YY1 = water.(tlayers{i}).TEMPdeg;
    yyaxis right
    plot(XX1, YY1,'.','color',CM(i,:));
    hold on;
end
hold off;
hold off;
xlim([X(1), X(end)]);
ylim(axes2,[10 35]);
ylabel({'Water salinity (psu)'});
xlabel({'Time'});
box(axes2,'on');
set(axes2,'FontSize',14,'FontName','Times New Roman');


%%
data = [];
for i = 1:13
    DT1 = water.(tlayers{i}).DATETIME-678942;
    DT2 = sim.datetime;
    DT = intersect(DT1,DT2);
    temp_temp = squeeze(sim.temp(2,floor(i/13*20),:));
    temp_salt = squeeze(sim.salt(2,floor(i/13*20),:));
    for ii = 1:length(DT)
        data.(tlayers{i}).DT = DT;
        data.(tlayers{i}).T(ii,1) = water.(tlayers{i}).TEMPdeg(water.(tlayers{i}).DATETIME-678942==DT(ii));
        data.(tlayers{i}).S(ii,1) = water.(tlayers{i}).SALpsu(water.(tlayers{i}).DATETIME-678942==DT(ii));
        data.(tlayers{i}).T(ii,2) = temp_temp(sim.datetime==DT(ii));
        data.(tlayers{i}).S(ii,2) = temp_salt(sim.datetime==DT(ii));
    end
end

figure3 = figure(3);
axes3 = axes('Parent',figure3);
hold(axes3,'on');
for i = 1:13
    scatter(data.(tlayers{i}).T(:,1),data.(tlayers{i}).T(:,2),'.');
    hold on;
end
xlim(axes3,[10 30]);
ylim(axes3,[10 30]);

%%
skill = [];
for i = 1:13
    MSE(i,1) = mean((data.(tlayers{i}).T(:,1)-data.(tlayers{i}).T(:,2)).^2);
    skill.T.RMSE(i,1) = sqrt(MSE(i,1));
    skill.T.NMSE(i,1) = MSE(i,1)/mean((data.(tlayers{i}).T(:,2)-0).^2);
    skill.T.BIAS(i,1) = mean(data.(tlayers{i}).T(:,1))-mean(data.(tlayers{i}).T(:,2));
    [skill.T.R2(i,1),~] = rsquare(data.(tlayers{i}).T(:,1),data.(tlayers{i}).T(:,2));
end
clear MSE
for i = 1:13
    MSE(i,1) = mean((data.(tlayers{i}).S(:,1)-data.(tlayers{i}).S(:,2)).^2);
    skill.S.RMSE(i,1) = sqrt(MSE(i,1));
    skill.S.NMSE(i,1) = MSE(i,1)/mean((data.(tlayers{i}).S(:,2)-0).^2);
    skill.S.BIAS(i,1) = mean(data.(tlayers{i}).S(:,1))-mean(data.(tlayers{i}).S(:,2));
    [skill.S.R2(i,1),~] = rsquare(data.(tlayers{i}).S(:,1),data.(tlayers{i}).S(:,2));
end
clear MSE
data.full.T = [];
data.full.S = [];
for i = 1:13
    data.full.T = [data.full.T; data.(tlayers{i}).T];
    data.full.S = [data.full.S; data.(tlayers{i}).S];
end

MSE(i,1) = mean((data.full.T(:,1)-data.full.T(:,2)).^2);
skill.T.RMSE(14,1) = sqrt(MSE(i,1));
skill.T.NMSE(14,1) = MSE(i,1)/mean((data.full.T(:,2)-0).^2);
skill.T.BIAS(14,1) = mean(data.full.T(:,1))-mean(data.full.T(:,2));
[skill.T.R2(14,1),~] = rsquare(data.full.T(:,1),data.full.T(:,2));

MSE(i,1) = mean((data.full.S(:,1)-data.full.S(:,2)).^2);
skill.S.RMSE(14,1) = sqrt(MSE(i,1));
skill.S.NMSE(14,1) = MSE(i,1)/mean((data.full.S(:,2)-0).^2);
skill.S.BIAS(14,1) = mean(data.full.S(:,1))-mean(data.full.S(:,2));
[skill.S.R2(14,1),~] = rsquare(data.full.S(:,1),data.full.S(:,2));

%%
temp_DT1 = data.(tlayers{1}).DT;
temp_DT2 = data.(tlayers{1}).DT;
for i = 2:13
    temp_DT1 = intersect(temp_DT1,data.(tlayers{i}).DT);
    temp_DT2 = union(temp_DT2,data.(tlayers{i}).DT);
end

temp_mean_salt = [];
temp_mean_temp = [];
for i = 1:10
    for ii = 1:length(temp_DT2)
        temp_mean_temp(ii,i) = data.(tlayers{i}).T(data.(tlayers{i}).DT==temp_DT2(ii),1);
        temp_mean_salt(ii,i) = data.(tlayers{i}).S(data.(tlayers{i}).DT==temp_DT2(ii),1);
    end
end
temp_mean_temp = mean(temp_mean_temp,2);
temp_mean_salt = mean(temp_mean_salt,2);
mean.DT = datetime(temp_DT2, 'ConvertFrom', 'modifiedjuliandate', 'Format', 'yyyy-MM-dd hh:mm:ss');
mean.T = temp_mean_temp;
mean.S = temp_mean_salt;

figure1 = figure(1);
axes1 = axes('Parent',figure1);
hold(axes1,'on');
clear X1 Y1 XX1 YY1
CM = autumn(20);
for i = 1:20
  X = sim.TimeDT;
  Y = squeeze(sim.temp(2,i,:));
  plot(X, movmean(double(Y),6),'.','color',CM(i,:));
  hold on;
end
hold off;
xlim([X(1), X(end)]);
ylim(axes1,[10 35]);
ylabel({'Water temperature (deg)'});
hold on;
CM = winter(20);
for i = 1:20
  X = sim.TimeDT;
  Y = squeeze(sim.salt(2,i,:));
  yyaxis right
  plot(X, movmean(double(Y),6),'.','color',CM(i,:));
  hold on;
end
hold off;
xlim([X(1), X(end)]);
ylim(axes1,[10 35]);
ylabel({'Water salinity (psu)'});
xlabel({'Time'});
box(axes1,'on');
set(axes1,'FontSize',14,'FontName','Times New Roman');

hold on;
plot(mean.DT,mean.T,'-','color',[0.5, 0.5, 0.5],'LineWidth',3);
hold on;
plot(mean.DT,mean.S,'-','color',[0.5, 0.5, 0.5],'LineWidth',3);