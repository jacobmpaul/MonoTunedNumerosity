%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% afni2mrVista_runModels %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FOR NUMEROSITY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vCheck = 0; % for creating the visual checks after coordinate reduction:

whichSubs = [1:11];

nTRsPerSweep = 176;
nTRs = 176;
myTR = 2.1; %2.5 for auditory?
nPrescanTRs = 6; %Probably different for auditory?
frameLength = 50;
framesPerTR = myTR*1000/frameLength; % 42 if TR=2.1
nFramesPerSweep = nTRsPerSweep*framesPerTR;
params.prescanFrames = 6; % MAKE INTO PARAM STRUCTURE
params.realFrames = 176; % MAKE INTO PARAM STRUCTURE
%
% SET THIS TO YOUR OWN LOCAL DEFINITION:
vistasoftpath = '/mnt/data/matlab/vistasoft_preproc';
rmdpath = '/mnt/data/matlab/rmDevel';
addpath(genpath(vistasoftpath));
addpath(genpath(rmdpath));

% Define project directory
masterdir = '/mnt/data/numerosity';
addpath(genpath(masterdir));
cd(masterdir)

% List directories to find number of participants
listing = dir(masterdir);
listing = listing(3:end);
numPart = length(listing);
for np = 1:numPart
    % Find the NAMES of the participants
    partNames{np} = listing(np).name;
    partDir = [masterdir '/' partNames{np}];
    cd(partDir)
    plist = dir(partDir);
    plist = plist(3:end);
    numSes(np) = length(plist);
    for ns = 1:numSes(np)
        clear params
        sesNames{np,ns} = plist(ns).name;
        sesDir = [partDir '/' sesNames{np,ns}];
        cd(sesDir)
        % Move to local mrVista directory to start the analysis
        projectdir = [sesDir '/mrVistaSession'];
        cd(projectdir)
        % Initialize session with the following files:
        % Inplane       <- lo2hi_for_clp_params
        % Functional    <- clp_EPI's
        % Volume        <- t1_1mm
        % First, find some files
        EPIlist = dir('clp_EPI*');
        % EPIlist = dir('*epi*.nii');
        inplist = dir('*lo2hi_for_clp_params*');
        % inplist = dir('*oneframe*'); % Remember to ask whether this flip happens
        % automatically when the inplane is flipped, or whether I have to specify
        % the flip for all individual runs.
        vollist = dir('*1mm.nii*');
        % Create some parameters
        numRuns(np,ns) = length(EPIlist);
        for nr = 1:numRuns(np,ns)
            params.functionals{nr} = EPIlist(nr).name;
        end
        params.vAnatomy = vollist(1).name;
        params.inplane = inplist(1).name;
        
        % Initialize session:
        mrInit(params);
        % Creates: mrSESSION.mat, mrInit_params.mat
        %% Adjust the mrSESSION file such that mrVista understands the proper alignment
        load mrSESSION.mat
        % Make the flip easier to handle:
        % Load in the low-res_T1
        local = readFileNifti(mrSESSION.inplanes.inplanePath);
        hires = readFileNifti(params.vAnatomy);
        % Redefine the alignment parameters based on the size of the R-L dimension
        % Add +1 to the dimension to be flipped, as space starts counting from
        % zero, but indices start at one!
        load('clp_params.mat')
        %         mrSESSION.alignment = [-0 -0 -1 local.dim(3)+box_boundary(6)+1; 1 -0 0 box_boundary(4); 0 1 -0 box_boundary(1); 0 0 0 1];
        mrSESSION.alignment = [-0 -0 -1 local.dim(3)+clp_n(6)+1; 1 -0 0 clp_n(4); 0 1 -0 clp_n(1); 0 0 0 1];
        if ~exist('vANATOMYPATH')
            load mrInit_params.mat
            vANATOMYPATH = [params.sessionDir,'/',params.vAnatomy];
        end
        save('mrSESSION.mat', 'mrSESSION', 'dataTYPES', 'vANATOMYPATH')
        
        rxAlign; % Check visually
        % Save the alignment created by mrVista?;
        
        %
        % Build the actual Gray Matter coordinates using the class files:
        % Inputs are:
        % 1. Gray or volume view, default is [] for automatic hidden volume view
        % 2. Path to which to save the coords.mat file
        % 3. Flag 1== keep ALL gm-coords, 0== ONLY gm in inplane
        % 4. Segmentation file (Class file)
        % 5. Number of layers to include (in mm, hence 4 == max)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %									     %
        % Check if the above step can be automated entirely.			     %
        % Which is the case if the coords structure can be reconstructed based on %
        % nothing but the input niftis and the segmentation masks provided.	     %
        %									     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        close all
        % If no input is provided, pop-up asks for class file:
        seglist = dir('*class*.nii');
        buildGrayCoords([],[],0,{seglist.name},8);
        % Creates [nodes, edges], where node is gm voxel, and edge is number of
        % neighbors it has.
        % Necessary information is coords (DimensionsxNumberOfGrayMatterVoxels)
        % e.g. coords = [1:3, 1:400000];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Get timeseries from the gm-voxels %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        close all
        mrVista('gray')
        inplane = checkSelectedInplane;
        VOLUME{1} = ip2volTSeries(inplane,VOLUME{1},0,'nearest');
        clear inplane;
        close all
        % Gives path Gray/Original/TSeries/Scan1
        % Carries: tSeries.mat
        % NumberOfTimePoints x NumberOfGrayMatterVoxels
        % e.g. tSeries = [1:196, 1:400000];
        %%
        % For later refining of the tseries, (removing empty ones)
        graypath = [projectdir '/Gray'];
        tspath = [graypath '/Original/TSeries'];
        
        % Construct a list of indices to keep
        for nr = 1:numRuns(np,ns)
            load([graypath '/coords.mat'])
            % Select current scan
            rundir = [tspath '/Scan' num2str(nr)];
            % Load the voxel_timeseries
            load([rundir '/tSeries1.mat'])
            % Find voxels for which the following is true:
            inds2{ns,nr}.c = find(floor((~isnan(sum(tSeries,1)) + (sum(tSeries,1)~=0))/2));
            % Make one list, but keep the originals as well
        end
        cd(partDir)
    end
    %%
    save([partDir '/' sesNames{np,1} '/mrVistaSession/indices_for_check.mat'], 'inds2')
    % Now that we have done all sessions/runs for THIS participant:
    % construct full list of indices that we would like to keep:
    for ns = 1:numSes(np)
        clear fullind
        for nr = 1:numRuns(np,ns)
            if nr == 1
                fullind = inds2{ns,nr}.c;
            else
                fullind = fullind(ismember(fullind, inds2{ns,nr}.c));
                %                 fullind = unique(fullind);
            end
        end
        save([partDir '/' sesNames{np,ns} '/mrVistaSession/fullind.mat'], 'fullind')
    end
    % Save the coordinates we will use for analysis
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for ns = 1:numSes(np)
        sesDir = [partDir '/' sesNames{np,ns}];
        cd([sesDir '/mrVistaSession'])
        load([sesDir '/mrVistaSession/Gray/coords.mat']);
        load([sesDir '/mrVistaSession/fullind.mat']);
        
        % Use the inherent sorting of coords structure:
        coords = coords(:,fullind);
        [nodes,edges,nNotReached] = keepNodes(nodes,edges,fullind);
        % Also split into left and right
        keepLeft = keepLeft(ismember(keepLeft,fullind));
        keepRight = keepRight(ismember(keepRight,fullind));
        [allLeftNodes,allLeftEdges,nLeftNotReached] = keepNodes(allLeftNodes,allLeftEdges,keepLeft);
        [allRightNodes, allRightEdges, nRightNotReached] = keepNodes(allRightNodes, allRightEdges, keepRight);
        
        % [newNodes,newEdges,nNotReached] = keepNodes(nodes,edges,keepList,verbose);
        
        save([sesDir '/mrVistaSession/Gray/coords.mat'],'coords','nodes','edges',...
            'allLeftNodes','allLeftEdges','allRightNodes','allRightEdges',...
            'leftPath','rightPath','keepLeft','keepRight', 'leftClassFile', 'rightClassFile');
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Remake the tSeries
        close all
        mrVista('gray')
        inplane = checkSelectedInplane;
        VOLUME{1} = ip2volTSeries(inplane,VOLUME{1},0,'nearest'); % Works
        clear inplane;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if vCheck == 1
        % Run over timeseries:
        for ns = 1:numSes(np)
            % Load the updated coordinate structure:
            sesDir = [partDir '/' sesNames{np,ns}];
            cd([sesDir '/mrVistaSession'])
            load([sesDir '/mrVistaSession/Gray/coords.mat']);
            load([sesDir '/mrVistaSession/clp_params.mat']);
            load([sesDir '/mrVistaSession/mrInit_params.mat']);
            for nr = 1%:numRuns(np,ns), just one functional is enough
                % Load the updated coordinate structure:
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Return a nifti with only the gm coordinates, all else == 0 %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if nr == 1
                    t1 = readFileNifti(params.vAnatomy);
                    % Rotate the t1 such that the coords gained from grow_gray match up:
                    p1 = [3 2 1];
                    pe = [3 2 1 4];
                    t1.data = permute(t1.data,p1);
                    t1.data = flip(t1.data,1);
                    t1.data = flip(t1.data,2);
                    % Correct the dimensions in the nifti file
                    t = t1.dim(3);
                    t1.dim(3) = t1.dim(1);
                    t1.dim(1) = t;
                    t1.sto_xyz(:,4) = t1.sto_xyz(pe,4);
                    % Extract the coordinates
                    inds = sub2ind(size(t1.data), coords(1,:),coords(2,:),coords(3,:));
                    tmp = zeros(size(t1.data));
                    tmp(inds) = t1.data(inds);
                    t1.data = tmp;
                    % t1.fname = 'rot_t1.nii';
                    % writeFileNifti(t1)
                    % Invert the applied transformations
                    t1.data = flip(t1.data,2);
                    t1.data = flip(t1.data,1);
                    t1.data = permute(t1.data,p1);
                    % Correct the dimensions in the nifti file
                    t = t1.dim(3);
                    t1.dim(3) = t1.dim(1);
                    t1.dim(1) = t;
                    t1.sto_xyz(:,4) = t1.sto_xyz(pe,4);
                    t1.fname = 'GM_only_t1.nii';
                    writeFileNifti(t1);
                end
                
                % Same stuff for the epi as sanity checksum
                % Rewrite in terms of readFileNifti so we can adjust the offsets as well
                epi = readFileNifti(params.functionals{nr});
                epi.data = permute(epi.data,pe);
                % Correct the dimensions in the nifti file
                t = epi.dim(3);
                epi.dim(3) = epi.dim(1);
                epi.dim(1) = t;
                epi.data = flip(epi.data,1);
                epi.data = flip(epi.data,2);
                epi.sto_xyz(:,4) = epi.sto_xyz(pe,4);
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Correct for difference in box size using parameters from clp_params.mat
                % numbers represent: [R L A P I S]
                % t1.data = (lr,ap,ud) Dimensions of original
                % t1.rotdata = (ud,ap,lr); % Dimensions of rotated
                lr = clp_n(1)+clp_n(2)+1; % Number of dimensions clipped
                ap = clp_n(3)+clp_n(4); % Number of voxels clipped
                is = t1.dim(3)+t1.qoffset_z-clp_n(5)-clp_n(6); % Same, but from 'the other side'
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                epi.sto_xyz(1,4) = epi.sto_xyz(1,4)-is;
                epi.sto_xyz(2,4) = epi.sto_xyz(2,4)+ap;
                epi.sto_xyz(3,4) = epi.sto_xyz(3,4)+lr;
                
                % Transform the coordinates into epi-box coordinates
                clear ecoords
                ecoords(1,:) = coords(1,:)-clp_n(6); % ap 22
                ecoords(2,:) = coords(2,:)-clp_n(4); % ud 7
                ecoords(3,:) = coords(3,:)-clp_n(1); % lr 7, lr flip
                inds = sub2ind(size(epi.data(:,:,:,1)), ecoords(1,:),ecoords(2,:),ecoords(3,:));
                for ntp = 1:size(epi.data,4)
                    tmp2 = zeros(size(epi.data(:,:,:,1)));
                    tmp3 = epi.data(:,:,:,ntp);
                    tmp2(inds) = tmp3(inds);
                    epi.data(:,:,:,ntp) = tmp2;
                end
                
                % Invert the applied transformations
                epi.sto_xyz(3,4) = epi.sto_xyz(3,4)-lr;
                epi.sto_xyz(2,4) = epi.sto_xyz(2,4)-ap;
                epi.sto_xyz(1,4) = epi.sto_xyz(1,4)+is;
                epi.sto_xyz(:,4) = epi.sto_xyz(pe,4);
                epi.data = flip(epi.data,2);
                epi.data = flip(epi.data,1);
                epi.data = permute(epi.data,pe);
                % Correct the dimensions in the nifti file
                t = epi.dim(3);
                epi.dim(3) = epi.dim(1);
                epi.dim(1) = t;
                epi.fname = ['GM_only_' params.functionals{nr}];
                writeFileNifti(epi);
            end
        end
    else
        % Do nothing
    end
    cd(masterdir)
    
    % Becomes combine function?
    % Import tSeries from other sessions into the first session.
    
    partDir = [masterdir '/' partNames{np}];
    cd([partDir '/' sesNames{np,1} '/mrVistaSession'])
    
    close all
    mrVista('gray')
    
    scansAdd = 0; % To keep track of the number of scans that were imported
    for ns = 2:numSes(np)
        srcSession = [partDir '/' sesNames{np,ns} '/mrVistaSession'];
        %         VOLUME{1} = importTSeries(VOLUME{1});
        VOLUME{1} = importTSeries(VOLUME{1}, srcSession, 1, 1:numRuns(np,ns));
        scansAdd = scansAdd+numRuns(np,ns);
    end
    % Combine all the scans in one dataTYPE
    VOLUME{1}.curDataType = 2;
    groupScans(VOLUME{1}, 1:scansAdd, 'Original')
    % Remove the redundant "original_imported" dataTYPE
    VOLUME{1}.curDataType = 2;
    removeDataType(getDataTypeName(VOLUME{1}),0);
    
    cd(projectdir)
