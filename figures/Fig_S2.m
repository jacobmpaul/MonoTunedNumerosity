%%%%%%%%%%%%
%% Fig.S2 %%
%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Visual field mapping (eccentricity) inflated meshes %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% NOTE: requires an inflated cortical surface structure (grayLayer1) - not shareable without being identifiable
data_dir = '/home/data/';

paths{1} = strcat(data_dir,'P01');
paths{2} = strcat(data_dir,'P02');
paths{3} = strcat(data_dir,'P03');
paths{4} = strcat(data_dir,'P04');
paths{5} = strcat(data_dir,'P05');
paths{6} = strcat(data_dir,'P06');
paths{7} = strcat(data_dir,'P07');
paths{8} = strcat(data_dir,'P08');
paths{9} = strcat(data_dir,'P09');
paths{10} = strcat(data_dir,'P10');
paths{11} = strcat(data_dir,'P11');

displayMesh = 1;
saveData = 1;

participantNames = {'P01', 'P02', 'P03', 'P04', 'P05', 'P06', 'P07', 'P08', 'P09', 'P10', 'P11'};
ROINames = {'gray-Layer1'}; ROIFieldNames = {'grayLayer1'};

%% VFM eccentricity & polar angle
modelNames = {'*retModel-Decimate-Freexy-FreeHRF_NoDC_OneG-fFit-fFit-fFit*'};
meshNames = {'meshBothInflated','meshLeftInflated','meshRightInflated'};
savePath = {'/home/data/NatComms/'};
eccNames = {'eccentricity_back','eccentricity_left','eccentricity_right'};
angNames = {'angle_back','angle_left','angle_right'};

