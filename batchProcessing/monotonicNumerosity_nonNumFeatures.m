%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% monotonic models to non-numerosity features %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

paths{1}='/mnt/data/P01/mrVistaSession';
paths{2}='/mnt/data/P02/mrVistaSession';
paths{3}='/mnt/data/P03/mrVistaSession';
paths{4}='/mnt/data/P04/mrVistaSession';
paths{5}='/mnt/data/P05/mrVistaSession';

% startup vo
% add vistaSoft to path
rmdpath = '/mnt/matlab/rmDevel'; % get from https:github.com/benharvey/vistasoftAddOns
addpath(genpath(rmdpath));

%% makeCueParamsFiles
cd('/mnt/data/CueStimuliScriptsParams')
load('params_indices_TR2.1.mat')
params.dotOrder(params.dotOrder==20)=8; %Just in case linear numerosities are stored rather than indices
indices=params.dotOrder;

stimuli=["Area", "Radius", "Circ", "Dense"];
models=["Number", "DisplayRMS", "EdgeDensity", "HullArea", "HullLength", "HullRMS", "ItemArea", "ItemRadius", "LuminanceDensity", "NumberDensity", "SFamplitude", "SFauc", "SFspread", "TotalArea", "TotalCirc", "SumLum", "SumEdges", "SumLumNorm",  "SumEdgesNorm", "SFauc_new"];

for model=1:length(models)
    for stim=1:length(stimuli)
        retParams.paramsFile=[pwd, '/Linear/params_', char(models(model)), char(stimuli(stim)), '.mat'];
        eval(['groupParams.' char(models(model)), '(', num2str(stim), ')=retParams;']);
    end
end
save('CueModelParamsLinear.mat', 'groupParams');

for model=1:length(models)
    for stim=1:length(stimuli)
        retParams.paramsFile=[pwd, '/Log/params_', char(models(model)), char(stimuli(stim)), '.mat'];
        eval(['groupParams.' char(models(model)), '(', num2str(stim), ')=retParams;']);
    end
end
save('CueModelParamsLog.mat', 'groupParams');

%% makeSumImageParams
cd('/mnt/data/CueStimuliScriptsParams/Linear')
load params_NumbersArea.mat
imageFiles=["edges", "lum", "edges", "lum"];
norms=["", "", "Norm", "Norm"];
stimuli=["Area", "Size", "Circ", "Dense"];
stimuliOut=["Area", "Radius", "Circ", "Dense"];
outputNames=["SumEdges", "SumLum",  "SumEdgesNorm","SumLumNorm"];

cd('/mnt/data//CueStimuliScriptsParams')

for imType=1:length(imageFiles)
    mostLow=999999999;
    mostHigh=-999999999;
    blank=[];
    mostLowLog=999999999;
    mostHighLog=-999999999;
    blankLog=[];
    
    for stim=1:length(stimuli)
        eval(['load(''images_', char(imageFiles(imType)), char(stimuli(stim)), char(norms(imType)), '.mat'');' ])
        for n=1:length(indices)
            params.dotOrder(n)=sum(sum(images(:,:,indices(n))));
        end
        mostLow=min(mostLow, min(params.dotOrder));
        mostHigh=max(mostHigh, max(params.dotOrder));
        blanks=[blank params.dotOrder(end)];
        save(['/mnt/data/CueStimuliScriptsParams/Linear/params_', char(outputNames(imType)), char(stimuliOut(stim)), '.mat'], 'params');
        figure; plot(params.dotOrder)
        params.dotOrder=log(params.dotOrder);
        mostLowLog=min(mostLowLog, min(params.dotOrder));
        mostHighLog=max(mostHighLog, max(params.dotOrder));
        blanksLog=[blank params.dotOrder(end)];
        save(['/mnt/data/CueStimuliScriptsParams/Log/params_', char(outputNames(imType)), char(stimuliOut(stim)), '.mat'], 'params');
    end
    [char(imageFiles(imType)), char(norms(imType))]
    mostLow
    mostHigh
    blanks
    mostLowLog
    mostHighLog
    blanksLog
end

%% CueRunModelsScriptMono - all scans

dts = [10:13]; %Area, Size, Peri, Dens
maxCores = 4;
cd('/mnt/data/CueStimuliScriptsParams')
load('CueModelParamsLinear.mat');

load('/mnt/data/cueRunModelsParams.mat');