end

% move first folder to a new combined folder

%F OR EVERYTHING, clip prescan. ONLY DO THIS ONCE
close(1); mrvCleanWorkspace;
startup vo
mrVista 3
subID = whichSubs;
dataTYPES(1).name = 'NumerosityScans'; %And rename folder accordingly, re-save MRSESSION variable,
save('mrSESSION.mat','vANATOMYPATH','mrSESSION','dataTYPES');
cd Gray
system('mv Original NumerosityScans');
cd ..
% label all scan tSeries1
cd Gray/NumerosityScans/TSeries
folderList = dir('Scan*');
for ii = 1:size(folderList,1)
    cd (folderList(ii).name)
    currentSeries = dir('t*');
    if strcmp(currentSeries.name,'tSeries.mat')
        movefile('tSeries.mat','tSeries1.mat');
    end
    cd ..
end
cd ../../..

close(1); mrvCleanWorkspace;
mrVista 3
whichDT = 1;
prescanTRs = 6;
dataTYPES(VOLUME{1}.curDataType).scanParams.nFrames
for thisDT = 1:length(whichDT)
    VOLUME{1}.curDataType = whichDT(thisDT);
    tSeriesClipFrames(VOLUME{1},1:size(dataTYPES(VOLUME{1}.curDataType).scanParams, 2),prescanTRs,dataTYPES(VOLUME{1}.curDataType).scanParams(1).nFrames(1)-prescanTRs);
