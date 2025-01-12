% === ver 2015/12/09   Copyright (c) 2015 Takashi NAKAMURA  =====

xlfile='C:\cygwin64\home\Takashi\ROMS\matlab\data\swat_data\SwatResult.xlsx';
SHEET_NAME = {'Todoroki'};
           
date_start = '2000/1/1';
LOCAL_TIME = 9; % hours: UTC+9 (JST) 

riv_D = [  0,   0 ];  % east<->west:0,  south<->north:1
riv_D2= [  1,   1 ];  % east->west or south-> north: 1,  west->east or north-> south:-1

% Yaeyama3 grid
NC_FILE = './output/shiraho_river_Nz8_10_15.nc';
xi_u = 63 ;
eta_v = 191 ;
s_rho = 8 ;
river = 2 ;
riv_X = [  4, 275, 276, 347 ];
riv_Y = [105, 233, 179, 186 ];

%% 

for i=1:river-1
     num = xlsread(xlfile,SHEET_NAME{i});
     flow(i,:)= num(:,2)*0.001; % L/s -> m3/s
     PO4(i,:) = num(:,3)/94.97*1000; % mg/L -> umol/L
     NO3(i,:) = num(:,4)/62.00*1000; % mg/L -> umol/L
     NH4(i,:) = num(:,5)/18.04*1000; % mg/L -> umol/L
     NO2(i,:) = num(:,6)/46.01*1000; % mg/L -> umol/L
end

river_time = size(flow(1,:),2) ;

% river_time
sta_date = datenum(date_start, 'yyyy/mm/dd');
riv_date = 1:river_time;
riv_date = (riv_date-1)*1/24 + datenum('2014/01/01', 'yyyy/mm/dd') - sta_date - LOCAL_TIME/24;

%% 
% ----- Create NetCDF river file ------------------------------------------
% river
nccreate(NC_FILE,'river',...
          'Dimensions',{'river',river},...
          'Datatype','double',...
          'Format','classic')
