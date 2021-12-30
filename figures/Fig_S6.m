%%%%%%%%%%%%
%% Fig.S6 %%
%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Normalized BOLD response & time-series predictions (Fourier power vs. numerosity) %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('monotonicNumerosity_fourierPower_timeseriesV1-V3.mat')

predictionArea = load('predictionArea.mat');
predictionSize = load('predictionRadius.mat');
predictionPeri = load('predictionCirc.mat');
predictionDens = load('predictionDense.mat');
predictionNumber = load('predictionNumber.mat');
clear prediction

savePlots = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Constant area Fig.S6a %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

V1dataArea = mean(group.ts_data.FourierPower.NumerosityAreaL1.bothV1_V3.tSeries, 2);
params.stim.nFrames = 44*4;
params.stim.nUniqueRep = 4;
params.stim(:).nDCT = 0.5;
[trends, ~, ~] = rmMakeTrends(params);
trendBetas = pinv(trends)*V1dataArea;
V1dataAreaTmp = V1dataArea;
V1dataArea = V1dataArea - trends*trendBetas;

X = [predictionArea.prediction ones(size(predictionArea.prediction))];
betas = pinv(X)*V1dataArea;
V1predAreaPower = X*betas;
X = [predictionNumber.prediction ones(size(predictionNumber.prediction))];
betas = pinv(X)*V1dataArea;
V1predAreaNum = X*betas;

% New bit
X = [V1predAreaNum ones(size(predictionNumber.prediction))];
betas = pinv(X)*predictionNumber.prediction;
V1predAreaNum = X*betas;
X = [V1predAreaPower ones(size(predictionNumber.prediction))];
V1predAreaPower = X*betas;
X = [V1dataArea ones(size(predictionNumber.prediction))];
V1dataArea = X*betas;

figure;hold on;
x_ts = (0:43)'.*2.1;
% Get dummy axis for plotting
hTSeries = plot(x_ts, V1dataArea, '.','Color','none'); %#ok<NASGU>
hFit = plot(x_ts, V1predAreaPower, '.','Color','none'); %#ok<NASGU>
xlim([min(x_ts) max(x_ts)]);pbaspect([2.75 1 1]);
xFitaxis = get(gca);xFitaxis.XAxis.Visible = 'off';set(gca,'XColor','none','YColor','none');
xFitaxis_pos = xFitaxis.Position;
% Create x-axis
timeAxis_pos = xFitaxis_pos;timeAxis_pos(2) = timeAxis_pos(2)*2.75;timeAxis_pos(4) = 1e-12;
timeAxis = axes('Position',timeAxis_pos);timeAxis.XAxis.TickDirection = 'out';timeAxis.FontSize = 10;
xlim([min(x_ts) max(x_ts)]);xFitaxis.YAxis.Visible = 'off';xticks([0 30 60 90]);
% Create y-axis
boldAxis_pos = xFitaxis_pos;boldAxis_pos(1) = boldAxis_pos(1)*.75;
boldAxis = axes('Position',boldAxis_pos);boldAxis.YAxis.TickDirection = 'out';
plot(boldAxis,x_ts, V1dataArea, '.', 'Color','none');pbaspect(boldAxis,[2.75 1 1]);
boldAxis.XAxis.Visible = 'off';box off;boldAxis.YAxis.TickDirection = 'out';
% Create data plot
dataAxis = axes('Position',xFitaxis_pos);
% Numerosity
hFit = plot(dataAxis,x_ts, V1predAreaNum, '--', 'LineWidth', 1.5,'Color',[0,0,0]./255);hold on %#ok<NASGU>
hTSeries = plot(dataAxis,x_ts, V1dataArea, 'o', 'LineWidth', 1.5,'Color',[205,0,0]./255); %#ok<NASGU>
% Fourier power
hFit = plot(dataAxis,x_ts, V1predAreaPower, '--', 'LineWidth', 1.5,'Color',[0,205,205]./255);hold on %#ok<NASGU>
xlim([min(x_ts) max(x_ts)]);pbaspect([2.75 1 1]);
dataAxis.XAxis.Visible = 'off';dataAxis.YAxis.Visible = 'off';box off;
xlabel('Time (seconds)');
ylabel('Normalized BOLD response');
set(gcf,'color','w');
if savePlots == 1,export_fig(['Fig_S6a','.png'],'-png','-r600','-painters');end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Constant item size Fig.S6a %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

