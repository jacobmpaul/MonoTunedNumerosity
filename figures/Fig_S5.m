%%%%%%%%%%%%
%% Fig.S5 %%
%%%%%%%%%%%%

load data_numerosity
load data_vfm
participantNames = {'P01', 'P02', 'P03', 'P04', 'P05'};
whichParticipants=1:5;
group.bins = []; fitData = []; bins = [];
mapNames=["bothIPS0","bothIPS1","bothIPS2","bothIPS3","bothIPS4","bothIPS5","bothsPCS1","bothsPCS2","bothiPCS",...
    "bothLO1","bothLO2","bothTO1","bothTO2","bothV1","bothV2","bothV3","bothV3AB"];
DTnames=["Area", "AreaOdd", "AreaEven", "Size", "SizeOdd", "SizeEven", "Circ", "CircOdd", "CircEven", "Dense", "DenseOdd", "DenseEven"];
allNames = ["All","AllOdd","AllEven"];
modelNames{1}=["aggFourierPower","monoNumber","tunedNumber"];
binsize = 0.20;thresh.ecc = [0 5.5];voxelSize = 1.77;
bins.MonoLogIncrease.x = (thresh.ecc(1):binsize:thresh.ecc(2))';
bins.MonoLogDecrease.x = (thresh.ecc(1):binsize:thresh.ecc(2))';
bins.TunedLog2Lin.x = (thresh.ecc(1):binsize:thresh.ecc(2))';
bins.AggFourierPower.x = (thresh.ecc(1):binsize:thresh.ecc(2))';
minNumerosity=log(1.01);maxNumerosity=log(6.99);
coloursTuned = [205,0,0]./255;coloursMono = [0,205,205]./255;coloursIncrease = [0,0,205]./255;coloursDecrease = [0,205,0]./255;
coloursFourierPower = [0 255 255]./255;
colourROI=1;yrange=0.5;

saveData = 1;savePlots = 1;

for thisParticipant=whichParticipants
    for DTs=1:length(allNames)
        for maps = 1:length(mapNames)
            eval(['AggFourierPower.',allNames{DTs},'.',mapNames{maps},...
                '=data_numerosity.ve.',participantNames{thisParticipant},'.aggFourierPower.',allNames{DTs},...
                '.',mapNames{maps},'.Both;']);
            eval(['MonoLog.',allNames{DTs},'.',mapNames{maps},...
                '=data_numerosity.ve.',participantNames{thisParticipant},'.monoNumber.',allNames{DTs},...
                '.',mapNames{maps},'.Both;']);
            eval(['Tuned.',allNames{DTs},'.',mapNames{maps},...
                '=data_numerosity.ve.',participantNames{thisParticipant},'.tunedNumber.',allNames{DTs},...
                '.',mapNames{maps},'.Both;']);
        end
    end
end

for thisParticipant=whichParticipants
    for DTs=2:length(allNames)
        for maps = 1:length(mapNames)
            % Fourier power
            x0s_current = data_numerosity.ve.(participantNames{thisParticipant}).aggFourierPower.(allNames{DTs}).(mapNames{maps}).Both.x0sAll;
            x0s_current_mean = mean(x0s_current);
            ves_current = data_numerosity.ve.(participantNames{thisParticipant}).aggFourierPower.(allNames{DTs}).(mapNames{maps}).Both.vesXvalAll;
            ves_current_mean = mean(ves_current);
            cv_data.AggFourierPower.(participantNames{thisParticipant}).(allNames{DTs}).(mapNames{maps}).xs = x0s_current_mean;
            cv_data.AggFourierPower.(participantNames{thisParticipant}).(allNames{DTs}).(mapNames{maps}).varianceExplained = ves_current_mean;
            
            % Monotonic numerosity
            x0s_current = data_numerosity.ve.(participantNames{thisParticipant}).monoNumber.(allNames{DTs}).(mapNames{maps}).Both.x0sAll;
            x0s_current_mean = mean(x0s_current);
            ves_current = data_numerosity.ve.(participantNames{thisParticipant}).monoNumber.(allNames{DTs}).(mapNames{maps}).Both.vesXvalAll;
            ves_current_mean = mean(ves_current);
            cv_data.MonoLog.(participantNames{thisParticipant}).(allNames{DTs}).(mapNames{maps}).xs = x0s_current_mean;
            cv_data.MonoLog.(participantNames{thisParticipant}).(allNames{DTs}).(mapNames{maps}).varianceExplained = ves_current_mean;
            
            % Tuned numerosity
            x0s_current = data_numerosity.ve.(participantNames{thisParticipant}).tunedNumber.(allNames{DTs}).(mapNames{maps}).Both.x0sAll;
            x0s_current_mean = mean(x0s_current);
            ves_current = data_numerosity.ve.(participantNames{thisParticipant}).tunedNumber.(allNames{DTs}).(mapNames{maps}).Both.vesXvalAll;
            ves_current_mean = mean(ves_current);
            cv_data.Tuned.(participantNames{thisParticipant}).(allNames{DTs}).(mapNames{maps}).xs = x0s_current_mean;
            cv_data.Tuned.(participantNames{thisParticipant}).(allNames{DTs}).(mapNames{maps}).varianceExplained = ves_current_mean;
        end
    end
end

condNames = fieldnames(cv_data.AggFourierPower.(participantNames{1}));
condNames(3) = {'AllOddEven'};
% Average odd/even scans
for thisParticipant=whichParticipants
    % Check for change in slope
    for ROIs = 1:length(mapNames)
        % Fourier power
        flipFlop = ~(cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{1}).(mapNames{ROIs}).xs == ...
            cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{2}).(mapNames{ROIs}).xs);

        cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).xs = ...
            cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{2}).(mapNames{ROIs}).xs;
        
        cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).xs(flipFlop) = 0; % Set changed xs to 0

        cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).varianceExplained = ...
            (cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{1}).(mapNames{ROIs}).varianceExplained + ...
            cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{2}).(mapNames{ROIs}).varianceExplained)./2;
        
        cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).varianceExplained(flipFlop) = 0; % Set changed VE to 0 
        
        % Monotonic numerosity
        flipFlop = ~(cv_data.MonoLog.(participantNames{thisParticipant}).(condNames{1}).(mapNames{ROIs}).xs == ...
            cv_data.MonoLog.(participantNames{thisParticipant}).(condNames{2}).(mapNames{ROIs}).xs);

        cv_data.MonoLog.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).xs = ...
            cv_data.MonoLog.(participantNames{thisParticipant}).(condNames{2}).(mapNames{ROIs}).xs;
        
        cv_data.MonoLog.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).xs(flipFlop) = 0; % Set changed xs to 0

        cv_data.MonoLog.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).varianceExplained = ...
            (cv_data.MonoLog.(participantNames{thisParticipant}).(condNames{1}).(mapNames{ROIs}).varianceExplained + ...
            cv_data.MonoLog.(participantNames{thisParticipant}).(condNames{2}).(mapNames{ROIs}).varianceExplained)./2;
        
        cv_data.MonoLog.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).varianceExplained(flipFlop) = 0; % Set changed VE to 0         

        % Tuned numerosity
        varianceExplained = (cv_data.Tuned.(participantNames{thisParticipant}).(condNames{1}).(mapNames{ROIs}).varianceExplained + ...
            cv_data.Tuned.(participantNames{thisParticipant}).(condNames{2}).(mapNames{ROIs}).varianceExplained)./2;
        
        cv_data.Tuned.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).varianceExplained = varianceExplained;
        
        xs = (cv_data.Tuned.(participantNames{thisParticipant}).(condNames{1}).(mapNames{ROIs}).xs + ...
            cv_data.Tuned.(participantNames{thisParticipant}).(condNames{2}).(mapNames{ROIs}).xs)./2;
                
        xs = exp(xs); %Log2Lin
        
        cv_data.Tuned.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).xs = xs;
            
        varianceExplained(xs<=minNumerosity)=0;varianceExplained(xs>=maxNumerosity)=0;
        
        cv_data.Tuned.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).varianceExplained = varianceExplained;        
    end
