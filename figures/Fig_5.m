%%%%%%%%%%%
%% Fig.5 %%
%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Monotonic model comparisons by all data-types (Fig.5A) %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load data_numerosity

participantOrder=["P01", "P02", "P03", "P04", "P05"];
plotOn=1;
mapNames="All";
clear modelNamesAll
modelNamesAll{1}=["logNumber", "logAggFourierPower", "logItemArea", "logItemRadius", "logTotalArea", "TotalCirc", "HullArea", "HullLength", "logLuminanceDensity", "logEdgeDensity", "NumberDensity", "DisplayRMS", "logHullRMS", "logSumLum", "logSumEdges"];
modelNamesAll=modelNamesAll{1};
veThresh=0.2; %#ok<NASGU>
hemiNames = ["Left","Right"];
oddEvenNames = ["Even","Odd"];
colIndx=[1,2;3,4];

fig5All_logNumber_all=[]; fig5All_logAggFourierPower_all=[]; fig5All_logItemArea_all=[];
fig5All_logItemRadius_all=[]; fig5All_logTotalArea_all=[]; fig5All_TotalCirc_all=[];
fig5All_HullArea_all=[]; fig5All_HullLength_all=[]; fig5All_logLuminanceDensity_all=[];
fig5All_logEdgeDensity_all=[]; fig5All_NumberDensity_all=[]; fig5All_DisplayRMS_all=[];
fig5All_logHullRMS_all=[]; fig5All_logSumLum_all=[]; fig5All_logSumEdges_all=[];

fig5All_logNumber_median=[]; fig5All_logAggFourierPower_median=[]; fig5All_logItemArea_median=[];
fig5All_logItemRadius_median=[]; fig5All_logTotalArea_median=[]; fig5All_TotalCirc_median=[];
fig5All_HullArea_median=[]; fig5All_HullLength_median=[]; fig5All_logLuminanceDensity_median=[];
fig5All_logEdgeDensity_median=[]; fig5All_NumberDensity_median=[]; fig5All_DisplayRMS_median=[];
fig5All_logHullRMS_median=[]; fig5All_logSumLum_median=[]; fig5All_logSumEdges_median=[];

for models = 1:length(modelNamesAll)
    for hemis = 1:2
        for participants = 1:5
            for modelsIdx = 1:length(modelNamesAll)
                eval(['vesEven_',modelNamesAll{modelsIdx},'=1-(sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{modelsIdx},'.All',...
                    oddEvenNames{1},'.VFMAll.',hemiNames{hemis},'.rssAll)./sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{modelsIdx},'.All',...
                    oddEvenNames{1},'.VFMAll.',hemiNames{hemis},'.rawrssAll));']);
                eval(['vesOdd_',modelNamesAll{modelsIdx},'=1-(sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{modelsIdx},'.All',...
                    oddEvenNames{2},'.VFMAll.',hemiNames{hemis},'.rssAll)./sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{modelsIdx},'.All',...
                    oddEvenNames{2},'.VFMAll.',hemiNames{hemis},'.rawrssAll));']);
                
                eval(['vesEven_',modelNamesAll{modelsIdx},'(~isfinite(vesEven_',modelNamesAll{modelsIdx},'))=0;']);
                eval(['vesEven_',modelNamesAll{modelsIdx},'=max(vesEven_',modelNamesAll{modelsIdx},',0);']);
                eval(['vesEven_',modelNamesAll{modelsIdx},'=min(vesEven_',modelNamesAll{modelsIdx},',1);']);
                
                eval(['vesOdd_',modelNamesAll{modelsIdx},'(~isfinite(vesOdd_',modelNamesAll{modelsIdx},'))=0;']);
                eval(['vesOdd_',modelNamesAll{modelsIdx},'=max(vesOdd_',modelNamesAll{modelsIdx},',0);']);
                eval(['vesOdd_',modelNamesAll{modelsIdx},'=min(vesOdd_',modelNamesAll{modelsIdx},',1);']);
                
                eval([modelNamesAll{modelsIdx},'VoxelsOdd=find(vesOdd_',modelNamesAll{modelsIdx},'>veThresh);']);
                eval([modelNamesAll{modelsIdx},'VoxelsEven=find(vesEven_',modelNamesAll{modelsIdx},'>veThresh);']);
            end
            voxelSelect_even=unique([logNumberVoxelsEven, logAggFourierPowerVoxelsEven, logItemAreaVoxelsEven,...
                logItemRadiusVoxelsEven, logTotalAreaVoxelsEven, TotalCircVoxelsEven, ...
                HullAreaVoxelsEven, HullLengthVoxelsEven, logLuminanceDensityVoxelsEven, ...
                logEdgeDensityVoxelsEven, NumberDensityVoxelsEven, DisplayRMSVoxelsEven, ...
                logHullRMSVoxelsEven, logSumLumVoxelsEven, logSumEdgesVoxelsEven]);
            
            voxelSelect_odd=unique([logNumberVoxelsOdd, logAggFourierPowerVoxelsOdd, logItemAreaVoxelsOdd,...
                logItemRadiusVoxelsOdd, logTotalAreaVoxelsOdd, TotalCircVoxelsOdd, ...
                HullAreaVoxelsOdd, HullLengthVoxelsOdd, logLuminanceDensityVoxelsOdd, ...
                logEdgeDensityVoxelsOdd, NumberDensityVoxelsOdd, DisplayRMSVoxelsOdd, ...
                logHullRMSVoxelsOdd, logSumLumVoxelsOdd, logSumEdgesVoxelsOdd]);
            
            eval(['vesEven_',modelNamesAll{models},'=1-(sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{models},...
                '.All',oddEvenNames{1},'.VFMAll.',hemiNames{hemis},'.rssAll)./sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{models},...
                '.All',oddEvenNames{1},'.VFMAll.',hemiNames{hemis},'.rawrssAll));']);
            eval(['vesOdd_',modelNamesAll{models},'=1-(sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{models},...
                '.All',oddEvenNames{2},'.VFMAll.',hemiNames{hemis},'.rssAll)./sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{models},...
                '.All',oddEvenNames{2},'.VFMAll.',hemiNames{hemis},'.rawrssAll));']);
            eval(['vesXvalEven_',modelNamesAll{models},'=1-(sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{models},...
                '.All',oddEvenNames{1},'.VFMAll.',hemiNames{hemis},'.rssXvalAll)./sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{models},...
                '.All',oddEvenNames{1},'.VFMAll.',hemiNames{hemis},'.rawrssXvalAll));']);
            eval(['vesXvalOdd_',modelNamesAll{models},'=1-(sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{models},...
                '.All',oddEvenNames{2},'.VFMAll.',hemiNames{hemis},'.rssXvalAll)./sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{models},...
                '.All',oddEvenNames{2},'.VFMAll.',hemiNames{hemis},'.rawrssXvalAll));']);
            
            eval(['vesEven_',modelNamesAll{models},'(~isfinite(vesEven_',modelNamesAll{models},'))=0;']);
            eval(['vesEven_',modelNamesAll{models},'=max(vesEven_',modelNamesAll{models},',0);']);
            eval(['vesEven_',modelNamesAll{models},'=min(vesEven_',modelNamesAll{models},',1);']);
            
            eval(['vesOdd_',modelNamesAll{models},'(~isfinite(vesOdd_',modelNamesAll{models},'))=0;']);
            eval(['vesOdd_',modelNamesAll{models},'=max(vesOdd_',modelNamesAll{models},',0);']);
            eval(['vesOdd_',modelNamesAll{models},'=min(vesOdd_',modelNamesAll{models},',1);']);
            
            eval(['vesXvalEven_',modelNamesAll{models},'(~isfinite(vesXvalEven_',modelNamesAll{models},'))=0;']);
            eval(['vesXvalEven_',modelNamesAll{models},'=max(vesXvalEven_',modelNamesAll{models},',0);']);
            eval(['vesXvalEven_',modelNamesAll{models},'=min(vesXvalEven_',modelNamesAll{models},',1);']);
            
            eval(['vesXvalOdd_',modelNamesAll{models},'(~isfinite(vesXvalOdd_',modelNamesAll{models},'))=0;']);
            eval(['vesXvalOdd_',modelNamesAll{models},'=max(vesXvalOdd_',modelNamesAll{models},',0);']);
            eval(['vesXvalOdd_',modelNamesAll{models},'=min(vesXvalOdd_',modelNamesAll{models},',1);']);
            
            eval(['fig5All_',modelNamesAll{models},'_median(',num2str(participants),',',num2str(colIndx(hemis,1)),...
                ')=median(vesXvalEven_',modelNamesAll{models},'(voxelSelect_even));']);
            eval(['fig5All_',modelNamesAll{models},'_all=[fig5All_',modelNamesAll{models},'_all,'...
                'vesXvalEven_',modelNamesAll{models},'(voxelSelect_even)];']);
            eval(['fig5All_',modelNamesAll{models},'_median(',num2str(participants),',',num2str(colIndx(hemis,2)),...
                ')=median(vesXvalOdd_',modelNamesAll{models},'(voxelSelect_odd));']);
            eval(['fig5All_',modelNamesAll{models},'_all=[fig5All_',modelNamesAll{models},'_all,'...
                'vesXvalOdd_',modelNamesAll{models},'(voxelSelect_odd)];']);
        end
    end