% find best fitting model (max7(tuned) or monotonic) at each voxel
for participants = 1:length(participantNames)

    cd(fullfile([paths{participants}]));
    meshSettings = load('MeshSettings.mat');
    subjSettings = length(meshSettings.settings);    
    possibleSettings={};
    for getSettings=1:subjSettings
       possibleSettings=[possibleSettings,meshSettings.settings(getSettings).name]; %#ok<AGROW>
    end
    backSettings = length(possibleSettings);
    leftSettings = find(contains(possibleSettings,'Left'),1,'last');
    rightSettings = find(contains(possibleSettings,'Right'),1,'last');
    
    currentSettings = [backSettings,leftSettings,rightSettings];
    
    for meshes = 1:3 % Both,Left,Right
        
        cd(fullfile([paths{participants}]));
        mrVista 3
        
        if participants <= 5
            stimuli = 18;
        else
            stimuli = 14;
        end
        
        stim = 1; %VFM (L1)
        VOLUME{1}.curDataType = stimuli(stim);
        % Get correct folder for stimulus configuration
        stimName = regexprep((dataTYPES(1,stimuli(stim)).name), '[^\w'']','');
        stimFolder = fullfile('Gray',dataTYPES(1,stimuli(stim)).name);
        % Load current filename
        cd(stimFolder);
        
        rmName = fullfile([paths{participants},stimFolder,'/',strcat(ls(modelNames{1}))]);
        cd([paths{participants}]);
        VOLUME{1} = rmSelect(VOLUME{1}, 1, rmName); VOLUME{1} = rmLoadDefault(VOLUME{1});
        
        %% Eccentricity
        VOLUME{1} = setMapWindow(VOLUME{1}, [0 6.35]);VOLUME{1} = refreshScreen(VOLUME{1}, 1);
        VOLUME{1} = setCothresh(VOLUME{1}, 0.1);VOLUME{1} = refreshScreen(VOLUME{1}, 1);   
        H = open3DWindow;
        
        meshPath = strcat([pwd,'/',meshNames{meshes}]);
        [VOLUME{1},OK] = meshLoad(VOLUME{1},meshPath,1);
        % Refresh happens there
        msh = viewGet(VOLUME{1}, 'currentmesh');
        if meshGet(msh,'windowid') < 0
            % First, check if the server is started
            serverStarted = mrmCheckServer(msh.host);
            % Now, get a new window ID (should return positive integer
            % corresponding to the mrMesh window)
            id = mrMesh(msh.host, -1, 'get'); 	% Start a new window
            
            % We could reuse numbers
            msh = meshSet(msh, 'windowid', id);
            msh = mrmInitMesh(msh);
        else
            meshVisualize(msh);
        end
       
        if ~isempty(msh)
            VOLUME{1} = viewSet(VOLUME{1},'currentmesh',msh);
        end
        mrmSet(msh, 'cursoroff');
        
        MSH = viewGet(VOLUME{1}, 'Mesh');
        vertexGrayMap = mrmMapVerticesToGray( meshGet(MSH, 'initialvertices'), viewGet(VOLUME{1}, 'nodes'),...
            viewGet(VOLUME{1}, 'mmPerVox'), viewGet(VOLUME{1}, 'edges') );
        MSH = meshSet(MSH, 'vertexgraymap', vertexGrayMap); VOLUME{1} = viewSet(VOLUME{1}, 'Mesh', MSH);
        clear MSH vertexGrayMap
        
        meshRetrieveSettings(viewGet(VOLUME{1}, 'CurMesh'), currentSettings(meshes));
        VOLUME{1} = meshColorOverlay(VOLUME{1}); VOLUME{1} = refreshScreen(VOLUME{1}, 1);
        msh = viewGet(VOLUME{1},'currentmesh');
        lights = meshGet(msh,'lights');
        lights{1}.diffuse=[0 0 0];
        lights{1}.ambient=[0.5 0.5 0.5];
        host = meshGet(msh, 'host');
        windowID = meshGet(msh, 'windowID');
        distance=10;
        for n = 1:length(lights)  
           L.actor = lights{n}.actor;
           L.origin = distance .* lights{n}.origin;
           lights{n} = mergeStructures(lights{n}, L);
           mrMesh(host, windowID, 'set', L);
        end
        msh = meshSet(msh, 'lights', lights);
        VOLUME{1} = viewSet(VOLUME{1}, 'mesh', msh);
        meshRetrieveSettings(viewGet(VOLUME{1}, 'CurMesh'), currentSettings(meshes));
        wSize=[1056,1855]; %@1920x1080
        mrmSet(msh,'windowSize',wSize(1),wSize(2));
        
        % Save screenshot - eccentricity
        fname = fullfile(savePath{1},participantNames{participants},[eccNames{meshes},'.png']);
        udata.rgb = mrmGet(msh,'screenshot')/255;
        imwrite(udata.rgb, fname);
        set(gcf,'userdata',udata);
        
        %% Polar angle
        VOLUME{1} = setMapWindow(VOLUME{1}, [0 2*pi]);VOLUME{1} = refreshScreen(VOLUME{1}, 1);
        VOLUME{1} = setDisplayMode(VOLUME{1},'ph'); VOLUME{1} = refreshScreen(VOLUME{1});
        modeInfo = VOLUME{1}.ui.(['ph' 'Mode']);
        nG = modeInfo.numGrays;nC = modeInfo.numColors;
        VOLUME{1} = cmapRedgreenblue(VOLUME{1}, 'ph', 1); VOLUME{1} = refreshScreen(VOLUME{1});
        switch meshes
            case 1
                % Right half first
                VOLUME{1}=rotateCmap(VOLUME{1},  90); VOLUME{1}=refreshScreen(VOLUME{1}, 1);
                VOLUME{1}=flipCmap(VOLUME{1}); VOLUME{1}=refreshScreen(VOLUME{1}, 1);
                VOLUME{1} = meshColorOverlay(VOLUME{1}); VOLUME{1} = refreshScreen(VOLUME{1}, 1);
                
                % Save screenshot - angle
                fname = fullfile(savePath{1},participantNames{participants},[angNames{meshes},'rightHalf.png']);
                udata.rgb = mrmGet(msh,'screenshot')/255;
                imwrite(udata.rgb, fname);
                set(gcf,'userdata',udata);
                
                % Left half second
                VOLUME{1}=rotateCmap(VOLUME{1},  180); VOLUME{1}=refreshScreen(VOLUME{1}, 1);
                VOLUME{1}=flipCmap(VOLUME{1}); VOLUME{1}=refreshScreen(VOLUME{1}, 1);
                VOLUME{1} = meshColorOverlay(VOLUME{1}); VOLUME{1} = refreshScreen(VOLUME{1}, 1);
                
                % Save screenshot - angle
                fname = fullfile(savePath{1},participantNames{participants},[angNames{meshes},'leftHalf.png']);
                udata.rgb = mrmGet(msh,'screenshot')/255;
                imwrite(udata.rgb, fname);
                set(gcf,'userdata',udata);                
            case 2
                VOLUME{1}=rotateCmap(VOLUME{1},  90); VOLUME{1}=refreshScreen(VOLUME{1}, 1);
                VOLUME{1}=flipCmap(VOLUME{1}); VOLUME{1}=refreshScreen(VOLUME{1}, 1);                 
                VOLUME{1}=rotateCmap(VOLUME{1},  180); VOLUME{1}=refreshScreen(VOLUME{1}, 1);
                VOLUME{1}=flipCmap(VOLUME{1}); VOLUME{1}=refreshScreen(VOLUME{1}, 1);
                VOLUME{1} = meshColorOverlay(VOLUME{1}); VOLUME{1} = refreshScreen(VOLUME{1}, 1);
                
                % Save screenshot - angle
                fname = fullfile(savePath{1},participantNames{participants},[angNames{meshes},'.png']);
                udata.rgb = mrmGet(msh,'screenshot')/255;
                imwrite(udata.rgb, fname);
                set(gcf,'userdata',udata);
            case 3
                VOLUME{1}=rotateCmap(VOLUME{1},  90); VOLUME{1}=refreshScreen(VOLUME{1}, 1);
                VOLUME{1}=flipCmap(VOLUME{1}); VOLUME{1}=refreshScreen(VOLUME{1}, 1);
                VOLUME{1} = meshColorOverlay(VOLUME{1}); VOLUME{1} = refreshScreen(VOLUME{1}, 1);
                
                % Save screenshot - angle
                fname = fullfile(savePath{1},participantNames{participants},[angNames{meshes},'.png']);
                udata.rgb = mrmGet(msh,'screenshot')/255;
                imwrite(udata.rgb, fname);
                set(gcf,'userdata',udata);       
        end

        allMeshes = viewGet(VOLUME{1}, 'allmeshes');
        mrmSet(allMeshes, 'closeall');
        h = findobj('Name', '3DWindow (mrMesh)');
        close(h);
        VOLUME{1}=rmfield(VOLUME{1},'mesh');
        
        close all
        mrvCleanWorkspace
    end
    
end