end

ve_data.AggFourierPower=cv_data.AggFourierPower;
ve_data.MonoLog=cv_data.MonoLog;
ve_data.TunedLog2Lin=cv_data.Tuned;

% Seperate out increasing & decreasing
ve_data.AggFourierPowerIncrease = ve_data.AggFourierPower;
ve_data.MonoLogIncrease = ve_data.MonoLog;
ve_data.MonoLogDecrease = ve_data.MonoLog;

for participant = 1:length(participantNames)
    for roi = 1:length(mapNames)
        % Fourier power
        ve_data.AggFourierPowerIncrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained...
            (ve_data.AggFourierPowerIncrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).xs==2) = 0;
        
        % Monotonic numerosity
        ve_data.MonoLogIncrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained...
            (ve_data.MonoLogIncrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).xs==2) = 0;
        ve_data.MonoLogDecrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained...
            (ve_data.MonoLogDecrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).xs==1) = 0;
    end
end

%% eccentricity
for participant = 1:length(participantNames)
    for roi = 1:length(mapNames)
        ecc.(participantNames{participant}).(char(mapNames{roi})).ecc = data_vfm.ve.(participantNames{participant}).VFML1.(char(mapNames{roi})).ecc;
        ecc.(participantNames{participant}).(char(mapNames{roi})).sigma = data_vfm.ve.(participantNames{participant}).VFML1.(char(mapNames{roi})).sigma;        
    end
end

%% Group data
for participant = 1:length(participantNames)
    for roi = 1:length(mapNames)
        eccCurrent = data_vfm.ve.(participantNames{participant}).VFML1.(mapNames{roi}).ecc;
        veCurrent_monoIncrease = ve_data.MonoLogIncrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained;
        veCurrent_monoDecrease = ve_data.MonoLogDecrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained;
        veCurrent_tuned = ve_data.TunedLog2Lin.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained;
        veCurrent_AggFourierPower = ve_data.AggFourierPower.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained;
        
        if participant==1
            group.ecc.(mapNames{roi}).ecc = eccCurrent;
            group.ve_data.MonoLogIncrease.(mapNames{roi}) = veCurrent_monoIncrease;
            group.ve_data.MonoLogDecrease.(mapNames{roi}) = veCurrent_monoDecrease;            
            group.ve_data.TunedLog2Lin.(mapNames{roi}) = veCurrent_tuned;
            group.ve_data.AggFourierPower.(mapNames{roi}) = veCurrent_AggFourierPower;            
        else
            group.ecc.(mapNames{roi}).ecc = [group.ecc.(mapNames{roi}).ecc, eccCurrent];
            group.ve_data.MonoLogIncrease.(mapNames{roi}) = [group.ve_data.MonoLogIncrease.(mapNames{roi}), veCurrent_monoIncrease];
            group.ve_data.MonoLogDecrease.(mapNames{roi}) = [group.ve_data.MonoLogDecrease.(mapNames{roi}), veCurrent_monoDecrease];            
            group.ve_data.TunedLog2Lin.(mapNames{roi}) = [group.ve_data.TunedLog2Lin.(mapNames{roi}), veCurrent_tuned];
            group.ve_data.AggFourierPower.(mapNames{roi}) = [group.ve_data.AggFourierPower.(mapNames{roi}), veCurrent_AggFourierPower];
        end
    end
end

