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
fprintf(['NC file at:',ncfile.name,'\n']);
% ncfile.info = ncdisp(ncfile.name);

matfile = '../../inp/varb/Mobj_02.mat';
load(matfile);
fprintf(['mat file at:',matfile,'\n']);

% outputFiles.base = [basedir,'works/hsi_case/test_tide_small_mesh/'];
tideObserve.base = [basedir,'tide/data/tide_jdoss/'];

tideObserve.stationName = {...
    'MA15','tokyo';...
    'HD06','chiba';...
    'HD29','yokohamashinko';...
    '3002','dainikaiho';...
    '0161','kurihamako';...
    };

%% 
%%%------------------------------------------------------------------------
%%%                          READ NC STATION FILE
%%%------------------------------------------------------------------------

tideObserve.readYear = '2014';
% tideObserve.readMonth = '07';
% plotdata.startDate = [2014,07,01,00,00,00];
% plotdata.endDate = [2014,07,16,00,00,00];
% plotdata.startDateMJD = greg2mjulian(plotdata.startDate(1),...
%     plotdata.startDate(2),plotdata.startDate(3),plotdata.startDate(4),...
%     plotdata.startDate(5),plotdata.startDate(6));
% plotdata.endDateMJD = greg2mjulian(plotdata.endDate(1),...
%     plotdata.endDate(2),plotdata.endDate(3),plotdata.endDate(4),...
%     plotdata.endDate(5),plotdata.endDate(6));
% list.month = {'01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12'};
% list.day1 = {'31';'28';'31';'30';'31';'30';'31';'31';'30';'31';'30';'31'};
% list.day2 = {'31';'29';'31';'30';'31';'30';'31';'31';'30';'31';'30';'31'};

% ncdisp tokyobay_station_timeseries.nc
day = 31+31+30+31+30+15;
start = (31+28+31+30+31+30)*24+1;
extent = (day)*24+1;
sim.elevation = ncread(ncfile.name,'zeta',[1, start],[Inf, extent]);
sim.time = ncread(ncfile.name,'time',[start],[extent]);
%sim.datetime = plotdata.startDateMJD:1/24:plotdata.endDateMJD;
%sim.datetime = sim.datetime';
%sim.TimeDT = datetime(sim.datetime, 'ConvertFrom', 'modifiedjuliandate', 'Format', 'yyyy-MM-dd hh:mm:ss');
sim.TimeDT = datetime(sim.time, 'ConvertFrom', 'modifiedjuliandate', 'Format', 'yyyy-MM-dd hh:mm:ss');

%% 
%%%------------------------------------------------------------------------
%%%                          READ OBSERVATION DATA
%%%------------------------------------------------------------------------

for i=1:length(tideObserve.stationName)
    tideObserve.foldername{i,1} = [tideObserve.base,tideObserve.stationName{i,1},'_',tideObserve.stationName{i,2},'/'];
    % fprintf('%s\n',tideObserve.foldername{i,1});
    filename = [tideObserve.stationName{i,1},'-',tideObserve.readYear];
    tideObserve.filename{i,1} = [tideObserve.foldername{i,1},filename,'.txt'];
    % fprintf('%s\n',tideObserve.filename{i,1});
end
clear i j filename

tideObserve.data.tokyo          = importJdossTide(tideObserve.filename{1,1});
tideObserve.data.chiba          = importJdossTide(tideObserve.filename{2,1});
tideObserve.data.yokohamashinko = importJdossTide(tideObserve.filename{3,1});
tideObserve.data.dainikaiho     = importJdossTide(tideObserve.filename{4,1});
tideObserve.data.kurihamako     = importJdossTide(tideObserve.filename{5,1});

tideObserve.data.kurihamako     = tideObserve.data.kurihamako';
tideObserve.data.dainikaiho     = tideObserve.data.dainikaiho';
tideObserve.data.chiba          = tideObserve.data.chiba';
tideObserve.data.yokohamashinko = tideObserve.data.yokohamashinko';
tideObserve.data.tokyo          = tideObserve.data.tokyo';

