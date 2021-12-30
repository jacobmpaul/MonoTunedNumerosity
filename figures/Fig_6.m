%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Comparison between the monotonic responses in neural network models of numerosity processing %%
%% and the relationship of numerosity to aggregate Fourier power Fig.6                          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% I. Stoianov, M. Zorzi, Emergence of a “visual number sense” in hierarchical generative models. Nat. Neurosci. 15, 194–196 (2012).
% Supplementary Figure 4A
Zorzi1X=round([1.006,2.002,3.006,4.009,4.996,5.985,7.01,7.982,8.986,10.004,11.011,11.984,12.97,14.036,15.02,15.982,17.006,17.993,18.931,20.03,20.955,22.047,23.066,23.995,24.822,25.969,27.015,27.946,29.072,29.904]);
Zorzi1Y=[0.736,0.82,0.872,0.911,0.956,0.993,1.029,1.074,1.118,1.142,1.19,1.218,1.242,1.271,1.307,1.312,1.341,1.353,1.382,1.389,1.408,1.434,1.452,1.48,1.49,1.493,1.505,1.521,1.538,1.55];
Zorzi2X=round([1.006,2.002,3.006,4.009,4.996,5.985,7.01,8.027,9.037,10.004,11.011,12.052,13.043,14.036,15.02,15.982,17.006,17.993,19.038,19.917,20.955,21.923,23.066,23.995,24.963,25.969,27.015,28.104,28.908]);
Zorzi2Y=[0.747,0.817,0.861,0.918,0.954,0.995,1.036,1.084,1.12,1.147,1.189,1.195,1.233,1.269,1.29,1.314,1.329,1.348,1.386,1.41,1.418,1.432,1.456,1.476,1.49,1.497,1.519,1.524,1.545];
Zorzi3X=round([1,2.002,3.006,4.009,4.996,5.985,7.01,7.982,8.986,10.004,11.011,11.984,12.97,13.957,15.02,15.982,17.006,17.993,18.931,19.917,20.955,22.047,23.066,23.995,24.963,25.822,27.015,27.946,28.908,29.736]);
Zorzi3Y=[0.765,0.807,0.868,0.921,0.957,1.01,1.04,1.062,1.105,1.132,1.17,1.202,1.24,1.267,1.29,1.314,1.339,1.35,1.362,1.379,1.401,1.425,1.439,1.451,1.471,1.478,1.495,1.521,1.536,1.55];
Zorzi4X=round([1.01,2,3.003,3.979,5.005,6.006,7.023,8,9.019,10.01,10.994,12.013,12.989,14.045,15.03,16,17.033,18.038,19.003,20.019,20.981,21.988,23.044,23.9,25.048,25.979,26.944,28.091,28.983,30.06,31.015]);
Zorzi4Y=[0.75,0.808,0.87,0.897,0.954,1.006,1.028,1.099,1.123,1.144,1.193,1.213,1.24,1.272,1.289,1.314,1.327,1.348,1.367,1.398,1.409,1.423,1.439,1.449,1.476,1.484,1.495,1.507,1.522,1.539,1.545];
Zorzi5X=round([1.005,2,3.003,4,5.005,6.006,7.023,8,9.019,10.01,10.994,12.013,12.989,13.972,15.03,16,17, 17.944,19.003,20.019,20.981,21.988,23.044,24.025,24.918,25.979,26.944,28.091,28.983,30.06,30.854,32]);
Zorzi5Y=[0.745,0.805,0.878,0.924,0.968,1.001,1.031,1.069,1.118,1.14,1.156,1.196,1.221,1.237,1.27,1.294,1.306, 1.318,1.333,1.341,1.355,1.381,1.408,1.409,1.446,1.465,1.471,1.482,1.504,1.514,1.531,1.537];
Zorzi6X=round([1.005,2,3.003,3.979,5.005,6.006,7.023,8,9.019,9.958,10.994,11.95,12.989,13.972,15.03,16,17.033,18.038,19.003,20.019,20.871,22.103,23.044,24.025,25.048,25.979,27.085,28.091,28.983,30.06,31.015,32]);
Zorzi6Y=[0.766,0.823,0.867,0.921,0.951,0.997,1.049,1.085,1.121,1.152,1.182,1.212,1.245,1.264,1.288,1.308,1.338,1.351,1.365,1.387,1.4,1.417,1.433,1.447,1.45,1.465,1.485,1.482,1.504,1.507,1.517,1.528];
Zorzi7X=round([1.01,2,3.003,4,5.005,6.006,7.023,8,9.019,10.01,10.994,12.013,13.057,14.045,14.952,16,16.944,18.038,19.003,20.019,20.981,21.988,23.044,24.025,25.048,25.979,26.944,28.091,28.983,30.06,31.015,32]);
Zorzi7Y=[0.775,0.83,0.886,0.925,0.966,1.001,1.03,1.063,1.087,1.107,1.136,1.17,1.186,1.208,1.243,1.253,1.284,1.3,1.322,1.344,1.357,1.37,1.386,1.393,1.401,1.412,1.423,1.433,1.438,1.441,1.454,1.455];
Zorzi8X=round([1.005,1.99,2.988,4,5.005,6.006,7.023,8,8.972,10.01,10.994,12.013,12.989,13.972,15.03,15.917,16.944,18.038,19.003,20.019,20.981,21.988,23.044,24.025,25.179,25.979,26.944,27.945,28.983,30.06,31.015,32]);
Zorzi8Y=[0.783,0.821,0.854,0.924,0.959,1,1.047,1.08,1.118,1.148,1.177,1.218,1.229,1.254,1.28,1.302,1.313,1.333,1.354,1.37,1.386,1.393,1.414,1.425,1.442,1.438,1.454,1.457,1.466,1.476,1.482,1.493];