V1dataSize = mean(group.ts_data.FourierPower.NumerositySizeL1.bothV1_V3.tSeries, 2);
params.stim.nFrames = 44*4;
params.stim.nUniqueRep = 4;
params.stim(:).nDCT = 0.5;
[trends, ~, ~] = rmMakeTrends(params);
trendBetas = pinv(trends)*V1dataSize;
V1dataSizeTmp = V1dataSize;
V1dataSize = V1dataSize - trends*trendBetas;

X = [predictionSize.prediction ones(size(predictionSize.prediction))];
betas = pinv(X)*V1dataSize;
V1predSizePower = X*betas;
X = [predictionNumber.prediction ones(size(predictionNumber.prediction))];
betas = pinv(X)*V1dataSize;
V1predSizeNum = X*betas;

% New bit
X = [V1predSizeNum ones(size(predictionNumber.prediction))];
betas = pinv(X)*predictionNumber.prediction;
V1predSizeNum = X*betas;
X = [V1predSizePower ones(size(predictionNumber.prediction))];
V1predSizePower = X*betas;
X = [V1dataSize ones(size(predictionNumber.prediction))];
V1dataSize = X*betas;

figure;hold on;
x_ts = (0:43)'.*2.1;
% Get dummy axis for plotting
hTSeries = plot(x_ts, V1dataSize, '.','Color','none'); %#ok<NASGU>
hFit = plot(x_ts, V1predSizePower, '.','Color','none'); %#ok<NASGU>
xlim([min(x_ts) max(x_ts)]);pbaspect([2.75 1 1]);
xFitaxis = get(gca);xFitaxis.XAxis.Visible = 'off';set(gca,'XColor','none','YColor','none');
xFitaxis_pos = xFitaxis.Position;
% Create x-axis
timeAxis_pos = xFitaxis_pos;timeAxis_pos(2) = timeAxis_pos(2)*2.75;timeAxis_pos(4) = 1e-12;
timeAxis = axes('Position',timeAxis_pos);timeAxis.XAxis.TickDirection = 'out';timeAxis.FontSize = 10;
xlim([min(x_ts) max(x_ts)]);xFitaxis.YAxis.Visible = 'off';xticks([0 30 60 90]);
% Create y-axis
boldAxis_pos = xFitaxis_pos;boldAxis_pos(1) = boldAxis_pos(1)*.75;
boldAxis = axes('Position',boldAxis_pos);boldAxis.YAxis.TickDirection = 'out';
plot(boldAxis,x_ts, V1dataSize, '.', 'Color','none');pbaspect(boldAxis,[2.75 1 1]);
boldAxis.XAxis.Visible = 'off';box off;boldAxis.YAxis.TickDirection = 'out';
% Create data plot
dataAxis = axes('Position',xFitaxis_pos);
% Numerosity
hFit = plot(dataAxis,x_ts, V1predSizeNum, '--', 'LineWidth', 1.5,'Color',[0,0,0]./255);hold on %#ok<NASGU>
hTSeries = plot(dataAxis,x_ts, V1dataSize, 'o', 'LineWidth', 1.5,'Color',[0,205,0]./255);%#ok<NASGU>
% Fourier power
hFit = plot(dataAxis,x_ts, V1predSizePower, '--', 'LineWidth', 1.5,'Color',[0,205,205]./255);hold on %#ok<NASGU>
xlim([min(x_ts) max(x_ts)]);pbaspect([2.75 1 1]);
dataAxis.XAxis.Visible = 'off';dataAxis.YAxis.Visible = 'off';box off;
xlabel('Time (seconds)');
ylabel('Normalized BOLD response');
set(gcf,'color','w');
if savePlots == 1,export_fig(['Fig_S6b','.png'],'-png','-r600','-painters');end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Constant perimeter Fig.S6c %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