tideObserve.data.kurihamako     = reshape(tideObserve.data.kurihamako,      (365)*24,1);
tideObserve.data.dainikaiho     = reshape(tideObserve.data.dainikaiho,      (365)*24,1);
tideObserve.data.chiba          = reshape(tideObserve.data.chiba,           (365)*24,1);
tideObserve.data.yokohamashinko = reshape(tideObserve.data.yokohamashinko,  (365)*24,1);
tideObserve.data.tokyo          = reshape(tideObserve.data.tokyo,           (365)*24,1);

%% 
%%%------------------------------------------------------------------------
%%%                       ASSIMILITE OBSERVATION DATA
%%%------------------------------------------------------------------------

tideObserve.stationChange.tokyo = {...
    '1961','01','01','-180.00';...
    '1968','01','01','-181.10';...
    '1978','01','01','-182.90';...
    '1982','04','01','-184.10';...
    '1988','01','01','-185.20';...
    '2011','03','11','-188.40'};
tideObserve.stationChange.chiba = {...
    '1964','07','01','-166.30';...
    '1987','01','01','-177.40'};
tideObserve.stationChange.yokohamashinko = {...
    '1997','09','01','-216.20';...
    '2009','01','01','-217.90'};
tideObserve.stationChange.dainikaiho = {...
    '2011','01','01','-108.40';...
    '2014','01','01','-103.20'};
tideObserve.stationChange.kurihamako = {...
    '2001','01','01','-182.40';...
    '2002','01','01','-186.70';...
    '2015','06','01','-193.50'};

tideObserve.log(5,1) = length(tideObserve.stationChange.kurihamako);
tideObserve.log(4,1) = length(tideObserve.stationChange.dainikaiho);
tideObserve.log(2,1) = length(tideObserve.stationChange.chiba);
tideObserve.log(3,1) = length(tideObserve.stationChange.yokohamashinko);
tideObserve.log(1,1) = length(tideObserve.stationChange.tokyo);

clear X1 YMatrix1
temp11 = mean(tideObserve.data.tokyo(start+9:start+extent-1+9)*0.01);
temp12 = mean(sim.elevation(1,:));
temp10 = temp11 - temp12; %1.9096
correct.tokyo = str2num(tideObserve.stationChange.tokyo{6,4});
% tideNew.tokyo = (tideObserve.data.tokyo(start+9:start+extent-1+9) + correct.tokyo)*0.0085;
tideNew.tokyo = (tideObserve.data.tokyo(start+9:start+extent-1+9) - 190.96)*0.01;
X1 = sim.TimeDT;
YMatrix1(1,:) = tideNew.tokyo';
YMatrix1(2,:) = sim.elevation(1,:);
createfigure(X1, YMatrix1, 'Tokyo');

clear X2 YMatrix2
temp21 = mean(tideObserve.data.chiba(start+9:start+extent-1+9)*0.01);
temp22 = mean(sim.elevation(2,:));
temp20 = temp21 - temp22; %1.8895
correct.chiba = str2num(tideObserve.stationChange.chiba{2,4})-5;
% tideNew.chiba = (tideObserve.data.chiba(start+9:start+extent-1+9) + correct.chiba)*0.0085;
tideNew.chiba = (tideObserve.data.chiba(start+9:start+extent-1+9) - 188.95)*0.01;
X2 = sim.TimeDT;
YMatrix2(1,:) = tideNew.chiba';
YMatrix2(2,:) = sim.elevation(2,:);
createfigure(X2, YMatrix2, 'Chiba');

clear X3 YMatrix3
temp31 = mean(tideObserve.data.yokohamashinko(start+9:start+extent-1+9)*0.01);
temp32 = mean(sim.elevation(3,:));
temp30 = temp31 - temp32; %2.2748
correct.yokohamashinko = str2num(tideObserve.stationChange.yokohamashinko{2,4})-5;
% tideNew.yokohamashinko = (tideObserve.data.yokohamashinko(start+9:start+extent-1+9) + correct.yokohamashinko)*0.009;
tideNew.yokohamashinko = (tideObserve.data.yokohamashinko(start+9:start+extent-1+9) - 227.48)*0.01;
X3 = sim.TimeDT;
YMatrix3(1,:) = tideNew.yokohamashinko';
YMatrix3(2,:) = sim.elevation(3,:);
createfigure(X3, YMatrix3, 'Yokohamashinko');