for participant = 1:length(participantNames)
    for roi = 1:length(mapNames)
        eccIndices_AggFourierPower(roi) = sum([length(ecc.(participantNames{1}).(mapNames{roi}).ecc),length(ecc.(participantNames{2}).(mapNames{roi}).ecc),...
            length(ecc.(participantNames{3}).(mapNames{roi}).ecc),length(ecc.(participantNames{4}).(mapNames{roi}).ecc),length(ecc.(participantNames{5}).(mapNames{roi}).ecc)]); %#ok<SAGROW>
        
        for b = round(thresh.ecc(1):binsize:thresh.ecc(2),1)
            % Determine which voxels are in each bin
            bii = ecc.(participantNames{participant}).(mapNames{roi}).ecc >  b-binsize./2 & ...
                ecc.(participantNames{participant}).(mapNames{roi}).ecc <= b+binsize./2;
            group_bii = group.ecc.(mapNames{roi}).ecc >  b-binsize./2 & ...
                group.ecc.(mapNames{roi}).ecc <= b+binsize./2;
            group_bii_FP = group.ecc.(mapNames{roi}).ecc(1:eccIndices_AggFourierPower(roi)) >  b-binsize./2 & ...
                group.ecc.(mapNames{roi}).ecc(1:eccIndices_AggFourierPower(roi)) <= b+binsize./2;
            if any(bii)
                % Fit which eccentricity bin this corresponds to
                ii2 = find(round(bins.MonoLogIncrease.x,1) == b);
                s_monoIncrease = wstat(ve_data.MonoLogIncrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained(bii),[], voxelSize^2);
                bins.MonoLogIncrease.(participantNames{participant}).(mapNames{roi}).sterr(:,ii2) = s_monoIncrease.sterr;
                bins.MonoLogIncrease.(participantNames{participant}).(mapNames{roi}).sdev(:,ii2) = s_monoIncrease.stdev;
                bins.MonoLogIncrease.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = s_monoIncrease.mean;
                
                s_monoDecrease = wstat(ve_data.MonoLogDecrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained(bii),[], voxelSize^2);
                bins.MonoLogDecrease.(participantNames{participant}).(mapNames{roi}).sterr(:,ii2) = s_monoDecrease.sterr;
                bins.MonoLogDecrease.(participantNames{participant}).(mapNames{roi}).sdev(:,ii2) = s_monoDecrease.stdev;
                bins.MonoLogDecrease.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = s_monoDecrease.mean;
                
                s_tuned = wstat(ve_data.TunedLog2Lin.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained(bii),[], voxelSize^2);
                bins.TunedLog2Lin.(participantNames{participant}).(mapNames{roi}).sterr(:,ii2) = s_tuned.sterr;
                bins.TunedLog2Lin.(participantNames{participant}).(mapNames{roi}).sdev(:,ii2) = s_tuned.stdev;
                bins.TunedLog2Lin.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = s_tuned.mean;
                
                s_AggFourierPower = wstat(ve_data.AggFourierPower.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained(bii),[], voxelSize^2);
                bins.AggFourierPower.(participantNames{participant}).(mapNames{roi}).sterr(:,ii2) = s_AggFourierPower.sterr;
                bins.AggFourierPower.(participantNames{participant}).(mapNames{roi}).sdev(:,ii2) = s_AggFourierPower.stdev;
                bins.AggFourierPower.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = s_AggFourierPower.mean;
                
            else
                ii2 = find(round(bins.MonoLogIncrease.x,1) == b);
                bins.MonoLogIncrease.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = 0;
                bins.MonoLogDecrease.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = 0;
                bins.TunedLog2Lin.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = 0;
                bins.AggFourierPower.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = 0;
                
            end
            if any(group_bii)
                group_ii2 = find(round(bins.MonoLogIncrease.x,1) == b);
                s_monoIncrease = wstat(group.ve_data.MonoLogIncrease.(mapNames{roi})(group_bii),[], voxelSize^2);
                group.bins.MonoLogIncrease.(mapNames{roi}).sterr(:,group_ii2 ) = s_monoIncrease.sterr;
                group.bins.MonoLogIncrease.(mapNames{roi}).sdev(:,group_ii2 ) = s_monoIncrease.stdev;
                group.bins.MonoLogIncrease.(mapNames{roi}).mean(:,group_ii2 ) = s_monoIncrease.mean;
                
                s_monoDecrease = wstat(group.ve_data.MonoLogDecrease.(mapNames{roi})(group_bii),[], voxelSize^2);
                group.bins.MonoLogDecrease.(mapNames{roi}).sterr(:,group_ii2 ) = s_monoDecrease.sterr;
                group.bins.MonoLogDecrease.(mapNames{roi}).sdev(:,group_ii2 ) = s_monoDecrease.stdev;
                group.bins.MonoLogDecrease.(mapNames{roi}).mean(:,group_ii2 ) = s_monoDecrease.mean;
                
                s_tuned = wstat(group.ve_data.TunedLog2Lin.(mapNames{roi})(group_bii),[], voxelSize^2);
                group.bins.TunedLog2Lin.(mapNames{roi}).sterr(:,group_ii2 ) = s_tuned.sterr;
                group.bins.TunedLog2Lin.(mapNames{roi}).sdev(:,group_ii2 ) = s_tuned.stdev;
                group.bins.TunedLog2Lin.(mapNames{roi}).mean(:,group_ii2 ) = s_tuned.mean;
            else
                group_ii2 = find(round(bins.MonoLogIncrease.x,1) == b);
                group.bins.MonoLogIncrease.(mapNames{roi}).mean(:,group_ii2) = 0;
                group.bins.MonoLogDecrease.(mapNames{roi}).mean(:,group_ii2) = 0;
                group.bins.TunedLog2Lin.(mapNames{roi}).mean(:,group_ii2) = 0;
            end
            
            if any(group_bii_FP)
                group_ii2 = find(round(bins.AggFourierPower.x,1) == b);
                s_AggFourierPower = wstat(group.ve_data.AggFourierPower.(mapNames{roi})(group_bii_FP),[], voxelSize^2);
                group.bins.AggFourierPower.(mapNames{roi}).sterr(:,group_ii2 ) = s_AggFourierPower.sterr;
                group.bins.AggFourierPower.(mapNames{roi}).sdev(:,group_ii2 ) = s_AggFourierPower.stdev;
                group.bins.AggFourierPower.(mapNames{roi}).mean(:,group_ii2 ) = s_AggFourierPower.mean;
            else
                group_ii2 = find(round(bins.AggFourierPower.x,1) == b);
                group.bins.AggFourierPower.(mapNames{roi}).mean(:,group_ii2) = 0;
            end
            
        end
        
        % Fitting data
        if participant==1
            fitData.ecc.(mapNames{roi}) = ecc.(participantNames{participant}).(mapNames{roi}).ecc;
            fitData.ve.MonoLogIncrease.(mapNames{roi}) = ve_data.MonoLogIncrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained;
            fitData.ve.MonoLogDecrease.(mapNames{roi}) = ve_data.MonoLogDecrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained;
            fitData.ve.TunedLog2Lin.(mapNames{roi}) = ve_data.TunedLog2Lin.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained;
            fitData.ve.AggFourierPower.(mapNames{roi}) = ve_data.AggFourierPower.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained;
        else
            fitData.ecc.(mapNames{roi}) = [fitData.ecc.(mapNames{roi}),ecc.(participantNames{participant}).(mapNames{roi}).ecc];
            fitData.ve.MonoLogIncrease.(mapNames{roi}) = [fitData.ve.MonoLogIncrease.(mapNames{roi}),ve_data.MonoLogIncrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained];
            fitData.ve.MonoLogDecrease.(mapNames{roi}) = [fitData.ve.MonoLogDecrease.(mapNames{roi}),ve_data.MonoLogDecrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained];
            fitData.ve.TunedLog2Lin.(mapNames{roi}) = [fitData.ve.TunedLog2Lin.(mapNames{roi}),ve_data.TunedLog2Lin.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained];
            fitData.ve.AggFourierPower.(mapNames{roi}) = [fitData.ve.AggFourierPower.(mapNames{roi}),ve_data.AggFourierPower.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained];
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Response model fit (R^2) vs. preferred visual field eccentricity, participants S1-S5 Fig.S5a %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for roi = [14:16,10:11] % V1-V3, LO1&LO2
    %% Eccentricity data
    eccBoot = fitData.ecc.(mapNames{roi});
    eccBoot_FP = fitData.ecc.(mapNames{roi})(1:eccIndices_AggFourierPower(roi));
    minEcc = min(thresh.ecc); maxEcc = max(thresh.ecc);

    %% Sigmoid fit
    %% Aggregate Fourier power    
    veBoot_FourierPower = fitData.ve.AggFourierPower.(mapNames{roi});
    x_AggFourierPower = bins.AggFourierPower.x;
    y_AggFourierPower = group.bins.AggFourierPower.(mapNames{roi}).mean';
    sterr_AggFourierPower = group.bins.AggFourierPower.(mapNames{roi}).sterr';
    x_AggFourierPower(y_AggFourierPower==0) = [];
    sterr_AggFourierPower(y_AggFourierPower==0) = [];
    y_AggFourierPower(y_AggFourierPower==0) = [];
    
    % Bootstrapping
    [sigmoidData.group.AggFourierPower.(mapNames{roi}),fitParams.group.AggFourierPower.(mapNames{roi})] = fitSigmoid3(eccBoot_FP,veBoot_FourierPower, 0, 5.5, 0.2, ones(size(veBoot_FourierPower)), 0);
    % For more robust estimates, consider using monoTuned_make_sigmoid_CIs
    
    figure; 
    scatter(sigmoidData.group.AggFourierPower.(mapNames{roi}).x, sigmoidData.group.AggFourierPower.(mapNames{roi}).y,[],'filled', 'MarkerFaceColor',coloursFourierPower)
    hold on; errorbar(sigmoidData.group.AggFourierPower.(mapNames{roi}).x,sigmoidData.group.AggFourierPower.(mapNames{roi}).y,...
        sigmoidData.group.AggFourierPower.(mapNames{roi}).ysterr(1,:),sigmoidData.group.AggFourierPower.(mapNames{roi}).ysterr(2,:),'.','Color',coloursFourierPower,...
        'MarkerFaceColor',coloursMono,'LineWidth',1);
    hold on; plot(sigmoidData.group.AggFourierPower.(mapNames{roi}).xfit, sigmoidData.group.AggFourierPower.(mapNames{roi}).yfit, '-', 'Color',coloursFourierPower,'LineWidth',3);
    hold on; plot(sigmoidData.group.AggFourierPower.(mapNames{roi}).xfit, sigmoidData.group.AggFourierPower.(mapNames{roi}).b_upper, '--','Color',coloursFourierPower,'LineWidth',2);
    hold on; plot(sigmoidData.group.AggFourierPower.(mapNames{roi}).xfit, sigmoidData.group.AggFourierPower.(mapNames{roi}).b_lower,  '--','Color',coloursFourierPower,'LineWidth',2);

    %% Monotonic numerosity (increasing)
    veBoot_monoIncrease = fitData.ve.MonoLogIncrease.(mapNames{roi});
    x_monoIncrease = bins.MonoLogIncrease.x;
    y_monoIncrease = group.bins.MonoLogIncrease.(mapNames{roi}).mean';
    sterr_monoIncrease = group.bins.MonoLogIncrease.(mapNames{roi}).sterr';
    x_monoIncrease(y_monoIncrease==0) = [];
    sterr_monoIncrease(y_monoIncrease==0) = [];
    y_monoIncrease(y_monoIncrease==0) = [];
    
    % Bootstrapping
    [sigmoidData.group.MonoLogIncrease.(mapNames{roi}),fitParams.group.MonoLogIncrease.(mapNames{roi})] = fitSigmoid3(eccBoot,veBoot_monoIncrease, 0, 5.5, 0.2, ones(size(veBoot_monoIncrease)), 0);
    % For more robust estimates, consider using monoTuned_make_sigmoid_CIs

    scatter(sigmoidData.group.MonoLogIncrease.(mapNames{roi}).x, sigmoidData.group.MonoLogIncrease.(mapNames{roi}).y,[],'filled', 'MarkerFaceColor',coloursIncrease)
    hold on; errorbar(sigmoidData.group.MonoLogIncrease.(mapNames{roi}).x,sigmoidData.group.MonoLogIncrease.(mapNames{roi}).y,...
        sigmoidData.group.MonoLogIncrease.(mapNames{roi}).ysterr(1,:),sigmoidData.group.MonoLogIncrease.(mapNames{roi}).ysterr(2,:),'.','Color',coloursIncrease,...
        'MarkerFaceColor',coloursMono,'LineWidth',1);
    hold on; plot(sigmoidData.group.MonoLogIncrease.(mapNames{roi}).xfit, sigmoidData.group.MonoLogIncrease.(mapNames{roi}).yfit, '-', 'Color',coloursIncrease,'LineWidth',3);
    hold on; plot(sigmoidData.group.MonoLogIncrease.(mapNames{roi}).xfit, sigmoidData.group.MonoLogIncrease.(mapNames{roi}).b_upper, '--','Color',coloursIncrease,'LineWidth',2);
    hold on; plot(sigmoidData.group.MonoLogIncrease.(mapNames{roi}).xfit, sigmoidData.group.MonoLogIncrease.(mapNames{roi}).b_lower,  '--','Color',coloursIncrease,'LineWidth',2);    

    %% Monotonic numerosity (decreasing)
    veBoot_monoDecrease = fitData.ve.MonoLogDecrease.(mapNames{roi});
    x_monoDecrease = bins.MonoLogDecrease.x;
    y_monoDecrease = group.bins.MonoLogDecrease.(mapNames{roi}).mean';
    sterr_monoDecrease = group.bins.MonoLogDecrease.(mapNames{roi}).sterr';
    x_monoDecrease(y_monoDecrease==0) = [];
    sterr_monoDecrease(y_monoDecrease==0) = [];
    y_monoDecrease(y_monoDecrease==0) = [];
    
    % Bootstrapping
    [sigmoidData.group.MonoLogDecrease.(mapNames{roi}),fitParams.group.MonoLogDecrease.(mapNames{roi})] = fitSigmoid3(eccBoot,veBoot_monoDecrease, 0, 5.5, 0.2, ones(size(veBoot_monoDecrease)), 0);
    % For more robust estimates, consider using monoTuned_make_sigmoid_CIs
    
    scatter(sigmoidData.group.MonoLogDecrease.(mapNames{roi}).x, sigmoidData.group.MonoLogDecrease.(mapNames{roi}).y,[],'filled', 'MarkerFaceColor',coloursDecrease)
    hold on; errorbar(sigmoidData.group.MonoLogDecrease.(mapNames{roi}).x,sigmoidData.group.MonoLogDecrease.(mapNames{roi}).y,...
        sigmoidData.group.MonoLogDecrease.(mapNames{roi}).ysterr(1,:),sigmoidData.group.MonoLogDecrease.(mapNames{roi}).ysterr(2,:),'.','Color',coloursDecrease,...
        'MarkerFaceColor',coloursMono,'LineWidth',1);
    hold on; plot(sigmoidData.group.MonoLogDecrease.(mapNames{roi}).xfit, sigmoidData.group.MonoLogDecrease.(mapNames{roi}).yfit, '-', 'Color',coloursDecrease,'LineWidth',3);
    hold on; plot(sigmoidData.group.MonoLogDecrease.(mapNames{roi}).xfit, sigmoidData.group.MonoLogDecrease.(mapNames{roi}).b_upper, '--','Color',coloursDecrease,'LineWidth',2);
    hold on; plot(sigmoidData.group.MonoLogDecrease.(mapNames{roi}).xfit, sigmoidData.group.MonoLogDecrease.(mapNames{roi}).b_lower,  '--','Color',coloursDecrease,'LineWidth',2);
    
    %% Tuned numerosity
    veBoot_tuned = fitData.ve.TunedLog2Lin.(mapNames{roi});
    x_tuned = bins.TunedLog2Lin.x;
    y_tuned = group.bins.TunedLog2Lin.(mapNames{roi}).mean';
    sterr_tuned = group.bins.TunedLog2Lin.(mapNames{roi}).sterr';
    x_tuned(y_tuned==0) = [];
    sterr_tuned(y_tuned==0) = [];
    y_tuned(y_tuned==0) = [];
    
    % Bootstrapping
    [sigmoidData.group.TunedLog2Lin.(mapNames{roi}),fitParams.group.TunedLog2Lin.(mapNames{roi})] = fitSigmoid3(eccBoot,veBoot_tuned, 0, 5.5, 0.2, ones(size(veBoot_tuned)), 0);
    % For more robust estimates, consider using monoTuned_make_sigmoid_CIs
              
    scatter(sigmoidData.group.TunedLog2Lin.(mapNames{roi}).x, sigmoidData.group.TunedLog2Lin.(mapNames{roi}).y,[],'filled', 'MarkerFaceColor',coloursTuned)
    hold on; errorbar(sigmoidData.group.TunedLog2Lin.(mapNames{roi}).x,sigmoidData.group.TunedLog2Lin.(mapNames{roi}).y,...
        sigmoidData.group.TunedLog2Lin.(mapNames{roi}).ysterr(1,:),sigmoidData.group.TunedLog2Lin.(mapNames{roi}).ysterr(2,:),'.','Color',coloursTuned,...
        'MarkerFaceColor',coloursTuned,'LineWidth',1);
    hold on; plot(sigmoidData.group.TunedLog2Lin.(mapNames{roi}).xfit, sigmoidData.group.TunedLog2Lin.(mapNames{roi}).yfit, '-', 'Color',coloursTuned,'LineWidth',3);
    hold on; plot(sigmoidData.group.TunedLog2Lin.(mapNames{roi}).xfit, sigmoidData.group.TunedLog2Lin.(mapNames{roi}).b_upper, '--','Color',coloursTuned,'LineWidth',2);
    hold on; plot(sigmoidData.group.TunedLog2Lin.(mapNames{roi}).xfit, sigmoidData.group.TunedLog2Lin.(mapNames{roi}).b_lower,  '--','Color',coloursTuned,'LineWidth',2);

    axis([0 5.5 0 yrange])
    yticks(0:.1:.5);yticklabels({'0','0.1','0.2','0.3','0.4','0.5'});
    ylabel({'Response model fit (R^2)'},'FontWeight','bold');
    xticks(0:1:5);xticklabels({'0','1','2','3','4','5'});
    xlabel('Preferred eccentricity (^o)','FontWeight','bold');
    set(gca,'FontSize',15);
    axis square
    set(gcf,'color','w');
    box off
    
    if savePlots,export_fig(['FigS5a_',mapNames{roi}],'-png','-r600','-painters');close all;end
    if saveData,save(['sigmoidData_',mapNames{roi},'.mat'],'sigmoidData','fitParams');end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Response model fit (R^2) vs. preferred visual field eccentricity, participants S1-S11 Fig.S5b %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear ve_data cv_data ecc