end
% check it worked right
dataTYPES(VOLUME{1}.curDataType).scanParams.nFrames

areaDTs = [{24:31},{9:16},{1:9},{19:26},{1:8},{1:7},{[1:10,20:23]},{[1:3,10:12]},{1:6},{1:6},{1:7}];
densDTs = [{9:16},{25:32},{18:24},{11:18},{9:16},{NaN},{NaN},{NaN},{NaN},{NaN},{NaN}];
periDTs = [{17:23},{1:8},{25:32},{7:10},{25:32},{NaN},{NaN},{NaN},{NaN},{NaN},{NaN}];
sizeDTs = [{1:8},{17:24},{10:17},{1:6},{17:24},{8:15},{[11:19,24:28]},{4:9},{7:11},{7:12},{8:16}];

allScanDT = 1;
VOLUME{1}.curDataType = allScanDT;
scanListArea = areaDTs{subID};
scanListSize = sizeDTs{subID};
if subID <= 5
    scanListPeri = periDTs{subID};
    scanListDens = densDTs{subID};
end
scanListOdd = 1:2:size(dataTYPES(VOLUME{1}.curDataType).scanParams, 2);
scanListEven = 2:2:size(dataTYPES(VOLUME{1}.curDataType).scanParams, 2);
scanListAll = 1:size(dataTYPES(VOLUME{1}.curDataType).scanParams, 2);

