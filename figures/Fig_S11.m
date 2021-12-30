%%%%%%%%%%%%%
%% Fig.S11 %%
%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Preferred tuned numerosity response by cortical distance to nearest monotonic numerosity (decreasing) response %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load data_numerosity
participantNames = {'P01', 'P02', 'P03', 'P04', 'P05', 'P06', 'P07', 'P08', 'P09', 'P10', 'P11'};

voxelSize = 1.77;
savePlots = 1;

% Correlation
groupDistances = data_numerosity.dist.group.distances';groupNumerosity = data_numerosity.dist.group.numerosities';
N = length(groupDistances);N = N/(voxelSize ^2);
[rho,pval] = corr(groupDistances,groupNumerosity,'Type','Spearman');
disp([rho,pval]);

maxDist = 30; %mm
maxRemove = find(groupDistances>=maxDist);
groupDistances(maxRemove) = [];
groupNumerosity(maxRemove) = [];

% Bin the data by distance
binsize = 2; %mm
binrange = [1 maxDist];
bins = (binrange(1):binsize:binrange(2))';

binnedDistances_mean = [];binnedDistances_sterr = [];binnedDistances_std = [];
for b = round(binrange(1):binsize:binrange(2),1)
    % Determine which distances are in each bin
    bii = groupDistances >  b-binsize./2 & groupDistances <= b+binsize./2;
    if any(bii)
        % Find which distance bin this corresponds to
        ii2 = find(round(bins,1) == b);
        currentBin = wstat(groupNumerosity(bii),[],1.77^2);
        binnedDistances_mean(:,ii2) = currentBin.mean; %#ok<SAGROW>
        binnedDistances_sterr(:,ii2) = currentBin.sterr; %#ok<SAGROW>
        binnedDistances_std(:,ii2) = currentBin.stdev; %#ok<SAGROW>
        
    else
        ii2 = find(round(bins,1) == b);
        binnedDistances_mean(:,ii2) = NaN; %#ok<SAGROW>
        binnedDistances_sterr(:,ii2) = NaN; %#ok<SAGROW>
        binnedDistances_std(:,ii2) = NaN; %#ok<SAGROW>
    end
end

figure;
% Plot individual points
participantColors = [243,195,0;135,86,146;243,132,0;
    161,202,241;190,0,50;194,178,128;
    132	132	130;0,136,86;230,143,172;
    0,103,165;249,147,121]./255;

for participant = 1:11
    distances = data_numerosity.dist.(participantNames{participant}).distances;
    numerosities = data_numerosity.dist.(participantNames{participant}).numerosities;
    
    maxRemove = find(distances>=maxDist);
    distances(maxRemove) = [];
    numerosities(maxRemove) = [];
    
    participantSample = randperm(round(length(distances)*.2));
    scatter(distances(participantSample)+.25*(2*rand-1),numerosities(participantSample),[],participantColors(participant,:),'Marker','.','MarkerFaceAlpha',1,'MarkerEdgeAlpha',1);
    hold on;
end

% Plot group means
errorbar(1:2:maxDist,binnedDistances_mean,2*binnedDistances_sterr,'Color','k','Marker','o','MarkerFaceColor','k','LineWidth',3); hold on;

axis square
xlabel('Cortical surface distance (mm)','FontWeight','bold');
ylabel('Preferred numerosity (log scale)','FontWeight','bold');
ylim([1 7]);xlim([0 maxDist]);
set(gca,'YScale','log');
set(gcf,'color','w');
box off

if savePlots;export_fig('FigS11','-png','-r600','-painters');end
