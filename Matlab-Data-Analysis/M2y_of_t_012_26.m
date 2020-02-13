function [theoData] = M2y_of_t_012_26(timeData, tempData, parameters)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This program calculates theoretical data based on calculated parameters
% as part of an identification algorithm for First Order Systems, Inc.
%
% Function Call
% function [tempData] = M2y_of_t_012_26(timeData, parameters)
%
% Input Arguments
% timeData, seconds, this data is the time values for our data
% temp, seconds, this data is the time values for our data
% parameters, various units including degrees C and seconds, the parameters
% y_L, y_H, t_s, tau in that order
%
% Output Arguments
% theoData, the theoretical temp data
%
% Assignment Information
%   Assignment:			M2, y(t)
%   Team ID:			012-26
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ____________________
%% INITIALIZATION
theoData = zeros(size(tempData));
count = 1;

%% ____________________
%% CALCULATIONS
if tempData(1) < tempData(length(tempData))
    while ~(timeData(count) == parameters(3))
        theoData(count) = parameters(1);
        count = count + 1;
    end
    while count <= length(tempData)
        theoData(count) = parameters(1) + (parameters(2) - parameters(1)) * (1 - exp((parameters(3) - timeData(count)) / parameters(4)));
        count = count + 1;
    end
else
    while ~(timeData(count) == parameters(3))
        theoData(count) = parameters(2);
        count = count + 1;
    end
    while (count <= length(tempData))
        theoData(count) = parameters(1) + (parameters(2) - parameters(1)) * exp((parameters(3) - timeData(count)) / parameters(4));
        count = count + 1;
    end
end
%% ____________________
%% COMMAND WINDOW OUTPUT


%% ____________________
%% ACADEMIC INTEGRITY STATEMENT