DTcount = size(dataTYPES, 2);
VOLUME{1} = averageTSeries(VOLUME{1}, scanListAll, 'NumerosityAll');
VOLUME{1} = averageTSeries(VOLUME{1}, scanListArea, 'NumerosityArea');
VOLUME{1} = averageTSeries(VOLUME{1}, scanListSize, 'NumerositySize');
if subID <= 5
    VOLUME{1} = averageTSeries(VOLUME{1}, scanListPeri, 'NumerosityPeri');
    VOLUME{1} = averageTSeries(VOLUME{1}, scanListDens, 'NumerosityDens');
end
VOLUME{1} = averageTSeries(VOLUME{1}, scanListOdd, 'NumerosityAllOdd');
VOLUME{1} = averageTSeries(VOLUME{1}, scanListEven, 'NumerosityAllEven');

DTcountNew = size(dataTYPES, 2);
for whichDT = (DTcount+1):DTcountNew
    VOLUME{1}.curDataType=whichDT;
    if whichDT == DTcount+1
        [VOLUME{1}, connectionMatrix] = collapseOverLayersTseries(VOLUME{1});
    else
        [VOLUME{1}] = collapseOverLayersTseries(VOLUME{1}, connectionMatrix);
    end
end
DTcountNewer = size(dataTYPES, 2);
load('/mnt/data/allModelParamsMix.mat')
NumerosityDTs{subID} = (DTcountNew+1):DTcountNewer;
save('/mnt/data/allModelParamsMix.mat',...
    'vfmDTs','paramsVFM','NumerosityDTs','paramsDurationPeriod', 'paramsNumerosity', 'paramsOccupancyPeriod', 'paramsOnTimeOffTime');

% Create an ROI of the layer 1 voxels and save to local file
VOLUME{1}=makeGrayROI(VOLUME{1}); VOLUME{1} = refreshScreen(VOLUME{1},0);
VOLUME{1} = roiRestricttoLayer1(VOLUME{1},VOLUME{1}.selectedROI);
VOLUME{1} = refreshScreen(VOLUME{1},0);
saveROI(VOLUME{1}, 'selected', 1);

close(1); mrvCleanWorkspace;

% BEFORE RUNNING MODELS, set paths
paths{1}='/mnt/data/P01/mrVistaSession';
paths{2}='/mnt/data/P02/mrVistaSession';
paths{3}='/mnt/data/P03/mrVistaSession';
paths{4}='/mnt/data/P04/mrVistaSession';
paths{5}='/mnt/data/P05/mrVistaSession';
paths{6}='/mnt/data/P06/mrVistaSession';
paths{7}='/mnt/data/P07/mrVistaSession';
paths{8}='/mnt/data/P08/mrVistaSession';
paths{9}='/mnt/data/P09/mrVistaSession';
paths{10}='/mnt/data/P10/mrVistaSession';
paths{11}='/mnt/data/P11/mrVistaSession';