participantNames = {'P01', 'P02', 'P03', 'P04', 'P05', 'P06', 'P07', 'P08', 'P09', 'P10', 'P11'};
whichParticipants=1:5;
group = [];group.bins = []; fitData = []; bins = [];
ROINames = {'IPS0', 'IPS1', 'IPS2', 'IPS3', 'IPS4', 'IPS5', ...
    'sPCS1', 'sPCS2', 'iPCS', 'LO1','LO2', 'TO1', 'TO2', ...
    'V1', 'V2', 'V3', 'V3AB'};
mapNames=["bothIPS0","bothIPS1","bothIPS2","bothIPS3","bothIPS4","bothIPS5","bothsPCS1","bothsPCS2","bothiPCS",...
    "bothLO1","bothLO2","bothTO1","bothTO2","bothV1","bothV2","bothV3","bothV3AB"];
modelFieldNames = {'MonoLog','TunedLog2Lin'};
binsize = 0.20;thresh.ecc = [0 5.5];voxelSize = 1.77;
bins.MonoLogIncrease.x = (thresh.ecc(1):binsize:thresh.ecc(2))';
bins.MonoLogDecrease.x = (thresh.ecc(1):binsize:thresh.ecc(2))';
bins.TunedLog2Lin.x = (thresh.ecc(1):binsize:thresh.ecc(2))';
minNumerosity=log(1.01);maxNumerosity=log(6.99);