ZorziAllX=[Zorzi1X, Zorzi2X, Zorzi3X, Zorzi4X,Zorzi5X, Zorzi6X,Zorzi7X, Zorzi8X];
ZorziAllY=[Zorzi1Y, Zorzi2Y, Zorzi3Y, Zorzi4Y,Zorzi5Y, Zorzi6Y,Zorzi7Y, Zorzi8Y];

figure; plot(ZorziAllX, ZorziAllY)
ZorziMin=mean(ZorziAllY(ZorziAllX==1));
ZorziMax=mean(ZorziAllY(ZorziAllX==30));
ZorziAllYNorm=(ZorziAllY-ZorziMin)./(ZorziMax-ZorziMin);
figure; plot(log(ZorziAllX), ZorziAllYNorm);

Zorzi1YNorm=(Zorzi1Y-ZorziMin)./(ZorziMax-ZorziMin);
Zorzi2YNorm=(Zorzi2Y-ZorziMin)./(ZorziMax-ZorziMin);
Zorzi3YNorm=(Zorzi3Y-ZorziMin)./(ZorziMax-ZorziMin);
Zorzi4YNorm=(Zorzi4Y-ZorziMin)./(ZorziMax-ZorziMin);
Zorzi5YNorm=(Zorzi5Y-ZorziMin)./(ZorziMax-ZorziMin);
Zorzi6YNorm=(Zorzi6Y-ZorziMin)./(ZorziMax-ZorziMin);
Zorzi7YNorm=(Zorzi7Y-ZorziMin)./(ZorziMax-ZorziMin);
Zorzi8YNorm=(Zorzi8Y-ZorziMin)./(ZorziMax-ZorziMin);

