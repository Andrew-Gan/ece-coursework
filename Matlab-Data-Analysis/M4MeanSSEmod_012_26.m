function [SSEmod, SSEmod_mean] = M3MeanSSEmod_012_26(parameters, timeData, tempData)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132
% Program Description
% This program will calculate SSEmod for each time history and determine a
% mean SSEmod for each thermocouple model
%
% Function Call
% 
% function[SSEmod, meanSSEmod] = M3MeanSSEmod_012_26(tau, predict_tau)
%
% Input Arguments
% tau - a vector of tau vallues split up by thermocouple
% predict_tau - a vector of predicted tau values
% %
% % Output Arguments
% mean - a vector of the mean values for each thermocouple
% stdDeviation - a vector of the standard deviation for each thermocouple
%
% Assignment Information
%   Assignment:       	Milestone 3, SSEmod and mean SSEmod
%   Team ID:            012-26
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ____________________
%% INITIALIZATION
inc = 20;
n = size(tempData, 2);
m = size(tempData, 1);
SSEmod = zeros(1, n);
SSEmod_mean = zeros(1, n / inc);
%% ____________________
%% CALCULATIONS
for i = 1:1:n
    predict_tempData = M2y_of_t_012_26(timeData, tempData(:,i), parameters(:,i));
    SSEmod(i) = (sum((tempData(:,i) - predict_tempData) .^ 2) / m);
end

x = 1;

for i = 1:inc:n-inc+1
    SSEmod_mean(x) = mean(SSEmod(i:i+inc-1));
    x = x + 1;
end


%% ____________________