whichSubs=[1:11];

startup vo

% FOR NUMEROSITY
% Normal (log tuned)
for thisSub=1:length(whichSubs)
    cd(paths{whichSubs(thisSub)})
    mrVista 3;
    
    load('/mnt/data/allModelParamsMix.mat')
    setAllRetParams(paramsNumerosity, NumerosityDTs{whichSubs(thisSub)})
    VOLUME{1} = rmRunNumbersScriptLog(VOLUME{1},NumerosityDTs{whichSubs(thisSub)}, 'gray-Layer1',8);
    close(1); mrvCleanWorkspace;
end

% Max 7 (log tuned)
for thisSub=1:length(whichSubs)
    cd(paths{whichSubs(thisSub)})
    mrVista 3;
    
    load('/mnt/data/allModelParamsMix.mat')
    setAllRetParams(paramsNumerosity, NumerosityDTs{whichSubs(thisSub)})
    VOLUME{1} = rmRunNumbersScriptLogMax7(VOLUME{1},NumerosityDTs{whichSubs(thisSub)}, 'gray-Layer1',8,[],[],[],8);
    close(1); mrvCleanWorkspace;
end

% Log Monotonic
for thisSub=1:length(whichSubs)
    cd(paths{whichSubs(thisSub)})
    mrVista 3;
    
    load('/mnt/data/allModelParamsMix.mat')
    setAllRetParams(paramsNumerosity, NumerosityDTs{whichSubs(thisSub)})
    VOLUME{1} = rmRunNumbersScriptLogMonotonic(VOLUME{1},NumerosityDTs{whichSubs(thisSub)}, 'gray-Layer1',10,[],[],[],8);
    close(1); mrvCleanWorkspace;
end

%%%%%%%%%%%%
%% FOR VFM %
%%%%%%%%%%%%

vCheck = 0; % for creating the visual checks after coordinate reduction:

whichSubs = 5;

nTRsPerSweep = 176;
nTRs = 176;
myTR = 2.1; %2.5 for auditory?
nPrescanTRs = 6; %Probably different for auditory?
frameLength = 50;
framesPerTR = myTR*1000/frameLength; % 42 if TR=2.1
nFramesPerSweep = nTRsPerSweep*framesPerTR;
params.prescanFrames = 6; % MAKE INTO PARAM STRUCTURE
params.realFrames = 176; % MAKE INTO PARAM STRUCTURE
%
% SET THIS TO YOUR OWN LOCAL DEFINITION:
vistasoftpath = '/mnt/data/matlab/vistasoft_preproc';
rmdpath = '/mnt/data/matlab/rmDevel';
addpath(genpath(vistasoftpath));
addpath(genpath(rmdpath));

% Define project directory
masterdir = '/mnt/data/vfm';
addpath(genpath(masterdir));
cd(masterdir)