for participant = 1:length(participantNames)
    ve_data.MonoLog.(participantNames{participant}) = data_numerosity.ve.(participantNames{participant}).MonoLog;
    ve_data.TunedLog2Lin.(participantNames{participant}) = data_numerosity.ve.(participantNames{participant}).TunedLog2Lin;
end

condNames = fieldnames(ve_data.MonoLog.(participantNames{participant}));
% Combine cross-validated model results
for participant = 1:length(participantNames)
    
    % Monotonic
    for ROIs = 1:length(mapNames)
        
        cv_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{1}).(mapNames{ROIs}).iCoords = ...
            ve_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{2}).(mapNames{ROIs}).iCoords;
        
        % Check for change in slope
        flipFlop = ~(ve_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{2}).(mapNames{ROIs}).xs == ...
            ve_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{3}).(mapNames{ROIs}).xs);

        cv_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{1}).(mapNames{ROIs}).xs = ...
            ve_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{2}).(mapNames{ROIs}).xs;
        
        cv_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{1}).(mapNames{ROIs}).xs(flipFlop) = 0; %set changed xs to 0

        cv_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{1}).(mapNames{ROIs}).varianceExplained = ...
            (ve_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{2}).(mapNames{ROIs}).varianceExplained + ...
            ve_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{3}).(mapNames{ROIs}).varianceExplained)./2;
        
        cv_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{1}).(mapNames{ROIs}).varianceExplained(flipFlop) = 0; %set changed VE to 0
        
    end
    % Tuned
    for ROIs = 1:length(mapNames)
        
        cv_data.(modelFieldNames{2}).(participantNames{participant}).(condNames{1}).(mapNames{ROIs}).iCoords = ...
            ve_data.(modelFieldNames{2}).(participantNames{participant}).(condNames{2}).(mapNames{ROIs}).iCoords;
        
        cv_data.(modelFieldNames{2}).(participantNames{participant}).(condNames{1}).(mapNames{ROIs}).xs = ...
            (ve_data.(modelFieldNames{2}).(participantNames{participant}).(condNames{2}).(mapNames{ROIs}).xs + ...
            ve_data.(modelFieldNames{2}).(participantNames{participant}).(condNames{3}).(mapNames{ROIs}).xs)./2;

        cv_data.(modelFieldNames{2}).(participantNames{participant}).(condNames{1}).(mapNames{ROIs}).varianceExplained = ...
            (ve_data.(modelFieldNames{2}).(participantNames{participant}).(condNames{2}).(mapNames{ROIs}).varianceExplained + ...
            ve_data.(modelFieldNames{2}).(participantNames{participant}).(condNames{3}).(mapNames{ROIs}).varianceExplained)./2;
    end
end

clear ve_data
ve_data = cv_data;

% Seperate out increase and decrease
ve_data.MonoLogIncrease = ve_data.MonoLog;
ve_data.MonoLogDecrease = ve_data.MonoLog;
condition=1;
for participant = 1:length(participantNames)
    condNames = fieldnames(ve_data.MonoLog.(participantNames{participant}));
    for roi = 1:length(mapNames)
        ve_data.MonoLogIncrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained...
            (ve_data.MonoLogIncrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).xs==2) = 0;
        ve_data.MonoLogDecrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained...
            (ve_data.MonoLogDecrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).xs==1) = 0;
    end
end

%% eccentricity
for participant = 1:length(participantNames)
    for roi = 1:length(mapNames)
        ecc.(participantNames{participant}).(char(mapNames{roi})).ecc = data_vfm.ve.(participantNames{participant}).VFML1.(char(mapNames{roi})).ecc;
        ecc.(participantNames{participant}).(char(mapNames{roi})).sigma = data_vfm.ve.(participantNames{participant}).VFML1.(char(mapNames{roi})).sigma;        
    end
end

%% Group data
for participant = 1:length(participantNames)
    condNames = fieldnames(ve_data.MonoLog.(participantNames{participant}));
    for roi = 1:length(mapNames)
        eccCurrent = ecc.(participantNames{participant}).(mapNames{roi}).ecc;
        veCurrent_monoIncrease = ve_data.MonoLogIncrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained;
        veCurrent_monoDecrease = ve_data.MonoLogDecrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained;
        veCurrent_tuned = ve_data.TunedLog2Lin.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained;
        
        if participant==1
            group.ecc.(mapNames{roi}).ecc = eccCurrent;
            group.ve_data.MonoLogIncrease.(mapNames{roi}) = veCurrent_monoIncrease;
            group.ve_data.MonoLogDecrease.(mapNames{roi}) = veCurrent_monoDecrease;            
            group.ve_data.TunedLog2Lin.(mapNames{roi}) = veCurrent_tuned;
        else
            group.ecc.(mapNames{roi}).ecc = [group.ecc.(mapNames{roi}).ecc, eccCurrent];
            group.ve_data.MonoLogIncrease.(mapNames{roi}) = [group.ve_data.MonoLogIncrease.(mapNames{roi}), veCurrent_monoIncrease];
            group.ve_data.MonoLogDecrease.(mapNames{roi}) = [group.ve_data.MonoLogDecrease.(mapNames{roi}), veCurrent_monoDecrease];            
            group.ve_data.TunedLog2Lin.(mapNames{roi}) = [group.ve_data.TunedLog2Lin.(mapNames{roi}), veCurrent_tuned];
        end
    end
