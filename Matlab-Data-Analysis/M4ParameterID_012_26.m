function [returnArray] = M4ParameterID_012_26(timeData, tempData)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% Calculates temperature parameters using a moving average.
%
% Function Call
% [y_L, y_H, t_s, tau] = M2_Algorithm1_012_26(timeData, tempData)
%
% Input Arguments
% timeData, a vector of all the time values to be analyzed.
% tempData, a vector of all temperature values to be analyzed.
%
% Output Arguments
% returnArray = A vector containing the following parameters: % column
% y_L, the low, stable level of measured temperature.
% y_H, the high, stable level of measured temperature.
% t_s, the time immediately before the rise or fall in temperature.
% tau, the time constant which is the time difference between t_s and the time
% at which the temperature = 0.632 * the temperature range.
%
% Assignment Information
%   Assignment:       	Milestone 2, Algorithm 1.
%   Team ID:            012-26
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ____________________
%% INITIALIZATION
% All initializations handled in Exec. function.

% parameter used for thresholds, step size, etc.
%consec_thres = 6;
%step_size = 27;

paramArray = zeros(4, 5); %Pre-Allocates the space for this array, reducing runtime
counter = 0;
sseMaxArray = zeros(1, 15); %Pre-Allocates the space for this array, reducing runtime
%% ____________________
%% CALCULATIONS
for consec_thres = 4 : 1 : 8        %This line ensures varying thresholds
    for step_size = 26 : 1 : 28     %%This line ensures varying thresholds
        if ((isnumeric(timeData) == 0 || isnumeric(tempData) == 0) || (length(timeData) ~= length(tempData))) % Check input validity and print error if necessary.
            error("Error: Invalid data input\n");
        end

        if (tempData(end) > tempData(1)) % Checks if data is increasing or decreasing, and assigns heatBool a respective value.
            heatBool = 1; % Initializes for heating.
        else 
            heatBool = 0; % Initializes for cooling.
        end

        % avgVector = zeros(1,10); % Creates a blank vector 10 spaces long to be used as a moving average.
        % avgIndex = 1; % Initialize moving average location index.

        if (heatBool == 1)
            avgTempInitial = min(tempData); % Initializes for heating.
        else
            avgTempInitial = max(tempData); % initializes for cooling.
        end

        avgCount = 0;
        lowTempIndex = 1; % Initializing location of temperature bounds.
        hiTempIndex = step_size; % " " 
        avgVector = tempData(lowTempIndex:hiTempIndex);

        while (avgCount < consec_thres) % Runs until 5 sections of data increase in a row
            avgTempNew = mean(avgVector); % Calculating average temperature
            if ((heatBool == 1 && avgTempNew > avgTempInitial) || (heatBool == 0 && (avgTempNew < avgTempInitial)))
                avgCount = avgCount + 1;
            else
                avgCount = 0;
            end
            % incrementing indices and resetting average temperatures.
            lowTempIndex = lowTempIndex + step_size;
            hiTempIndex = hiTempIndex + step_size;
            avgVector = tempData(lowTempIndex:hiTempIndex); 
            avgTempInitial = avgTempNew;
        end

        t_s = timeData(lowTempIndex - consec_thres * step_size);
        t_s_location = lowTempIndex - consec_thres * step_size;

        if (heatBool == 0)
            y_H = mean(tempData(1:t_s_location));
            avgTempInitial = min(tempData);
        else
            y_L = mean(tempData(1:t_s_location));
            avgTempInitial = max(tempData);
        end
       
        %repeat process from right to left to find second temperature
        %parameter
        avgCount = 0;
        hiTempIndex = length(tempData);
        lowTempIndex = hiTempIndex - (step_size - 1);
        avgVector = tempData(lowTempIndex:-1:hiTempIndex);

        while (avgCount < consec_thres)
            avgTempNew = mean(avgVector);
            if ((~heatBool && (avgTempNew > avgTempInitial)) || (heatBool && (avgTempNew < avgTempInitial)))
                avgCount = avgCount + 1;
            else
                avgCount = 0;
            end
            lowTempIndex = lowTempIndex - step_size;
            hiTempIndex = hiTempIndex - step_size;
            avgVector = tempData(lowTempIndex:hiTempIndex);
            avgTempInitial = avgTempNew;
        end

        if (heatBool == 1)
            y_H = mean(tempData(hiTempIndex + consec_thres * step_size:length(tempData)));
        else
            y_L = mean(tempData(hiTempIndex + consec_thres * step_size:length(tempData)));
        end


        tempRange = y_H - y_L;  % Calculate Temperature Range

        if (heatBool == 1)
            tauPoint = y_L + (tempRange * 0.632);
        else
            tauPoint = y_H - (tempRange * 0.632);
        end

        currentTemp = tempData(t_s_location);
        count = t_s_location;

        while ((heatBool == 1 && (currentTemp < tauPoint)) || (heatBool == 0 && (currentTemp > tauPoint)))
            currentTemp = tempData(count);
            count = count + 1;
        end

        tauTime = timeData(count);

        tau = tauTime - t_s;    %Find tau value
    
        counter = counter + 1;
        paramArray(:,counter) = [y_L; y_H; t_s; tau];   %Store Parameters
    end
end

for x = 1:size(paramArray, 2)
    predict_tempData = M2y_of_t_012_26(timeData, tempData, paramArray(:,x));    %Find the predicted data for each set of parameters
    sseMaxArray(x) = (sum((tempData - predict_tempData) .^ 2) / 10240); %Find and store the SSE
end

returnArray = paramArray(:, min(find(sseMaxArray == min(sseMaxArray))));    %Return the parameters with the lowest SSE

%% ____________________
%% COMMAND WINDOW OUTPUT


%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
 
% Call your academic integrity statement here
        
        