% List directories to find number of participants
listing = dir(masterdir);
listing = listing(3:end);
numPart = length(listing);
for np = 1:numPart
    % Find the NAMES of the participants
    partNames{np} = listing(np).name;
    partDir = [masterdir '/' partNames{np}];
    cd(partDir)
    plist = dir(partDir);
    plist = plist(3:end);
    numSes(np) = length(plist);
    for ns = 1:numSes(np)
        clear params
        sesNames{np,ns} = plist(ns).name;
        sesDir = [partDir '/' sesNames{np,ns}];
        cd(sesDir)
        % Move to local mrVista directory to start the analysis
        projectdir = [sesDir '/mrVistaSession'];
        cd(projectdir)
        % Initialize session with the following files:
        % Inplane       <- lo2hi_for_clp_params
        % Functional    <- clp_EPI's
        % Volume        <- t1_1mm
        % First, find some files
        EPIlist = dir('clp_EPI*');
        % EPIlist = dir('*epi*.nii');
        inplist = dir('*lo2hi_for_clp_params*');
        % inplist = dir('*oneframe*'); % Remember to ask whether this flip happens
        % automatically when the inplane is flipped, or whether I have to specify
        % the flip for all individual runs.
        vollist = dir('*1mm.nii*');
        % Create some parameters
        numRuns(np,ns) = length(EPIlist);
        for nr = 1:numRuns(np,ns)
            params.functionals{nr} = EPIlist(nr).name;
        end
        params.vAnatomy = vollist(1).name;
        params.inplane = inplist(1).name;
        
        % Initialize session:
        mrInit(params);
        % Creates: mrSESSION.mat, mrInit_params.mat
        %% Adjust the mrSESSION file such that mrVista understands the proper alignment
        load mrSESSION.mat
        % Make the flip easier to handle:
        % Load in the low-res_T1
        local = readFileNifti(mrSESSION.inplanes.inplanePath);
        hires = readFileNifti(params.vAnatomy);
        % Redefine the alignment parameters based on the size of the R-L dimension
        % Add +1 to the dimension to be flipped, as space starts counting from
        % zero, but indices start at one!
        load('clp_params.mat')
        % mrSESSION.alignment = [-0 -0 -1 local.dim(3)+box_boundary(6)+1; 1 -0 0 box_boundary(4); 0 1 -0 box_boundary(1); 0 0 0 1];
        mrSESSION.alignment = [-0 -0 -1 local.dim(3)+clp_n(6)+1; 1 -0 0 clp_n(4); 0 1 -0 clp_n(1); 0 0 0 1];
        if ~exist('vANATOMYPATH')
            load mrInit_params.mat
            vANATOMYPATH = [params.sessionDir,'/',params.vAnatomy];
        end
        save('mrSESSION.mat', 'mrSESSION', 'dataTYPES', 'vANATOMYPATH')
        
        rxAlign; % Check visually
        % Save the alignment created by mrVista?;
        
        %
        % Build the actual Gray Matter coordinates using the class files:
        % Inputs are:
        % 1. Gray or volume view, default is [] for automatic hidden volume view
        % 2. Path to which to save the coords.mat file
        % 3. Flag 1== keep ALL gm-coords, 0== ONLY gm in inplane
        % 4. Segmentation file (Class file)
        % 5. Number of layers to include (in mm, hence 4 == max)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %									     %
        % Check if the above step can be automated entirely. 		     %
        % Which is the case if the coords structure can be reconstructed based on %
        % nothing but the input niftis and the segmentation masks provided.       %
        %									     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        close all
        % If no input is provided, pop-up asks for class file:
        seglist = dir('*class*.nii');
        buildGrayCoords([],[],0,{seglist.name},8);
        % Creates [nodes, edges], where node is gm voxel, and edge is number of
        % neighbors it has.
        % Necessary information is coords (DimensionsxNumberOfGrayMatterVoxels)
        % e.g. coords = [1:3, 1:400000];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Get timeseries from the gm-voxels %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        close all
        mrVista('gray')
        inplane = checkSelectedInplane;
        VOLUME{1} = ip2volTSeries(inplane,VOLUME{1},0,'nearest');
        clear inplane;
        close all
        % Gives path Gray/Original/TSeries/Scan1
        % Carries: tSeries.mat
        % NumberOfTimePoints x NumberOfGrayMatterVoxels
        % e.g. tSeries = [1:196, 1:400000];
        %%
        % For later refining of the tseries, (removing empty ones)
        graypath = [projectdir '/Gray'];
        tspath = [graypath '/Original/TSeries'];
        
        % Construct a list of indices to keep
        for nr = 1:numRuns(np,ns)
            load([graypath '/coords.mat'])
            % Select current scan
            rundir = [tspath '/Scan' num2str(nr)];
            % Load the voxel_timeseries
            load([rundir '/tSeries1.mat'])
            % Find voxels for which the following is true:
            inds2{ns,nr}.c = find(floor((~isnan(sum(tSeries,1)) + (sum(tSeries,1)~=0))/2));
            % Make one list, but keep the originals as well
        end
        cd(partDir)
    end
    %%
    save([partDir '/' sesNames{np,1} '/mrVistaSession/indices_for_check.mat'], 'inds2')
    % Now that we have done all sessions/runs for THIS participant:
    % construct full list of indices that we would like to keep:
    for ns = 1:numSes(np)
        clear fullind
        for nr = 1:numRuns(np,ns)
            if nr == 1
                fullind = inds2{ns,nr}.c;
            else
                fullind = fullind(ismember(fullind, inds2{ns,nr}.c));
                % fullind = unique(fullind);
            end
        end
        save([partDir '/' sesNames{np,ns} '/mrVistaSession/fullind.mat'], 'fullind')
    end
    % Save the coordinates we will use for analysis
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for ns = 1:numSes(np)
        sesDir = [partDir '/' sesNames{np,ns}];
        cd([sesDir '/mrVistaSession'])
        load([sesDir '/mrVistaSession/Gray/coords.mat']);
        load([sesDir '/mrVistaSession/fullind.mat']);
        
        % Use the inherent sorting of coords structure:
        coords = coords(:,fullind);
        [nodes,edges,nNotReached] = keepNodes(nodes,edges,fullind);
        % Also split into left and right
        keepLeft = keepLeft(ismember(keepLeft,fullind));
        keepRight = keepRight(ismember(keepRight,fullind));
        [allLeftNodes,allLeftEdges,nLeftNotReached] = keepNodes(allLeftNodes,allLeftEdges,keepLeft);
        [allRightNodes, allRightEdges, nRightNotReached] = keepNodes(allRightNodes, allRightEdges, keepRight);
        
        % [newNodes,newEdges,nNotReached] = keepNodes(nodes,edges,keepList,verbose);
        
        save([sesDir '/mrVistaSession/Gray/coords.mat'],'coords','nodes','edges',...
            'allLeftNodes','allLeftEdges','allRightNodes','allRightEdges',...
            'leftPath','rightPath','keepLeft','keepRight', 'leftClassFile', 'rightClassFile');
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Remake the tSeries
        close all
        mrVista('gray')
        inplane=checkSelectedInplane;
        VOLUME{1}=ip2volTSeries(inplane,VOLUME{1},0,'nearest'); % Works
        clear inplane;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if vCheck == 1
        % Run over timeseries:
        for ns = 1:numSes(np)
            % Load the updated coordinate structure:
            sesDir = [partDir '/' sesNames{np,ns}];
            cd([sesDir '/mrVistaSession'])
            load([sesDir '/mrVistaSession/Gray/coords.mat']);
            load([sesDir '/mrVistaSession/clp_params.mat']);
            load([sesDir '/mrVistaSession/mrInit_params.mat']);
            for nr = 1%:numRuns(np,ns), just one functional is enough
                % Load the updated coordinate structure:
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Return a nifti with only the gm coordinates, all else == 0 %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if nr == 1
                    t1 = readFileNifti(params.vAnatomy);
                    % Rotate the t1 such that the coords gained from grow_gray match up:
                    p1 = [3 2 1];
                    pe = [3 2 1 4];
                    t1.data = permute(t1.data,p1);
                    t1.data = flip(t1.data,1);
                    t1.data = flip(t1.data,2);
                    % Correct the dimensions in the nifti file
                    t = t1.dim(3);
                    t1.dim(3) = t1.dim(1);
                    t1.dim(1) = t;
                    t1.sto_xyz(:,4) = t1.sto_xyz(pe,4);
                    % Extract the coordinates
                    inds = sub2ind(size(t1.data), coords(1,:),coords(2,:),coords(3,:));
                    tmp = zeros(size(t1.data));
                    tmp(inds) = t1.data(inds);
                    t1.data = tmp;
                    % t1.fname = 'rot_t1.nii';
                    % writeFileNifti(t1)
                    % Invert the applied transformations
                    t1.data = flip(t1.data,2);
                    t1.data = flip(t1.data,1);
                    t1.data = permute(t1.data,p1);
                    % Correct the dimensions in the nifti file
                    t = t1.dim(3);
                    t1.dim(3) = t1.dim(1);
                    t1.dim(1) = t;
                    t1.sto_xyz(:,4) = t1.sto_xyz(pe,4);
                    t1.fname = 'GM_only_t1.nii';
                    writeFileNifti(t1);
                end
                
                % Same stuff for the epi as sanity checksum
                % Rewrite in terms of readFileNifti so we can adjust the offsets as well
                epi = readFileNifti(params.functionals{nr});
                epi.data = permute(epi.data,pe);
                % Correct the dimensions in the nifti file
                t = epi.dim(3);
                epi.dim(3) = epi.dim(1);
                epi.dim(1) = t;
                epi.data = flip(epi.data,1);
                epi.data = flip(epi.data,2);
                epi.sto_xyz(:,4) = epi.sto_xyz(pe,4);
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Correct for difference in box size using parameters from clp_params.mat
                % numbers represent: [R L A P I S]
                % t1.data = (lr,ap,ud) Dimensions of original
                % t1.rotdata = (ud,ap,lr); % Dimensions of rotated
                lr = clp_n(1)+clp_n(2)+1; % Number of dimensions clipped
                ap = clp_n(3)+clp_n(4); % Number of voxels clipped
                is = t1.dim(3)+t1.qoffset_z-clp_n(5)-clp_n(6); % Same, but from 'the other side'
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                epi.sto_xyz(1,4) = epi.sto_xyz(1,4)-is;
                epi.sto_xyz(2,4) = epi.sto_xyz(2,4)+ap;
                epi.sto_xyz(3,4) = epi.sto_xyz(3,4)+lr;
                
                % Transform the coordinates into epi-box coordinates
                clear ecoords
                ecoords(1,:) = coords(1,:)-clp_n(6); % ap 22
                ecoords(2,:) = coords(2,:)-clp_n(4); % ud 7
                ecoords(3,:) = coords(3,:)-clp_n(1); % lr 7, lr flip
                inds = sub2ind(size(epi.data(:,:,:,1)), ecoords(1,:),ecoords(2,:),ecoords(3,:));
                for ntp = 1:size(epi.data,4)
                    tmp2 = zeros(size(epi.data(:,:,:,1)));
                    tmp3 = epi.data(:,:,:,ntp);
                    tmp2(inds) = tmp3(inds);
                    epi.data(:,:,:,ntp) = tmp2;
                end
                
                % Invert the applied transformations
                epi.sto_xyz(3,4) = epi.sto_xyz(3,4)-lr;
                epi.sto_xyz(2,4) = epi.sto_xyz(2,4)-ap;
                epi.sto_xyz(1,4) = epi.sto_xyz(1,4)+is;
                epi.sto_xyz(:,4) = epi.sto_xyz(pe,4);
                epi.data = flip(epi.data,2);
                epi.data = flip(epi.data,1);
                epi.data = permute(epi.data,pe);
                % Correct the dimensions in the nifti file
                t = epi.dim(3);
                epi.dim(3) = epi.dim(1);
                epi.dim(1) = t;
                epi.fname = ['GM_only_' params.functionals{nr}];
                writeFileNifti(epi);
            end
        end
    else
        % Do nothing
    end
    cd(projectdir)
