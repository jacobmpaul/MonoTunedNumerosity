%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% monoTunedNumerosity_load_data %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load numerosity data, creates the following structures:
%% (1) data_numerosity, doi: 10.6084/m9.figshare.17294390
%% (2) data_vfm, doi: 10.6084/m9.figshare.17294219
%% (3) time_series_numerosity, doi: 10.6084/m9.figshare.17294342
%% (4) time_series_vfm, doi: 10.6084/m9.figshare.17294060

%% Paths where data is stored
data_dir = '/mnt/data/';

paths{1}=strcat(data_dir,'P01');
paths{2}=strcat(data_dir,'P02');
paths{3}=strcat(data_dir,'P03');
paths{4}=strcat(data_dir,'P04');
paths{5}=strcat(data_dir,'P05');
paths{6}=strcat(data_dir,'P06');
paths{7}=strcat(data_dir,'P07');
paths{8}=strcat(data_dir,'P08');
paths{9}=strcat(data_dir,'P09');
paths{10}=strcat(data_dir,'P10');
paths{11}=strcat(data_dir,'P11');

%% Other info
save_path = strcat(data_dir, '/NatComms/');

modelFieldNames = {'MonoLog','TunedLog2Lin'};
participantNames = {'P01','P02','P03','P04','P05','P06','P07','P08','P09','P10','P11'};
minNumerosity=log(1.01);maxNumerosity=log(6.99);

%% ROI names
VFM_ROIs =  {'IPS0', 'IPS1', 'IPS2', 'IPS3', 'IPS4', 'IPS5', 'sPCS1', 'sPCS2', 'iPCS', 'LO1', 'LO2', 'TO1', 'TO2', 'V1', 'V2','V3', 'V3AB'};
Num_ROIs = {'Front', 'IPS1', 'IPS2', 'IPS3', 'PO', 'TO'};

% VFM model
file_VF = 'retModel-Decimate-Freexy-FreeHRF_NoDC_OneG-fFit-fFit-fFit';

%% Get data
for participant = 1:length(participantNames)
    for numerosity_maps = 0:1 % VFM = 0, NM = 1
        if numerosity_maps == 0
            ROILabels = [strcat('left', VFM_ROIs), strcat('right', VFM_ROIs), strcat('both', VFM_ROIs)];
            ROINames = strcat('VFMafni_', ROILabels, '.mat');
        elseif numerosity_maps == 1
            ROILabels = [strcat('NumLeft', Num_ROIs), strcat('NumRight', Num_ROIs)];
            ROINames = strcat(ROILabels,'.mat');
        end
        
        % Starts mrVista 3
        cd(paths{participant})
        VOLUME{1} = initHiddenGray;
        
        % Get each voxel's VFM eccentricities
        vfm_path = strcat(paths{participant},'/Gray/VFM (L1)/');
        eccentricity_path = [vfm_path ,file_VF];
        load(fullfile(eccentricity_path))
        % Get info for each ROI
        for roi = 1:length(ROINames)
            cd(paths{participant})
            ROI_path = strcat(paths{participant},'/Gray/ROIs/',ROINames{roi});
            
            if exist(ROI_path, 'file') == 2
                
                load(fullfile(ROI_path))                                    %Load ROIs
                [~, iCrds] = intersectCols(VOLUME{1}.coords, ROI.coords);   %Isolate ROI locations
                eccentricities = rmGet(model{1}, 'eccentricity');
                polarAngle = rmGet(model{1}, 'polar-angle');
                sigmas = model{1}.sigma.major;
                varianceExplained = rmGet(model{1},'ve');                   %Get variance explained (VE) Calculated with rmGet
                varianceExplained = varianceExplained(iCrds);               %Get VE in ROI
                rss = model{1}.rss(iCrds);
                rawrss = model{1}.rawrss(iCrds);
                
                data_vfm.ve.(participantNames{participant}).VFML1.(ROILabels{roi}).iCoords = iCrds;                         % Save VFM coords
                data_vfm.ve.(participantNames{participant}).VFML1.(ROILabels{roi}).ecc = eccentricities(iCrds);             % Save VFM ecc
                data_vfm.ve.(participantNames{participant}).VFML1.(ROILabels{roi}).pol = polarAngle(iCrds);                 % Save VFM pol
                data_vfm.ve.(participantNames{participant}).VFML1.(ROILabels{roi}).sigma = sigmas(iCrds);                   % Save VFM sigma
                data_vfm.ve.(participantNames{participant}).VFML1.(ROILabels{roi}).varianceExplained = varianceExplained;   % Save VFM variance explained
                data_vfm.ve.(participantNames{participant}).VFML1.(ROILabels{roi}).rss = rss;                               % Save VFM rss
                data_vfm.ve.(participantNames{participant}).VFML1.(ROILabels{roi}).rawrss = rawrss;                         % Save VFM rawrss
                
                % Get each voxel's VFM time-series
                time_series_vfm.(participantNames{participant}).VFML1.(ROILabels{roi}).iCoords = iCrds;
                cd([vfm_path,'TSeries/Scan1']);
                load('tSeries1');
                time_series_vfm.(participantNames{participant}).VFML1.(ROILabels{roi}).Scan1 = tSeries(:,iCrds);
            end
        end
        
        cd(paths{participant})
        if participant<=5
            stimuli = [9,14:15];
        else
            stimuli = [7,10:11];
        end
        
        % Get model info voxels
        for stim = 1:length(stimuli)
            
            for models = 1:length(modelFieldNames)
                
                % Get correct folder for stimulus configuration
                stimName = regexprep((dataTYPES(1,stimuli(stim)).name), '[^\w'']','');
                if stim==1
                    modelNames = {'*Monotonic-Log-*gFit-gFit.mat', '*Log-FullBlanks-DT0.5-Fineret*gFit-gFit.mat'};
                    stimFolder = fullfile('Gray',dataTYPES(1,stimuli(stim)).name); %Average
                else
                    modelNames = {'*Monotonic-Log-FullBlanks-DT0.5-gFit-gFit.mat', 'xval-*Log-*gFit-fFit.mat'};
                    if models==1
                        stimFolder = fullfile('Gray',dataTYPES(1,stimuli(stim)).name);
                    else
                        stimFolder = fullfile('Gray',dataTYPES(1,stimuli(stim)).name,'SearchFit_tuned/xval');
                    end
                end
                % Load current filename
                
                cd(stimFolder);
                load(strcat(ls(modelNames{models})));
                
                % Get info for each ROI
                for roi = 1:length(ROINames)
                    cd(paths{participant})
                    ROI_path = strcat(paths{participant},'/Gray/ROIs/',ROINames{roi});
                    
                    if exist(ROI_path, 'file') == 2
                        load(fullfile(ROI_path))                                    %Load ROIs
                        [~, iCrds] = intersectCols(VOLUME{1}.coords, ROI.coords);   %Isolate ROI locations
                        varianceExplained = rmGet(model{1},'ve');                   %Get variance explained (VE) Calculated with rmGet
                        varianceExplained = varianceExplained(iCrds);               %Get VE in ROI
                        xs = model{1}.x0(iCrds);
                        rss = model{1}.rss(iCrds);
                        rawrss = model{1}.rawrss(iCrds);
                        
                        if models>1 %tuned model restrict to 1-7 range
                            varianceExplained(xs<=minNumerosity)=0;
                            varianceExplained(xs>=maxNumerosity)=0;
                        end
                        
                        grayROI=load(fullfile(strcat(paths{participant},'/Gray/ROIs/gray-Layer1.mat')));
                        grayCoords=grayROI.ROI.coords;
                        
                        data_numerosity.ve.(participantNames{participant}).(modelFieldNames{models}).(stimName).(ROILabels{roi}).iCoords = iCrds;                        % Save ROI coords
                        data_numerosity.ve.(participantNames{participant}).(modelFieldNames{models}).(stimName).(ROILabels{roi}).xs = xs;                                % Save best fitting model
                        if strcmp(modelFieldNames{models},'TunedLog2Lin')==1
                            data_numerosity.ve.(participantNames{participant}).(modelFieldNames{models}).(stimName).(ROILabels{roi}).sigma_tuned = model{1}.sigma.major(iCrds);
                        end
                        data_numerosity.ve.(participantNames{participant}).(modelFieldNames{models}).(stimName).(ROILabels{roi}).varianceExplained = varianceExplained;  % Save VE
                        data_numerosity.ve.(participantNames{participant}).(modelFieldNames{models}).(stimName).(ROILabels{roi}).rss = rss;                              % Save rss
                        data_numerosity.ve.(participantNames{participant}).(modelFieldNames{models}).(stimName).(ROILabels{roi}).rawrss = rawrss;                        % Save rawrss
                        
                        % Get time-series
                        if models == 1
                            time_series_numerosity.(participantNames{participant}).(stimName).(ROILabels{roi}).iCoords = iCrds;
                            cd(strcat(paths{participant}, '/',stimFolder, '/TSeries/Scan1'));
                            load('tSeries1');
                            time_series_numerosity.(participantNames{participant}).(stimName).(ROILabels{roi}).Scan1 = tSeries(:,iCrds);
                            cd(paths{participant})
                        end
                    else
                        fprintf('Map does not exist: %s for %s \n',ROINames{roi}, participantNames{participant})
                    end
                end
            end
        end
    end
    mrvCleanWorkspace