end

for participant = 1:length(participantNames)
    condNames = fieldnames(ve_data.MonoLog.(participantNames{participant}));
    for roi = 1:length(mapNames)
        for b = round(thresh.ecc(1):binsize:thresh.ecc(2),1)
            % Determine which voxels are in each bin
            bii = ecc.(participantNames{participant}).(mapNames{roi}).ecc >  b-binsize./2 & ...
                ecc.(participantNames{participant}).(mapNames{roi}).ecc <= b+binsize./2;
            group_bii = group.ecc.(mapNames{roi}).ecc >  b-binsize./2 & ...
                group.ecc.(mapNames{roi}).ecc <= b+binsize./2;
            if any(bii)
                % Fit which eccentricity bin this corresponds to
                ii2 = find(bins.MonoLogIncrease.x == b);
                s_monoIncrease = wstat(ve_data.MonoLogIncrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained(bii),[], voxelSize^2);
                bins.MonoLogIncrease.(participantNames{participant}).(mapNames{roi}).sterr(:,ii2) = s_monoIncrease.sterr;
                bins.MonoLogIncrease.(participantNames{participant}).(mapNames{roi}).sdev(:,ii2) = s_monoIncrease.stdev;
                bins.MonoLogIncrease.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = s_monoIncrease.mean;

                s_monoDecrease = wstat(ve_data.MonoLogDecrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained(bii),[], voxelSize^2);
                bins.MonoLogDecrease.(participantNames{participant}).(mapNames{roi}).sterr(:,ii2) = s_monoDecrease.sterr;
                bins.MonoLogDecrease.(participantNames{participant}).(mapNames{roi}).sdev(:,ii2) = s_monoDecrease.stdev;
                bins.MonoLogDecrease.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = s_monoDecrease.mean;
                
                s_tuned = wstat(ve_data.TunedLog2Lin.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained(bii),[], voxelSize^2);
                bins.TunedLog2Lin.(participantNames{participant}).(mapNames{roi}).sterr(:,ii2) = s_tuned.sterr;
                bins.TunedLog2Lin.(participantNames{participant}).(mapNames{roi}).sdev(:,ii2) = s_tuned.stdev;
                bins.TunedLog2Lin.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = s_tuned.mean;

            else
                ii2 = find(bins.MonoLogIncrease.x == b);
                bins.MonoLogIncrease.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = 0;
                bins.MonoLogDecrease.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = 0;
                bins.TunedLog2Lin.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = 0;
                
            end
            if any(group_bii)                
                group_ii2 = find(round(bins.MonoLogIncrease.x,1) == b);
                s_monoIncrease = wstat(group.ve_data.MonoLogIncrease.(mapNames{roi})(group_bii),[], voxelSize^2);
                group.bins.MonoLogIncrease.(mapNames{roi}).sterr(:,group_ii2 ) = s_monoIncrease.sterr;
                group.bins.MonoLogIncrease.(mapNames{roi}).sdev(:,group_ii2 ) = s_monoIncrease.stdev;
                group.bins.MonoLogIncrease.(mapNames{roi}).mean(:,group_ii2 ) = s_monoIncrease.mean;
                
                s_monoDecrease = wstat(group.ve_data.MonoLogDecrease.(mapNames{roi})(group_bii),[], voxelSize^2);
                group.bins.MonoLogDecrease.(mapNames{roi}).sterr(:,group_ii2 ) = s_monoDecrease.sterr;
                group.bins.MonoLogDecrease.(mapNames{roi}).sdev(:,group_ii2 ) = s_monoDecrease.stdev;
                group.bins.MonoLogDecrease.(mapNames{roi}).mean(:,group_ii2 ) = s_monoDecrease.mean;                
                
                s_tuned = wstat(group.ve_data.TunedLog2Lin.(mapNames{roi})(group_bii),[], voxelSize^2);
                group.bins.TunedLog2Lin.(mapNames{roi}).sterr(:,group_ii2 ) = s_tuned.sterr;
                group.bins.TunedLog2Lin.(mapNames{roi}).sdev(:,group_ii2 ) = s_tuned.stdev;
                group.bins.TunedLog2Lin.(mapNames{roi}).mean(:,group_ii2 ) = s_tuned.mean;
            else
                group_ii2 = find(bins.MonoLogIncrease.x == b);
                group.bins.MonoLogIncrease.(mapNames{roi}).mean(:,group_ii2) = 0;
                group.bins.MonoLogDecrease.(mapNames{roi}).mean(:,group_ii2) = 0;                
                group.bins.TunedLog2Lin.(mapNames{roi}).mean(:,group_ii2) = 0;
            end                
        end
        
        %fitting data
        if participant==1
            fitData.ecc.(mapNames{roi}) = ecc.(participantNames{participant}).(mapNames{roi}).ecc;
            fitData.ve.MonoLogIncrease.(mapNames{roi}) = ve_data.MonoLogIncrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained;
            fitData.ve.MonoLogDecrease.(mapNames{roi}) = ve_data.MonoLogDecrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained;            
            fitData.ve.TunedLog2Lin.(mapNames{roi}) = ve_data.TunedLog2Lin.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained;
        else
            fitData.ecc.(mapNames{roi}) = [fitData.ecc.(mapNames{roi}),ecc.(participantNames{participant}).(mapNames{roi}).ecc];
            fitData.ve.MonoLogIncrease.(mapNames{roi}) = [fitData.ve.MonoLogIncrease.(mapNames{roi}),ve_data.MonoLogIncrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained];
            fitData.ve.MonoLogDecrease.(mapNames{roi}) = [fitData.ve.MonoLogDecrease.(mapNames{roi}),ve_data.MonoLogDecrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained];            
            fitData.ve.TunedLog2Lin.(mapNames{roi}) = [fitData.ve.TunedLog2Lin.(mapNames{roi}),ve_data.TunedLog2Lin.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained];
        end
    end

end