V1dataPeri = mean(group.ts_data.FourierPower.NumerosityPeriL1.bothV1_V3.tSeries, 2);
params.stim.nFrames = 44*4;
params.stim.nUniqueRep = 4;
params.stim(:).nDCT = 0.5;
[trends, ~, ~] = rmMakeTrends(params);
trendBetas = pinv(trends)*V1dataPeri;
V1dataPeriTmp = V1dataPeri;
V1dataPeri = V1dataPeri - trends*trendBetas;

X = [predictionPeri.prediction ones(size(predictionPeri.prediction))];
betas = pinv(X)*V1dataPeri;
V1predPeriPower = X*betas;
X = [predictionNumber.prediction ones(size(predictionNumber.prediction))];
betas = pinv(X)*V1dataPeri;
V1predPeriNum = X*betas;

% New bit
X = [V1predPeriNum ones(size(predictionNumber.prediction))];
betas = pinv(X)*predictionNumber.prediction;
V1predPeriNum = X*betas;
X = [V1predPeriPower ones(size(predictionNumber.prediction))];
V1predPeriPower = X*betas;
X = [V1dataPeri ones(size(predictionNumber.prediction))];
V1dataPeri = X*betas;

figure;hold on;
x_ts = (0:43)'.*2.1;
% Get dummy axis for plotting
hTSeries = plot(x_ts, V1dataPeri, '.','Color','none'); %#ok<NASGU>
hFit = plot(x_ts, V1predPeriPower, '.','Color','none'); %#ok<NASGU>
xlim([min(x_ts) max(x_ts)]);pbaspect([2.75 1 1]);
xFitaxis = get(gca);xFitaxis.XAxis.Visible = 'off';set(gca,'XColor','none','YColor','none');
xFitaxis_pos = xFitaxis.Position;
% Create x-axis
timeAxis_pos = xFitaxis_pos;timeAxis_pos(2) = timeAxis_pos(2)*2.75;timeAxis_pos(4) = 1e-12;
timeAxis = axes('Position',timeAxis_pos);timeAxis.XAxis.TickDirection = 'out';timeAxis.FontSize = 10;
xlim([min(x_ts) max(x_ts)]);xFitaxis.YAxis.Visible = 'off';xticks([0 30 60 90]);
% Create y-axis
boldAxis_pos = xFitaxis_pos;boldAxis_pos(1) = boldAxis_pos(1)*.75;
boldAxis = axes('Position',boldAxis_pos);boldAxis.YAxis.TickDirection = 'out';
plot(boldAxis,x_ts, V1dataPeri, '.', 'Color','none');pbaspect(boldAxis,[2.75 1 1]);
boldAxis.XAxis.Visible = 'off';box off;boldAxis.YAxis.TickDirection = 'out';
% Create data plot
dataAxis = axes('Position',xFitaxis_pos);
% Numerosity
hFit = plot(dataAxis,x_ts, V1predPeriNum, '--', 'LineWidth', 1.5,'Color',[0,0,0]./255);hold on %#ok<NASGU>
hTSeries = plot(dataAxis,x_ts, V1dataPeri, 'o', 'LineWidth', 1.5,'Color',[0,0,205]./255); %#ok<NASGU>
% Fourier power
hFit = plot(dataAxis,x_ts, V1predPeriPower, '--', 'LineWidth', 1.5,'Color',[0,205,205]./255);hold on %#ok<NASGU>
xlim([min(x_ts) max(x_ts)]);pbaspect([2.75 1 1]);
dataAxis.XAxis.Visible = 'off';dataAxis.YAxis.Visible = 'off';box off;
xlabel('Time (seconds)');
ylabel('Normalized BOLD response');
set(gcf,'color','w');
if savePlots == 1,export_fig(['Fig_S6c','.png'],'-png','-r600','-painters');end

