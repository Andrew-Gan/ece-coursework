function M4Exec_026_12()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This program loads csv data and runs a heating/cooling parameter
% identification algorithm for First Order Systems, Inc.
%
% Function Call
% function M4Exec_026_12()
%
% Input Arguments
% no Inputs
%
% Output Arguments
% no Outputs
%
% Assignment Information
%   Assignment:			M4, Exec
%   Team ID:			012-26
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ____________________
%% INITIALIZATION
rawHeatNoisy = csvread("M2_Data_Calibration_HeatingNoisy.csv"); %Imports raw data from the .csv file
heatNoisyTime = rawHeatNoisy(:,1);                           %Assigns the time data to its own variable
heatNoisyTemp = rawHeatNoisy(:,2);                          %Assigns the temp data to its own variable

rawHeatClean = csvread("M2_Data_Calibration_HeatingClean.csv"); %Imports raw data from the .csv file
heatCleanTime = rawHeatClean(:,1);                           %Assigns the time data to its own variable
heatCleanTemp = rawHeatClean(:,2);                          %Assigns the temp data to its own variable

rawCoolNoisy = csvread("M2_Data_Calibration_CoolingNoisy.csv"); %Imports raw data from the .csv file
coolNoisyTime = rawCoolNoisy(:,1);                           %Assigns the time data to its own variable
coolNoisyTemp = rawCoolNoisy(:,2);                          %Assigns the temp data to its own variable

rawCoolClean = csvread("M2_Data_Calibration_CoolingClean.csv"); %Imports raw data from the .csv file
coolCleanTime = rawCoolClean(:,1);                           %Assigns the time data to its own variable
coolCleanTemp = rawCoolClean(:,2);                          %Assigns the temp data to its own variable


rawCoolingData = csvread("M3_Data_CoolingTimeHistories.csv"); %Imports raw data from the .csv file
timeArray = rawCoolingData(:,1);                           %Assigns the time data to its own variable
coolingTemp = rawCoolingData(:,2:51);                          %Assigns the temp data to its own variable

rawHeatingData = csvread("M3_Data_HeatingTimeHistories.csv"); %Imports raw data from the .csv file
heatingTemp = rawHeatingData(:,2:51);                          %Assigns the temp data to its own variable

tempData = zeros(10240, 100);

prices = [15.83 8.52 3.5 2.03 0.65];

%% ____________________
%% CALCULATIONS
count = 1;
for x = 1:20:81
    tempData(:, x:x+9) = coolingTemp(:, count:count+9);
    tempData(:, x+10:x+19) = heatingTemp(:, count:count+9);
    count = count + 10;
end

% M4ParameterID_012_26(coolNoisyTime, coolNoisyTemp)

param = zeros(4, 100);
for i = 1:size(tempData, 2)
    param(:, i) = transpose(M4ParameterID_012_26(timeArray, tempData(:, i)));
end

[average, stdDev] = M4Stats_012_26(param(4, :));

[SSEmod, meanSSEmod] = M4MeanSSEmod_012_26(param, timeArray, tempData);

count = 1;
for i = 1:1:5
    priceVector(1, count:count+19) = ones(1,20) * prices(i);
    count = count + 20;
end

M4Regression_012_26(param(4, :), priceVector, average);
%% ____________________
%% COMMAND WINDOW OUTPUT
% Price = -0.982 * (10 ^ (20.836 * Tau))
% SSE = 91.05
% SST = 3071.13
% R-Squared = 0.97
% We are submitting code that is our own original work. We have not used
% source code, either modified or unmodified, obtained from any
% unauthorized source. Neither have we provided access to our code to any
% peer or unauthorized source. Signed,
% John Papas Dennerline
% Andrew Gan
% Neel Lingam
% Nick Sherman
%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
PS07_academic_integrity_iLingam(["John Papas Dennerline", "Andrew Gan", "Neel Lingam", "Nick Sherman"]);