% G. Kim, J. Jang, S. Baek, M. Song, S. B. Paik, Visual number sense in untrained deep neural networks. Sci. Adv. 7 (2021)
% Figure 5B
Kim1X=round([1.02,2.02,3.001,4.022,5.003,6.023,7.004,8.024,9.005,9.986,11.007,12.027,13.008,13.989,15.009,16.03,17.011,17.992,19.012,20.032,21.014,21.995,22.976,23.996,25.016,25.997,27.018,27.959,28.98,29.941]);
Kim1Y=[0,0.128,0.223,0.312,0.35,0.39,0.43,0.468,0.499,0.528,0.584,0.635,0.672,0.718,0.776,0.842,0.859,0.873,0.875,0.881,0.889,0.899,0.921,0.945,0.963,0.977,0.968,0.963,0.983,1];
Kim2X=round([1.02,2.02,3.001,3.982,5.003,6.023,7.004,7.946,8.966,10.026,10.968,11.949,13.008,13.989,15.009,15.991,17.011,18.031,19.012,19.993,21.014,22.034,23.015,23.996,24.977,25.997,27.018,27.959,29.019,30.02]);
Kim2Y=[0,0.15,0.2,0.25,0.309,0.371,0.435,0.488,0.527,0.567,0.614,0.662,0.665,0.665,0.725,0.783,0.801,0.822,0.86,0.896,0.883,0.875,0.894,0.918,0.932,0.942,0.948,0.948,0.974,1];
Kim3X=round([0.98,2.02,3.001,3.982,5.003,5.984,7.004,7.985,9.005,9.986,11.046,12.027,13.047,13.989,14.97,16.03,17.011,17.992,19.012,19.993,20.974,22.034,23.015,23.996,25.016,25.997,27.018,27.999,28.98,30.059]);
Kim3Y=[0,0.042,0.127,0.212,0.256,0.304,0.338,0.368,0.412,0.475,0.501,0.544,0.571,0.604,0.669,0.734,0.765,0.794,0.774,0.758,0.809,0.866,0.891,0.883,0.895,0.908,0.898,0.888,0.942,1];
Kim4X=round([1,1.961,3.001,4.022,5.003,6.023,7.004,8.024,9.005,10.026,11.007,11.988,13.008,13.989,14.97,16.03,17.011,17.992,19.012,19.993,21.014,21.995,22.976,23.996,24.977,25.997,27.018,27.999,28.98,30.02]);
Kim4Y=[0,0.003,0.068,0.127,0.194,0.263,0.296,0.325,0.399,0.458,0.485,0.512,0.525,0.541,0.596,0.646,0.682,0.719,0.727,0.738,0.768,0.797,0.824,0.86,0.908,0.961,0.944,0.928,0.968,1];
Kim5X=round([0.98,2.02,3.001,4.022,5.003,5.984,7.004,8.024,9.005,9.986,11.007,12.027,13.008,14.028,15.009,16.03,17.011,18.031,19.012,20.032,21.014,21.995,23.015,23.996,25.016,25.997,27.018,27.999,29.019,30.02]);
Kim5Y=[0,0.095,0.158,0.22,0.283,0.342,0.387,0.44,0.483,0.524,0.564,0.604,0.635,0.666,0.698,0.727,0.75,0.777,0.803,0.829,0.853,0.876,0.898,0.919,0.932,0.947,0.96,0.971,0.983,1];
Kim6X=round([1.02,2.02,3.001,4.022,4.963,6.023,6.965,8.024,9.005,9.947,11.007,11.988,13.008,14.028,15.009,16.03,17.011,17.992,19.012,19.993,21.014,22.034,23.015,23.996,25.016,25.997,27.018,27.999,29.019,29.98]);
Kim6Y=[0,0.058,0.092,0.131,0.236,0.325,0.329,0.337,0.446,0.542,0.508,0.476,0.548,0.614,0.662,0.698,0.717,0.734,0.729,0.728,0.765,0.796,0.847,0.905,0.886,0.863,0.925,0.994,0.96,1];
Kim7X=round([0.98,2.02,3.001,3.982,5.003,5.984,7.004,8.024,9.005,10.026,11.007,12.027,13.008,13.989,15.009,16.03,17.011,17.992,19.012,20.032,20.974,22.034,22.976,23.957,24.977,25.997,27.018,28.038,28.98,29.98]);
Kim7Y=[0,0.069,0.144,0.201,0.213,0.222,0.266,0.322,0.37,0.416,0.446,0.473,0.528,0.577,0.576,0.574,0.62,0.668,0.683,0.705,0.712,0.717,0.826,0.909,0.889,0.86,0.917,0.97,0.981,1];
Kim8X=round([1.02,2.02,3.001,3.943,5.003,6.023,7.043,7.985,9.005,9.986,11.007,12.027,13.008,13.989,15.009,16.03,17.011,17.953,18.973,20.032,21.014,21.995,23.015,23.996,24.977,26.037,27.018,27.999,29.019,29.98]);
Kim8Y=[0,0.066,0.117,0.157,0.247,0.321,0.312,0.305,0.406,0.491,0.492,0.494,0.521,0.553,0.586,0.616,0.616,0.614,0.662,0.717,0.812,0.896,0.842,0.781,0.876,0.967,0.965,0.965,0.981,1];
KimAllX=[Kim1X, Kim2X, Kim3X, Kim4X, Kim5X, Kim6X, Kim7X, Kim8X];
KimAllY=[Kim1Y, Kim2Y, Kim3Y, Kim4Y, Kim5Y, Kim6Y, Kim7Y, Kim8Y];