%%%%%%%%%%%%%%%%%%%%%%%%%%
%% High density Fig.S6d %%
%%%%%%%%%%%%%%%%%%%%%%%%%%

V1dataDens = mean(group.ts_data.FourierPower.NumerosityDensL1.bothV1_V3.tSeries, 2);
params.stim.nFrames = 44*4;
params.stim.nUniqueRep = 4;
params.stim(:).nDCT = 0.5;
[trends, ~, ~] = rmMakeTrends(params);
trendBetas = pinv(trends)*V1dataDens;
V1dataDensTmp = V1dataDens;
V1dataDens = V1dataDens - trends*trendBetas;

X = [predictionDens.prediction ones(size(predictionDens.prediction))];
betas = pinv(X)*V1dataDens;
V1predDensPower = X*betas;
X = [predictionNumber.prediction ones(size(predictionNumber.prediction))];
betas = pinv(X)*V1dataDens;
V1predDensNum = X*betas;

% New bit
X = [V1predDensNum ones(size(predictionNumber.prediction))];
betas = pinv(X)*predictionNumber.prediction;
V1predDensNum = X*betas;
X = [V1predDensPower ones(size(predictionNumber.prediction))];
V1predDensPower = X*betas;
X = [V1dataDens ones(size(predictionNumber.prediction))];
V1dataDens = X*betas;

figure;hold on;
x_ts = (0:43)'.*2.1;
% Get dummy axis for plotting
hTSeries = plot(x_ts, V1dataDens, '.','Color','none'); %#ok<NASGU>
hFit = plot(x_ts, V1predDensPower, '.','Color','none'); %#ok<NASGU>
xlim([min(x_ts) max(x_ts)]);pbaspect([2.75 1 1]);
xFitaxis = get(gca);xFitaxis.XAxis.Visible = 'off';set(gca,'XColor','none','YColor','none');
xFitaxis_pos = xFitaxis.Position;
% Create x-axis
timeAxis_pos = xFitaxis_pos;timeAxis_pos(2) = timeAxis_pos(2)*2.75;timeAxis_pos(4) = 1e-12;
timeAxis = axes('Position',timeAxis_pos);timeAxis.XAxis.TickDirection = 'out';timeAxis.FontSize = 10;
xlim([min(x_ts) max(x_ts)]);xFitaxis.YAxis.Visible = 'off';xticks([0 30 60 90]);
% Create y-axis
boldAxis_pos = xFitaxis_pos;boldAxis_pos(1) = boldAxis_pos(1)*.75;
boldAxis = axes('Position',boldAxis_pos);boldAxis.YAxis.TickDirection = 'out';
plot(boldAxis,x_ts, V1dataDens, '.', 'Color','none');pbaspect(boldAxis,[2.75 1 1]);
boldAxis.XAxis.Visible = 'off';box off;boldAxis.YAxis.TickDirection = 'out';
% Create data plot
dataAxis = axes('Position',xFitaxis_pos);
% Numerosity
hFit = plot(dataAxis,x_ts, V1predDensNum, '--', 'LineWidth', 1.5,'Color',[0,0,0]./255);hold on %#ok<NASGU>
hTSeries = plot(dataAxis,x_ts, V1dataDens, 'o', 'LineWidth', 1.5,'Color',[205,0,205]./255);
% Fourier power
hFit = plot(dataAxis,x_ts, V1predDensPower, '--', 'LineWidth', 1.5,'Color',[0,205,205]./255);hold on
xlim([min(x_ts) max(x_ts)]);pbaspect([2.75 1 1]);
dataAxis.XAxis.Visible = 'off';dataAxis.YAxis.Visible = 'off';box off;
xlabel('Time (seconds)');
ylabel('Normalized BOLD response');
set(gcf,'color','w');
if savePlots == 1,export_fig(['Fig_S6d','.png'],'-png','-r600','-painters');end