for whichSubs=1:5
    
    cd(paths{whichSubs})
    mrVista 3;
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLin, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.Number(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-Number-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 20, 20,1);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLin, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.ItemArea(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-ItemArea-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 1.32, 1.32);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLin, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.TotalArea(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-TotalArea-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 1.32, 1.32);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLin, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.TotalCirc(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-TotalCirc-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 10.6, 10.6);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLin, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.HullLength(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-HullLength-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 4.4, 4.4);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLin, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.HullArea(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-HullArea-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 1.45, 1.45);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLin, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.LuminanceDensity(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-LuminanceDensity-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 1, 1);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLin, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.HullRMS(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-HullRMS-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 0.5, 0.5);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLin, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.DisplayRMS(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-DisplayRMS-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 0.5, 0.5);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLin, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.NumberDensity(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-NumberDensity-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 5.7, 5.7);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLin, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.SFamplitude(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-SFamplitude-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 5, 5);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLin, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.SFspread(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-SFspread-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 5, 5);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLin, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.SFauc(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-SFauc-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 2.5, 2.5);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLin, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.ItemRadius(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-ItemRadius-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 1.15, 1.15);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLin, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.EdgeDensity(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-EdgeDensity-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 0.53, 0.53);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLin, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.SumLum(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-SumLuminance-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 79.4830, 79.4830, 3.2999);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLin, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.SumEdges(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-SumEdges-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 63.1685, 63.1685, 3.1484);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLin, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.SumLumNorm(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-SumLuminanceNorm-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 79.4830, 79.4830, 12.3233);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLin, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.SumEdgesNorm(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-SumEdgesNorm-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 65.7382, 65.7382, 12.9157);

    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLin, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.SFauc_new(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-AggFourierPower-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 2.6, 2.6,1);    
    
    close all; mrvCleanWorkspace;
end

%% CueRunModelsScriptMonoLog - all scans

dts = [10:13]; %Area, Size, Peri, Dens
maxCores = 4;
cd('/mnt/data/CueStimuliScriptsParams')
load('CueModelParamsLog.mat');

load('/mnt/WholeBrainNewSeg-afni/cueRunModelsParams.mat');

