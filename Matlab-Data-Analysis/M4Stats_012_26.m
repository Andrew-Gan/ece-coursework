function[average, stdDeviation] = M3Stats_012_26(tau)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This program will calculate the mean and standard deviation of the time
% constants across all 20 time histories for each thermocouple model.
%
% Function Call
% function[mean, stdDeviation] = M3Stats_012_26(tau)
%
% Input Arguments
% tau - a vector of tau values split up by thermocouple
%
% Output Arguments
% mean - a vector of the mean values for each thermocouple
% stdDeviation - a vector of the standard deviation for each thermocouple
%
% Assignment Information
%   Assignment:       	Milestone 3, Stats (mean and standard deviation)
%   Team ID:            012-26
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ____________________
%% INITIALIZATION

value = size(tau);
ncol = value(2);
average = zeros(1,ncol / 20);
stdDeviation = zeros(1,ncol / 20);

%% ____________________
%% CALCULATIONS
x = 1;
for count = 1:20:ncol
    average(x) = mean(tau(:,count:count+19));
    stdDeviation(x) = std(tau(:,count:count+19));
    x = x + 1;
end
%% ____________________