for roi = [12:13,17,1:9] % TO1&TO2, V3AB, IPS0-IPS5, iPCS, sPCS1&sPCS2
    %% Eccentricity data
    eccBoot = fitData.ecc.(mapNames{roi});
    minEcc = min(thresh.ecc); maxEcc = max(thresh.ecc);

    %% Quadratic fit
    nboot = 1000; % Number of bootstrap samples
    poly_order = 2; % Quadratic
        
    %% Monotonic numerosity (increasing)
    x_monoIncrease = bins.MonoLogIncrease.x;
    y_monoIncrease = group.bins.MonoLogIncrease.(mapNames{roi}).mean';
    sterr_monoIncrease = group.bins.MonoLogIncrease.(mapNames{roi}).sterr';
    x_monoIncrease(y_monoIncrease==0) = [];
    sterr_monoIncrease(y_monoIncrease==0) = [];
    y_monoIncrease(y_monoIncrease==0) = [];
    
    [pQuad_monoIncrease,SQuad_monoIncrease] = polyfit(x_monoIncrease,y_monoIncrease,poly_order);
    xvQuad_monoIncrease = linspace(min(x_monoIncrease), max(x_monoIncrease), 1000);
    [yQuad_ci_monoIncrease,deltaQuad_monoIncrease] = polyconf(pQuad_monoIncrease,xvQuad_monoIncrease,SQuad_monoIncrease,'predopt','curve');
    
    xfit = linspace(min(x_monoIncrease(~isnan(y_monoIncrease))),max(x_monoIncrease(~isnan(y_monoIncrease))),1000)';
    yfit = polyval(pQuad_monoIncrease,xfit,SQuad_monoIncrease);
     
    figure
    errorbar(x_monoIncrease, y_monoIncrease, sterr_monoIncrease, '.','Color',coloursIncrease(colourROI,:),'LineWidth',1); % Original data
    hold on
    scatter(x_monoIncrease, y_monoIncrease, [], coloursIncrease(colourROI,:),'filled'); % Original data
    hold on
    plot(xfit,yfit,'Color',coloursIncrease(colourROI,:),'LineWidth',3); % Fit
    plot(xfit,yQuad_ci_monoIncrease-deltaQuad_monoIncrease, '--','Color',coloursIncrease(colourROI,:),'LineWidth',2); % 95% confidence interval of fit line
    plot(xfit,yQuad_ci_monoIncrease+deltaQuad_monoIncrease, '--','Color',coloursIncrease(colourROI,:),'LineWidth',2); % 95% confidence interval of fit line
    
    %% Monotonic numerosity (decreasing)
    x_monoDecrease = bins.MonoLogDecrease.x;
    y_monoDecrease = group.bins.MonoLogDecrease.(mapNames{roi}).mean';
    sterr_monoDecrease = group.bins.MonoLogDecrease.(mapNames{roi}).sterr';
    x_monoDecrease(y_monoDecrease==0) = [];
    sterr_monoDecrease(y_monoDecrease==0) = [];
    y_monoDecrease(y_monoDecrease==0) = [];
    
    [pQuad_monoDecrease,SQuad_monoDecrease] = polyfit(x_monoDecrease,y_monoDecrease,poly_order);
    xvQuad_monoDecrease = linspace(min(x_monoDecrease), max(x_monoDecrease), 1000);
    [yQuad_ci_monoDecrease,deltaQuad_monoDecrease] = polyconf(pQuad_monoDecrease,xvQuad_monoDecrease,SQuad_monoDecrease,'predopt','curve');
    
    xfit = linspace(min(x_monoDecrease(~isnan(y_monoDecrease))),max(x_monoDecrease(~isnan(y_monoDecrease))),1000)';
    yfit = polyval(pQuad_monoDecrease,xfit,SQuad_monoDecrease);
           
    errorbar(x_monoDecrease, y_monoDecrease, sterr_monoDecrease, '.','Color',coloursDecrease(colourROI,:),'LineWidth',1); % Original data
    hold on
    scatter(x_monoDecrease, y_monoDecrease, [], coloursDecrease(colourROI,:),'filled'); % Original data
    hold on
    plot(xfit,yfit,'Color',coloursDecrease(colourROI,:),'LineWidth',3); % Fit
    plot(xfit,yQuad_ci_monoDecrease-deltaQuad_monoDecrease, '--','Color',coloursDecrease(colourROI,:),'LineWidth',2); % 95% confidence interval of fit line
    plot(xfit,yQuad_ci_monoDecrease+deltaQuad_monoDecrease, '--','Color',coloursDecrease(colourROI,:),'LineWidth',2); % 95% confidence interval of fit line
    
    %% Tuned numerosity
    x_tuned = bins.TunedLog2Lin.x;
    y_tuned = group.bins.TunedLog2Lin.(mapNames{roi}).mean';
    sterr_tuned = group.bins.TunedLog2Lin.(mapNames{roi}).sterr';
    x_tuned(y_tuned==0) = [];
    sterr_tuned(y_tuned==0) = [];
    y_tuned(y_tuned==0) = [];
    
    [pQuad_tuned,SQuad_tuned] = polyfit(x_tuned,y_tuned,poly_order);
    xvQuad_tuned = linspace(min(x_tuned), max(x_tuned), 1000);
    [yQuad_ci_tuned,deltaQuad_tuned] = polyconf(pQuad_tuned,xvQuad_tuned,SQuad_tuned,'predopt','curve');
    
    xfit = linspace(min(x_tuned(~isnan(y_tuned))),max(x_tuned(~isnan(y_tuned))),1000)';
    yfit = polyval(pQuad_tuned,xfit,SQuad_tuned);
           
    errorbar(x_tuned, y_tuned, sterr_tuned, '.','Color',coloursTuned(colourROI,:),'LineWidth',1); % Original data
    hold on
    scatter(x_tuned, y_tuned, [], coloursTuned(colourROI,:),'filled'); % Original data
    hold on
    plot(xfit,yfit,'Color',coloursTuned(colourROI,:),'LineWidth',3); % Fit
    plot(xfit,yQuad_ci_tuned-deltaQuad_tuned, '--','Color',coloursTuned(colourROI,:),'LineWidth',2); % 95% confidence interval of fit line
    plot(xfit,yQuad_ci_tuned+deltaQuad_tuned, '--','Color',coloursTuned(colourROI,:),'LineWidth',2); % 95% confidence interval of fit line
    
    axis([0 5.5 0 yrange])
    yticks(0:.1:.5);yticklabels({'0','0.1','0.2','0.3','0.4','0.5'});
    ylabel({'Response model fit (R^2)'},'FontWeight','bold');
    xticks(0:1:5);xticklabels({'0','1','2','3','4','5'});
    xlabel('Preferred eccentricity (^o)','FontWeight','bold');
    set(gca,'FontSize',15);
    axis square
    set(gcf,'color','w');
    box off

    if savePlots,export_fig(['FigS5b_',mapNames{roi}],'-png','-r600','-painters');close all;end
end

if saveData,save('Rsquared_data.mat','Rsquared','Rsquared_P');end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% % Cumulative Gaussian & Quadratic model fit R^2 vs. visual field map Fig.S5c %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

quadFits_monoIncrease=zeros(1,17);quadFits_monoDecrease=zeros(1,17);quadFits_tuned=zeros(1,17);quadFits_fourier=zeros(1,17);
sigmFits_monoIncrease=zeros(1,17);sigmFits_monoDecrease=zeros(1,17);sigmFits_tuned=zeros(1,17);sigmFits_fourier=zeros(1,17);

for roi=1:17  
    quadFits_monoIncrease(roi) = Rsquared.quad.MonoLogIncrease.(ROINames{roi});
    quadFits_monoDecrease(roi) = Rsquared.quad.MonoLogDecrease.(ROINames{roi});
    quadFits_tuned(roi) = Rsquared.quad.TunedLog2Lin.(ROINames{roi});
    quadFits_fourier(roi) = Rsquared.quad.FourierPowerIncrease.(ROINames{roi});
    
    sigmFits_monoIncrease(roi) = Rsquared.sigm.MonoLogIncrease.(ROINames{roi});
    sigmFits_monoDecrease(roi) = Rsquared.sigm.MonoLogDecrease.(ROINames{roi});
    sigmFits_tuned(roi) = Rsquared.sigm.TunedLog2Lin.(ROINames{roi});
    sigmFits_fourier(roi) = Rsquared.sigm.FourierPowerIncrease.(ROINames{roi});
