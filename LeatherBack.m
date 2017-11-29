
%This is going to look at Leatherback movement
%LeatherBack.m
%Tiffany Nguyen
%11/26/2017


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Comments%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 2004: Sep,Oct,Nov,Dec
% 2005: Jan,Feb,Mar,Apr,May,___, ____,Aug,Sept____,Nov (only 19 days),
% 2006: Dec
% 2007: Jan,Feb,Mar, Pr(13days only)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Load the Data%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Load the data
fid=fopen('LONG_LB090604_041307.csv');
leatherData=textscan(fid,'%d%d%s','delimiter',',','headerLines',2);
% fid2=fopen('Leatherback06_07.txt');
% fid3=fopen('Leatherback04_05.csv');
% leatherData=textscan(fid,'%d %d %s', 'headerLines', 2);
% leatherData2=textscan(fid2,'%d %d %s', 'headerLines', 2);
% leatherData3=textscan(fid3,'%d,%d,%s', 'headerLines', 2);
fclose(fid);

%A
lon_leather=leatherData{1};

lat_leather=leatherData{2};
numEntries = length(lat_leather);

formatIn = "YY-MM-DD";
formatOut = "YY-MM-DD";

time_leather=datenum(leatherData{3},formatIn);
trajectory_leather = zeros(numEntries,3);


trajectory_leather(:,1) = lon_leather;
trajectory_leather(:,2) = lat_leather;
trajectory_leather(:,3) = time_leather;
trajectory_leather = sort(trajectory_leather,3);

% %B
% long_leather2=leatherData2{1};
% lat_leather2=leatherData2{2};
% time_leather2=leatherData2{3};
%
% %C
% long_leather3=leatherData3{1};
% lat_leather3=leatherData3{2};
% time_leather3=leatherData3{3};

%Coastlines
load('coastlines.mat')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Plotting%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% subplot(2,2,1);

% %fix coastlon
% for i = 1:length(coastlon),
%     if coastlon(i)>180,
%         coastlon(i) = -1*(coastlon(i) - 180);
%     end
% end


for i = 1:numEntries,
    if trajectory_leather(i,1) <= 0,
        trajectory_leather(i,1) = trajectory_leather(i,1) + 360;
    end
end


%plot (coastlon,coastlat,'k');
%hold on
%plot(long_leather,lat_leather,'.')

%plot(trajectory_leather(:,1),trajectory_leather(:,2),'-*',  'Color', 'g','MarkerSize', 1, 'MarkerEdgeColor','r');



%plot 30 day periods
months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul','Aug' ,'Sep' ,'Oct', 'Nov', 'Dec'];
for monthNo = 1:12 %goes from 2 to 13 to work with indexing
    figure(monthNo );
    plot (coastlon,coastlat,'k');
    titleStringName = datestr(trajectory_leather(30*monthNo,3),formatOut);
    hold on;
    
    if monthNo == 1
%        titleStringName = months(1:monthNo*3);
        title(titleStringName);
        
        plot(trajectory_leather(1:monthNo*30,1),trajectory_leather(1:monthNo*30,2),'-*',  'Color', 'g','MarkerSize', 1, 'MarkerEdgeColor','r');
        
    else
%        titleStringName = months((monthNo - 2/3)*3:monthNo*3);
        title(titleStringName);
        
        plot(trajectory_leather((monthNo - 1)*30:monthNo*30,1),trajectory_leather((monthNo - 1)*30:monthNo*30,2),'-*',  'Color', 'g','MarkerSize', 1, 'MarkerEdgeColor','r');
    end
end



%xlim([ 100 200]);
%ylim([0 50]);
title('A')

% subplot(2,2,2);
% plot (coastlon, coastlat,'k')
% hold on
% plot (long_leather2,lat_leather2,'.')
% title('B')
%
% subplot(2,2,3);
% plot (coastlon,coastlat,'k')
% hold on
% plot(long_leather3,lat_leather3,'.')
% xlim([0 350])
% title('C')




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Analysis%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

timesteps = zeros(numEntries,1);
stepsize = zeros(numEntries,1);
for num = 1:(numEntries - 1)
    stepsize(num,1) = sqrt(( trajectory_leather(num + 1,2)- trajectory_leather(num ,2))^2 +(trajectory_leather(num + 1,1)- trajectory_leather(num ,1))^2);
    timesteps(num,1) = trajectory_leather(num + 1,3)- trajectory_leather(num ,3);
end