end

%% Get distances between monotonic numerosity decreasing & tuned numerosity responses

modelFieldNames = {'TunedLog2Lin', 'MonoLog'};
participantNames = {'Dumo', 'Frac', 'Harv', 'Klei', 'Nell', 'S8', 'S9', 'S10', 'S11', 'S12', 'S13'};
ROINames = {'gray-Layer1'}; ROIFieldNames = {'grayLayer1'};
cross_validated = 1; veLimit = .30;
groupDistances = []; groupNumerosity = [];

% Find best fitting model (log(tuned) or monotonic) at each voxel
for participant = 1:length(participantNames)
    cd(paths{participant})
    VOLUME{1} = initHiddenGray;
    
    if participant<=5
        stimuli = [9,14:15];% All,odd,even
    else
        stimuli = [7,10:11]; % All,odd,even
    end
    
    for stim = 1:length(stimuli)
        VOLUME{1}.curDataType = stimuli(stim);
        
        for models = 1:length(modelFieldNames)
            
            % Get correct folder for stimulus configuration
            if stim == 1
                modelNames = {'*Log-FullBlanks-DT0.5-Fineret*gFit-gFit.mat', '*Monotonic-Log-*gFit-gFit.mat'};
                stimFolder = fullfile([paths{participant}],'Gray',dataTYPES(1,stimuli(stim)).name); % Average
                
                cd(stimFolder);
                load(strcat(ls(modelNames{models})));
                if models == 1 % Tuned numerosity
                    Log2Lin
                    tuneAll = rmGet(model{1},'ve');
                    tuneAll_xs = model{1}.x0;
                    tuneAll_rss = model{1}.rss;
                    tuneAll_rawrss = model{1}.rawrss;
                end
                
                if models == 2 % Monotonic numerosity
                    monoAll = rmGet(model{1},'ve');
                    monoAll_xs = model{1}.x0;
                    monoAll_rss = model{1}.rss;
                    monoAll_rawrss = model{1}.rawrss;
                end
                
            else
                modelNames = {'xval-*Log-*gFit-fFit.mat', '*Monotonic-Log-FullBlanks-DT0.5-gFit-gFit.mat'};
                if models == 1
                    stimFolder = fullfile([paths{participant}],'Gray',dataTYPES(1,stimuli(stim)).name,'SearchFit_tuned/xval');
                    cd(stimFolder);
                    load(strcat(ls(modelNames{models})));
                    Log2Lin
                    if stim == 2
                        tuneOdd = rmGet(model{1},'ve');
                        tuneOdd_xs = model{1}.x0;
                        tuneOdd_rss = model{1}.rss;
                        tuneOdd_rawrss = model{1}.rawrss;
                    elseif stim == 3
                        tuneEven = rmGet(model{1},'ve');
                        tuneEven_xs = model{1}.x0;
                        tuneEven_rss = model{1}.rss;
                        tuneEven_rawrss = model{1}.rawrss;
                    end
                else
                    stimFolder = fullfile([paths{participant}],'Gray',dataTYPES(1,stimuli(stim)).name);
                    cd(stimFolder);
                    load(strcat(ls(modelNames{models})));
                    if stim == 2
                        monoOdd = rmGet(model{1},'ve');
                        monoOdd_xs = model{1}.x0;
                        monoOdd_rss = model{1}.rss;
                        monoOdd_rawrss = model{1}.rawrss;
                    elseif stim == 3
                        monoEven = rmGet(model{1},'ve');
                        monoEven_xs = model{1}.x0;
                        monoEven_rss = model{1}.rss;
                        monoEven_rawrss = model{1}.rawrss;
                    end
                end
            end
            
        end
        
    end
    
    cd(paths{participant})
    
    if cross_validated==1
        % Check for change in slope
        flipFlop = ~(monoOdd_xs == monoEven_xs);
        mono_xs = monoOdd_xs;
        mono_xs(flipFlop) = 0; % Set changed xs to 0
        mono = (monoOdd + monoEven)./2;
        mono(flipFlop) = 0; % Set changed VE to 0
        mono_rss = (monoOdd_rss + monoEven_rss)./2;
        mono_rss(flipFlop) = 0; % Set changed VE to 0
        mono_rawrss = (monoOdd_rawrss + monoEven_rawrss)./2;
        mono_rawrss(flipFlop) = 0; % Set changed VE to 0
        
        tune_xs = (tuneOdd_xs + tuneEven_xs)./2;
        tune = (tuneOdd + tuneEven)./2;
        tune_rss = (tuneOdd_rss + tuneEven_rss)./2;
        tune_rawrss = (tuneOdd_rawrss + tuneEven_rawrss)./2;
    else
        tune = tuneAll;
        tune_xs = tuneAll_xs;
        tune_rss = tuneAll_rss;
        tune_rawrss = tuneAll_rawrss;
        mono = monoAll;
        mono_xs = monoAll_xs;
        mono_rss = monoAll_rss;
        mono_rawrss = monoAll_rawrss;
    end
    
    tune(tune_xs<1.01 | tune_xs>6.99) = 0; % Restrict mapWin to number range 1-7
       
    savePath = 'F:\data\NatComms\';    
       
    %% Tuned numerosity
    model{1}.x0=[];model{1}.rss=[];model{1}.rawrss=[];
    
    tuneIdx=[];
    monotunedT = zeros(size(mono)).*-1;
    for idx=1:size(mono,2)
        if (tune(idx) > mono(idx) && (tune(idx) >= veLimit)) % Tuned response fits better than monotonic
            monotunedT(idx) = tune(idx);
            model{1}.x0(idx) = monotunedT(idx);
            model{1}.rss(idx) = tune_rss(idx);
            model{1}.rawrss(idx) = tune_rawrss(idx);
            tuneIdx=[tuneIdx,idx]; %#ok<AGROW>
            
        elseif (tune(idx) < mono(idx) && (mono(idx) >= veLimit)) % Monotonic response fits better than tuned
            if mono_xs(idx) == 1 % Increasing
                monotunedT(idx) = -1;
                model{1}.x0(idx) = monotunedT(idx);
                model{1}.rss(idx) = -1;
                model{1}.rawrss(idx) = -1;
            elseif mono_xs(idx) == 2 % Decreasing
                monotunedT(idx) = -1;
                model{1}.x0(idx) = monotunedT(idx);
                model{1}.rss(idx) = -1;
                model{1}.rawrss(idx) = -1;
            end
            
        elseif (tune(idx) && mono(idx)) == 0 % Neither model fits well
            monotunedT(idx) = -1;
            model{1}.x0(idx) = monotunedT(idx);
            model{1}.rss(idx) = -1;
            model{1}.rawrss(idx) = -1;
            continue
        elseif (tune(idx) == mono(idx) && (tune(idx) >= veLimit)) % Tuned and monotonic response fits equally well, coin-flip
            monotuneFlip = randi(2);
            if monotuneFlip == 1 % Choose monotonic
                if mono_xs(idx) == 1 % Increasing
                    monotunedT(idx) = -1;
                    model{1}.x0(idx) = monotunedT(idx);
                    model{1}.rss(idx) = -1;
                    model{1}.rawrss(idx) = -1;                    
                elseif mono_xs(idx) == 2 % Decreasing
                    monotunedT(idx) = -1;
                    model{1}.x0(idx) = monotunedT(idx);
                    model{1}.rss(idx) = -1;
                    model{1}.rawrss(idx) = -1;                   
                end
            elseif monotuneFlip == 2 % Choose tuned
                monotunedT(idx) = tune(idx);
                model{1}.x0(idx) = monotunedT(idx);
                model{1}.rss(idx) = tune_rss(idx);
                model{1}.rawrss(idx) = tune_rawrss(idx);
                tuneIdx=[tuneIdx,idx]; %#ok<AGROW>
            end    
        end
    end
       
    %% Monotonic increase
    model{1}.x0=[];model{1}.rss=[];model{1}.rawrss=[];
    
    monoInIdx=[];
    monotunedI = zeros(size(mono)).*-1;
    for idx=1:size(mono,2)
        if (tune(idx) > mono(idx) && (tune(idx) >= veLimit)) % Tuned response fits better than monotonic
            monotunedI(idx) = -1;
            model{1}.x0(idx) = monotunedI(idx);
            model{1}.rss(idx) = -1;
            model{1}.rawrss(idx) = -1;
        elseif (tune(idx) < mono(idx) && (mono(idx) >= veLimit)) % Monotonic response fits better than tuned
            if mono_xs(idx) == 1 % Increasing
                monotunedI(idx) = mono(idx);
                model{1}.x0(idx) = monotunedI(idx);
                model{1}.rss(idx) = mono_rss(idx);
                model{1}.rawrss(idx) = mono_rawrss(idx);
                monoInIdx=[monoInIdx,idx]; %#ok<AGROW>
            elseif mono_xs(idx) == 2 % Decreasing
                monotunedI(idx) = -1;
                model{1}.x0(idx) = monotunedI(idx);
                model{1}.rss(idx) = -1;
                model{1}.rawrss(idx) = -1;
            end
        elseif (tune(idx) && mono(idx)) == 0 % Neither model fits well
            monotunedI(idx) = -1;
            model{1}.x0(idx) = monotunedI(idx);
            model{1}.rss(idx) = -1;
            model{1}.rawrss(idx) = -1;
            continue
        elseif (tune(idx) == mono(idx) && (tune(idx) >= veLimit)) % Tuned and monotonic response fits equally well, coin-flip
            monotuneFlip = randi(2);
            if monotuneFlip == 1 % Choose mono
                if mono_xs(idx) == 1 % Increasing
                    monotunedI(idx) = mono(idx);
                    model{1}.x0(idx) = monotunedI(idx);
                    model{1}.rss(idx) = mono_rss(idx);
                    model{1}.rawrss(idx) = mono_rawrss(idx);
                    monoInIdx=[monoInIdx,idx]; %#ok<AGROW>
                elseif mono_xs(idx) == 2 % Decreasing
                    monotunedI(idx) = -1;
                    model{1}.x0(idx) = monotunedI(idx);
                    model{1}.rss(idx) = -1;
                    model{1}.rawrss(idx) = -1;
                end
            elseif monotuneFlip == 2 % Choose tuned
                monotunedI(idx) = -1;
                model{1}.x0(idx) = monotunedI(idx);
                model{1}.rss(idx) = -1;
                model{1}.rawrss(idx) = -1;
            end
        end
    end

    %% Monotonic decrease
    model{1}.x0=[];model{1}.rss=[];model{1}.rawrss=[];
    
    monoDeIdx=[];
    monotunedD = zeros(size(mono)).*-1;
    for idx=1:size(mono,2)
        if (tune(idx) > mono(idx) && (tune(idx) >= veLimit)) % Tuned response fits better than monotonic
            monotunedD(idx) = -1;
            model{1}.x0(idx) = monotunedD(idx);
            model{1}.rss(idx) = -1;
            model{1}.rawrss(idx) = -1;
        elseif (tune(idx) < mono(idx) && (mono(idx) >= veLimit)) % Monotonic response fits better than tuned
            if mono_xs(idx) == 1 % Increasing
                monotunedD(idx) = -1;
                model{1}.x0(idx) = monotunedD(idx);
                model{1}.rss(idx) = -1;
                model{1}.rawrss(idx) = -1;
            elseif mono_xs(idx) == 2 % Decreasing
                monotunedD(idx) = mono(idx);
                model{1}.x0(idx) = monotunedD(idx);
                model{1}.rss(idx) = mono_rss(idx);
                model{1}.rawrss(idx) = mono_rawrss(idx);
                monoDeIdx=[monoDeIdx,idx]; %#ok<AGROW>
            end
        elseif (tune(idx) && mono(idx)) == 0 % Neither model fits well
            monotunedD(idx) = -1;
            model{1}.x0(idx) = monotunedD(idx);
            model{1}.rss(idx) = -1;
            model{1}.rawrss(idx) = -1;
            continue
        elseif (tune(idx) == mono(idx) && (tune(idx) >= veLimit)) % Tuned and monotonic response fits equally well, coin-flip
            monotuneFlip = randi(2);
            if monotuneFlip == 1 % Choose mono
                if mono_xs(idx) == 1 % Increasing
                    monotunedD(idx) = -1;
                    model{1}.x0(idx) = monotunedD(idx);
                    model{1}.rss(idx) = -1;
                    model{1}.rawrss(idx) = -1;
                elseif mono_xs(idx) == 2 % Decreasing
                    monotunedD(idx) = mono(idx);
                    model{1}.x0(idx) = monotunedD(idx);
                    model{1}.rss(idx) = mono_rss(idx);
                    model{1}.rawrss(idx) = mono_rawrss(idx);
                    monoDeIdx=[monoDeIdx,idx]; %#ok<AGROW>
                end
            elseif monotuneFlip == 2 % Choose tuned
                monotunedD(idx) = -1;
                model{1}.x0(idx) = monotunedD(idx);
                model{1}.rss(idx) = -1;
                model{1}.rawrss(idx) = -1;
            end
        end
    end
    
    %% Create combined mesh coords
    allCoords = VOLUME{1}.coords;
    
    combinedCoords = zeros(1,size(monotunedT,2)); % 1 = Increasing, 2 = Decreasing, 3 = Tuned
    combinedVE = zeros(1,size(monotunedT,2));
    combinedPref = zeros(1,size(monotunedT,2)); % x0
    
    combinedCoords(find(monotunedI>0)) = 1; %#ok<FNDSB>
    combinedCoords(find(monotunedD>0)) = 2; %#ok<FNDSB>
    combinedCoords(find(monotunedT>0)) = 3; %#ok<FNDSB>
    
    combinedVE(find(monotunedI>0)) = monotunedI(find(monotunedI>0)); %#ok<FNDSB>
    combinedVE(find(monotunedD>0)) = monotunedD(find(monotunedD>0)); %#ok<FNDSB>
    combinedVE(find(monotunedT>0)) = monotunedT(find(monotunedT>0)); %#ok<FNDSB>
    
    combinedPref(find(monotunedT>0)) = tune_xs(find(monotunedT>0)); %#ok<FNDSB>

    % Decrease ROI
    decreaseCoords = allCoords(:,combinedCoords==2);   
    VOLUME{1} = newROI(VOLUME{1},'monoDecrease',1,'g',single(decreaseCoords));
    
    % Tuned ROI
    tunedCoords = allCoords(:,combinedCoords==3);
    VOLUME{1} = newROI(VOLUME{1},'tuned',1,'r',single(tunedCoords));
    
    % Get distances between decreasing & tuned ROIs
    distances = RoiToRoiDist(VOLUME{1}.ROIs(1), VOLUME{1}.ROIs(2), VOLUME{1}); % TargetROI = decreasing, SourceROI = tuned
    numerosities = combinedPref(combinedPref>0);
    
    groupDistances = [groupDistances,distances]; %#ok<AGROW>
    groupNumerosity = [groupNumerosity,numerosities]; %#ok<AGROW>
    
    data_numerosity.dist.(participantNames{participant}).distances=distances;
    data_numerosity.dist.(participantNames{participant}).numerosities=numerosities;
    
    close all
    mrvCleanWorkspace
    