end

% FOR EVERYTHING, clip prescan. ONLY DO THIS ONCE
close(1); mrvCleanWorkspace;
startup vo
mrVista 3
subID = whichSubs;
dataTYPES(1).name = 'VFMScans'; % And rename folder accordingly, re-save MRSESSION variable
save('mrSESSION.mat','vANATOMYPATH','mrSESSION','dataTYPES');
cd Gray
system('mv Original VFMScans');
cd ..
% label all scan tSeries1
cd Gray/VFMScans/TSeries
folderList = dir('Scan*');
for ii = 1:size(folderList,1)
    cd (folderList(ii).name)
    currentSeries = dir('t*');
    if strcmp(currentSeries.name,'tSeries.mat')
        movefile('tSeries.mat','tSeries1.mat');
    end
    cd ..
end
cd ../../..

close(1); mrvCleanWorkspace;
mrVista 3
whichDT = 1;
prescanTRs = 6;
dataTYPES(VOLUME{1}.curDataType).scanParams.nFrames
for thisDT = 1:length(whichDT)
    VOLUME{1}.curDataType = whichDT(thisDT);
    tSeriesClipFrames(VOLUME{1},1:size(dataTYPES(VOLUME{1}.curDataType).scanParams, 2),prescanTRs,dataTYPES(VOLUME{1}.curDataType).scanParams(1).nFrames(1)-prescanTRs);
