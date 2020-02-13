function [] = M3Regression_012_26(tauVector100, priceVector100, meanTauVector5)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% Linear regression analysis of average Tau vs. price data.
% 
% Input arguments:
% tauVector - vector of 100 Tau values.
% meanTauVector - vector of 5 average Tau values (one per thermocouple).
% priceVector - vector of 5 prices sized to match tauVector. 
%
% Assigment Information
%   Assignment:     M3Regression_012_26
%   Team ID:        012-26
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ____________________
%% INITIALIZATION
% Creating 5-long price vector corresponding to each thermocouple
priceVector5 = [priceVector100(1), priceVector100(21), priceVector100(41), priceVector100(61), priceVector100(81)]; 


%% ____________________
%% SUBPLOT FIGURE(S)

% Linearization of initial data by manipulating axes:
figure (1) % log(x)
subplot (2,2,1)
semilogx(meanTauVector5, priceVector5, 'b-')
xlabel('Tau (seconds)')
ylabel('Price per thermocouple ($)')
title('Price (LOGARITHMIC)')
grid on

subplot (2,2,2) % exponential 
semilogy(meanTauVector5, priceVector5, 'r-')
xlabel('Tau (seconds)')
ylabel('Price per thermocouple ($)')
title('Price (EXPONENTIAL)')
grid on

subplot (2,2,3) % power curve
loglog(meanTauVector5, priceVector5, 'k-')
xlabel('Tau (seconds)')
ylabel('Price per thermocouple ($)')
title('Price (POWER CURVE)')
grid on

subplot(2,2,4) % Initial plot of price vs time constant for average time constants:
plot(meanTauVector5, priceVector5, 'b--')
xlabel('Tau (seconds)')
ylabel('Price per thermocouple ($)')
title('Price (LINEAR)')
grid on

%% ____________________
%% LINEARIZATION
logPrice100 = log10(priceVector100); % Log(10) of initial 100-long price vector
logMeanTau5 = log10(meanTauVector5); % Log(10) of average Tau vector.
logTauVector100 = log10(tauVector100);
logPrice5 = log10(priceVector5); % Log(10) of 5-long price vector.

% Logarithmic linearization:
polyfitLogTau = polyfit(tauVector100, logPrice100, 1); % Array of 2 elements showing slope (m) and y intercept (b) of LINEAR model.

% Line below replaces the POLYVAL function.
plotVec = 0.11:0.01:2;
%plotPricePow = (plotVec .^ polyfitLogTau(1)) * (10 ^ polyfitLogTau(2));   % predicted prices for exponential CURVE model.
plotPricePow = (10 .^ (plotVec * polyfitLogTau(1))) * (10 ^ polyfitLogTau(2));   % predicted prices for exponential CURVE model.

predictedPricePow = (10 .^ (tauVector100 * polyfitLogTau(1))) * (10 ^ polyfitLogTau(2));   % predicted prices for exponential CURVE model.
fprintf("Price = %0.3f * (10 ^ (%0.3f * Tau))\n", polyfitLogTau(1),  10 ^ polyfitLogTau(2));

SSEpow = sum((priceVector100 - predictedPricePow) .^ 2); % SSE with regard to predicted values calculated 2 lines above.
SSTpow = sum((priceVector100 - mean(priceVector100)) .^ 2); % SST comparing actual values to the average price value. 
R_SquaredExp = 1 - (SSEpow / SSTpow); % R-Squared value.
fprintf("SSE = %0.2f\nSST = %0.2f\nR-Squared = %0.2f\n", SSEpow, SSTpow, R_SquaredExp);

% Plotting exponential-modeled curve on top of original data:
figure(2)
plot(tauVector100, priceVector100, 'bx') % Original data.
xlabel('Tau (seconds)')
ylabel('Price per Thermocouple ($)')
title('Price per Thermocouple with Given Time Constants')
hold on
plot(plotVec, plotPricePow, 'k-') % exponential modeled curve.
legend('Raw Data', 'Exponential Function Modeled Data', 'location', 'best')
grid on