end

data_numerosity.dist.group.distances=groupDistances;
data_numerosity.dist.group.numerosities=groupNumerosity;

%% Get Fourier power & other non-numerical models for P1-P5
clear paths

%% Paths where data is stored
data_dir = '/mnt/data/';
paths{1}=strcat(data_dir,'P01');
paths{2}=strcat(data_dir,'P02');
paths{3}=strcat(data_dir,'P03');
paths{4}=strcat(data_dir,'P04');
paths{5}=strcat(data_dir,'P05');

whichParticipants=1:5;
participantNames = {'P01','P02','P03','P04','P05'};
DTnames=["Area", "AreaOdd", "AreaEven", "Size", "SizeOdd", "SizeEven", "Circ", "CircOdd", "CircEven", "Dense", "DenseOdd", "DenseEven"];

for modelxROI = 1:6
    clear mapNames modelFolders modelNames modelFileNames
    if modelxROI == 1
        mapNames=["V1", "V2", "V3"];
        vfmMaps=1; %0 for numerosity maps, 1 for VFM ROIs
        % Folder names to get models from
        modelFolders=["Log", "Linear"];
        % Models withing each folder
        modelNames{1}=["logItemArea", "logTotalArea", "logTotalCirc", "logHullLength", "logHullArea","logLuminanceDensity", "logHullRMS", "logDisplayRMS", "logNumber", "logNumberDensity", "logSFamplitude", "logSFspread", "logSFauc", "logItemRadius", "logEdgeDensity", "logSumLum", "logSumEdges", "logSumLumNorm", "logSumEdgesNorm", "logAggFourierPower"];
        modelNames{2}=["ItemArea", "TotalArea", "TotalCirc", "HullLength", "HullArea","LuminanceDensity", "HullRMS", "DisplayRMS", "Number", "NumberDensity", "SFamplitude", "SFspread", "SFauc", "ItemRadius", "EdgeDensity", "SumLum", "SumEdges", "SumLumNorm", "SumEdgesNorm", "AggFourierPower"];
        % Unique part of corresponding file name
        modelFileNames{1}=["logItemArea", "logTotalArea", "logTotalCirc", "logHullLength", "logHullArea","logLuminanceDensity", "logHullRMS", "logDisplayRMS", "logNumber", "logNumberDensity", "logSFamplitude", "logSFspread", "logSFauc", "logItemRadius", "logEdgeDensity", "logSumLuminance", "logSumEdges", "logSumLuminanceNorm", "logSumEdgesNorm", "logAggFourierPower"];
        modelFileNames{2}=["ItemArea", "TotalArea", "TotalCirc", "HullLength", "HullArea","LuminanceDensity", "HullRMS", "DisplayRMS", "Number", "NumberDensity", "SFamplitude", "SFspread", "SFauc", "ItemRadius", "EdgeDensity", "SumLuminance", "SumEdges", "SumLuminance", "SumEdgesNorm", "AggFourierPower"];
    elseif modelxROI == 2
        mapNames=["PO", "TO", "IPS1","IPS2","IPS3","Front"];
        vfmMaps=0; %0 for numerosity maps, 1 for VFM ROIs
        % Folder names to get models from
        modelFolders="FourierPower_pRF";
        % Models withing each folder
        modelNames{1}=["logNumber", "logAggFourierPower"];
        % Unique part of corresponding file name
        modelFileNames{1}=["logNumber", "logAggFourierPower"];
    elseif modelxROI == 3
        mapNames=["V1", "V2", "V3"];
        vfmMaps=1; %0 for numerosity maps, 1 for VFM ROIs
        % Folder names to get models from
        modelFolders="Log";
        % Models withing each folder
        modelNames{1}=["logNumber_byDT", "logAggFourierPower_byDT"];
        % Unique part of corresponding file name
        modelFileNames{1}=["logNumber","logAggFourierPower"];
    elseif modelxROI == 4
        mapNames=["PO", "TO", "IPS1","IPS2","IPS3","Front"];
        vfmMaps=0; %0 for numerosity maps, 1 for VFM ROIs
        % Folder names to get models from
        modelFolders="FourierPower_pRF";
        % Models withing each folder
        modelNames{1}=["logNumber_byDT", "logAggFourierPower_byDT"];
        % Unique part of corresponding file name
        modelFileNames{1}=["logNumber", "logAggFourierPower"];
    elseif modelxROI == 5
        mapNames=["bothIPS0", "bothIPS1", "bothIPS2", "bothIPS3", "bothIPS4", "bothIPS5", "bothsPCS1", "bothsPCS2",... 
            "bothiPCS", "bothLO1", "bothLO2", "bothTO1", "bothTO2", "bothV1", "bothV2", "bothV3", "bothV3AB",...
            "leftIPS0", "leftIPS1", "leftIPS2", "leftIPS3", "leftIPS4", "leftIPS5", "leftsPCS1", "leftsPCS2",...
            "leftiPCS", "leftLO1", "leftLO2", "leftTO1", "leftTO2", "leftV1", "leftV2", "leftV3", "leftV3AB",...
            "rightIPS0", "rightIPS1", "rightIPS2", "rightIPS3", "rightIPS4", "rightIPS5", "rightsPCS1", "rightsPCS2",...
            "rightiPCS", "rightLO1", "rightLO2", "rightTO1", "rightTO2", "rightV1", "rightV2", "rightV3", "rightV3AB"];
        vfmMaps=2;
        % Folder names to get models from
        modelFolders="Log";
        % Models withing each folder
        modelNames{1}=["monoNumber", "aggFourierPower"];
        % Unique part of corresponding file name
        modelFileNames{1}=["logNumber", "logAggFourierPower"];
    elseif modelxROI == 6
        mapNames=["bothIPS0", "bothIPS1", "bothIPS2", "bothIPS3", "bothIPS4", "bothIPS5", "bothsPCS1", "bothsPCS2",... 
            "bothiPCS", "bothLO1", "bothLO2", "bothTO1", "bothTO2", "bothV1", "bothV2", "bothV3", "bothV3AB",...
            "leftIPS0", "leftIPS1", "leftIPS2", "leftIPS3", "leftIPS4", "leftIPS5", "leftsPCS1", "leftsPCS2",...
            "leftiPCS", "leftLO1", "leftLO2", "leftTO1", "leftTO2", "leftV1", "leftV2", "leftV3", "leftV3AB",...
            "rightIPS0", "rightIPS1", "rightIPS2", "rightIPS3", "rightIPS4", "rightIPS5", "rightsPCS1", "rightsPCS2",...
            "rightiPCS", "rightLO1", "rightLO2", "rightTO1", "rightTO2", "rightV1", "rightV2", "rightV3", "rightV3AB"];
        vfmMaps=2;
        % Folder names to get models from
        modelFolders="FourierPower_pRF";
        % Models withing each folder
        modelNames{1}="tunedNumber";
        % Unique part of corresponding file name
        modelFileNames{1}="logNumber";  
    end
    mapLabels = [];
    
    % Get data
    for thisParticipant=whichParticipants
        
        % Define which mrVista dataTYPES contain data for all, odd and even runs
        % (odd and even for cross-validation)
        
        DTs=10:13;
        if thisParticipant==3||thisParticipant==5 % Also have visual timing data
            DTsOdd=34:37;
            DTsEven=38:41;
        else
            DTsOdd=27:30;
            DTsEven=31:34;
        end
        
        DTsAll=[DTs; DTsOdd; DTsEven];
        allXvalDTs=[DTsOdd; DTsEven];
        DTsAll=DTsAll(:);
        allXvalDTs=allXvalDTs(:);
        
        path=paths{thisParticipant};
        cd(path);path=char(path);
        mrGlobals;VOLUME{1} = initHiddenGray;
        
        % Load all ROIs
        VOLUME{1}=deleteAllROIs(VOLUME{1});
        for whichMap=1:length(mapNames)
            if vfmMaps==1 % Get VFM ROIs
                [VOLUME{1}, ~] = loadROI(VOLUME{1}, char(strcat('VFMafni_left', mapNames(whichMap))), [],[],[],1);
                [VOLUME{1}, ~] = loadROI(VOLUME{1}, char(strcat('VFMafni_right', mapNames(whichMap))), [],[],[],1);
                if thisParticipant==1,mapLabels = [mapLabels,join(["VFM",mapNames(whichMap)],"")];end %#ok<AGROW>
            elseif vfmMaps==0 % Get numerosity ROIs
                [VOLUME{1}, ~] = loadROI(VOLUME{1}, char(strcat('NumLeft', mapNames(whichMap))), [],[],[],1);
                [VOLUME{1}, ~] = loadROI(VOLUME{1}, char(strcat('NumRight', mapNames(whichMap))), [],[],[],1);
                if thisParticipant==1,mapLabels = [mapLabels,join(["Num",mapNames(whichMap)],"")];end %#ok<AGROW>
            elseif vfmMaps==2 % Get VFM ROIs
                [VOLUME{1}, ~] = loadROI(VOLUME{1}, char(strcat('VFMafni_', mapNames(whichMap))), [],[],[],1);
                if thisParticipant==1,mapLabels = [mapLabels,join(["VFM",mapNames(whichMap)],"")];end %#ok<AGROW>
            end
        end
        
        if modelxROI < 5
            for whichDT=1:length(DTsAll)
                if DTsAll(whichDT)>0
                    VOLUME{1}=viewSet(VOLUME{1}, 'curdt', DTsAll(whichDT));
                    for whichFolder=1:length(modelFolders)
                        folder=[path filesep 'Gray' filesep dataTYPES(DTsAll(whichDT)).name filesep char(modelFolders(whichFolder))];
                        whichModelNames=modelNames{whichFolder};
                        whichModelFiles=modelFileNames{whichFolder};
                        for whichModel=1:length(whichModelNames)
                            if modelxROI == 1 || modelxROI == 3
                                modelFile=dir([char(strcat(folder,filesep, '*-', whichModelFiles(whichModel), '-*'))]); %#ok<NBRAK>
                            elseif modelxROI == 2 || modelxROI == 4
                                modelFile=dir([char(strcat(folder,filesep, '*-', whichModelFiles(whichModel), '*-FullBlanks-DT0.5-gFit.mat'))]); %#ok<NBRAK>
                            end
                            VOLUME{1}=rmSelect(VOLUME{1}, 1,[folder, filesep, modelFile.name]);
                            try
                                VOLUME{1} = rmLoadDefault(VOLUME{1});
                            catch
                                VOLUME{1}; %#ok<VUNUS>
                            end
                            
                            if ismember(DTsAll(whichDT), allXvalDTs)
                                % NOTE: Looks in the other DT of the cross-validation pair
                                modul=mod(whichDT, 3);
                                if modul==0
                                    modul=3;
                                end
                                otherDT=floor((whichDT-1)/3)*3+5-modul;
                                if modelxROI == 1 || modelxROI == 3 || modelxROI == 5
                                    xvalFolder=[path filesep 'Gray' filesep dataTYPES(DTsAll(otherDT)).name filesep char(modelFolders(whichFolder)) filesep 'GridFit_monotonic/xval'];
                                    xvalModelFile=dir([char(strcat(xvalFolder,filesep, '*-', whichModelFiles(whichModel), '-*-gFit-gFit.mat'))]); %#ok<NBRAK>
                                elseif modelxROI == 2 || modelxROI == 4 || modelxROI == 6
                                    xvalFolder=[path filesep 'Gray' filesep dataTYPES(DTsAll(otherDT)).name filesep char(modelFolders(whichFolder)) filesep 'xval'];
                                    xvalModelFile=dir([char(strcat(xvalFolder,filesep, '*-', whichModelFiles(whichModel), '-*-gFit-gFit-gFit.mat'))]); %#ok<NBRAK>
                                end
                                xvalModel=load([xvalFolder, filesep, xvalModelFile.name], 'model');
                                xvalVes=rmGet(xvalModel.model{1}, 've');
                                xvalRSS=rmGet(xvalModel.model{1}, 'rss');
                                xvalRawRSS=rmGet(xvalModel.model{1}, 'rawrss');
                            end
                            
                            for whichMap=1:length(mapNames)
                                dataName=char(strcat('data_numerosity.ve.',participantNames{thisParticipant}, '.',whichModelNames(whichModel), '.',DTnames(whichDT), '.',mapLabels(whichMap), '.Left'));
                                
                                % Left hemisphere first entries
                                [~, dataTmp.roiIndices]=intersectCols(VOLUME{1}.coords, VOLUME{1}.ROIs((whichMap-1)*2+1).coords);
                                dataTmp.x0s=VOLUME{1}.rm.retinotopyModels{1}.x0(dataTmp.roiIndices);
                                dataTmp.sigmas=VOLUME{1}.rm.retinotopyModels{1}.sigma.major(dataTmp.roiIndices);
                                dataTmp.rss=VOLUME{1}.rm.retinotopyModels{1}.rss(dataTmp.roiIndices);
                                dataTmp.rawrss=VOLUME{1}.rm.retinotopyModels{1}.rawrss(dataTmp.roiIndices);
                                
                                if modelxROI == 1 && whichModel==1
                                    eval(['time_series_numerosity.',(participantNames{thisParticipant}),'.',DTnames{whichDT},'.',mapLabels{whichMap},'.Left.iCoords = dataTmp.roiIndices;']);
                                    cd(strcat([path filesep 'Gray' filesep dataTYPES(DTsAll(whichDT)).name], '/TSeries/Scan1'));
                                    load('tSeries1');
                                    eval(['time_series_numerosity.',(participantNames{thisParticipant}),'.',DTnames{whichDT},'.',mapLabels{whichMap},'.Left.Scan1 = tSeries(:,dataTmp.roiIndices);']);
                                end
                                
                                % Converts RSS to VE
                                ves=1-(dataTmp.rss./dataTmp.rawrss);
                                ves(~isfinite(ves)) = 0;
                                ves = max(ves, 0);
                                ves = min(ves, 1);
                                dataTmp.ves=ves;
                                
                                if ismember(DTsAll(whichDT), allXvalDTs)
                                    dataTmp.vesXval=xvalVes(dataTmp.roiIndices);
                                    dataTmp.rssXval=xvalRSS(dataTmp.roiIndices);
                                    dataTmp.rawrssXval=xvalRawRSS(dataTmp.roiIndices);
                                end
                                eval([dataName, '=dataTmp;'])
                                
                                dataName=char(strcat('data_numerosity.ve.',participantNames{thisParticipant}, '.',whichModelNames(whichModel), '.',DTnames(whichDT), '.',mapLabels(whichMap), '.Right'));
                                
                                % Right hemisphere first entries
                                [~, dataTmp.roiIndices]=intersectCols(VOLUME{1}.coords, VOLUME{1}.ROIs((whichMap-1)*2+2).coords);
                                dataTmp.x0s=VOLUME{1}.rm.retinotopyModels{1}.x0(dataTmp.roiIndices);
                                dataTmp.sigmas=VOLUME{1}.rm.retinotopyModels{1}.sigma.major(dataTmp.roiIndices);
                                dataTmp.rss=VOLUME{1}.rm.retinotopyModels{1}.rss(dataTmp.roiIndices);
                                dataTmp.rawrss=VOLUME{1}.rm.retinotopyModels{1}.rawrss(dataTmp.roiIndices);
                                
                                if modelxROI == 1 && whichModel==1
                                    eval(['time_series_numerosity.',(participantNames{thisParticipant}),'.',DTnames{whichDT},'.',mapLabels{whichMap},'.Right.iCoords = dataTmp.roiIndices;']);
                                    cd(strcat([path filesep 'Gray' filesep dataTYPES(DTsAll(whichDT)).name], '/TSeries/Scan1'));
                                    load('tSeries1');
                                    eval(['time_series_numerosity.',(participantNames{thisParticipant}),'.',DTnames{whichDT},'.',mapLabels{whichMap},'.Right.Scan1 = tSeries(:,dataTmp.roiIndices);']);
                                end
                                
                                % Converts RSS to VE
                                ves=1-(dataTmp.rss./dataTmp.rawrss);
                                ves(~isfinite(ves)) = 0;
                                ves = max(ves, 0);
                                ves = min(ves, 1);
                                dataTmp.ves=ves;
                                
                                if ismember(DTsAll(whichDT), allXvalDTs)
                                    dataTmp.vesXval=xvalVes(dataTmp.roiIndices);
                                    dataTmp.rssXval=xvalRSS(dataTmp.roiIndices);
                                    dataTmp.rawrssXval=xvalRawRSS(dataTmp.roiIndices);
                                end
                                eval([dataName, '=dataTmp;'])
                            end
                        end
                        cd(path);
                    end
                end
            end
        else
            for whichDT=1:length(DTsAll)
                VOLUME{1}=viewSet(VOLUME{1}, 'curdt', DTsAll(whichDT));
                for whichFolder=1:length(modelFolders)
                    folder=[path filesep 'Gray' filesep dataTYPES(DTsAll(whichDT)).name filesep char(modelFolders(whichFolder))];
                    whichModelNames=modelNames{whichFolder};
                    whichModelFiles=modelFileNames{whichFolder};
                    for whichModel=1:length(whichModelNames)
                        if modelxROI == 5
                            modelFile=dir([char(strcat(folder,filesep, '*-', whichModelFiles(whichModel), '-*'))]); %#ok<NBRAK>
                        elseif modelxROI == 6
                            modelFile=dir([char(strcat(folder,filesep, '*-', whichModelFiles(whichModel), '-*-gFit-gFit.mat'))]); %#ok<NBRAK>
                        end
                        
                        VOLUME{1}=rmSelect(VOLUME{1}, 1,[folder, filesep, modelFile.name]);
                        try
                            VOLUME{1} = rmLoadDefault(VOLUME{1});
                        catch
                            VOLUME{1}; %#ok<VUNUS>
                        end
                        
                        if ismember(DTsAll(whichDT), allXvalDTs)
                            %NOTE: Looks in the other DT of the cross-validation pair
                            modul=mod(whichDT, 3);
                            if modul==0
                                modul=3;
                            end
                            otherDT=floor((whichDT-1)/3)*3+5-modul;
                            if modelxROI == 5
                                xvalFolder=[path filesep 'Gray' filesep dataTYPES(DTsAll(otherDT)).name filesep char(modelFolders(whichFolder)) filesep 'GridFit_monotonic/xval'];
                                xvalModelFile=dir([char(strcat(xvalFolder,filesep, '*-', whichModelFiles(whichModel), '-*-gFit-gFit.mat'))]); %#ok<NBRAK>
                            elseif modelxROI == 6
                                xvalFolder=[path filesep 'Gray' filesep dataTYPES(DTsAll(otherDT)).name filesep char(modelFolders(whichFolder)) filesep 'xval'];
                                xvalModelFile=dir([char(strcat(xvalFolder,filesep, '*-', whichModelFiles(whichModel), '-*-gFit-gFit-gFit.mat'))]); %#ok<NBRAK>
                            end
                            xvalModel=load([xvalFolder, filesep, xvalModelFile.name], 'model');
                            xvalVes=rmGet(xvalModel.model{1}, 've');
                            xvalRSS=rmGet(xvalModel.model{1}, 'rss');
                            xvalRawRSS=rmGet(xvalModel.model{1}, 'rawrss');
                        end
                        
                        for whichMap=1:length(mapNames)
                            dataName=char(strcat('data_numerosity.ve.',participantNames{thisParticipant}, '.',whichModelNames(whichModel), '.',DTnames(whichDT), '.',mapLabels(whichMap), '.Both'));

                            % Both hemisphere first entries
                            [~, dataTmp.roiIndices]=intersectCols(VOLUME{1}.coords, VOLUME{1}.ROIs((whichMap)).coords);
                            dataTmp.x0s=VOLUME{1}.rm.retinotopyModels{1}.x0(dataTmp.roiIndices);
                            dataTmp.sigmas=VOLUME{1}.rm.retinotopyModels{1}.sigma.major(dataTmp.roiIndices);                            
                            dataTmp.rss=VOLUME{1}.rm.retinotopyModels{1}.rss(dataTmp.roiIndices);
                            dataTmp.rawrss=VOLUME{1}.rm.retinotopyModels{1}.rawrss(dataTmp.roiIndices);
                            
                            %Converts rss to ve
                            ves=1-(dataTmp.rss./dataTmp.rawrss);
                            ves(~isfinite(ves)) = 0;
                            ves = max(ves, 0);
                            ves = min(ves, 1);
                            dataTmp.ves=ves;
                            
                            if ismember(DTsAll(whichDT), allXvalDTs)
                                dataTmp.vesXval=xvalVes(dataTmp.roiIndices);
                                dataTmp.rssXval=xvalRSS(dataTmp.roiIndices);
                                dataTmp.rawrssXval=xvalRawRSS(dataTmp.roiIndices);
                            end
                            eval([dataName, '=dataTmp;'])
                            
                        end
                    end
                end
            end
        end
        mrvCleanWorkspace;
    end
    
    %Join all ROIs within subject into a field called 'All'
    if modelxROI < 5
        for thisParticipant=whichParticipants
            thisData=char(strcat('data_numerosity.ve.',participantNames{thisParticipant}));
            hemispheres=["Left", "Right"];
            for whichDT=1:length(DTsAll)
                if DTsAll(whichDT)>0
                    for whichFolder=1:length(modelFolders)
                        whichModelNames=modelNames{whichFolder};
                        for whichModel=1:length(whichModelNames)
                            for whichMap=1:length(mapNames)
                                for whichHemi=1:length(hemispheres)
                                    if modelxROI == 1 || modelxROI == 3
                                        targetData=char(strcat(thisData,'.', whichModelNames{whichModel},'.',DTnames{whichDT},'.VFMAll', '.',hemispheres{whichHemi}));
                                    elseif modelxROI == 2 || modelxROI == 4
                                        targetData=char(strcat(thisData,'.', whichModelNames{whichModel},'.',DTnames{whichDT},'.NumAll', '.',hemispheres{whichHemi}));
                                    end

                                    sourceData=char(strcat(thisData, '.',whichModelNames(whichModel),'.',DTnames(whichDT),'.',mapLabels(whichMap), '.',hemispheres{whichHemi}));
                                    
                                    % Check and initialise variables
                                    try
                                        eval(['~isfield(',targetData, ', ''mapOrder'');'])
                                    catch
                                        eval([targetData, '=[];'])
                                    end
                                    
                                    if eval(['~isfield(',targetData, ', ''mapOrder'')'])
                                        eval(char(strcat(targetData, '.mapOrder= "', hemispheres(whichHemi),mapLabels(whichMap),'";')));
                                        eval([targetData, '.mapIndices=', num2str(length(eval([sourceData '.x0s']))), ';']);
                                    else
                                        % Fill variables
                                        eval(char(strcat(targetData, '.mapOrder = [', targetData, '.mapOrder, "', hemispheres(whichHemi),mapLabels(whichMap), '"];')))
                                        try
                                            eval([targetData, '.mapIndices = [', targetData, '.mapIndices, ', num2str(length(eval([sourceData '.x0s']))), '];'])
                                        catch
                                            targetData;
                                        end
                                    end
                                    
                                    if eval(['~isfield(',targetData, ', ''x0s'')'])
                                        eval([targetData, '.x0s=',sourceData, '.x0s;']);
                                        eval([targetData, '.sigmas=',sourceData, '.sigmas;']);
                                        eval([targetData, '.roiIndices=',sourceData, '.roiIndices;']);
                                        eval([targetData, '.ves=',sourceData, '.ves;']);
                                        eval([targetData, '.rss=',sourceData, '.rss;']);
                                        eval([targetData, '.rawrss=',sourceData, '.rawrss;']);
                                    else
                                        eval([targetData, '.x0s = [', targetData, '.x0s, ', sourceData, '.x0s];'])
                                        eval([targetData, '.sigmas = [', targetData, '.sigmas, ', sourceData, '.sigmas];'])
                                        eval([targetData, '.roiIndices = [', targetData, '.roiIndices; ', sourceData, '.roiIndices];'])
                                        eval([targetData, '.ves = [', targetData, '.ves, ', sourceData, '.ves];'])
                                        eval([targetData, '.rss = [', targetData, '.rss, ', sourceData, '.rss];'])
                                        eval([targetData, '.rawrss = [', targetData, '.rawrss, ', sourceData, '.rawrss];'])
                                    end
                                    
                                    if ismember(DTsAll(whichDT), allXvalDTs)
                                        if eval(['~isfield(',targetData, ', ''vesXval'')'])
                                            eval([targetData, '.vesXval=',sourceData, '.vesXval;']);
                                            eval([targetData, '.rssXval=',sourceData, '.rssXval;']);
                                            eval([targetData, '.rawrssXval=',sourceData, '.rawrssXval;']);
                                        else
                                            eval([targetData, '.vesXval = [', targetData, '.vesXval, ', sourceData, '.vesXval];'])
                                            eval([targetData, '.rssXval = [', targetData, '.rssXval, ', sourceData, '.rssXval];'])
                                            eval([targetData, '.rawrssXval = [', targetData, '.rawrssXval, ', sourceData, '.rawrssXval];'])
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    % Now the 'All' ROI exists
    if modelxROI == 1 || modelxROI == 3
        mapNames=["VFMV1", "VFMV2", "VFMV3", "VFMAll"];
    elseif modelxROI == 2 || modelxROI == 4
        mapNames=["NumPO", "NumTO", "NumIPS1","NumIPS2","NumIPS3","NumFront", "NumAll"];
    end
    
    % Join data from all DTs into a DT called 'All'
    for thisParticipant=whichParticipants
        thisData=char(strcat('data_numerosity.ve.',participantNames{thisParticipant}));
        if modelxROI == 1 || modelxROI == 2
            for whichDT=1:3
                if DTsAll(whichDT)>0
                    for whichFolder=1:length(modelFolders)
                        whichModelNames=modelNames{whichFolder};
                        for whichModel=1:length(whichModelNames)
                            for whichMap=1:length(mapNames)
                                for whichHemi=1:length(hemispheres)
                                    if whichDT==1
                                        targetData=char(strcat(thisData, '.', whichModelNames{whichModel}, '.All.', mapNames(whichMap), '.',hemispheres(whichHemi)));
                                    elseif whichDT==2
                                        targetData=char(strcat(thisData, '.', whichModelNames{whichModel}, '.AllOdd.', mapNames(whichMap), '.',hemispheres(whichHemi)));
                                    elseif whichDT==3
                                        targetData=char(strcat(thisData, '.', whichModelNames{whichModel}, '.AllEven.', mapNames(whichMap), '.',hemispheres(whichHemi)));
                                    end
                                    
                                    sourceData1=char(strcat(thisData, '.', whichModelNames(whichModel), '.', DTnames(whichDT), '.', mapNames(whichMap), '.',hemispheres{whichHemi}));
                                    sourceData2=char(strcat(thisData, '.', whichModelNames(whichModel), '.', DTnames(whichDT+3), '.', mapNames(whichMap), '.',hemispheres{whichHemi}));
                                    sourceData3=char(strcat(thisData, '.', whichModelNames(whichModel), '.', DTnames(whichDT+6), '.', mapNames(whichMap), '.',hemispheres{whichHemi}));
                                    sourceData4=char(strcat(thisData, '.', whichModelNames(whichModel), '.', DTnames(whichDT+9), '.', mapNames(whichMap), '.',hemispheres{whichHemi}));
                                    
                                    % Check this comes out as rows
                                    eval([targetData, '.x0sAll=[',sourceData1, '.x0s;' ,sourceData2, '.x0s;',sourceData3, '.x0s;'  ,sourceData4, '.x0s];']);
                                    eval([targetData, '.vesAll=[',sourceData1, '.ves;' ,sourceData2, '.ves;',sourceData3, '.ves;'  ,sourceData4, '.ves];']);
                                    eval([targetData, '.rssAll=[',sourceData1, '.rss;' ,sourceData2, '.rss;',sourceData3, '.rss;'  ,sourceData4, '.rss];']);
                                    eval([targetData, '.rawrssAll=[',sourceData1, '.rawrss;' ,sourceData2, '.rawrss;',sourceData3, '.rawrss;'  ,sourceData4, '.rawrss];']);
                                    
                                    % Check this is taking the mean over the correct dimension
                                    eval([targetData, '.x0s=nanmean(', targetData, '.x0sAll, 2);']);
                                    eval([targetData, '.vesMean=nanmean(', targetData, '.vesAll, 2);']);
                                    eval([targetData, '.rss=nanmean(', targetData, '.rssAll, 2);']);
                                    eval([targetData, '.rawrss=nanmean(', targetData, '.rawrssAll, 2);']);
                                    eval(['rss=',targetData, '.rss;']);
                                    eval(['rawrss=',targetData, '.rawrss;']);
                                    ves=1-(rss./rawrss);
                                    ves(~isfinite(ves)) = 0;
                                    ves = max(ves, 0);
                                    ves = min(ves, 1);
                                    eval([targetData, '.ves=ves;']);
                                    
                                    if whichDT==2 || whichDT==3
                                        % Check this comes out as rows
                                        eval([targetData, '.vesXvalAll=[',sourceData1, '.vesXval;' ,sourceData2, '.vesXval;',sourceData3, '.vesXval;'  ,sourceData4, '.vesXval];']);
                                        eval([targetData, '.rssXvalAll=[',sourceData1, '.rssXval;' ,sourceData2, '.rssXval;',sourceData3, '.rssXval;'  ,sourceData4, '.rssXval];']);
                                        eval([targetData, '.rawrssXvalAll=[',sourceData1, '.rawrssXval;' ,sourceData2, '.rawrssXval;',sourceData3, '.rawrssXval;'  ,sourceData4, '.rawrssXval];']);
                                        
                                        % Check this is taking the mean over the correct dimension
                                        eval([targetData, '.vesXvalMean=nanmean(', targetData, '.vesXvalAll, 2);']);
                                        eval([targetData, '.rssXval=nanmean(', targetData, '.rssXvalAll, 2);']);
                                        eval([targetData, '.rawrssXval=nanmean(', targetData, '.rawrssXvalAll, 2);']);
                                        eval(['rss=',targetData, '.rssXval;']);
                                        eval(['rawrss=',targetData, '.rawrssXval;']);
                                        ves=1-(rss./rawrss);
                                        ves(~isfinite(ves)) = 0;
                                        ves = max(ves, 0);
                                        ves = min(ves, 1);
                                        eval([targetData, '.vesXval=ves;']);
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
        elseif modelxROI == 3 || modelxROI == 4
            for whichDT=1:3
                if DTsAll(whichDT)>0
                    for whichFolder=1:length(modelFolders)
                        whichModelNames=modelNames{whichFolder};
                        for whichModel=1:length(whichModelNames)
                            for whichMap=1:length(mapNames)
                                for whichHemi=1:length(hemispheres)
                                    if whichDT==1
                                        targetData=char(strcat(thisData, '.', whichModelNames{whichModel}, '.All.', mapNames(whichMap), '.',hemispheres(whichHemi)));
                                    elseif whichDT==2
                                        targetData=char(strcat(thisData, '.', whichModelNames{whichModel}, '.AllOdd.', mapNames(whichMap), '.',hemispheres(whichHemi)));
                                    elseif whichDT==3
                                        targetData=char(strcat(thisData, '.', whichModelNames{whichModel}, '.AllEven.', mapNames(whichMap), '.',hemispheres(whichHemi)));
                                    end
                                    
                                    sourceData1=char(strcat(thisData, '.', whichModelNames(whichModel), '.', DTnames(whichDT), '.', mapNames(whichMap), '.',hemispheres{whichHemi}));
                                    sourceData2=char(strcat(thisData, '.', whichModelNames(whichModel), '.', DTnames(whichDT+3), '.', mapNames(whichMap), '.',hemispheres{whichHemi}));
                                    sourceData3=char(strcat(thisData, '.', whichModelNames(whichModel), '.', DTnames(whichDT+6), '.', mapNames(whichMap), '.',hemispheres{whichHemi}));
                                    sourceData4=char(strcat(thisData, '.', whichModelNames(whichModel), '.', DTnames(whichDT+9), '.', mapNames(whichMap), '.',hemispheres{whichHemi}));
                                    
                                    % Check this comes out as rows
                                    eval([targetData, '.x0sAll=[',sourceData1, '.x0s;' ,sourceData2, '.x0s;',sourceData3, '.x0s;'  ,sourceData4, '.x0s];']);
                                    eval([targetData, '.vesAll=[',sourceData1, '.ves;' ,sourceData2, '.ves;',sourceData3, '.ves;'  ,sourceData4, '.ves];']);
                                    eval([targetData, '.rssAll=[',sourceData1, '.rss;' ,sourceData2, '.rss;',sourceData3, '.rss;'  ,sourceData4, '.rss];']);
                                    eval([targetData, '.rawrssAll=[',sourceData1, '.rawrss;' ,sourceData2, '.rawrss;',sourceData3, '.rawrss;'  ,sourceData4, '.rawrss];']);
                                    
                                    % Check this is taking the mean over the correct dimension
                                    eval([targetData, '.x0s=nanmean(', targetData, '.x0sAll, 2);']);
                                    eval([targetData, '.vesMean=nanmean(', targetData, '.vesAll, 2);']);
                                    eval([targetData, '.rss=nanmean(', targetData, '.rssAll, 2);']);
                                    eval([targetData, '.rawrss=nanmean(', targetData, '.rawrssAll, 2);']);
                                    eval(['rss=',targetData, '.rss;']);
                                    eval(['rawrss=',targetData, '.rawrss;']);
                                    ves=1-(rss./rawrss);
                                    ves(~isfinite(ves)) = 0;
                                    ves = max(ves, 0);
                                    ves = min(ves, 1);
                                    eval([targetData, '.ves=ves;']);
                                    
                                    if whichDT==2 || whichDT==3
                                        % Check this comes out as rows
                                        % Area
                                        eval([targetData, '.vesXvalAllArea=[',sourceData1, '.vesXval];']);
                                        eval([targetData, '.rssXvalAllArea=[',sourceData1, '.rssXval];']);
                                        eval([targetData, '.rawrssXvalAllArea=[',sourceData1, '.rawrssXval];']);
                                        
                                        % Size
                                        eval([targetData, '.vesXvalAllSize=[',sourceData2, '.vesXval];']);
                                        eval([targetData, '.rssXvalAllSize=[',sourceData2, '.rssXval];']);
                                        eval([targetData, '.rawrssXvalAllSize=[',sourceData2, '.rawrssXval];']);
                                        
                                        % Peri
                                        eval([targetData, '.vesXvalAllCirc=[',sourceData3, '.vesXval];']);
                                        eval([targetData, '.rssXvalAllCirc=[',sourceData3, '.rssXval];']);
                                        eval([targetData, '.rawrssXvalAllCirc=[',sourceData3, '.rawrssXval];']);
                                        
                                        % Dens
                                        eval([targetData, '.vesXvalAllDense=[',sourceData4, '.vesXval];']);
                                        eval([targetData, '.rssXvalAllDense=[',sourceData4, '.rssXval];']);
                                        eval([targetData, '.rawrssXvalAllDense=[',sourceData4, '.rawrssXval];']);
                                        
                                        % Check this is taking the mean over the correct dimension
                                        % Area
                                        eval([targetData, '.vesXvalMeanArea=nanmean(', targetData, '.vesXvalAllArea, 2);']);
                                        eval([targetData, '.rssXvalArea=nanmean(', targetData, '.rssXvalAllArea, 2);']);
                                        eval([targetData, '.rawrssXvalArea=nanmean(', targetData, '.rawrssXvalAllArea, 2);']);
                                        eval(['rss=',targetData, '.rssXvalArea;']);
                                        eval(['rawrss=',targetData, '.rawrssXvalArea;']);
                                        ves=1-(rss./rawrss);
                                        ves(~isfinite(ves)) = 0;
                                        ves = max(ves, 0);
                                        ves = min(ves, 1); %#ok<NASGU>
                                        eval([targetData, '.vesXvalArea=ves;']);
                                        
                                        % Size
                                        eval([targetData, '.vesXvalMeanSize=nanmean(', targetData, '.vesXvalAllSize, 2);']);
                                        eval([targetData, '.rssXvalSize=nanmean(', targetData, '.rssXvalAllSize, 2);']);
                                        eval([targetData, '.rawrssXvalSize=nanmean(', targetData, '.rawrssXvalAllSize, 2);']);
                                        eval(['rss=',targetData, '.rssXvalSize;']);
                                        eval(['rawrss=',targetData, '.rawrssXvalSize;']);
                                        ves=1-(rss./rawrss);
                                        ves(~isfinite(ves)) = 0;
                                        ves = max(ves, 0);
                                        ves = min(ves, 1); %#ok<NASGU>
                                        eval([targetData, '.vesXvalSize=ves;']);
                                        
                                        % Peri
                                        eval([targetData, '.vesXvalMeanCirc=nanmean(', targetData, '.vesXvalAllCirc, 2);']);
                                        eval([targetData, '.rssXvalCirc=nanmean(', targetData, '.rssXvalAllCirc, 2);']);
                                        eval([targetData, '.rawrssXvalCirc=nanmean(', targetData, '.rawrssXvalAllCirc, 2);']);
                                        eval(['rss=',targetData, '.rssXvalCirc;']);
                                        eval(['rawrss=',targetData, '.rawrssXvalCirc;']);
                                        ves=1-(rss./rawrss);
                                        ves(~isfinite(ves)) = 0;
                                        ves = max(ves, 0);
                                        ves = min(ves, 1); %#ok<NASGU>
                                        eval([targetData, '.vesXvalCirc=ves;']);
                                        
                                        % Dens
                                        eval([targetData, '.vesXvalMeanDense=nanmean(', targetData, '.vesXvalAllDense, 2);']);
                                        eval([targetData, '.rssXvalDense=nanmean(', targetData, '.rssXvalAllDense, 2);']);
                                        eval([targetData, '.rawrssXvalDense=nanmean(', targetData, '.rawrssXvalAllDense, 2);']);
                                        eval(['rss=',targetData, '.rssXvalDense;']);
                                        eval(['rawrss=',targetData, '.rawrssXvalDense;']);
                                        ves=1-(rss./rawrss);
                                        ves(~isfinite(ves)) = 0;
                                        ves = max(ves, 0);
                                        ves = min(ves, 1);
                                        eval([targetData, '.vesXvalDense=ves;']);
                                    end
                                end
                            end
                        end
                    end
                end
            end
        else
            hemispheres="Both";
            for whichDT=1:3
                for whichFolder=1:length(modelFolders)
                    whichModelNames=modelNames{whichFolder};
                    for whichModel=1:length(whichModelNames)
                        for whichMap=1:length(mapNames)
                            for whichHemi=1:length(hemispheres)
                                if whichDT==1
                                    targetData=char(strcat(thisData, '.', whichModelNames{whichModel}, '.All.', mapNames(whichMap), '.',hemispheres(whichHemi)));
                                elseif whichDT==2
                                    targetData=char(strcat(thisData, '.', whichModelNames{whichModel}, '.AllOdd.', mapNames(whichMap), '.',hemispheres(whichHemi)));
                                elseif whichDT==3
                                    targetData=char(strcat(thisData, '.', whichModelNames{whichModel}, '.AllEven.', mapNames(whichMap), '.',hemispheres(whichHemi)));
                                end
                                
                                sourceData1=char(strcat(thisData, '.', whichModelNames(whichModel), '.', DTnames(whichDT), '.', mapLabels(whichMap), '.',hemispheres{whichHemi}));
                                sourceData2=char(strcat(thisData, '.', whichModelNames(whichModel), '.', DTnames(whichDT+3), '.', mapLabels(whichMap), '.',hemispheres{whichHemi}));
                                sourceData3=char(strcat(thisData, '.', whichModelNames(whichModel), '.', DTnames(whichDT+6), '.', mapLabels(whichMap), '.',hemispheres{whichHemi}));
                                sourceData4=char(strcat(thisData, '.', whichModelNames(whichModel), '.', DTnames(whichDT+9), '.', mapLabels(whichMap), '.',hemispheres{whichHemi}));
                                
                                %Check this comes out as rows
                                eval([targetData, '.x0sAll=[',sourceData1, '.x0s;' ,sourceData2, '.x0s;',sourceData3, '.x0s;'  ,sourceData4, '.x0s];']);
                                eval([targetData, '.vesAll=[',sourceData1, '.ves;' ,sourceData2, '.ves;',sourceData3, '.ves;'  ,sourceData4, '.ves];']);
                                eval([targetData, '.rssAll=[',sourceData1, '.rss;' ,sourceData2, '.rss;',sourceData3, '.rss;'  ,sourceData4, '.rss];']);
                                eval([targetData, '.rawrssAll=[',sourceData1, '.rawrss;' ,sourceData2, '.rawrss;',sourceData3, '.rawrss;'  ,sourceData4, '.rawrss];']);
                                
                                %Check this is taking the mean over the
                                %correct dimension
                                eval([targetData, '.x0s=mean(', targetData, '.x0sAll, 2);']);
                                eval([targetData, '.vesMean=mean(', targetData, '.vesAll, 2);']);
                                eval([targetData, '.rss=mean(', targetData, '.rssAll, 2);']);
                                eval([targetData, '.rawrss=mean(', targetData, '.rawrssAll, 2);']);
                                eval(['rss=',targetData, '.rss;']);
                                eval(['rawrss=',targetData, '.rawrss;']);
                                ves=1-(rss./rawrss);
                                ves(~isfinite(ves)) = 0;
                                ves = max(ves, 0);
                                ves = min(ves, 1);
                                eval([targetData, '.ves=ves;']);
                                
                                if whichDT==2 || whichDT==3
                                    %Check this comes out as rows
                                    eval([targetData, '.vesXvalAll=[',sourceData1, '.vesXval;' ,sourceData2, '.vesXval;',sourceData3, '.vesXval;'  ,sourceData4, '.vesXval];']);
                                    eval([targetData, '.rssXvalAll=[',sourceData1, '.rssXval;' ,sourceData2, '.rssXval;',sourceData3, '.rssXval;'  ,sourceData4, '.rssXval];']);
                                    eval([targetData, '.rawrssXvalAll=[',sourceData1, '.rawrssXval;' ,sourceData2, '.rawrssXval;',sourceData3, '.rawrssXval;'  ,sourceData4, '.rawrssXval];']);
                                    
                                    %Check this is taking the mean over the
                                    %correct dimension
                                    eval([targetData, '.vesXvalMean=mean(', targetData, '.vesXvalAll, 2);']);
                                    eval([targetData, '.rssXval=mean(', targetData, '.rssXvalAll, 2);']);
                                    eval([targetData, '.rawrssXval=mean(', targetData, '.rawrssXvalAll, 2);']);
                                    eval(['rss=',targetData, '.rssXval;']);
                                    eval(['rawrss=',targetData, '.rawrssXval;']);
                                    ves=1-(rss./rawrss);
                                    ves(~isfinite(ves)) = 0;
                                    ves = max(ves, 0);
                                    ves = min(ves, 1);
                                    eval([targetData, '.vesXval=ves;']);
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

cd(save_path);
save('data_numerosity', 'data_numerosity','-v7.3');save('data_vfm', 'data_vfm','-v7.3');
save('time_series_numerosity', 'time_series_numerosity','-v7.3');save('time_series_vfm', 'time_series_vfm','-v7.3');