end

scatter_order=[14:16,10:13,17,1:9];
scatter_roiLabels = {'IPS0','IPS1','IPS2','IPS3','IPS4','IPS5',...
    'sPCS1','sPCS2','iPCS','LO1 ','LO2 ','TO1 ','TO2 ',...
    ' V1 ',' V2 ',' V3 ','V3AB'};

% Fourier power increasing
figure;hold on
plot(1:length(ROINames),quadFits_fourier(scatter_order),':','Color',coloursFourierPower(colourROI,:),'LineWidth',3);
plot(1:length(ROINames),sigmFits_fourier(scatter_order),'-','Color',coloursFourierPower(colourROI,:),'LineWidth',3);
scatter(1:length(ROINames),quadFits_fourier(scatter_order),64,coloursFourierPower(colourROI,:),'s','filled','LineWidth',2,...
    'MarkerFaceColor',[224,255,255]./255,'MarkerEdgeColor',coloursFourierPower(colourROI,:));
scatter(1:length(ROINames),sigmFits_fourier(scatter_order),64,coloursFourierPower(colourROI,:),'s','filled','LineWidth',2,...
    'MarkerFaceColor',[224,255,255]./255,'MarkerEdgeColor',coloursFourierPower(colourROI,:));
xticks(1:1:17);xticklabels([scatter_roiLabels(scatter_order(1:end)),' ',scatter_roiLabels(scatter_order(1:end))]);
xtickangle(90);box off
axis([0,18,0,1])
yticks(0:.2:1);yticklabels({'0','0.2','0.4','0.6','0.8','1'})
set(gca,'FontSize',15);
set(gcf,'Color','w');
xlabel('Visual Field Maps','FontWeight','bold');
ylabel({'Eccentricity progression fit (%R^2)';'Fourier Power'},'FontWeight','bold');
set(gcf,'units','centimeters','position',[0.1 0.1 18 12]);
if savePlots
    export_fig(['FigS5c_fourier','.png'],'-png','-r600','-painters');
end

% Numerosity monotonically increasing
figure;hold on
plot(1:length(ROINames),quadFits_monoIncrease(scatter_order),':','Color',coloursIncrease(colourROI,:),'LineWidth',3);
plot(1:length(ROINames),sigmFits_monoIncrease(scatter_order),'-','Color',coloursIncrease(colourROI,:),'LineWidth',3);
scatter(1:length(ROINames),quadFits_monoIncrease(scatter_order),64,coloursIncrease(colourROI,:),'s','filled','LineWidth',2,...
    'MarkerFaceColor',[.8,.8,1],'MarkerEdgeColor',coloursIncrease(colourROI,:));
scatter(1:length(ROINames),sigmFits_monoIncrease(scatter_order),64,coloursIncrease(colourROI,:),'s','filled','LineWidth',2,...
    'MarkerFaceColor',[.8,.8,1],'MarkerEdgeColor',coloursIncrease(colourROI,:));
xticks(1:1:17);xticklabels([scatter_roiLabels(scatter_order(1:end)),' ',scatter_roiLabels(scatter_order(1:end))]);
xtickangle(90);box off
axis([0,18,0,1])
yticks(0:.2:1);yticklabels({'0','0.2','0.4','0.6','0.8','1'})
set(gca,'FontSize',15);
set(gcf,'Color','w');
xlabel('Visual Field Maps','FontWeight','bold');
ylabel({'Eccentricity progression fit (%R^2)';'Numerosity monotonically increasing'},'FontWeight','bold');
set(gcf,'units','centimeters','position',[0.1 0.1 18 12]);
if savePlots
    export_fig(['FigS5c_increasing','.png'],'-png','-r600','-painters');
end

% Numerosity monotonically decreasing
figure;hold on
plot(1:length(ROINames),quadFits_monoDecrease(scatter_order),':','Color',coloursDecrease(colourROI,:),'LineWidth',3);
plot(1:length(ROINames),sigmFits_monoDecrease(scatter_order),'-','Color',coloursDecrease(colourROI,:),'LineWidth',3);
scatter(1:length(ROINames),quadFits_monoDecrease(scatter_order),64,coloursDecrease(colourROI,:),'s','filled','LineWidth',2,...
    'MarkerFaceColor',[.8,1,.8],'MarkerEdgeColor',coloursDecrease(colourROI,:));
scatter(1:length(ROINames),sigmFits_monoDecrease(scatter_order),64,coloursDecrease(colourROI,:),'s','filled','LineWidth',2,...
    'MarkerFaceColor',[.8,1,.8],'MarkerEdgeColor',coloursDecrease(colourROI,:));
xticks(1:1:17);xticklabels([scatter_roiLabels(scatter_order(1:end)),' ',scatter_roiLabels(scatter_order(1:end))]);
xtickangle(90);box off
axis([0,18,0,1])
yticks(0:.2:1);yticklabels({'0','0.2','0.4','0.6','0.8','1'})
set(gca,'FontSize',15);
set(gcf,'Color','w');
xlabel('Visual Field Maps','FontWeight','bold');
ylabel({'Eccentricity progression fit (%R^2)';'Numerosity monotonically decreasing'},'FontWeight','bold');
set(gcf,'units','centimeters','position',[0.1 0.1 18 12]);
if savePlots
    export_fig(['FigS5c_decreasing','.png'],'-png','-r600','-painters');
end

% Numerosity tuned
figure;hold on
plot(1:length(ROINames),quadFits_tuned(scatter_order),':','Color',coloursTuned(colourROI,:),'LineWidth',3);
plot(1:length(ROINames),sigmFits_tuned(scatter_order),'-','Color',coloursTuned(colourROI,:),'LineWidth',3);
scatter(1:length(ROINames),quadFits_tuned(scatter_order),64,coloursTuned(colourROI,:),'s','filled','LineWidth',2,...
    'MarkerFaceColor',[1,.8,.8],'MarkerEdgeColor',coloursTuned(colourROI,:));
scatter(1:length(ROINames),sigmFits_tuned(scatter_order),64,coloursTuned(colourROI,:),'s','filled','LineWidth',2,...
    'MarkerFaceColor',[1,.8,.8],'MarkerEdgeColor',coloursTuned(colourROI,:));
xticks(1:1:17);xticklabels([scatter_roiLabels(scatter_order(1:end)),' ',scatter_roiLabels(scatter_order(1:end))]);
xtickangle(90);box off
axis([0,18,0,1])
yticks(0:.2:1);yticklabels({'0','0.2','0.4','0.6','0.8','1'})
set(gca,'FontSize',15);
set(gcf,'Color','w');
xlabel('Visual Field Maps','FontWeight','bold');
ylabel({'Eccentricity progression fit (%R^2)';'Numerosity tuned'},'FontWeight','bold');
set(gcf,'units','centimeters','position',[0.1 0.1 18 12]);
if savePlots
    export_fig(['FigS5c_tuned','.png'],'-png','-r600','-painters');
end
