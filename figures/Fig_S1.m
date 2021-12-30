%%%%%%%%%%%%
%% Fig.S1 %%
%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Normalized BOLD response & time-series predictions (increasing, decreasing, tuned) %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Time-series & model predictions provided here because whole structure cannot be shared
savePlots = 1;participant = 1;
increasingVoxel = 223242;decreasingVoxel = 41063;tunedVoxel = 254574; 

increase_predictions = ...
[405.5008;176.5875;-98.6820; -263.0622; -344.6168; -355.4561; -334.6002; -283.1456;
 -221.3007; -146.6400;-78.7864;-17.0262; 27.5862; 62.1538; 82.4406;159.5898;
  239.6465;290.7545;314.3567;319.3995;312.5805;297.7597;277.7285;184.4466;
   78.9919;-10.4403;-72.7369; -121.7008; -153.1219; -181.9214; -198.5369; -218.0146;
 -229.7545; -258.1531; -283.3360; -341.4211; -396.0633; -225.2510;  2.3826;176.9270;
  288.7706;354.5971;387.5184;394.0432];

increase_tSeries = ...
[431.2039;366.8527; 90.6536; -225.8414; -334.3449; -415.9317; -300.9772; -243.5169;
 -181.7484; -172.4069; -165.7417; 18.4418;  4.3106; 21.4520; 46.5168; 49.2093;
  316.4247;337.0608;360.7746;291.7658;301.0752;306.9504;219.3746;186.5780;
   51.7438;-51.8167;-22.3793; -118.5186; -136.8062; -212.7503; -263.6690; -329.9426;
 -376.6060; -340.8278; -334.1899; -293.0516; -342.8123; -182.8462;154.7968;274.2617;
  339.7074;285.8912;330.3317;261.3487];

decrease_predictions = ...
[-2926.9792;-1274.6411;712.3043; 1898.8302;2487.5068;2565.7460;2415.2050;2043.7962;
1597.3885;1058.4741;568.6940;122.8979;-199.1230;-448.6379;-595.0715;-1151.9482;
-1729.8125;-2098.7199;-2269.0847;-2305.4841;-2256.2634;-2149.2844;-2004.6953;-1331.3696;
-570.1779;75.3593;525.0275;878.4581;1105.2613;1313.1411;1433.0753;1573.6685;
1658.4090;1863.3957;2045.1706;2464.4396;2858.8569;1625.9023;-17.1984;-1277.0915;
-2084.3991;-2559.5471;-2797.1789;-2844.2761];

decrease_tSeries = ...
[-2252.9223;-1150.0331; 776.0337; 1926.1898;2177.4479; 2359.5579;  2111.8032; 1709.3434;
1398.2652; 1185.7702; 173.9024; -331.0491;-707.2531;-517.7192;-603.6635;-724.0460;
-1418.9512;-2279.7021;-2372.0861;-2322.8344;-2396.7032;-2568.7714; -2257.3090;-1873.2288;
-989.0449; 16.2262; 414.7661; 904.5347;913.0612; 1223.8115; 1334.8887; 1304.3874;
1642.6561; 2068.2474; 2687.6394; 3234.2811;3246.9490; 2612.5107; 216.9064;-1639.8917;
-2300.6004;-2252.4053;-2144.9613;-2536.0038];

tuned_predictions = ...
[-950.7880;-778.5397;-396.7812;60.5417;627.1555;1026.6660;1250.5986;1283.9760;
1190.8872;1026.3894;836.2919;670.9338;518.2288;395.8930;279.2669;-48.7299;
-706.5556;-1150.9924;-1322.9642;-1345.5156;-1267.7973;-1128.9616;-1016.5192;-693.7808;
-26.2066;480.1914;775.5651;933.9169;1001.2277;982.8676;980.4826;989.3762;
1000.1770;943.5002;802.4309;505.2745;-1.2863;-502.5552;-1020.0134;-1305.7467;
-1362.4095;-1292.0704;-1178.3187;-1065.3127];

tuned_tSeries = ...
[-1212.7750;-1049.9247;-696.8620;-291.8322;396.2794;880.2684;974.5365;997.3738;
836.5882;706.0445;647.8761;439.1733;385.1793;395.8413;235.3863;11.7119;
-595.1942;-1255.6094;-1392.2701;-1403.9133;-1287.3583;-1411.2746;-1164.9703;-971.5781;
-176.0543;397.9664;1015.2941;1286.8671;1279.6093;1276.8491;1184.7456;1071.2162;
1157.9643;1227.7967;1220.5424;979.6315;265.4201;-442.8479;-821.3962;-1093.3877;
-1113.3111;-1063.1837;-812.8788;-1013.5403];

