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
file = 'request_2234_user_1025_dataset_739_20170922.csv';
fid = fopen(file);
seabirdData = textscan(fid, '%d %s %s %s %s %s %s %s %s %s %s %s %s %s %f %f %f', 'headerlines', 1);
relevantData = seabirdData{1,6};
numEntries = length(relevantData);

%load coast lines data
load('coastlines.mat');


%Initialize Variables
trackIDData = zeros(numEntries,1);
dateData = strings(numEntries,1);%zeros(numEntries,1);
timeData = strings(numEntries,1);
latitudeData = zeros(numEntries,1);
longitudeData = zeros(numEntries,1);
datetimeData = strings(numEntries,1);


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
   % datetimeData(i) =[dateData(i) timeData(i)];
   
   datetimeData(i) =strcat(dateData(i), " ", timeData(i));
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
latitude = zeros(numEntries,2,count_individuals);
longitude = zeros(numEntries,2,count_individuals);
datetime = strings(numEntries,count_individuals);

chronologicalLongitude = zeros(size(longitude));
chronologicalLatitude = zeros(size(latitude));


%Date format
%https://www.mathworks.com/help/matlab/ref/datenum.html
formatIn = 'yyyy-mm-dd';
formatDateTime = 'yyyy-mm-dd HH:MM:SS';

%store the number of entires in for each individual

numSteps = zeros(1,count_individuals);


%Individualize Data
for L = 1:(count_individuals)
    if L < count_individuals
        numSteps(1, L) = individuals(L+1,2) - individuals(L,2);

        for pos = individuals(L,2):individuals(L + 1 ,2) - 1
            pos_normalized = pos - individuals(L,2) + 1;
            latitude(pos_normalized,1,L) = latitudeData(pos);
            
            longitude(pos_normalized,1,L) = longitudeData(pos);
            time(pos_normalized,L) = timeData(pos);
            date(pos_normalized,L) = datenum(dateData(pos),formatIn);
            datetime(pos_normalized,L) = datenum(datetimeData(pos),formatDateTime);
            latitude(pos_normalized,2,L) = datetime(pos_normalized,L);
            longitude(pos_normalized,2,L) = datetime(pos_normalized,L);
            
        end
    end
    if L == count_individuals
        numSteps(1, L) = numEntries - individuals(L,2);

        for pos = individuals(L,2):numEntries
            pos_normalized = pos - individuals(L,2) + 1;
            latitude(pos_normalized,1,L) = latitudeData(pos);
            longitude(pos_normalized,1,L) = longitudeData(pos);
            time(pos_normalized,L) = timeData(pos);
            date(pos_normalized,L) = datenum(dateData(pos),formatIn);
            datetime(pos_normalized,L) = datenum(datetimeData(pos),formatDateTime);
            latitude(pos_normalized,2,L) = datetime(pos_normalized,L);
            longitude(pos_normalized,2,L) = datetime(pos_normalized,L);
            
        end
    end
chronologicalLongitude = sort(longitude,3);
chronologicalLatitude = sort(latitude,3);
    
end

datetime = str2double(datetime);
%chronologicalDateTime = zeros(size(datetime));

timeMax = zeros(1,2,count_individuals); %(max value(1) matrix rowlocation(2) matrix collocation(3) individual id);
timeMin = zeros(1,2,count_individuals); %(min value(1) matrix rowlocation(2) matrix collocation(3)individual id);



%Properly organize them chronically

% for ind = 1:count_individuals
%     timeMax(1,1,ind) = max(datetime(:,ind));
%     timeMin(1,1,ind) = min(datetime(:,ind));
%    % [timeMax(1,2,ind) timeMax(1,3,ind)] = find(datetime(:,ind) == max(datetime(:,ind)));
%     %[timeMin(1,2,ind) timeMin(1,3,ind)] = find(datetime(:,ind) == min(datetime(:,ind)));
%     timeMax(1,2,ind) = find(datetime(:,ind) == max(datetime(:,ind)));
%     timeMin(1,2,ind) = find(datetime(:,ind) == min(datetime(:,ind)));
%     chronologicalDateTime(1,ind) = timeMin(1,1,ind);
%     chronologicalDateTime(end,ind) = timeMin(1,1,ind);
% 
%     for t = 1:numSteps(1,ind)
%         
%         
%         
%     end
%     
% end