% From orginal figure
PowerX32=PowerX(2:33); %#ok<NASGU>
PowerY32=PowerY(2:33); %#ok<NASGU>

% From repeated cycles
load('powerVsNumerostiyParams.mat')
PowerX32=1:32;
PowerY32=mean(params.fftSumToMin, 2)';

PowerY32Norm=(PowerY32-PowerY32(1))./(PowerY32(30)-PowerY32(1));
NetworkAllX=[ZorziAllX, KimAllX];
NetworkAllY=[ZorziAllYNorm, KimAllY];

PowerFitX=[PowerY32(NetworkAllX)' ones(size(NetworkAllX))'];
B_hat = pinv(PowerFitX)*NetworkAllY';
NetworkAllYPredictionPower=PowerFitX*B_hat;
PowerY32Fit=[PowerY32' ones(size(PowerY32))']*B_hat;
RSSPower=sum((NetworkAllYPredictionPower-NetworkAllY').^2);
corrcoef(NetworkAllYPredictionPower, NetworkAllY')

LogFitX=[log(NetworkAllX)' ones(size(NetworkAllX))'];
B_hat = pinv(LogFitX)*NetworkAllY';
NetworkAllYPredictionLog=LogFitX*B_hat;
LogY32Fit=[log(PowerX32)' ones(size(PowerX32))']*B_hat;
RSSLog=sum((NetworkAllYPredictionLog-NetworkAllY').^2);
corrcoef(NetworkAllYPredictionLog, NetworkAllY')

PolyFit2=polyfit(NetworkAllX, NetworkAllY, 2);
NetworkAllYPredictionPoly=polyval(PolyFit2, NetworkAllX');
PolyY32Fit=polyval(PolyFit2, PowerX32');
RSSPoly=sum((NetworkAllYPredictionPoly-NetworkAllY').^2);
corrcoef(NetworkAllYPredictionPoly, NetworkAllY')

figure; plot((ZorziAllX), ZorziAllYNorm);
hold on; plot((KimAllX), KimAllY);
hold on; plot((PowerX32), PowerY32Norm)
hold on; plot((PowerX32), PowerY32Fit)

figure; plot(log(ZorziAllX), ZorziAllYNorm);
hold on; plot(log(KimAllX), KimAllY);
hold on; plot(log(PowerX32), PowerY32Norm)
hold on; plot(log(PowerX32), PowerY32Fit)
%hold on; plot(log(NetworkAllX), NetworkAllYPrediction)

% Figure to publish
figure; plot((Zorzi1X), (Zorzi1Y-ZorziMin)./(ZorziMax-ZorziMin));
hold on; plot((Zorzi2X), (Zorzi2Y-ZorziMin)./(ZorziMax-ZorziMin));
hold on; plot((Zorzi3X), (Zorzi3Y-ZorziMin)./(ZorziMax-ZorziMin));
hold on; plot((Zorzi4X), (Zorzi4Y-ZorziMin)./(ZorziMax-ZorziMin));
hold on; plot((Zorzi5X), (Zorzi5Y-ZorziMin)./(ZorziMax-ZorziMin));
hold on; plot((Zorzi6X), (Zorzi6Y-ZorziMin)./(ZorziMax-ZorziMin));
hold on; plot((Zorzi7X), (Zorzi7Y-ZorziMin)./(ZorziMax-ZorziMin));
hold on; plot((Zorzi8X), (Zorzi8Y-ZorziMin)./(ZorziMax-ZorziMin));
hold on; plot((Kim1X), Kim1Y);
hold on; plot((Kim2X), Kim2Y);
hold on; plot((Kim3X), Kim3Y);
hold on; plot((Kim4X), Kim4Y);
hold on; plot((Kim5X), Kim5Y);
hold on; plot((Kim6X), Kim6Y);
hold on; plot((Kim7X), Kim7Y);
hold on; plot((Kim8X), Kim8Y);
figure
hold on; plot((PowerX32), PowerY32Norm)
hold on; plot((PowerX32), PowerY32Fit)
hold on; plot((PowerX32), LogY32Fit)
hold on; plot((PowerX32), PolyY32Fit)
axis([0 32 -0.25 1.25])
axis square
yticks([-0.25 0 0.25 0.50 0.75 1 1.25])

% Make log x
set(gca, 'Xscale', 'log')
xticks([1 2 4 8 16 32])

% For stats
for n=1:16
    if n<=8
        eval(['thisDataX=Zorzi', num2str(n), 'X;'])
        eval(['thisDataY=(Zorzi', num2str(n), 'Y-ZorziMin)./(ZorziMax-ZorziMin);'])
    else
        eval(['thisDataX=Kim', num2str(n-8), 'X;'])
        eval(['thisDataY=Kim', num2str(n-8), 'Y;'])
    end
    
    PowerFitX=[PowerY32(thisDataX)' ones(size(thisDataX))'];
    B_hat = pinv(PowerFitX)*thisDataY';
    thisDataYPredictionPower=PowerFitX*B_hat;
    RSSPower(n)=sum((thisDataYPredictionPower-thisDataY').^2);
    tmp=corrcoef(thisDataYPredictionPower, thisDataY');
    corPower(n)=tmp(1,2); %#ok<SAGROW>
    
    LogFitX=[log(thisDataX)' ones(size(thisDataX))'];
    B_hat = pinv(LogFitX)*thisDataY';
    thisDataYPredictionLog=LogFitX*B_hat;
    RSSLog(n)=sum((thisDataYPredictionLog-thisDataY').^2);
    tmp=corrcoef(thisDataYPredictionLog, thisDataY');
    corLog(n)=tmp(1,2); %#ok<SAGROW>
    
    % Refit polynomial for each iteration (overfit)
    % PolyFit2=polyfit(thisDataX, thisDataY, 2);
    % thisDataYPredictionPoly=polyval(PolyFit2, thisDataX');
    PolyFit2=[PolyY32Fit(thisDataX) ones(size(thisDataX))'];
    B_hat = pinv(PolyFit2)*thisDataY';
    thisDataYPredictionPoly=PolyFit2*B_hat;
    RSSPoly(n)=sum((thisDataYPredictionPoly-thisDataY').^2);
    tmp=corrcoef(thisDataYPredictionPoly, thisDataY');
    corPoly(n)=tmp(1,2); %#ok<SAGROW>
end

[~, pPowerLog, ~, statsPowerLog]=ttest(corPower-corLog);
tPowerLog=statsPowerLog.tstat;
[~, pPowerPoly, ~, statsPowerPoly]=ttest(corPower-corPoly);
tPowerPoly=statsPowerPoly.tstat;

% Transformation to tuning. Never figured this out, more complicated than it looks in Kim et al.
weights=0:0.1:1;
contrast=1;
for n=1:32
    for w=1:length(weights)
        x=length(weights)+1-w;
        %for x=1:length(weights)
            tunedResp(n,w)=(PowerY32Norm(n)*contrast*weights(w))+(PowerY32inv(n))*contrast*(weights(x)); %#ok<SAGROW>
        %end
    end
end
figure; plot(tunedResp)
figure; plot(squeeze(tunedResp(:,6,:)))
axis square