%% Monotonic numerosity response model time-series
% Plot together
figure;hold on;
x_ts = (0:43)'.*2.1;
% Get dummy axis for plotting
hTSeries = plot(x_ts, zscore(increase_tSeries), '.','Color','none'); %#ok<NASGU>
hFit = plot(x_ts, zscore(increase_predictions), '.','Color','none'); %#ok<NASGU>
xlim([min(x_ts) max(x_ts)]);boldYLim=ylim;pbaspect([2.75 1 1]);
xFitaxis = get(gca);xFitaxis.XAxis.Visible='off';set(gca,'XColor','none','YColor','none');
xFitaxis_pos = xFitaxis.Position;

% Create x-axis
timeAxis_pos=xFitaxis_pos;timeAxis_pos(2)=timeAxis_pos(2)*2.75;timeAxis_pos(4)=1e-12;
timeAxis=axes('Position',timeAxis_pos);timeAxis.XAxis.TickDirection='out';
xlim([min(x_ts) max(x_ts)]);xFitaxis.YAxis.Visible='off';xticks([0 30 60 90]);
% Create y-axis
boldAxis_pos = xFitaxis_pos;boldAxis_pos(1)=boldAxis_pos(1)*.75;
boldAxis=axes('Position',boldAxis_pos);boldAxis.YAxis.TickDirection='out';
plot(boldAxis,x_ts, zscore(increase_tSeries), '.', 'Color','none');pbaspect(boldAxis,[2.75 1 1]);
boldAxis.XAxis.Visible='off';box off;boldAxis.YAxis.TickDirection='out';
% Create data plot
dataAxis=axes('Position',xFitaxis_pos);
% Increasing
hFit = plot(dataAxis,x_ts, zscore(increase_predictions), ':', 'LineWidth', 1.5,'Color',[0,0,205]./255);hold on %#ok<NASGU>
hTSeries = plot(dataAxis,x_ts, zscore(increase_tSeries), 'o', 'LineWidth', 1.5,'Color',[0,0,205]./255); %#ok<NASGU>
% Decreasing
hFit = plot(dataAxis,x_ts, zscore(decrease_predictions), ':', 'LineWidth', 1.5,'Color',[0,205,0]./255);hold on %#ok<NASGU>
hTSeries = plot(dataAxis,x_ts, zscore(decrease_tSeries), 'o', 'LineWidth', 1.5,'Color',[0,205,0]./255); %#ok<NASGU>
xlim([min(x_ts) max(x_ts)]);pbaspect([2.75 1 1]);
dataAxis.XAxis.Visible='off';dataAxis.YAxis.Visible='off';box off;
xlabel('Time (seconds)');
ylabel('Normalized BOLD response');
set(gcf,'color','w');
if savePlots==1,export_fig('Fig_S1c.png','-png','-r600','-painters');end

%% Tuned numerosity response model time-series
figure;
x_ts = (0:43)'.*2.1;
% Get dummy axis for plotting
hTSeries = plot(x_ts, zscore(tuned_tSeries), '.','Color','none'); %#ok<NASGU>
hFit = plot(x_ts, zscore(tuned_predictions), '.','Color','none'); %#ok<NASGU>
xlim([min(x_ts) max(x_ts)]);pbaspect([2.75 1 1]);
xFitaxis = get(gca);xFitaxis.XAxis.Visible='off';set(gca,'XColor','none','YColor','none');
xFitaxis_pos = xFitaxis.Position;
% Create x-axis
timeAxis_pos=xFitaxis_pos;timeAxis_pos(2)=timeAxis_pos(2)*2.75;timeAxis_pos(4)=1e-12;
timeAxis=axes('Position',timeAxis_pos);timeAxis.XAxis.TickDirection='out';
xlim([min(x_ts) max(x_ts)]);xFitaxis.YAxis.Visible='off';xticks([0 30 60 90]);
% Create y-axis
boldAxis_pos = xFitaxis_pos;boldAxis_pos(1)=boldAxis_pos(1)*.75;
boldAxis=axes('Position',boldAxis_pos);boldAxis.YAxis.TickDirection='out';
plot(boldAxis,x_ts, zscore(tuned_tSeries), '.', 'Color','none');pbaspect(boldAxis,[2.75 1 1]);
boldAxis.XAxis.Visible='off';box off;boldAxis.YAxis.TickDirection='out';
% Create data plot
dataAxis=axes('Position',xFitaxis_pos);
hFit = plot(dataAxis,x_ts, zscore(tuned_predictions), ':', 'LineWidth', 1.5,'Color',[205,0,0]./255);hold on
hTSeries = plot(dataAxis,x_ts, zscore(tuned_tSeries), 'o', 'LineWidth', 1.5,'Color',[205,0,0]./255);
xlim([min(x_ts) max(x_ts)]);pbaspect([2.75 1 1]);
dataAxis.XAxis.Visible='off';dataAxis.YAxis.Visible='off';box off;
xlabel('Time (seconds)');
ylabel('Normalized BOLD response');
set(gcf,'color','w');
if savePlots==1,export_fig('Fig_S1d.png','-png','-r600','-painters');end