for whichSubs=1:5
    
    cd(paths{whichSubs})
    mrVista 3;
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLog, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.Number(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-logNumber-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 2.9957, 2.9957, 0);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLog, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.ItemArea(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-logItemArea-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 0.275, 0.275, -5.75);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLog, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.TotalArea(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-logTotalArea-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 0.275, 0.275, -4.3125);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLog, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.TotalCirc(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-logTotalCirc-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 2.36, 2.36, -0.661);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLog, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.HullLength(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-logHullLength-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 1.48, 1.48, -0.661);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLog, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.HullArea(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-logHullArea-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 0.38, 0.38, -3.86);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLog, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.LuminanceDensity(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-logLuminanceDensity-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 0, 0, -3.02);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLog, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.HullRMS(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-logHullRMS-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 0, 0, -1.55);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLog, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.DisplayRMS(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-logDisplayRMS-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, -0.73, -0.73, -2.461);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLog, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.NumberDensity(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-logNumberDensity-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 1.731, 1.731, -2.578);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLog, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.SFamplitude(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-logSFamplitude-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 1.55, 1.55, 0.93);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLog, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.SFspread(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-logSFspread-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 1.6, 1.6, -1.25);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLog, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.SFauc(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-logSFauc-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 0.88, 0.88, -0.962);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLog, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.ItemRadius(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-logItemRadius-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 0.1375, 0.1375, -2.85);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLog, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.EdgeDensity(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-logEdgeDensity-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, -0.65, -0.65, -3.11);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLog, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.SumLum(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-logSumLuminance-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 13.5859, 13.5859, 10.4042);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLog, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.SumEdges(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-logSumEdges-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 13.3561, 13.3561, 10.3572);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLog, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.SumLumNorm(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-logSumLuminanceNorm-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 13.5859, 13.5859, 11.7218);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLog, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.SumEdgesNorm(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-logSumEdgesNorm-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 13.3960, 13.3960, 11.7688);
    
    for n=1:4
        setAllRetParams(paramsNumerosityMonotonicLog, dts(n));
        dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.SFauc_new(n).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts, 'gray-Layer1',9, [], [], sprintf('eachCondition-logAggFourierPower-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 2.0, 2.0, 0);

    close all; mrvCleanWorkspace;
end

%% cross-validation

subjNames = {'P01', 'P02', 'P03', 'P04', 'P05'};

for subID = 1:length(subjNames)
    cd(fullfile('/mnt/data/',[subjNames{subID},'/mrVistaSession']))
    close all; mrvCleanWorkspace;
    mrVista 3
    whichDT = 1;
    
    % all scans
    areaDTs = [{24:31},{9:16},{1:9},{19:26},{1:8}];
    densDTs = [{9:16},{25:32},{18:24},{11:18},{9:16}];
    periDTs = [{17:23},{1:8},{25:32},{7:10},{25:32}];
    sizeDTs = [{1:8},{17:24},{10:17},{1:6},{17:24}];
    
    % odd scans
    areaDTs_odd = [{areaDTs{1}(1:2:end)},{areaDTs{2}(1:2:end)},{areaDTs{3}(1:2:end)},{areaDTs{4}(1:2:end)},{areaDTs{5}(1:2:end)}];
    densDTs_odd = [{densDTs{1}(1:2:end)},{densDTs{2}(1:2:end)},{densDTs{3}(1:2:end)},{densDTs{4}(1:2:end)},{densDTs{5}(1:2:end)}];
    periDTs_odd = [{periDTs{1}(1:2:end)},{periDTs{2}(1:2:end)},{periDTs{3}(1:2:end)},{periDTs{4}(1:2:end)},{periDTs{5}(1:2:end)}];
    sizeDTs_odd = [{sizeDTs{1}(1:2:end)},{sizeDTs{2}(1:2:end)},{sizeDTs{3}(1:2:end)},{sizeDTs{4}(1:2:end)},{sizeDTs{5}(1:2:end)}];
    %even scans
    areaDTs_even = [{areaDTs{1}(2:2:end)},{areaDTs{2}(2:2:end)},{areaDTs{3}(2:2:end)},{areaDTs{4}(2:2:end)},{areaDTs{5}(2:2:end)}];
    densDTs_even = [{densDTs{1}(2:2:end)},{densDTs{2}(2:2:end)},{densDTs{3}(2:2:end)},{densDTs{4}(2:2:end)},{densDTs{5}(2:2:end)}];
    periDTs_even = [{periDTs{1}(2:2:end)},{periDTs{2}(2:2:end)},{periDTs{3}(2:2:end)},{periDTs{4}(2:2:end)},{periDTs{5}(2:2:end)}];
    sizeDTs_even = [{sizeDTs{1}(2:2:end)},{sizeDTs{2}(2:2:end)},{sizeDTs{3}(2:2:end)},{sizeDTs{4}(2:2:end)},{sizeDTs{5}(2:2:end)}];
    
    allScanDT = 1;
    VOLUME{1}.curDataType = allScanDT;
    scanListArea_odd = areaDTs_odd{subID};
    scanListSize_odd = sizeDTs_odd{subID};
    scanListPeri_odd = periDTs_odd{subID};
    scanListDens_odd = densDTs_odd{subID};
    
    scanListArea_even = areaDTs_even{subID};
    scanListSize_even = sizeDTs_even{subID};
    scanListPeri_even = periDTs_even{subID};
    scanListDens_even = densDTs_even{subID};
    
    DTcount = size(dataTYPES, 2);
    VOLUME{1} = averageTSeries(VOLUME{1}, scanListArea_odd, 'NumerosityAreaOdd');
    VOLUME{1} = averageTSeries(VOLUME{1}, scanListSize_odd, 'NumerositySizeOdd');
    VOLUME{1} = averageTSeries(VOLUME{1}, scanListPeri_odd, 'NumerosityPeriOdd');
    VOLUME{1} = averageTSeries(VOLUME{1}, scanListDens_odd, 'NumerosityDensOdd');
    
    VOLUME{1} = averageTSeries(VOLUME{1}, scanListArea_even, 'NumerosityAreaEven');
    VOLUME{1} = averageTSeries(VOLUME{1}, scanListSize_even, 'NumerositySizeEven');
    VOLUME{1} = averageTSeries(VOLUME{1}, scanListPeri_even, 'NumerosityPeriEven');
    VOLUME{1} = averageTSeries(VOLUME{1}, scanListDens_even, 'NumerosityDensEven');
    
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
    
    close(1); mrvCleanWorkspace;
end

%% CueRunModelsScriptMono - odd/even scans

dts = [{27:34},{27:34},{34:41},{27:34},{34:41}]; %Area, Size, Peri, Dens
maxCores = 8;
cd('/mnt/data/CueStimuliScriptsParams')
load('CueModelParamsLinear.mat');

load('/mnt/data/cueRunModelsParams.mat');

for whichSubs=1:5
    
    cd(paths{whichSubs})
    mrVista 3;
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.Number(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-Number-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 20, 20,1);

    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.ItemArea(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-ItemArea-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 1.32, 1.32);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.TotalArea(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-TotalArea-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 1.32, 1.32);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.TotalCirc(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-TotalCirc-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 10.6, 10.6);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.HullLength(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-HullLength-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 4.4, 4.4);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.HullArea(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-HullArea-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 1.45, 1.45);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.LuminanceDensity(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-LuminanceDensity-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 1, 1);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.HullRMS(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-HullRMS-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 0.5, 0.5);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.DisplayRMS(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-DisplayRMS-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 0.5, 0.5);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.NumberDensity(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-NumberDensity-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 5.7, 5.7);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.SFamplitude(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-SFamplitude-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 5, 5);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.SFspread(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-SFspread-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 5, 5);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.SFauc(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-SFauc-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 2.5, 2.5);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.ItemRadius(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-ItemRadius-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 1.15, 1.15);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.EdgeDensity(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-EdgeDensity-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 0.53, 0.53);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.SumLum(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-SumLuminance-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 79.4830, 79.4830, 3.2999);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.SumEdges(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-SumEdges-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 63.1685, 63.1685, 3.1484);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.SumLumNorm(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-SumLuminanceNorm-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 79.4830, 79.4830, 12.3233);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.SumEdgesNorm(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-SumEdgesNorm-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 65.7382, 65.7382, 12.9157);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.SFauc_new(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-AggFourierPower-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 2.6, 2.6,1);

    close all; mrvCleanWorkspace;
end

%% CueRunModelsScriptMonoLog - odd/even scans

dts = [{27:34},{27:34},{34:41},{27:34},{34:41}]; %Area, Size, Peri, Dens
maxCores = 8;
cd('/mnt/data/CueStimuliScriptsParams')
load('CueModelParamsLog.mat');

load('/mnt/data/cueRunModelsParams.mat');

for whichSubs=1:5
    
    cd(paths{whichSubs})
    mrVista 3;
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLog, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.Number(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logNumber-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 2.9957, 2.9957, 0);

    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLog, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.ItemArea(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logItemArea-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 0.275, 0.275, -5.75);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLog, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.TotalArea(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logTotalArea-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 0.275, 0.275, -4.3125);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLog, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.TotalCirc(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logTotalCirc-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 2.36, 2.36, -0.661);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLog, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.HullLength(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logHullLength-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 1.48, 1.48, -0.661);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLog, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.HullArea(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logHullArea-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 0.38, 0.38, -3.86);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLog, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.LuminanceDensity(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logLuminanceDensity-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 0, 0, -3.02);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLog, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.HullRMS(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logHullRMS-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 0, 0, -1.55);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLog, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.DisplayRMS(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logDisplayRMS-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, -0.73, -0.73, -2.461);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLog, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.NumberDensity(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logNumberDensity-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 1.731, 1.731, -2.578);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLog, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.SFamplitude(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logSFamplitude-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 1.55, 1.55, 0.93);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLog, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.SFspread(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logSFspread-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 1.6, 1.6, -1.25);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLog, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.SFauc(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logSFauc-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 0.88, 0.88, -0.962);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLog, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.ItemRadius(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logItemRadius-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 0.1375, 0.1375, -2.85);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLog, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.EdgeDensity(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logEdgeDensity-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, -0.65, -0.65, -3.11);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLog, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.SumLum(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logSumLuminance-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 13.5859, 13.5859, 10.4042);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLog, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.SumEdges(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logSumEdges-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 13.3561, 13.3561, 10.3572);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLog, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.SumLumNorm(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logSumLuminanceNorm-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 13.5859, 13.5859, 11.7218);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLog, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.SumEdgesNorm(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logSumEdgesNorm-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 13.3960, 13.3960, 11.7688);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLog, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.SFauc_new(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logAggFourierPower-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 2.0, 2.0, 0);

    close all; mrvCleanWorkspace;
end