clear X4 YMatrix4
temp41 = mean(tideObserve.data.dainikaiho(start+9:start+extent-1+9)*0.01);
temp42 = mean(sim.elevation(4,:));
temp40 = temp41 - temp42; %1.1644
correct.dainikaiho = str2num(tideObserve.stationChange.dainikaiho{2,4})-6;
% tideNew.dainikaiho = (tideObserve.data.dainikaiho(start+9:start+extent-1+9) + correct.dainikaiho)*0.0085;
tideNew.dainikaiho = (tideObserve.data.dainikaiho(start+9:start+extent-1+9) - 116.44)*0.01;
X4 = sim.TimeDT;
YMatrix4(1,:) = tideNew.dainikaiho';
YMatrix4(2,:) = sim.elevation(4,:);
createfigure(X4, YMatrix4, 'Dainikaiho');

clear X5 YMatrix5
temp51 = mean(tideObserve.data.kurihamako(start+9:start+extent-1+9)*0.01);
temp52 = mean(sim.elevation(5,:));
temp50 = temp51 - temp52; %1.9389
correct.kurihamako = str2num(tideObserve.stationChange.kurihamako{2,4})-1;
% tideNew.kurihamako = (tideObserve.data.kurihamako(start+9:start+extent-1+9) + correct.kurihamako)*0.01;
tideNew.kurihamako = (tideObserve.data.kurihamako(start+9:start+extent-1+9) - 193.89)*0.01;
X5 = sim.TimeDT;
YMatrix5(1,:) = tideNew.kurihamako';
YMatrix5(2,:) = sim.elevation(5,:);
createfigure(X5, YMatrix5, 'Kurihamako');

clear temp*

%%

MSE1 = mean((YMatrix1(1,:)-YMatrix1(2,:)).^2);
MSE2 = mean((YMatrix2(1,:)-YMatrix2(2,:)).^2);
MSE3 = mean((YMatrix3(1,:)-YMatrix3(2,:)).^2);
MSE4 = mean((YMatrix4(1,:)-YMatrix4(2,:)).^2);
MSE5 = mean((YMatrix5(1,:)-YMatrix5(2,:)).^2);

RMSE1 = sqrt(MSE1);
RMSE2 = sqrt(MSE2);
RMSE3 = sqrt(MSE3);
RMSE4 = sqrt(MSE4);
RMSE5 = sqrt(MSE5);

NMSE1 = MSE1/mean((YMatrix1(1,:)-0).^2);
NMSE2 = MSE2/mean((YMatrix2(1,:)-0).^2);
NMSE3 = MSE3/mean((YMatrix3(1,:)-0).^2);
NMSE4 = MSE4/mean((YMatrix4(1,:)-0).^2);
NMSE5 = MSE5/mean((YMatrix5(1,:)-0).^2);

BIAS1 = mean(YMatrix1(1,:))-mean(YMatrix1(2,:));
BIAS2 = mean(YMatrix2(1,:))-mean(YMatrix2(2,:));
BIAS3 = mean(YMatrix3(1,:))-mean(YMatrix3(2,:));
BIAS4 = mean(YMatrix4(1,:))-mean(YMatrix4(2,:));
BIAS5 = mean(YMatrix5(1,:))-mean(YMatrix5(2,:));

[R21,~] = rsquare(YMatrix1(1,:),YMatrix1(2,:));
[R22,~] = rsquare(YMatrix2(1,:),YMatrix2(2,:));
[R23,~] = rsquare(YMatrix3(1,:),YMatrix3(2,:));
[R24,~] = rsquare(YMatrix4(1,:),YMatrix4(2,:));
[R25,~] = rsquare(YMatrix5(1,:),YMatrix5(2,:));

skill.ele.rmse = [RMSE1,RMSE2,RMSE3,RMSE4,RMSE5];
skill.ele.nmse = [NMSE1,NMSE2,NMSE3,NMSE4,NMSE5];
skill.ele.bias = [BIAS1,BIAS2,BIAS3,BIAS4,BIAS5];
skill.ele.code = [R21,R22,R23,R24,R25];

clear MSE* RMSE* NMS* BIAS* R2*