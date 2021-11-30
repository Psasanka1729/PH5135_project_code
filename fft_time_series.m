clear;clc;close all

Time = [];

% Array to hold the PM data.
PM_1 = [];
PM2_5 = [];
PM10 = [];

% The currently working directory. Will be used for relative path.
path = pwd;

% Year.
Year = 2019;

% Loop runs over one month and the specified number of days and combines all data to a
% single array.


for month = 8:8 % Change the xlim of power plot for a better view of the peak.
    
    % If month < 10 we need to add a leading zero in front to get the file
    % name correctly.
    if month < 10
        
        for date = 1:30

            % If date is less than 10, we need to add a leading zero in front
            % of the month to get the correct file name.

            if date < 10     
                
                % Creating the PM file name.
                PMFileName = string(path)+'/data/'+string(Year)+'/0'+string(month)+'/0'+string(date)+...
                '/MINTS_001e06305a61_OPCN2_'+string(Year)+'_0'+string(month)+...
                '_0'+string(date);  

                % Creating a table of the PM file just created / opened.
                Table_pm = readtable(PMFileName + '.csv');

            % If date is greater than 10 then we do not need an a leading zero
            % in front.

            else

                PMFileName = string(path)+'/data/'+string(Year)+'/0'+string(month)+'/'+string(date)+...
                '/MINTS_001e06305a61_OPCN2_'+string(Year)+'_0'+string(month)+...
                '_'+string(date);         
             
                Table_pm = readtable(PMFileName + '.csv');

            % Converting the table to time table.
            ttpm = table2timetable(Table_pm);        

            % Interval in minutes over which the data will be averaged.
            Interval = 60;

            % Averaging the data.
            rtpm = retime(table2timetable(Table_pm),'regular',@nanmean,'TimeStep',minutes(Interval));              
            
            Time = [Time; rtpm.dateTime];

            % Adding the pm data to the array.
            PM_1 = [PM_1; rtpm.pm1];        
            PM2_5 = [PM2_5; rtpm.pm2_5];
            PM10 = [PM10; rtpm.pm10];   

            end
        end
        
    else % month >= 10
        for date = 1:30

            % If date is less than 10, we need to add a leading zero in front
            % of the month to get the correct file name.

            if date < 10        
                % Creating the PM file name.
                PMFileName = string(path)+'/data/'+string(Year)+'/'+string(month)+'/0'+string(date)+...
                '/MINTS_001e06305a61_OPCN2_'+string(Year)+'_'+string(month)+...
                '_0'+string(date);  

                % Creating a table of the PM file just created / opened.
                Table_pm = readtable(PMFileName + '.csv');

            % If date is greater than 10 then we do not need an a leading zero
            % in front.

            else

                PMFileName = string(path)+'/data/'+string(Year)+'/'+string(month)+'/'+string(date)+...
                '/MINTS_001e06305a61_OPCN2_'+string(Year)+'_'+string(month)+...
                '_'+string(date);         

                % Converts the data file into a table.
                Table_pm = readtable(PMFileName + '.csv');

            % Converting the table to time table.
            ttpm = table2timetable(Table_pm);        

            % Interval in minutes over which the data will be averaged.
            Interval = 60;

            % Averaging the data.
            rtpm = retime(table2timetable(Table_pm),'regular',@nanmean,'TimeStep',minutes(Interval));  

            Time = [Time; rtpm.dateTime];

            % Adding the pm data to the array.
            PM_1 = [PM_1; rtpm.pm1];        
            PM2_5 = [PM2_5; rtpm.pm2_5];
            PM10 = [PM10; rtpm.pm10];   

            end
        end        
    end
end       


% Specify the pollutant in the following line.
% PM_1, PM10, PM2_5.

Pollutant = PM_1;


figure
[pks,locs] = findpeaks(Pollutant,'MinPeakDistance',12);
plot(Time(locs),pks,'or','MarkerFaceColor','r','LineWidth',10)
legend('Peaks')
hold on;
plot(Time, Pollutant, 'b-', 'LineWidth', 3) % Plot original data.
xlabel('Time')
ylabel('PM levels (\mu g / m^3)')
title('PM Data')
set(gca,'FontSize',25) % set default font size, this will affect tick mark labels
set(gca,'LineWidth',4)

figure
y = fft(Pollutant);
y(1) = [];
plot(y,'ro')
xlabel('real(y)')
ylabel('imag(y)')
title('Fourier Coefficients')
set(gca,'FontSize',20) % set default font size, this will affect tick mark labels
set(gca,'LineWidth',2) % set default line width

figure
n = length(y);
power = abs(y(1:floor(n/2))).^2; % power of first half of transform data
maxfreq = 1/2;                   % maximum frequency
freq = (1:n/2)/(n/2)*maxfreq;    % equally spaced frequency grid
plot(freq,power)
xlabel('Cycles/Hours')
ylabel('Power')
grid on
set(gca,'FontSize',20) % set default font size, this will affect tick mark labels
set(gca,'LineWidth',2) % set default line width

figure
period = 1./freq;
plot(period,power,'LineWidth',2);
xlabel('Hours/Cycle')
ylabel('Power')
xlim([0 50])
title('Power plot')
set(gca,'FontSize',20) % set default font size, this will affect tick mark labels
set(gca,'LineWidth',2) % set default line width