end
% check it worked right
dataTYPES(VOLUME{1}.curDataType).scanParams.nFrames

allScanDT = 1;
VOLUME{1}.curDataType = allScanDT;
scanListAll = 1:size(dataTYPES(VOLUME{1}.curDataType).scanParams, 2);

DTcount = size(dataTYPES, 2);
VOLUME{1} = averageTSeries(VOLUME{1}, scanListAll, 'VFM');

DTcountNew = size(dataTYPES, 2);
for whichDT = (DTcount+1):DTcountNew
    VOLUME{1}.curDataType = whichDT;
    if whichDT == DTcount+1
        [VOLUME{1}, connectionMatrix] = collapseOverLayersTseries(VOLUME{1});
    else
        [VOLUME{1}] = collapseOverLayersTseries(VOLUME{1}, connectionMatrix);
    end
end
DTcountNewer = size(dataTYPES, 2);
load('/mnt/data/allModelParamsMix.mat')
vfmDTs{subID} = (DTcountNew+1):DTcountNewer;
vfmDTs{subID} = NumerosityDTs{subID}(end):1:NumerosityDTs{subID}(end-1)+vfmDTs{subID}(1);
save('/mnt/data/allModelParamsMix.mat',...
    'vfmDTs','paramsVFM','NumerosityDTs','paramsDurationPeriod', 'paramsNumerosity', 'paramsOccupancyPeriod', 'paramsOnTimeOffTime');

% Create an ROI of the layer 1 voxels and save to local file
VOLUME{1} = makeGrayROI(VOLUME{1}); VOLUME{1} = refreshScreen(VOLUME{1},0);
VOLUME{1} = roiRestricttoLayer1(VOLUME{1},VOLUME{1}.selectedROI);
VOLUME{1} = refreshScreen(VOLUME{1},0);
saveROI(VOLUME{1}, 'selected', 1);

close(1); mrvCleanWorkspace;

% transfer scans to combined folder before running models

%BEFORE RUNNING MODELS, set paths
paths{1}='/mnt/data/P01/mrVistaSession';
paths{2}='/mnt/data/P02/mrVistaSession';
paths{3}='/mnt/data/P03/mrVistaSession';
paths{4}='/mnt/data/P04/mrVistaSession';
paths{5}='/mnt/data/P05/mrVistaSession';
paths{6}='/mnt/data/P06/mrVistaSession';
paths{7}='/mnt/data/P07/mrVistaSession';
paths{8}='/mnt/data/P08/mrVistaSession';
paths{9}='/mnt/data/P09/mrVistaSession';
paths{10}='/mnt/data/P10/mrVistaSession';
paths{11}='/mnt/data/P11/mrVistaSession';

whichSubs=[1:11];

% startup vo
% add vistaSoft to path

% FOR VFM
for thisSub = 1:length(whichSubs)
    cd(paths{whichSubs(thisSub)})
    mrVista 3;
    
    load('/mnt/data/allModelParamsMix.mat')
    setAllRetParams(paramsVFM, vfmDTs{whichSubs(thisSub)})
    
    matfilename = 'retModel-Decimate-Freexy-FreeHRF_NoDC_OneG';
    tmpv = rmInitView([1 vfmDTs{whichSubs(thisSub)}]);
    tmpv = rmMain(tmpv,'gray-Layer1',5,'matfilename',matfilename,'coarsetofine',false,'datadrivendc',false);
    
    close(1); mrvCleanWorkspace;
end
