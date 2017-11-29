%This is going to look at Leatherback movement
%LeatherBack.m
%Tiffany Nguyen
%11/26/2017

%Load the data
fid=fopen('Leatherback05.txt');
fid2=fopen('Leatherback06_07.txt');
fid3=fopen('Leatherback04_05.csv');
leatherData=textscan(fid,'%d %d %s', 'headerLines', 2);
leatherData2=textscan(fid2,'%d %d %s', 'headerLines', 2);
leatherData3=textscan(fid3,'%d,%d,%s', 'headerLines', 2);
fclose(fid);  

%A
long_leather=leatherData{1};
lat_leather=leatherData{2};
time_leather=leatherData{3};

%B
long_leather2=leatherData2{1};
lat_leather2=leatherData2{2};
time_leather2=leatherData2{3};

%C
long_leather3=leatherData3{1};
lat_leather3=leatherData3{2};
time_leather3=leatherData3{3};

%Coastlines
load('coastlines.mat')

%Plotting
subplot(2,2,1);
plot (coastlon,coastlat,'k')
hold on
plot(long_leather,lat_leather,'.')
title('A')

subplot(2,2,2);
plot (coastlon, coastlat,'k')
hold on
plot (long_leather2,lat_leather2,'.')
title('B')

subplot(2,2,3);
plot (coastlon,coastlat,'k')
hold on
plot(long_leather3,lat_leather3,'.')
xlim([0 350])
title('C')