ncwriteatt(NC_FILE,'river','long_name','river runoff identification number');
% river_Xposition
nccreate(NC_FILE,'river_Xposition',...
          'Dimensions',{'river',river},...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_Xposition','long_name','river XI-position at RHO-points');
ncwriteatt(NC_FILE,'river_Xposition','valid_min',1);
ncwriteatt(NC_FILE,'river_Xposition','valid_max',xi_u);
% river_Eposition
nccreate(NC_FILE,'river_Eposition',...
          'Dimensions',{'river',river},...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_Eposition','long_name','river ETA-position at RHO-points');
ncwriteatt(NC_FILE,'river_Eposition','valid_min',1);
ncwriteatt(NC_FILE,'river_Eposition','valid_max',eta_v);
% river_direction
nccreate(NC_FILE,'river_direction',...
          'Dimensions',{'river',river},...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_direction','long_name','river runoff direction');
% river_Vshape
nccreate(NC_FILE,'river_Vshape',...
          'Dimensions',{'river',river, 's_rho',s_rho },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_Vshape','long_name','river runoff mass transport vertical profile');
% river_time
nccreate(NC_FILE,'river_time',...
          'Dimensions',{'river_time',river_time},...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_time','long_name','river runoff time');
ncwriteatt(NC_FILE,'river_time','units','days since 2000-01-01 00:00:00');  %%% �ύX�K�v!!!!!!!!!!!!!!!!!!!!!!!!!!!
% river_transport
nccreate(NC_FILE,'river_transport',...
          'Dimensions',{'river',river, 'river_time',river_time},...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_transport','long_name','river runoff vertically integrated mass transport');
ncwriteatt(NC_FILE,'river_transport','units','meter3 second-1');
ncwriteatt(NC_FILE,'river_transport','time','river_time');
% river_temp
nccreate(NC_FILE,'river_temp',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_temp','long_name','river runoff potential temperature');
ncwriteatt(NC_FILE,'river_temp','units','Celsius');
ncwriteatt(NC_FILE,'river_temp','time','river_time');
% river_salt
nccreate(NC_FILE,'river_salt',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_salt','long_name','river runoff salinity');
ncwriteatt(NC_FILE,'river_salt','time','river_time');
% river_mud_01
nccreate(NC_FILE,'river_mud_01',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_mud_01','long_name','iver runoff suspended sediment concentration');
ncwriteatt(NC_FILE,'river_mud_01','units','kilogram meter-3');
ncwriteatt(NC_FILE,'river_mud_01','time','river_time');
% river_TIC
nccreate(NC_FILE,'river_TIC',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_TIC','long_name','iver runoff TIC');
ncwriteatt(NC_FILE,'river_TIC','units','umol kg-1');
ncwriteatt(NC_FILE,'river_TIC','time','river_time');
% river_alkalinity
nccreate(NC_FILE,'river_alkalinity',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_alkalinity','long_name','river runoff alkalinity');
ncwriteatt(NC_FILE,'river_alkalinity','units','umol kg-1');
ncwriteatt(NC_FILE,'river_alkalinity','time','river_time');
% river_Oxyg
nccreate(NC_FILE,'river_Oxyg',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_Oxyg','long_name','river runoff oxygen');
ncwriteatt(NC_FILE,'river_Oxyg','units','umol L-1');
ncwriteatt(NC_FILE,'river_Oxyg','time','river_time');
% river_NO3
nccreate(NC_FILE,'river_NO3',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_NO3','long_name','river runoff NO3');
ncwriteatt(NC_FILE,'river_NO3','units','umol L-1');
ncwriteatt(NC_FILE,'river_NO3','time','river_time');
% river_NO2
nccreate(NC_FILE,'river_NO2',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_NO2','long_name','river runoff NO2');
ncwriteatt(NC_FILE,'river_NO2','units','umol L-1');
ncwriteatt(NC_FILE,'river_NO2','time','river_time');
% river_NH4
nccreate(NC_FILE,'river_NH4',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_NH4','long_name','river runoff NH4');
ncwriteatt(NC_FILE,'river_NH4','units','umol L-1');
ncwriteatt(NC_FILE,'river_NH4','time','river_time');
% river_PO4
nccreate(NC_FILE,'river_PO4',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_PO4','long_name','river runoff PO4');
ncwriteatt(NC_FILE,'river_PO4','units','umol L-1');
ncwriteatt(NC_FILE,'river_PO4','time','river_time');
% river_DOC
nccreate(NC_FILE,'river_DOC',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_DOC','long_name','river runoff DOC');
ncwriteatt(NC_FILE,'river_DOC','units','umol L-1');
ncwriteatt(NC_FILE,'river_DOC','time','river_time');
% river_DON
nccreate(NC_FILE,'river_DON',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_DON','long_name','river runoff DON');
ncwriteatt(NC_FILE,'river_DON','units','umol L-1');
ncwriteatt(NC_FILE,'river_DON','time','river_time');
% river_DOP
nccreate(NC_FILE,'river_DOP',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_DOP','long_name','river runoff DOP');
ncwriteatt(NC_FILE,'river_DOP','units','umol L-1');
ncwriteatt(NC_FILE,'river_DOP','time','river_time');
% river_POC
nccreate(NC_FILE,'river_POC',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_POC','long_name','river runoff POC');
ncwriteatt(NC_FILE,'river_POC','units','umol L-1');
ncwriteatt(NC_FILE,'river_POC','time','river_time');
% river_PON
nccreate(NC_FILE,'river_PON',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_PON','long_name','river runoff PON');
ncwriteatt(NC_FILE,'river_PON','units','umol L-1');
ncwriteatt(NC_FILE,'river_PON','time','river_time');
% river_POP
nccreate(NC_FILE,'river_POP',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_POP','long_name','river runoff POP');
ncwriteatt(NC_FILE,'river_POP','units','umol L-1');
ncwriteatt(NC_FILE,'river_POP','time','river_time');
% river_Phy1
nccreate(NC_FILE,'river_Phy1',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_Phy1','long_name','river runoff phytoplankton1');
ncwriteatt(NC_FILE,'river_Phy1','units','umolC L-1');
ncwriteatt(NC_FILE,'river_Phy1','time','river_time');
% river_Phy2
nccreate(NC_FILE,'river_Phy2',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_Phy2','long_name','river runoff phytoplankton2');
ncwriteatt(NC_FILE,'river_Phy2','units','umolC L-1');
ncwriteatt(NC_FILE,'river_Phy2','time','river_time');
% river_Zoop
nccreate(NC_FILE,'river_Zoop',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_Zoop','long_name','river runoff zooplankton');
ncwriteatt(NC_FILE,'river_Zoop','units','umolC L-1');
ncwriteatt(NC_FILE,'river_Zoop','time','river_time');
% river_d13C_TIC
nccreate(NC_FILE,'river_d13C_TIC',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_d13C_TIC','long_name','river runoff d13C in DIC');
ncwriteatt(NC_FILE,'river_d13C_TIC','units','permil VPDB');
ncwriteatt(NC_FILE,'river_d13C_TIC','time','river_time');
% river_d13C_DOC
nccreate(NC_FILE,'river_d13C_DOC',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_d13C_DOC','long_name','river runoff d13C in DOC');
ncwriteatt(NC_FILE,'river_d13C_DOC','units','permil VPDB');
ncwriteatt(NC_FILE,'river_d13C_DOC','time','river_time');
% river_d13C_POC
nccreate(NC_FILE,'river_d13C_POC',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_d13C_POC','long_name','river runoff d13C in POC');
ncwriteatt(NC_FILE,'river_d13C_POC','units','permil VPDB');
ncwriteatt(NC_FILE,'river_d13C_POC','time','river_time');
% river_d13C_Phy1
nccreate(NC_FILE,'river_d13C_Phy1',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_d13C_Phy1','long_name','river runoff d13C in phtoplankton1');
ncwriteatt(NC_FILE,'river_d13C_Phy1','units','permil VPDB');
ncwriteatt(NC_FILE,'river_d13C_Phy1','time','river_time');
% river_d13C_Phy2
nccreate(NC_FILE,'river_d13C_Phy2',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_d13C_Phy2','long_name','river runoff d13C in phtoplankton2');
ncwriteatt(NC_FILE,'river_d13C_Phy2','units','permil VPDB');
ncwriteatt(NC_FILE,'river_d13C_Phy2','time','river_time');
% river_d13C_Zoo
nccreate(NC_FILE,'river_d13C_Zoo',...
          'Dimensions',{'river',river, 's_rho',s_rho, 'river_time',river_time },...
          'Datatype','double')
ncwriteatt(NC_FILE,'river_d13C_Zoo','long_name','river runoff d13C in zooplankton');
ncwriteatt(NC_FILE,'river_d13C_Zoo','units','permil VPDB');
ncwriteatt(NC_FILE,'river_d13C_Zoo','time','river_time');
% global attributes
ncwriteatt(NC_FILE,'/','type','ROMS FORCING file');
ncwriteatt(NC_FILE,'/','title','YAEYAMA River Forcing');
ncwriteatt(NC_FILE,'/','grd_file','Yaeyama1_grd_v8.nc');
ncwriteatt(NC_FILE,'/','rivers','(1)Nakama river, (2) Nagura river, (3) Arakawa river, (4) Miyara river, (5) Todoroki river');

%% 
% ----- Add data to NetCDF river file ------------------------------------------
% river
ncwrite(NC_FILE,'river',1:river);
% river_Xposition
ncwrite(NC_FILE,'river_Xposition',riv_X);
% river_Eposition
ncwrite(NC_FILE,'river_Eposition',riv_Y);
% river_direction
ncwrite(NC_FILE,'river_direction',riv_D(1:river));
% river_Vshap
riv_V(1)=0;
for i=2:s_rho
    riv_V(i)=riv_V(i-1)+2/s_rho/(s_rho-1);
end
for i=1:river
    riv_Vshape(i,:) = riv_V;
end
ncwrite(NC_FILE,'river_Vshape',riv_Vshape);
% river_time
sta_date = datenum(date_start, 2000);
riv_date = datenum(riv(1).Date, 2000) - sta_date - LOCAL_TIME/24;
ncwrite(NC_FILE,'river_time',riv_date);
% river_transport
for i=1:river
    riv_flow(i,:) = riv(i).Flow*riv_D2(i);
end
ncwrite(NC_FILE,'river_transport',riv_flow);

% river_temp
riv_value( 1, 1:s_rho, 1:river_time ) = 25.0;
riv_value( 2, 1:s_rho, 1:river_time ) = 25.0;
riv_value( 3, 1:s_rho, 1:river_time ) = 25.0;
riv_value( 4, 1:s_rho, 1:river_time ) = 25.0;
riv_value( 5, 1:s_rho, 1:river_time ) = 25.0;
ncwrite(NC_FILE,'river_temp',riv_value(1:river, :, :));

% river_salt
riv_value( 1, 1:s_rho, 1:river_time ) = 3;
riv_value( 2, 1:s_rho, 1:river_time ) = 3;
riv_value( 3, 1:s_rho, 1:river_time ) = 3;
riv_value( 4, 1:s_rho, 1:river_time ) = 3;
riv_value( 5, 1:s_rho, 1:river_time ) = 3;
ncwrite(NC_FILE,'river_salt',riv_value(1:river, :, :));

% river_mud_01
riv_value( 1, 1:s_rho, 1:river_time ) = 0.05;
riv_value( 2, 1:s_rho, 1:river_time ) = 0.047;
riv_value( 3, 1:s_rho, 1:river_time ) = 0.05;
riv_value( 4, 1:s_rho, 1:river_time ) = 0.044;
riv_value( 5, 1:s_rho, 1:river_time ) = 0.036;
ncwrite(NC_FILE,'river_mud_01',riv_value(1:river, :, :));

% river_TIC
riv_value( 1, 1:s_rho, 1:river_time ) = 380;
riv_value( 2, 1:s_rho, 1:river_time ) = 1600;
riv_value( 3, 1:s_rho, 1:river_time ) = 1600;
riv_value( 4, 1:s_rho, 1:river_time ) = 2800;
riv_value( 5, 1:s_rho, 1:river_time ) = 1330;
ncwrite(NC_FILE,'river_TIC',riv_value(1:river, :, :));

% river_alkalinity
riv_value( 1, 1:s_rho, 1:river_time ) = 270;
riv_value( 2, 1:s_rho, 1:river_time ) = 1960;
riv_value( 3, 1:s_rho, 1:river_time ) = 1960;
riv_value( 4, 1:s_rho, 1:river_time ) = 2570;
riv_value( 5, 1:s_rho, 1:river_time ) = 1180;
ncwrite(NC_FILE,'river_alkalinity',riv_value(1:river, :, :));

% river_Oxyg
riv_value( 1, 1:s_rho, 1:river_time ) = 200;
riv_value( 2, 1:s_rho, 1:river_time ) = 200;
riv_value( 3, 1:s_rho, 1:river_time ) = 200;
riv_value( 4, 1:s_rho, 1:river_time ) = 200;
riv_value( 5, 1:s_rho, 1:river_time ) = 200;
ncwrite(NC_FILE,'river_Oxyg',riv_value(1:river, :, :));

% river_NO3
riv_value( 1, 1:s_rho, 1:river_time ) = 9.4;
riv_value( 2, 1:s_rho, 1:river_time ) = 19;
riv_value( 3, 1:s_rho, 1:river_time ) = 165;
riv_value( 4, 1:s_rho, 1:river_time ) = 37;
riv_value( 5, 1:s_rho, 1:river_time ) = 180;
ncwrite(NC_FILE,'river_NO3',riv_value(1:river, :, :));

% river_NO2
riv_value( 1, 1:s_rho, 1:river_time ) = 0.04;
riv_value( 2, 1:s_rho, 1:river_time ) = 0.2;
riv_value( 3, 1:s_rho, 1:river_time ) = 1.5;
riv_value( 4, 1:s_rho, 1:river_time ) = 0.8;
riv_value( 5, 1:s_rho, 1:river_time ) = 1;
ncwrite(NC_FILE,'river_NO2',riv_value(1:river, :, :));

% river_NH4
riv_value( 1, 1:s_rho, 1:river_time ) = 1;
riv_value( 2, 1:s_rho, 1:river_time ) = 1.6;
riv_value( 3, 1:s_rho, 1:river_time ) = 30;
riv_value( 4, 1:s_rho, 1:river_time ) = 2.5;
riv_value( 5, 1:s_rho, 1:river_time ) = 3;
ncwrite(NC_FILE,'river_NH4',riv_value(1:river, :, :));

% river_PO4
riv_value( 1, 1:s_rho, 1:river_time ) = 0.04;
riv_value( 2, 1:s_rho, 1:river_time ) = 0.3;
riv_value( 3, 1:s_rho, 1:river_time ) = 6;
riv_value( 4, 1:s_rho, 1:river_time ) = 0.2;
riv_value( 5, 1:s_rho, 1:river_time ) = 0.6;
ncwrite(NC_FILE,'river_PO4',riv_value(1:river, :, :));

% river_DOC
riv_value( 1, 1:s_rho, 1:river_time ) = 100;
riv_value( 2, 1:s_rho, 1:river_time ) = 156;
riv_value( 3, 1:s_rho, 1:river_time ) = 363;
riv_value( 4, 1:s_rho, 1:river_time ) = 135;
riv_value( 5, 1:s_rho, 1:river_time ) = 125;
ncwrite(NC_FILE,'river_DOC',riv_value(1:river, :, :));

% river_DON
riv_value( 1, 1:s_rho, 1:river_time ) = 10;
riv_value( 2, 1:s_rho, 1:river_time ) = 33;
riv_value( 3, 1:s_rho, 1:river_time ) = 21;
riv_value( 4, 1:s_rho, 1:river_time ) = 16;
riv_value( 5, 1:s_rho, 1:river_time ) = 14;
ncwrite(NC_FILE,'river_DON',riv_value(1:river, :, :));

% river_DOP
riv_value( 1, 1:s_rho, 1:river_time ) = 0.03;
riv_value( 2, 1:s_rho, 1:river_time ) = 0.03;
riv_value( 3, 1:s_rho, 1:river_time ) = 1.9;
riv_value( 4, 1:s_rho, 1:river_time ) = 0.1;
riv_value( 5, 1:s_rho, 1:river_time ) = 0.03;
ncwrite(NC_FILE,'river_DOP',riv_value(1:river, :, :));

% river_POC
riv_value( 1, 1:s_rho, 1:river_time ) = 0;
riv_value( 2, 1:s_rho, 1:river_time ) = 0;
riv_value( 3, 1:s_rho, 1:river_time ) = 0;
riv_value( 4, 1:s_rho, 1:river_time ) = 0;
riv_value( 5, 1:s_rho, 1:river_time ) = 0;
ncwrite(NC_FILE,'river_POC',riv_value(1:river, :, :));

% river_PON
riv_value( 1, 1:s_rho, 1:river_time ) = 0;
riv_value( 2, 1:s_rho, 1:river_time ) = 0;
riv_value( 3, 1:s_rho, 1:river_time ) = 0;
riv_value( 4, 1:s_rho, 1:river_time ) = 0;
riv_value( 5, 1:s_rho, 1:river_time ) = 0;
ncwrite(NC_FILE,'river_PON',riv_value(1:river, :, :));

% river_POP
riv_value( 1, 1:s_rho, 1:river_time ) = 0;
riv_value( 2, 1:s_rho, 1:river_time ) = 0;
riv_value( 3, 1:s_rho, 1:river_time ) = 0;
riv_value( 4, 1:s_rho, 1:river_time ) = 0;
riv_value( 5, 1:s_rho, 1:river_time ) = 0;
ncwrite(NC_FILE,'river_POP',riv_value(1:river, :, :));

% river_Phy1
riv_value( 1, 1:s_rho, 1:river_time ) = 0;
riv_value( 2, 1:s_rho, 1:river_time ) = 0;
riv_value( 3, 1:s_rho, 1:river_time ) = 0;
riv_value( 4, 1:s_rho, 1:river_time ) = 0;
riv_value( 5, 1:s_rho, 1:river_time ) = 0;
ncwrite(NC_FILE,'river_Phy1',riv_value(1:river, :, :));

% river_Phy2
riv_value( 1, 1:s_rho, 1:river_time ) = 0;
riv_value( 2, 1:s_rho, 1:river_time ) = 0;
riv_value( 3, 1:s_rho, 1:river_time ) = 0;
riv_value( 4, 1:s_rho, 1:river_time ) = 0;
riv_value( 5, 1:s_rho, 1:river_time ) = 0;
ncwrite(NC_FILE,'river_Phy2',riv_value(1:river, :, :));

% river_Zoop
riv_value( 1, 1:s_rho, 1:river_time ) = 0;
riv_value( 2, 1:s_rho, 1:river_time ) = 0;
riv_value( 3, 1:s_rho, 1:river_time ) = 0;
riv_value( 4, 1:s_rho, 1:river_time ) = 0;
riv_value( 5, 1:s_rho, 1:river_time ) = 0;
ncwrite(NC_FILE,'river_Zoop',riv_value(1:river, :, :));

% river_d13C_TIC
riv_value( 1, 1:s_rho, 1:river_time ) = -14.4;
riv_value( 2, 1:s_rho, 1:river_time ) = -8.4;
riv_value( 3, 1:s_rho, 1:river_time ) = -8.4;
riv_value( 4, 1:s_rho, 1:river_time ) = -8.4;
riv_value( 5, 1:s_rho, 1:river_time ) = -8.4;
ncwrite(NC_FILE,'river_d13C_TIC',riv_value(1:river, :, :));

% river_d13C_DOC
riv_value( 1, 1:s_rho, 1:river_time ) = -25;
riv_value( 2, 1:s_rho, 1:river_time ) = -25;
riv_value( 3, 1:s_rho, 1:river_time ) = -25;
riv_value( 4, 1:s_rho, 1:river_time ) = -25;
riv_value( 5, 1:s_rho, 1:river_time ) = -25;
ncwrite(NC_FILE,'river_d13C_DOC',riv_value(1:river, :, :));

% river_d13C_POC
riv_value( 1, 1:s_rho, 1:river_time ) = -25;
riv_value( 2, 1:s_rho, 1:river_time ) = -25;
riv_value( 3, 1:s_rho, 1:river_time ) = -25;
riv_value( 4, 1:s_rho, 1:river_time ) = -25;
riv_value( 5, 1:s_rho, 1:river_time ) = -25;
ncwrite(NC_FILE,'river_d13C_POC',riv_value(1:river, :, :));

% river_d13C_Phy1
riv_value( 1, 1:s_rho, 1:river_time ) = -25;
riv_value( 2, 1:s_rho, 1:river_time ) = -25;
riv_value( 3, 1:s_rho, 1:river_time ) = -25;
riv_value( 4, 1:s_rho, 1:river_time ) = -25;
riv_value( 5, 1:s_rho, 1:river_time ) = -25;
ncwrite(NC_FILE,'river_d13C_Phy1',riv_value(1:river, :, :));

% river_d13C_Phy2
riv_value( 1, 1:s_rho, 1:river_time ) = -25;
riv_value( 2, 1:s_rho, 1:river_time ) = -25;
riv_value( 3, 1:s_rho, 1:river_time ) = -25;
riv_value( 4, 1:s_rho, 1:river_time ) = -25;
riv_value( 5, 1:s_rho, 1:river_time ) = -25;
ncwrite(NC_FILE,'river_d13C_Phy2',riv_value(1:river, :, :));

% river_d13C_Zoo
riv_value( 1, 1:s_rho, 1:river_time ) = -25;
riv_value( 2, 1:s_rho, 1:river_time ) = -25;
riv_value( 3, 1:s_rho, 1:river_time ) = -25;
riv_value( 4, 1:s_rho, 1:river_time ) = -25;
riv_value( 5, 1:s_rho, 1:river_time ) = -25;
ncwrite(NC_FILE,'river_d13C_Zoo',riv_value(1:river, :, :));

%% 
% 
varData = ncread(NC_FILE,'river_transport');
disp(varData); 
% ncdisp(NC_FILE);