end

% black = Left, grey = Right
% odd = filled, even = empty
leftRight_color=[0,0,0;128,128,128]./255;
subject_shape=["o","^","s","d","p"];
modelScatter = ["logNumber", "logAggFourierPower", "logItemArea", "logItemRadius", "logTotalArea", ...
    "TotalCirc", "HullArea", "HullLength", "logLuminanceDensity", "logEdgeDensity", "NumberDensity", ...
    "DisplayRMS", "logHullRMS", "logSumLum", "logSumEdges"];

% Plots bar chart and pairwise differences between candidate model fits.
barPoints=[];barMeans=[];CI95=[];barStd=[];barSerr=[];
whichBars=1:length(modelNamesAll);
for n=1:length(whichBars)
    if strcmp(char(mapNames),'All')        
        eval(['tmp=fig5All_',modelScatter{n},'_median(:,:);']);
        tmp=(tmp(:));
        tmp=tmp(~isnan(tmp));
        barMeans(n)=nanmean(tmp); %#ok<SAGROW>
        barStd(n)=std(tmp); %#ok<SAGROW>
        barSerr(n)=std(tmp)/sqrt(length(tmp)); %#ok<SAGROW>
        barPoints(1:length(tmp),n)=tmp; %#ok<SAGROW>
        CI95(n,:) = tinv([0.025 0.975], length(tmp)-1); %#ok<SAGROW>
        CI95(n,:) =bsxfun(@times, barSerr(n), CI95(n,:)); %#ok<SAGROW>
    else
        tmp=barDataMeans(:, :, :, :,whichBars(n));
        tmp2=[];
        for jj=1:whichHemi
            for kk=1:oddEven
                tmp2=[tmp2;tmp(:,:,kk,jj)]; %#ok<AGROW>
            end
        end
        tmp=tmp2;
        barMeans(n,:)=nanmean(tmp); %#ok<SAGROW>
        barStd(n,:)=nanstd(tmp); %#ok<SAGROW>
        barSerr(n,:)=nanstd(tmp)/sqrt(length(tmp)); %#ok<SAGROW>
        barPoints(:,:,n)=tmp; %#ok<SAGROW>
        CI95_t(n,:) = tinv([0.025 0.975], length(tmp)-1); %#ok<SAGROW>
        CI95(:,:,n) =bsxfun(@times, barSerr(n,:)', CI95_t(n,:)); %#ok<SAGROW>
    end
end

figure;
hold on;
if strcmp(char(mapNames),'All')
    for ii=1:length(barMeans)
        b=bar(ii,barMeans(ii),'LineWidth',1);
        if ii==1 % numerosity
            b.FaceColor = [.4 .4 .4];
        else
            b.FaceColor = [.8 .8 .8];
        end
    end
else
    b=bar(barMeans,'LineWidth',1);
    b(1).FaceColor=V1_V3colors(1,:);
    b(2).FaceColor=V1_V3colors(2,:);
    b(3).FaceColor=V1_V3colors(3,:);
    
end
for ii=1:length(barMeans)
    if strcmp(char(mapNames),'All')
        b=bar(ii,barMeans(ii),'LineWidth',1);
    else
        b=bar(barMeans,'LineWidth',1);
    end
    if ii==1 % Numerosity
        if strcmp(char(mapNames),'All')
            b.FaceColor = [.4 .4 .4];
        else
            b.FaceColor = V1_V3colors;
        end
    elseif ii>13 % Position selective
        if strcmp(char(mapNames),'All')
            b.FaceColor = [.9 .9 .9];
        else
            b.FaceColor = V1_V3colors;
            b.FaceAlpha = .75;
        end
    else
        if strcmp(char(mapNames),'All')
            b.FaceColor = [.8 .8 .8];
        else
            b.FaceColor = V1_V3colors;
            b.FaceAlpha = .75;
        end
    end
end
hold on; errorbar(1:size(barMeans,2), barMeans, CI95(:,1), CI95(:,2), 'k.','LineWidth',1);
plot([0,length(barMeans)+1],[barMeans(1),barMeans(1)],'--r','LineWidth',1.5);

% Individual data scatter
for participants=1:5
    
    % Left Even
    scatter([1:size(barMeans,2)]-.3,...
        [fig5All_logNumber_median(participants,1),fig5All_logAggFourierPower_median(participants,1),fig5All_logItemArea_median(participants,1),...
        fig5All_logItemRadius_median(participants,1),fig5All_logTotalArea_median(participants,1),fig5All_TotalCirc_median(participants,1),...
        fig5All_HullArea_median(participants,1),fig5All_HullLength_median(participants,1),fig5All_logLuminanceDensity_median(participants,1),...
        fig5All_logEdgeDensity_median(participants,1),fig5All_NumberDensity_median(participants,1),fig5All_DisplayRMS_median(participants,1),...
        fig5All_logHullRMS_median(participants,1),fig5All_logSumLum_median(participants,1),fig5All_logSumEdges_median(participants,1)],...
        42,subject_shape{participants},'filled','MarkerFaceColor',leftRight_color(1,:),'MarkerEdgeColor',leftRight_color(1,:),...
        'LineWidth',1);hold on %#ok<NBRAK>
    
    % Left Odd
    scatter([1:size(barMeans,2)]-.1,...
        [fig5All_logNumber_median(participants,2),fig5All_logAggFourierPower_median(participants,2),fig5All_logItemArea_median(participants,2),...
        fig5All_logItemRadius_median(participants,2),fig5All_logTotalArea_median(participants,2),fig5All_TotalCirc_median(participants,2),...
        fig5All_HullArea_median(participants,2),fig5All_HullLength_median(participants,2),fig5All_logLuminanceDensity_median(participants,2),...
        fig5All_logEdgeDensity_median(participants,2),fig5All_NumberDensity_median(participants,2),fig5All_DisplayRMS_median(participants,2),...
        fig5All_logHullRMS_median(participants,2),fig5All_logSumLum_median(participants,2),fig5All_logSumEdges_median(participants,2)],...
        42,subject_shape{participants},'MarkerEdgeColor',leftRight_color(1,:),'LineWidth',1);hold on %#ok<NBRAK>
    
    % Right Even
    scatter([1:size(barMeans,2)]+.1,...
        [fig5All_logNumber_median(participants,3),fig5All_logAggFourierPower_median(participants,3),fig5All_logItemArea_median(participants,3),...
        fig5All_logItemRadius_median(participants,3),fig5All_logTotalArea_median(participants,3),fig5All_TotalCirc_median(participants,3),...
        fig5All_HullArea_median(participants,3),fig5All_HullLength_median(participants,3),fig5All_logLuminanceDensity_median(participants,3),...
        fig5All_logEdgeDensity_median(participants,3),fig5All_NumberDensity_median(participants,3),fig5All_DisplayRMS_median(participants,3),...
        fig5All_logHullRMS_median(participants,3),fig5All_logSumLum_median(participants,3),fig5All_logSumEdges_median(participants,3)],...
        42,subject_shape{participants},'filled','MarkerFaceColor',leftRight_color(2,:),'MarkerEdgeColor',leftRight_color(2,:),...
        'LineWidth',1);hold on %#ok<NBRAK>
    
    % Right Odd
    scatter([1:size(barMeans,2)]+.3,...
        [fig5All_logNumber_median(participants,4),fig5All_logAggFourierPower_median(participants,4),fig5All_logItemArea_median(participants,4),...
        fig5All_logItemRadius_median(participants,4),fig5All_logTotalArea_median(participants,4),fig5All_TotalCirc_median(participants,4),...
        fig5All_HullArea_median(participants,4),fig5All_HullLength_median(participants,4),fig5All_logLuminanceDensity_median(participants,4),...
        fig5All_logEdgeDensity_median(participants,4),fig5All_NumberDensity_median(participants,4),fig5All_DisplayRMS_median(participants,4),...
        fig5All_logHullRMS_median(participants,4),fig5All_logSumLum_median(participants,4),fig5All_logSumEdges_median(participants,4)],...
        42,subject_shape{participants},'MarkerEdgeColor',leftRight_color(2,:),'LineWidth',1);hold on %#ok<NBRAK> 
end

xlim([0.5 length(barMeans)+0.5]);
ylim([0 0.65]);
barNames_1={'Numerosity', 'Fourier power', 'Individual', 'Individual', 'Total item', 'Total item', 'Convex hull', 'Convex hull', 'Luminance', 'Edge', 'Numerical', 'Display RMS', 'Convex hull', 'Luminance', 'Contrast'};
barNames_2={'', '', 'item area', 'item perimeter', 'area', 'radius', 'area', 'perimeter', 'density', 'density', 'density', 'contrast', 'RMS contrast', '(dot positions)', '(edge positions)'};
barNames_array = [barNames_1;barNames_2];
tickLabels = strtrim(sprintf('%s\\newline%s\n',barNames_array{:}));
ax=gca();
ax.XTick=1:length(barMeans);
ax.XTickLabel=tickLabels;xtickangle(-90);
yticks(0:.1:.6);yticklabels({'0','0.1','0.2','0.3','0.4','0.5','0.6'})
set(gcf,'Color','w');box off
xlabel('Monotonic models        Visual position selective pRF models','FontWeight','bold');
ylabel({'Response model fit (R^2)'},'FontWeight','bold');
set(gcf,'units','centimeters','position',[0.1 0.1 24 12]);
if plotOn
    export_fig(['Fig5a','.png'],'-png','-r600','-painters');
end

% Compute t-statistics and corresponding probabilities of pairwise differences between model fits
tMatrix=[];pvals=[];
for x=1:length(whichBars)
    for y=1:length(whichBars)
        % Wilcoxon
        x_wilcoxon = barPoints(:,x);y_wilcoxon = barPoints(:,y);
        zval_removeX = find(x_wilcoxon==0);zval_removeY = find(y_wilcoxon==0);
        zval_remove = union(zval_removeX,zval_removeY);
        x_wilcoxon(zval_remove)=[];y_wilcoxon(zval_remove)=[];
        [p_ztest,~,stats_ztest] = signrank(x_wilcoxon, y_wilcoxon, 'method','approximate');
        pvals(x,y)=p_ztest; %#ok<SAGROW>
        if x==y
            tMatrix(x,y)=NaN; %#ok<SAGROW>
        else
            tMatrix(x,y)=stats_ztest.zval; %#ok<SAGROW>
        end
    end
end
tMatrix(tMatrix>200)=200;
tMatrix(tMatrix<-200)=-200;

disp(tMatrix(2:end,1));
[~, ~, ~, adj_p]=fdr_bh(pvals(2:end,1));
disp(adj_p);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Tuned numerosity & aggregate Fourier power model comparisons by all data-types (Fig.5B) %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mapNames="All";
clear modelNamesAll
modelNamesAll{1}=["logNumber", "logAggFourierPower"];
modelNamesAll=modelNamesAll{1};
veThresh=0.2;
hemiNames = ["Left","Right"];
oddEvenNames = ["Even","Odd"];
colIndx=[1,2;3,4];

fig5All_num_all=[];fig5All_fp_all=[];

for hemis = 1:2
    for participants = 1:5
        % Numerosity
        eval(['vesEven_num=1-(sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{1},...
            '.All',oddEvenNames{1},'.NumAll.',hemiNames{hemis},'.rssAll)./sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{1},...
            '.All',oddEvenNames{1},'.NumAll.',hemiNames{hemis},'.rawrssAll));']);
        eval(['vesOdd_num=1-(sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{1},...
            '.All',oddEvenNames{2},'.NumAll.',hemiNames{hemis},'.rssAll)./sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{1},...
            '.All',oddEvenNames{2},'.NumAll.',hemiNames{hemis},'.rawrssAll));']);
        eval(['vesXvalEven_num=1-(sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{1},...
            '.All',oddEvenNames{1},'.NumAll.',hemiNames{hemis},'.rssXvalAll)./sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{1},...
            '.All',oddEvenNames{1},'.NumAll.',hemiNames{hemis},'.rawrssXvalAll));']);
        eval(['vesXvalOdd_num=1-(sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{1},...
            '.All',oddEvenNames{2},'.NumAll.',hemiNames{hemis},'.rssXvalAll)./sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{1},...
            '.All',oddEvenNames{2},'.NumAll.',hemiNames{hemis},'.rawrssXvalAll));']);
        
        vesEven_num(~isfinite(vesEven_num)) = 0;vesEven_num = max(vesEven_num, 0);vesEven_num = min(vesEven_num, 1); %#ok<SAGROW>
        vesOdd_num(~isfinite(vesOdd_num)) = 0;vesOdd_num = max(vesOdd_num, 0);vesOdd_num = min(vesOdd_num, 1); %#ok<SAGROW>
        vesXvalEven_num(~isfinite(vesXvalEven_num)) = 0;vesXvalEven_num = max(vesXvalEven_num, 0);vesXvalEven_num = min(vesXvalEven_num, 1); %#ok<SAGROW>
        vesXvalOdd_num(~isfinite(vesXvalOdd_num)) = 0;vesXvalOdd_num = max(vesXvalOdd_num, 0);vesXvalOdd_num = min(vesXvalOdd_num, 1); %#ok<SAGROW>
        
        % Fourier power
        eval(['vesEven_fp=1-(sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{2},...
            '.All',oddEvenNames{1},'.NumAll.',hemiNames{hemis},'.rssAll)./sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{2},...
            '.All',oddEvenNames{1},'.NumAll.',hemiNames{hemis},'.rawrssAll));']);
        eval(['vesOdd_fp=1-(sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{2},...
            '.All',oddEvenNames{2},'.NumAll.',hemiNames{hemis},'.rssAll)./sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{2},...
            '.All',oddEvenNames{2},'.NumAll.',hemiNames{hemis},'.rawrssAll));']);
        eval(['vesXvalEven_fp=1-(sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{2},...
            '.All',oddEvenNames{1},'.NumAll.',hemiNames{hemis},'.rssXvalAll)./sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{2},...
            '.All',oddEvenNames{1},'.NumAll.',hemiNames{hemis},'.rawrssXvalAll));']);
        eval(['vesXvalOdd_fp=1-(sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{2},...
            '.All',oddEvenNames{2},'.NumAll.',hemiNames{hemis},'.rssXvalAll)./sum(data_numerosity.ve.',participantOrder{participants},'.',modelNamesAll{2},...
            '.All',oddEvenNames{2},'.NumAll.',hemiNames{hemis},'.rawrssXvalAll));']);
        
        vesEven_fp(~isfinite(vesEven_fp)) = 0;vesEven_fp = max(vesEven_fp, 0);vesEven_fp = min(vesEven_fp, 1); %#ok<SAGROW>
        vesOdd_fp(~isfinite(vesOdd_fp)) = 0;vesOdd_fp = max(vesOdd_fp, 0);vesOdd_fp = min(vesOdd_fp, 1); %#ok<SAGROW>
        vesXvalEven_fp(~isfinite(vesXvalEven_fp)) = 0;vesXvalEven_fp = max(vesXvalEven_fp, 0);vesXvalEven_fp = min(vesXvalEven_fp, 1); %#ok<SAGROW>
        vesXvalOdd_fp(~isfinite(vesXvalOdd_fp)) = 0;vesXvalOdd_fp = max(vesXvalOdd_fp, 0);vesXvalOdd_fp = min(vesXvalOdd_fp, 1); %#ok<SAGROW>
        
        numVoxelsOdd=find(vesOdd_num>veThresh);
        numVoxelsEven=find(vesEven_num>veThresh);
        fpVoxelsOdd=find(vesOdd_fp>veThresh);
        fpVoxelsEven=find(vesEven_fp>veThresh);
        
        voxelSelect_even=unique([numVoxelsEven,fpVoxelsEven]);
        voxelSelect_odd=unique([numVoxelsOdd,fpVoxelsOdd]);
        clear numVoxelsOdd fpVoxelsOdd numVoxelsEven fpVoxelsEven
        
        eval(['fig5All_num_median(',num2str(participants),',',num2str(colIndx(hemis,1)),...
            ')=median(vesXvalEven_num(voxelSelect_odd>',num2str(veThresh),'));']);
        eval(['fig5All_num_all=[fig5All_num_all,'...
            'vesXvalEven_num(voxelSelect_odd>',num2str(veThresh),')];']);
        eval(['fig5All_num_median(',num2str(participants),',',num2str(colIndx(hemis,2)),...
            ')=median(vesXvalOdd_num(voxelSelect_even>',num2str(veThresh),'));']);
        eval(['fig5All_num_all=[fig5All_num_all,'...
            'vesXvalOdd_num(voxelSelect_even>',num2str(veThresh),')];']);
        
        eval(['fig5All_fp_median(',num2str(participants),',',num2str(colIndx(hemis,1)),...
            ')=median(vesXvalEven_fp(voxelSelect_odd>',num2str(veThresh),'));']);
        eval(['fig5All_fp_all=[fig5All_fp_all,'...
            'vesXvalEven_fp(voxelSelect_odd>',num2str(veThresh),')];']);
        eval(['fig5All_fp_median(',num2str(participants),',',num2str(colIndx(hemis,2)),...
            ')=median(vesXvalOdd_fp(voxelSelect_even>',num2str(veThresh),'));']);
        eval(['fig5All_fp_all=[fig5All_fp_all,'...
            'vesXvalOdd_fp(voxelSelect_even>',num2str(veThresh),')];']);
        
    end
end

% Wilcoxon by voxel
eval('x_wilcoxon=fig5All_num_median;');
eval('y_wilcoxon=fig5All_fp_median;');
zval_removeX = find(x_wilcoxon==0);zval_removeY = find(y_wilcoxon==0);
zval_remove = union(zval_removeX,zval_removeY);
x_wilcoxon(zval_remove)=[];y_wilcoxon(zval_remove)=[];
[p_ztest,~,stats_ztest] = signrank(x_wilcoxon, y_wilcoxon, 'method','approximate');
pvals=p_ztest;disp(pvals);
tMatrix=stats_ztest.zval;disp(tMatrix);

% black = Left, grey = Right
% odd = filled, even = empty
leftRight_color=[0,0,0;128,128,128]./255;
subject_shape=["o","^","s","d","p"];
modelScatter = ["logNumber", "logAggFourierPower"];
fig5All_logNumber_median=fig5All_num_median;
fig5All_logAggFourierPower_median=fig5All_fp_median;

% Plots bar chart and pairwise differences between candidate model fits.
barMeans=[];CI95=[];barStd=[];barSerr=[];
whichBars=1:length(modelNamesAll);
for n=1:length(whichBars)
    if strcmp(char(mapNames),'All')
        eval(['tmp=fig5All_',modelScatter{n},'_median(:,:);']);
        tmp=(tmp(:));
        tmp=tmp(~isnan(tmp));
        barMeans(n)=nanmean(tmp); %#ok<SAGROW>
        barStd(n)=std(tmp); %#ok<SAGROW>
        barSerr(n)=std(tmp)/sqrt(length(tmp)); %#ok<SAGROW>
        barPoints(1:length(tmp),n)=tmp; %#ok<SAGROW>
        CI95(n,:) = tinv([0.025 0.975], length(tmp)-1); %#ok<SAGROW>
        CI95(n,:) =bsxfun(@times, barSerr(n), CI95(n,:)); %#ok<SAGROW>
    else
        tmp=barDataMeans(:, :, :, :,whichBars(n));
        tmp2=[];
        for jj=1:whichHemi
            for kk=1:oddEven
                tmp2=[tmp2;tmp(:,:,kk,jj)]; %#ok<AGROW>
            end
        end
        tmp=tmp2;
        barMeans(n,:)=nannanmean(tmp); %#ok<SAGROW>
        barStd(n,:)=nanstd(tmp); %#ok<SAGROW>
        barSerr(n,:)=nanstd(tmp)/sqrt(length(tmp)); %#ok<SAGROW>
        barPoints(:,:,n)=tmp; %#ok<SAGROW>
        CI95_t(n,:) = tinv([0.025 0.975], length(tmp)-1);
        CI95(:,:,n) =bsxfun(@times, barSerr(n,:)', CI95_t(n,:)); %#ok<SAGROW>
    end
end

figure;
hold on;data1=[];data2=[];colorCounter=1;
if strcmp(char(mapNames),'All')
    for ii=1:length(barMeans)
        b=bar(ii,barMeans(ii),'LineWidth',1);hold on
        if ii==1 % Numerosity
            b.FaceColor = [.4 .4 .4];
        else % Fourier power
            b.FaceColor = [.8 .8 .8];
        end
    end
else
    b=bar(barMeans,'LineWidth',1);
    b(1).FaceColor=numerosityColors(1,:);
    b(2).FaceColor=numerosityColors(2,:);
    b(3).FaceColor=numerosityColors(3,:);
    b(4).FaceColor=numerosityColors(4,:);
    b(5).FaceColor=numerosityColors(5,:);
    b(6).FaceColor=numerosityColors(6,:);
end
hold on; errorbar(1:size(barMeans,2), barMeans, CI95(:,1), CI95(:,2), 'k.','LineWidth',1);
plot([0,length(barMeans)+1],[barMeans(1),barMeans(1)],'--r','LineWidth',1.5);

% Individual data scatter
for participants=1:5
    
    % Left Even
    scatter([1:size(barMeans,2)]-.3,...
        [fig5All_logNumber_median(participants,1),fig5All_logAggFourierPower_median(participants,1)],...
        42,subject_shape{participants},'filled','MarkerFaceColor',leftRight_color(1,:),...
        'MarkerEdgeColor',leftRight_color(1,:),'LineWidth',1);hold on %#ok<NBRAK>
    
    % Left Odd
    scatter([1:size(barMeans,2)]-.1,...
        [fig5All_logNumber_median(participants,2),fig5All_logAggFourierPower_median(participants,2)],...
        42,subject_shape{participants},'MarkerEdgeColor',leftRight_color(1,:),'LineWidth',1);hold on %#ok<NBRAK>
    
    % Right Even
    scatter([1:size(barMeans,2)]+.1,...
        [fig5All_logNumber_median(participants,3),fig5All_logAggFourierPower_median(participants,3)],...
        42,subject_shape{participants},'filled','MarkerFaceColor',leftRight_color(2,:),...
        'MarkerEdgeColor',leftRight_color(2,:),'LineWidth',1);hold on %#ok<NBRAK>
    
    % Right Odd
    scatter([1:size(barMeans,2)]+.3,...
        [fig5All_logNumber_median(participants,4),fig5All_logAggFourierPower_median(participants,4)],...
        42,subject_shape{participants},'MarkerEdgeColor',leftRight_color(2,:),'LineWidth',1);hold on %#ok<NBRAK>
    
end

xlim([0.5 15+0.5]);
ylim([0 0.65]);
barNames_1={'Numerosity', 'Fourier power'};
barNames_2={'(tuned)', '(tuned)'};
barNames_array = [barNames_1;barNames_2];
tickLabels = strtrim(sprintf('%s\\newline%s\n',barNames_array{:}));
ax=gca();
ax.XTick=1:length(barMeans);
ax.XTickLabel=tickLabels;
yticks(0:.1:.6);yticklabels({'0','0.1','0.2','0.3','0.4','0.5','0.6'})
set(gcf,'Color','w');box off
xlabel('Tuned models','FontWeight','bold');
ylabel({'Response model fit (R^2)'},'FontWeight','bold');
set(gcf,'units','centimeters','position',[0.1 0.1 24 12]);
if plotOn
    export_fig(['Fig5b','.png'],'-png','-r600','-painters');
end

% Compute t-statistics and corresponding probabilities of pairwise differences between model fits
tMatrix=[];pvals=[];
for x=1:length(whichBars)
    for y=1:length(whichBars)
        % Wilcoxon
        x_wilcoxon = barPoints(:,x);y_wilcoxon = barPoints(:,y);
        zval_removeX = find(x_wilcoxon==0);zval_removeY = find(y_wilcoxon==0);
        zval_remove = union(zval_removeX,zval_removeY);
        x_wilcoxon(zval_remove)=[];y_wilcoxon(zval_remove)=[];
        [p_ztest,~,stats_ztest] = signrank(x_wilcoxon, y_wilcoxon, 'method','approximate');
        pvals(x,y)=p_ztest; %#ok<SAGROW>
        if x==y
            tMatrix(x,y)=NaN; %#ok<SAGROW>
        else
            tMatrix(x,y)=stats_ztest.zval; %#ok<SAGROW>
        end
    end
end
tMatrix(tMatrix>200)=200;
tMatrix(tMatrix<-200)=-200;

disp(tMatrix(2,1));
disp(pvals(2,1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Monotonic numerosity & aggregate Fourier power model comparisons by all data-types (Fig.5C) %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear modelNamesAll
modelNamesAll{1}=["logNumber_byDT", "logAggFourierPower_byDT"];
modelNamesAll=modelNamesAll{1}; %#ok<NASGU>
veThresh=0.2;
DTnames = ["Area","Size","Circ","Dense"];
hemiNames = ["Left","Right"];
oddEvenNames = ["Even","Odd"];

fig5Area_num_all=[];fig5Size_num_all=[];fig5Circ_num_all=[];fig5Dense_num_all=[]; %#ok<NASGU>
fig5Area_fp_all=[];fig5Size_fp_all=[];fig5Circ_fp_all=[];fig5Dense_fp_all=[]; %#ok<NASGU>

for dts = 1:4
    colIndx = 0;
    for oddEven = 1:2
        for hemis = 1:2
            colIndx = colIndx + 1;
            for participants = 1:5
                % Get voxels
                eval(['numVoxels=find(data_numerosity.ve.',participantOrder{participants},'.logNumber_byDT.',DTnames{dts},oddEvenNames{oddEven},'.VFMAll.',hemiNames{hemis},...
                    '.ves>',num2str(veThresh),');']);
                eval(['fpVoxels=find(data_numerosity.ve.',participantOrder{participants},'.logAggFourierPower_byDT.',DTnames{dts},oddEvenNames{oddEven},'.VFMAll.',hemiNames{hemis},...
                    '.ves>',num2str(veThresh),');']);
                
                voxelSelect=unique([numVoxels,fpVoxels]);
                
                % Numerosity
                eval(['fig5',DTnames{dts},'_num_median(',num2str(participants),',',num2str(colIndx),')=median(data_numerosity.ve.'...
                    participantOrder{participants},'.logNumber_byDT.',DTnames{dts},oddEvenNames{oddEven},'.VFMAll.',hemiNames{hemis},...
                    '.vesXval([',num2str(voxelSelect),']));']);
                eval(['fig5',DTnames{dts},'_num_all=[fig5',DTnames{dts},'_num_all,data_numerosity.ve.'...
                    participantOrder{participants},'.logNumber_byDT.',DTnames{dts},oddEvenNames{oddEven},'.VFMAll.',hemiNames{hemis},...
                    '.vesXval([',num2str(voxelSelect),'])];']);
                % Fourier power
                eval(['fig5',DTnames{dts},'_fp_median(',num2str(participants),',',num2str(colIndx),')=median(data_numerosity.ve.'...
                    participantOrder{participants},'.logAggFourierPower_byDT.',DTnames{dts},oddEvenNames{oddEven},'.VFMAll.',hemiNames{hemis},...
                    '.vesXval([',num2str(voxelSelect),']));']);
                eval(['fig5',DTnames{dts},'_fp_all=[fig5',DTnames{dts},'_fp_all,data_numerosity.ve.'...
                    participantOrder{participants},'.logAggFourierPower_byDT.',DTnames{dts},oddEvenNames{oddEven},'.VFMAll.',hemiNames{hemis},...
                    '.vesXval([',num2str(voxelSelect),'])];']);
                
            end
        end
    end
    
    % Wilcoxon by voxel
    eval(['x_wilcoxon=fig5',DTnames{dts},'_num_median-fig5',DTnames{dts},'_fp_median;']);
    eval(['y_wilcoxon=zeros(length(fig5',DTnames{dts},'_fp_median(:)),1);']);
    [p_ztest,~,stats_ztest] = signrank(x_wilcoxon(:), y_wilcoxon(:), 'method','approximate');
    pvals(dts)=p_ztest; %#ok<SAGROW>
    tMatrix(dts)=stats_ztest.zval;
end

disp(tMatrix);
[~, ~, ~, adj_p]=fdr_bh(pvals);
disp(adj_p);

clear modelNamesAll
modelNamesAll{1}=["logNumber", "logAggFourierPower","logNumber", "logAggFourierPower","logNumber", "logAggFourierPower","logNumber", "logAggFourierPower"];
modelNamesAll=modelNamesAll{1};
mapNames="All";
Area_color=[255,0,0]./255;
Size_color=[0,255,0]./255;
Peri_color=[0,0,255]./255;
Dens_color=[255,0,255]./255;

% black = Left, grey = Right
% odd = filled, even = empty
leftRight_color=[0,0,0;128,128,128]./255; 
subject_shape=["o","^","s","d","p"];
modelScatter = ["num","fp"];

barPoints=nan(20,length(modelNamesAll));iy=0;
barMeans=[];CI95=[];barStd=[];barSerr=[];
whichBars=1:2;
for dts=1:length(DTnames)
    for n=1:length(whichBars)
        if strcmp(char(mapNames),'All')
            eval(['tmp=fig5',DTnames{dts},'_',modelScatter{n},'_median(:,:);']);
            tmp=(tmp(:));
            tmp=tmp(~isnan(tmp));
            barMeans=[barMeans,nanmean(tmp)]; %#ok<AGROW>
            barStd=[barStd,std(tmp)]; %#ok<AGROW>
            barSerr_current=std(tmp)/sqrt(length(tmp));
            barSerr=[barSerr,std(tmp)/sqrt(length(tmp))]; %#ok<AGROW>
            iy=iy+1;
            barPoints(1:length(tmp),iy)=tmp;
            CI95_current = tinv([0.025 0.975], length(tmp)-1);
            CI95 =[CI95;bsxfun(@times, barSerr_current, CI95_current)]; %#ok<AGROW>
        else
            
        end
    end
end

figure;
hold on;ix=1;
if strcmp(char(mapNames),'All')
    for ii=1:8
        b=bar(ix,barMeans(ii),'LineWidth',1);
        switch ix
            case 1
                b.FaceColor=Area_color;b.FaceAlpha = 1;
            case 2
                b.FaceColor=Area_color;b.FaceAlpha = .45;
            case 3
                b.FaceColor=Size_color;b.FaceAlpha = 1;
                
            case 4
                b.FaceColor=Size_color;b.FaceAlpha = .45;
                
            case 5
                b.FaceColor=Peri_color;b.FaceAlpha = 1;
                
            case 6
                b.FaceColor=Peri_color;b.FaceAlpha = .45;
                
            case 7
                b.FaceColor=Dens_color;b.FaceAlpha = 1;
                
            case 8
                b.FaceColor=Dens_color;b.FaceAlpha = .45;
        end
        ix=ix+1;
    end
else
    
end

hold on;
errorbar(1:size(barMeans,2), barMeans(1:8), CI95(:,1), CI95(:,2), 'k.','LineWidth',1);

% Individual data scatter
for participants=1:5
    % Left Even
    scatter([1:size(barMeans,2)]-.3,...
        [fig5Area_num_median(participants,1),fig5Area_fp_median(participants,1),...
        fig5Size_num_median(participants,1),fig5Size_fp_median(participants,1),...
        fig5Circ_num_median(participants,1),fig5Circ_fp_median(participants,1),...
        fig5Dense_num_median(participants,1),fig5Dense_fp_median(participants,1)],...
        42,subject_shape{participants},'filled','MarkerFaceColor',leftRight_color(1,:),...
        'MarkerEdgeColor',leftRight_color(1,:),'LineWidth',1);hold on %#ok<NBRAK>
    
    % Left Odd
    scatter([1:size(barMeans,2)]-.1,...
        [fig5Area_num_median(participants,2),fig5Area_fp_median(participants,2),...
        fig5Size_num_median(participants,2),fig5Size_fp_median(participants,2),...
        fig5Circ_num_median(participants,2),fig5Circ_fp_median(participants,2),...
        fig5Dense_num_median(participants,2),fig5Dense_fp_median(participants,2)],...
        42,subject_shape{participants},'MarkerEdgeColor',leftRight_color(1,:),'LineWidth',1);hold on %#ok<NBRAK>
    
    % Right Even
    scatter([1:size(barMeans,2)]+.1,...
        [fig5Area_num_median(participants,3),fig5Area_fp_median(participants,3),...
        fig5Size_num_median(participants,3),fig5Size_fp_median(participants,3),...
        fig5Circ_num_median(participants,3),fig5Circ_fp_median(participants,3),...
        fig5Dense_num_median(participants,3),fig5Dense_fp_median(participants,3)],...
        42,subject_shape{participants},'filled','MarkerFaceColor',leftRight_color(2,:),...
        'MarkerEdgeColor',leftRight_color(2,:),'LineWidth',1);hold on %#ok<NBRAK>
    
    % Right Odd
    scatter([1:size(barMeans,2)]+.3,...
        [fig5Area_num_median(participants,4),fig5Area_fp_median(participants,4),...
        fig5Size_num_median(participants,4),fig5Size_fp_median(participants,4),...
        fig5Circ_num_median(participants,4),fig5Circ_fp_median(participants,4),...
        fig5Dense_num_median(participants,4),fig5Dense_fp_median(participants,4)],...
        42,subject_shape{participants},'MarkerEdgeColor',leftRight_color(2,:),'LineWidth',1);hold on %#ok<NBRAK>
end

xlim([0.5 15+.5]);
ylim([0 0.65]);
barNames_array =[{'Numerosity';'Area'},{'Fourier power';'Area'},{'Numerosity';'Size'},{'Fourier power';'Size'},...
    {'Numerosity';'Peri'},{'Fourier power';'Peri'},{'Numerosity';'Dens'},{'Fourier power';'Dens'}];
tickLabels = strtrim(sprintf('%s\\newline%s\n',barNames_array{:}));
ax=gca();
ax.XTick=1:length(barMeans);
ax.XTickLabel=tickLabels;xtickangle(-90);
yticks(0:.1:.6);yticklabels({'0','0.1','0.2','0.3','0.4','0.5','0.6'})
set(gcf,'Color','w');box off
xlabel('Monotonic models','FontWeight','bold');
ylabel({'Response model fit (R^2)'},'FontWeight','bold');
set(gcf,'units','centimeters','position',[0.1 0.1 24 12]);
if plotOn
    export_fig(['Fig5c','.png'],'-png','-r600','-painters');
end

% Compute t-statistics and corresponding probabilities of pairwise differences between model fits
tMatrix=[];pvals=[];
for x=1:length(modelNamesAll)
    for y=1:length(modelNamesAll)
        % Wilcoxon
        x_wilcoxon = barPoints(:,x);y_wilcoxon = barPoints(:,y);
        zval_removeX = find(x_wilcoxon==0);zval_removeY = find(y_wilcoxon==0);
        zval_remove = union(zval_removeX,zval_removeY);
        x_wilcoxon(zval_remove)=[];y_wilcoxon(zval_remove)=[];
        [p_ztest,~,stats_ztest] = signrank(x_wilcoxon, y_wilcoxon, 'method','approximate');
        pvals(x,y)=p_ztest; %#ok<SAGROW>
        if x==y
            tMatrix(x,y)=NaN; %#ok<SAGROW>
        else
            tMatrix(x,y)=stats_ztest.zval; %#ok<SAGROW>
        end
    end
end
tMatrix(tMatrix>200)=200;
tMatrix(tMatrix<-200)=-200;

disp([tMatrix(2,1),tMatrix(4,3),tMatrix(6,5),tMatrix(8,7)]);
[~, ~, ~, adj_p]=fdr_bh([pvals(2,1),pvals(4,3),pvals(6,5),pvals(8,7)]);
disp(adj_p);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Tuned numerosity & aggregate Fourier power model comparisons by all data-types (Fig.5D) %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DTnames = ["Area","Size","Circ","Dense"];
hemiNames = ["Left","Right"];
oddEvenNames = ["Even","Odd"];

fig5Area_num_all=[];fig5Size_num_all=[];fig5Circ_num_all=[];fig5Dense_num_all=[];
fig5Area_fp_all=[];fig5Size_fp_all=[];fig5Circ_fp_all=[];fig5Dense_fp_all=[];

for dts = 1:4
    colIndx = 0;
    for oddEven = 1:2
        for hemis = 1:2
            colIndx = colIndx + 1;
            for participants = 1:5
                % Get voxels
                eval(['numVoxels=find(data_numerosity.ve.',participantOrder{participants},'.logNumber_byDT.',DTnames{dts},oddEvenNames{oddEven},'.NumAll.',hemiNames{hemis},...
                    '.ves>',num2str(veThresh),');']);
                eval(['fpVoxels=find(data_numerosity.ve.',participantOrder{participants},'.logAggFourierPower_byDT.',DTnames{dts},oddEvenNames{oddEven},'.NumAll.',hemiNames{hemis},...
                    '.ves>',num2str(veThresh),');']);
                
                voxelSelect=unique([numVoxels,fpVoxels]);
                
                % Numerosity
                eval(['fig5',DTnames{dts},'_num_median(',num2str(participants),',',num2str(colIndx),')=median(data_numerosity.ve.'...
                    ,participantOrder{participants},'.logNumber_byDT.',DTnames{dts},oddEvenNames{oddEven},'.NumAll.',hemiNames{hemis},...
                    '.vesXval([',num2str(voxelSelect),']));']);
                eval(['fig5',DTnames{dts},'_num_all=[fig5',DTnames{dts},'_num_all,data_numerosity.ve.'...
                    ,participantOrder{participants},'.logNumber_byDT.',DTnames{dts},oddEvenNames{oddEven},'.NumAll.',hemiNames{hemis},...
                    '.vesXval([',num2str(voxelSelect),'])];']);
                % Fourier power
                eval(['fig5',DTnames{dts},'_fp_median(',num2str(participants),',',num2str(colIndx),')=median(data_numerosity.ve.'...
                    ,participantOrder{participants},'.logAggFourierPower_byDT.',DTnames{dts},oddEvenNames{oddEven},'.NumAll.',hemiNames{hemis},...
                    '.vesXval([',num2str(voxelSelect),']));']);
                eval(['fig5',DTnames{dts},'_fp_all=[fig5',DTnames{dts},'_fp_all,data_numerosity.ve.'...
                    ,participantOrder{participants},'.logAggFourierPower_byDT.',DTnames{dts},oddEvenNames{oddEven},'.NumAll.',hemiNames{hemis},...
                    '.vesXval([',num2str(voxelSelect),'])];']);
                
            end
        end
    end
    % Wilcoxon by voxel
    eval(['x_wilcoxon=fig5',DTnames{dts},'_num_median;']);
    eval(['y_wilcoxon=fig5',DTnames{dts},'_fp_median;']);
    
    [p_ztest,~,stats_ztest] = signrank(x_wilcoxon(:), y_wilcoxon(:), 'method','approximate');
    pvals(dts)=p_ztest; %#ok<SAGROW>
    tMatrix(dts)=stats_ztest.zval;
end

disp(tMatrix);
[~, ~, ~, adj_p]=fdr_bh(pvals);
disp(adj_p);

clear modelNamesAll
modelNamesAll{1}=["logNumber", "logAggFourierPower","logNumber", "logAggFourierPower","logNumber", "logAggFourierPower","logNumber", "logAggFourierPower"];
modelNamesAll=modelNamesAll{1};
mapNames="All";
Area_color=[255,0,0]./255;
Size_color=[0,255,0]./255;
Peri_color=[0,0,255]./255;
Dens_color=[255,0,255]./255;

% black = Left, grey = Right
% odd = filled, even = empty
leftRight_color=[0,0,0;128,128,128]./255;
subject_shape=["o","^","s","d","p"];
modelScatter = ["num","fp"];

barPoints=nan(20,length(modelNamesAll));iy=0;
barMeans=[];CI95=[];barStd=[];barSerr=[];
whichBars=1:2;
for dts=1:length(DTnames)
    for n=1:length(whichBars)
        if strcmp(char(mapNames),'All')
            eval(['tmp=fig5',DTnames{dts},'_',modelScatter{n},'_median(:,:);']);
            tmp=(tmp(:));
            tmp=tmp(~isnan(tmp));
            barMeans=[barMeans,nanmean(tmp)]; %#ok<AGROW>
            barStd=[barStd,std(tmp)]; %#ok<AGROW>
            barSerr_current=std(tmp)/sqrt(length(tmp));
            barSerr=[barSerr,std(tmp)/sqrt(length(tmp))]; %#ok<AGROW>
            iy=iy+1;
            barPoints(1:length(tmp),iy)=tmp;
            CI95_current = tinv([0.025 0.975], length(tmp)-1);
            CI95 =[CI95;bsxfun(@times, barSerr_current, CI95_current)]; %#ok<AGROW>
        else
            
        end
    end
end

figure;
hold on;ix=1;
if strcmp(char(mapNames),'All')
    for ii=1:8
        b=bar(ix,barMeans(ii),'LineWidth',1);
        switch ix
            case 1
                b.FaceColor=Area_color;b.FaceAlpha = 1;
            case 2
                b.FaceColor=Area_color;b.FaceAlpha = .45;
            case 3
                b.FaceColor=Size_color;b.FaceAlpha = 1;
                
            case 4
                b.FaceColor=Size_color;b.FaceAlpha = .45;
                
            case 5
                b.FaceColor=Peri_color;b.FaceAlpha = 1;
                
            case 6
                b.FaceColor=Peri_color;b.FaceAlpha = .45;
                
            case 7
                b.FaceColor=Dens_color;b.FaceAlpha = 1;
                
            case 8
                b.FaceColor=Dens_color;b.FaceAlpha = .45;
        end
        ix=ix+1;
    end
else
    
end

hold on;
errorbar(1:size(barMeans,2), barMeans(1:8), CI95(:,1), CI95(:,2), 'k.','LineWidth',1);

% Individual data scatter
for participants=1:5
    % Left Even
    scatter([1:size(barMeans,2)]-.3,...
        [fig5Area_num_median(participants,1),fig5Area_fp_median(participants,1),...
        fig5Size_num_median(participants,1),fig5Size_fp_median(participants,1),...
        fig5Circ_num_median(participants,1),fig5Circ_fp_median(participants,1),...
        fig5Dense_num_median(participants,1),fig5Dense_fp_median(participants,1)],...
        42,subject_shape{participants},'filled','MarkerFaceColor',leftRight_color(1,:),...
        'MarkerEdgeColor',leftRight_color(1,:),'LineWidth',1);hold on %#ok<NBRAK>
    
    % Left Odd
    scatter([1:size(barMeans,2)]-.1,...
        [fig5Area_num_median(participants,2),fig5Area_fp_median(participants,2),...
        fig5Size_num_median(participants,2),fig5Size_fp_median(participants,2),...
        fig5Circ_num_median(participants,2),fig5Circ_fp_median(participants,2),...
        fig5Dense_num_median(participants,2),fig5Dense_fp_median(participants,2)],...
        42,subject_shape{participants},'MarkerEdgeColor',leftRight_color(1,:),'LineWidth',1);hold on %#ok<NBRAK>
    
    % Right Even
    scatter([1:size(barMeans,2)]+.1,...
        [fig5Area_num_median(participants,3),fig5Area_fp_median(participants,3),...
        fig5Size_num_median(participants,3),fig5Size_fp_median(participants,3),...
        fig5Circ_num_median(participants,3),fig5Circ_fp_median(participants,3),...
        fig5Dense_num_median(participants,3),fig5Dense_fp_median(participants,3)],...
        42,subject_shape{participants},'filled','MarkerFaceColor',leftRight_color(2,:),...
        'MarkerEdgeColor',leftRight_color(2,:),'LineWidth',1);hold on %#ok<NBRAK>
    
    % Right Odd
    scatter([1:size(barMeans,2)]+.3,...
        [fig5Area_num_median(participants,4),fig5Area_fp_median(participants,4),...
        fig5Size_num_median(participants,4),fig5Size_fp_median(participants,4),...
        fig5Circ_num_median(participants,4),fig5Circ_fp_median(participants,4),...
        fig5Dense_num_median(participants,4),fig5Dense_fp_median(participants,4)],...
        42,subject_shape{participants},'MarkerEdgeColor',leftRight_color(2,:),'LineWidth',1);hold on %#ok<NBRAK>
end

xlim([0.5 15+.5]);
ylim([0 0.65]);
barNames=[{'Numerosity';'Area'},{'Fourier power';'Area'},{'Numerosity';'Size'},{'Fourier power';'Size'},{'Numerosity';'Peri'},{'Fourier power';'Peri'},{'Numerosity';'Dens'},{'Fourier power';'Dens'}];
barNames_array =[{'Numerosity';'Area'},{'Fourier power';'Area'},{'Numerosity';'Size'},{'Fourier power';'Size'},...
    {'Numerosity';'Peri'},{'Fourier power';'Peri'},{'Numerosity';'Dens'},{'Fourier power';'Dens'}];
tickLabels = strtrim(sprintf('%s\\newline%s\n',barNames_array{:}));
ax=gca();
ax.XTick=1:length(barMeans);
ax.XTickLabel=tickLabels;xtickangle(-90);
yticks(0:.1:.6);yticklabels({'0','0.1','0.2','0.3','0.4','0.5','0.6'})
set(gcf,'Color','w');box off
xlabel('Tuned models','FontWeight','bold');
ylabel({'Response model fit (R^2)'},'FontWeight','bold');
set(gcf,'units','centimeters','position',[0.1 0.1 24 12]);
if plotOn
    export_fig(['Fig5d','.png'],'-png','-r600','-painters');
end

% Compute t-statistics and corresponding probabilities of pairwise differences between model fits
tMatrix=[];pvals=[];
for x=1:length(modelNamesAll)
    for y=1:length(modelNamesAll)
        % Wilcoxon
        x_wilcoxon = barPoints(:,x);y_wilcoxon = barPoints(:,y);
        zval_removeX = find(x_wilcoxon==0);zval_removeY = find(y_wilcoxon==0);
        zval_remove = union(zval_removeX,zval_removeY);
        x_wilcoxon(zval_remove)=[];y_wilcoxon(zval_remove)=[];
        [p_ztest,~,stats_ztest] = signrank(x_wilcoxon, y_wilcoxon, 'method','approximate');
        pvals(x,y)=p_ztest; %#ok<SAGROW>
        if x==y
            tMatrix(x,y)=NaN; %#ok<SAGROW>
        else
            tMatrix(x,y)=stats_ztest.zval; %#ok<SAGROW>
        end
    end
end
tMatrix(tMatrix>200)=200;
tMatrix(tMatrix<-200)=-200;

disp([tMatrix(2,1),tMatrix(4,3),tMatrix(6,5),tMatrix(8,7)]);
[~, ~, ~, adj_p]=fdr_bh([pvals(2,1),pvals(4,3),pvals(6,5),pvals(8,7)]);
disp(adj_p);