%Calculate timesteps and step sizes
timesteps = zeros(numEntries,count_individuals);
stepsize = zeros(numEntries,count_individuals);
for num = 1:numEntries
    for individualno = 1:count_individuals
        if num < numSteps(1 , individualno)
            stepsize(num,individualno) = sqrt((latitude(num + 1,individualno) - latitude(num,individualno))^2 +(longitude(num + 1,individualno) - longitude(num,individualno))^2);
            %  timestep(num,individualno) = str2double(datetime(num,individualno)-datetime(num,individualno));
        elseif num >= numSteps(1 , individualno)
            stepsize(num ,individualno) = 0/0;
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Statistics&&&&&&&&%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Ergodicity
%Is the time average of a single individual the same as the ensemble
%average of just one timestep?
meanIndividualStepSize = nanmean(stepsize(:,1))
meanEnsembleSingleStep = mean(stepsize(1,:))

ensembleAverageAllTimes = zeros(400,1);

%All ensemble means

for t = 1:400
ensembleAverageAllTimes(t) = nanmean(stepsize(t,:));
 
end

%ensembleAverageAllTimes(:) = ensembleAverageAllTimes(:)';
%mean of ensemble means
 meanOfEnsembleMeans = mean(ensembleAverageAllTimes(:))




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot Individual Data%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%***********PLOT 1***************************
% % %Plot Hisograms of step sizes
% for plotnum = 1:count_individuals
%     figure(plotnum);
%     hist(stepsize(:,plotnum),round(numSteps(1,plotnum)));
%     
%     plotnumString = string(plotnum);
%     titleString = [ 'Histogram of Individual' plotnumString];
%     title(titleString);
%     xlim([0 150]);
%     ylim([0 50])
% end
% % close(1:count_individuals)
% 


months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul','Aug' ,'Sep' ,'Oct', 'Nov', 'Dec'];
month30days = [ 4,6,9,11];
month31days = [ 1,3,5,7,8,10,12];
oddcounter = 1;

%***********PLOT 2***************************
% plot monthly trajectories for individual 1
    
for figurenum = 2:13
    
    figure(figurenum);
    titleString = months(figurenum);
    title(titleString);
    
    plot(colony_longitudeData , colony_latitudeData , 'b*');
    hold on;
    plot(coastlon - 180 ,coastlat, '-k');
    xlim([ -180 180]);
    ylim([ -90 90]);
    
    
    plot(chronologicalLongitude(((figurenum - 1)*30:(figurenum)*30),1,2), chronologicalLatitude(((figurenum - 1)*30:(figurenum)*30),1,2), '-*',  'Color', 'g','MarkerSize', 1, 'MarkerEdgeColor','r');
end    
    % close(count_individuals: 2*count_individuals)

%***********PLOT 3***************************
% %Entire Trajectories for all 
% for plotnum = 1:count_individuals
%     figure(plotnum + count_individuals);
%     plotnumString = string(plotnum );
%     titleString = [ 'Trajectory of individual' plotnumString];
%     title(titleString);
%     plot(colony_longitudeData , colony_latitudeData , 'b*');
%     hold on;
%     plot(chronologicalLongitude(:,1,plotnum), chronologicalLatitude(:,1,plotnum), '-*',  'Color', 'g','MarkerSize', 1, 'MarkerEdgeColor','r');
%     plot(coastlon - 180 ,coastlat, '-k');
% xlim([ -180 180]);
% ylim([ -90 90]);
% end
% % close(count_individuals: 2*count_individuals)


%close(1: 3*count_individuals)

%



% %Histogram of Ensemble Means
% figure(plotnum + count_individuals + 1);
% histogram(ensembleAverageAllTimes(:), 20);
% title('Histogram of Ensemble Means For All Times');
% close(plotnum +  count_individuals + 1);
% 
% %plot time series of Ensemble means
% figure(plotnum + count_individuals + 2);
% for t = 1:400
% plot(t,ensembleAverageAllTimes(t,1), 'r-');
% title('Ensemble Mean vs Time');
% hold on
%  
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%IGNORE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%STUFF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%BELOW%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%THIS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%LINE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% for t=1:340
% plot(longitude(t,1),latitude(t,1), 'r--');
% hold on
% 
% end

% % % % for figurenum = 1:12
% % % %     figure(figurenum);        
% % % %     titleString = months(figurenum);
% % % %     title(titleString);
% % % % 
% % % %     plot(colony_longitudeData , colony_latitudeData , 'b*');
% % % %     hold on;
% % % %     plot(coastlon - 180 ,coastlat, '-k');
% % % %     xlim([ -180 180]);
% % % %     ylim([ -90 90]);
% % % %     
% % % %     if figurenum ~= 2
% % % %         for day = 1:30
% % % %             plot(chronologicalLongitude((day + (figurenum - 1)*30),1,2), chronologicalLatitude((day + (figurenum - 1)*30),1,2), 'r--.');
% % % %         end
% % % %     end
% % % % end
