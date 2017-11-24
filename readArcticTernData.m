%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   TO-DO
%1) Fix the data to be day 1 after day 2 (it's randomly oriented rn)
%2) Find a way to load in the lat and lon max and min
%3) Set axis min and max
%4) Ask if using "datenum" functio is allowed
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








% This script loads Artic tern tracking data
%readSeabirdData.m
%Author: Syed Faizanul Haque
%Date: Nov/23/2017

%https://en.wikipedia.org/wiki/Arctic_tern


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Load Data and Initialize Variables%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Load Data
file = 'C:\Users\Faizan\Documents\Academics\Research_Greg\Data\Animal Telemetry Network\request_2234_user_1025_dataset_739_20170922.csv';
fid = fopen(file);
seabirdData = textscan(fid, '%d %s %s %s %s %s %s %s %s %s %s %s %s %s %f %f %f', 'headerlines', 1);
relevantData = seabirdData{1,6};
numEntries = length(relevantData);

%emptyArray = [];
%colony_lat = [emptyArray, emptyArray*10]; %zeros(1,numEntries);
%useArray = relevantData{1};

%Initialize Variables
%colony_latitudeData = zeros(numEntries,1);
%colony_longitudeData = zeros(numEntries,1);
trackIDData = zeros(numEntries,1);
dateData = strings(numEntries,1);%zeros(numEntries,1);
timeData = strings(numEntries,1);
latitudeData = zeros(numEntries,1);
longitudeData = zeros(numEntries,1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Read and Clean Data%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Read Data into separate Matrices
for i = 1:numEntries
    useArray = relevantData{i};
    c_lat = [];
    c_lon = [];
    tempTrackID = [];
    tempDate = [];
    tempTime = [];
    tempLatitude = [];
    tempLongitude =[];
    for j = 9:13
        c_lat = [c_lat useArray(j) ];
        
    end
    colony_latitudeData(i) = str2double(c_lat);
    
    for j = 15:20
        c_lon = [c_lon useArray(j) ];
    end
    
    
    for j = 28:32
        tempTrackID = [tempTrackID useArray(j) ];
    end
    trackIDData(i) = str2double(tempTrackID);
    
    for j = 97:106
        tempDate = [tempDate useArray(j) ];
    end
    dateData(i) = tempDate;%str2double(tempDate);
    for j = 108:115
        tempTime = [tempTime useArray(j) ];
    end
    timeData(i) = tempTime; %str2double(tempTime);
    for j = 117:125
        tempLatitude = [tempLatitude useArray(j) ];
    end
    latitudeData(i) = str2double(tempLatitude);
    
    for j = 127:134
        tempLongitude = [tempLongitude useArray(j) ];
    end
    longitudeData(i) = str2double(tempLongitude);
    
end
colony_longitudeData = str2double(c_lon);
colony_latitudeData = str2double(c_lat);


%Find separate individuals
individuals = zeros(numEntries,2);
count_individuals = 1;

for k = count_individuals:numEntries
    if trackIDData(k) ~= individuals(k,1);
        if count_individuals == 1;
            if  trackIDData(k) ~= 0;
                individuals(count_individuals,1) = trackIDData(k);
                individuals(count_individuals,2) = k;
                count_individuals = count_individuals + 1;
            end
        end
        if count_individuals > 1;
            if  trackIDData(k) ~= individuals((count_individuals - 1),1);
                individuals(count_individuals,1) = trackIDData(k);
                individuals(count_individuals,2) = k;
                count_individuals = count_individuals + 1;
            end
            
        end
    end
    
end

% subtract the additional counting factor
count_individuals = count_individuals - 1;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Individualize Data%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Initialize Individual Variables
colony_latitude = zeros(numEntries,count_individuals);
colony_longitude = zeros(numEntries,count_individuals);
trackID = zeros(numEntries,count_individuals);
date = strings(numEntries,count_individuals);
time = strings(numEntries,count_individuals);
latitude = zeros(numEntries,count_individuals);
longitude = zeros(numEntries,count_individuals);

%Date format
%https://www.mathworks.com/help/matlab/ref/datenum.html
formatIn = 'yyyy-mm-dd';


%Individualize Data
for L = 1:(count_individuals)
    if L < count_individuals
        for pos = individuals(L,2):individuals(L + 1 ,2) - 1
            pos_normalized = pos - individuals(L,2) + 1;
            latitude(pos_normalized,L) = latitudeData(pos);
            
            longitude(pos_normalized,L) = longitudeData(pos);
            time(pos_normalized,L) = timeData(pos);
            date(pos_normalized,L) = datenum(dateData(pos),formatIn);
            
        end
    end
    if L == count_individuals
        for pos = individuals(L,2):numEntries
            pos_normalized = pos - individuals(L,2) + 1;
            latitude(pos_normalized,L) = latitudeData(pos);
            longitude(pos_normalized,L) = longitudeData(pos);
            time(pos_normalized,L) = timeData(pos);
            date(pos_normalized,L) = datenum(dateData(pos),formatIn);
            
        end
    end
end


% for k = 1:numEntries
%     for l = 1:numEntries
%         if
%
%
%
%         end
%     end
% end
%

%for i = 1:10

% plot different trajectories
for plotnum = 1:2 % count_individuals
    figure(plotnum);
    plot(colony_longitudeData , colony_latitudeData , 'b*');
    hold on;
    plot(longitude(:,plotnum), latitude(:,plotnum), 'r--o');
    
end
 %   hold on
    
%end
