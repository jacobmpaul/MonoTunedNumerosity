%%%%%%%%%%%%%%%%%%%%%%%%
%% makeCueParamsFiles %%
%%%%%%%%%%%%%%%%%%%%%%%%

load('params_indices_TR2.1.mat')
params.dotOrder(params.dotOrder==20)=8; % Just in case linear numerosities are stored rather than indices
indices=params.dotOrder;

cd('/mnt/data/CueStimuliScriptsParams/Linear')
load params_NumbersArea.mat
imageFiles=["edges", "lum", "edges", "lum"];
norms=["", "", "Norm", "Norm"];
stimuli=["Area", "Size", "Circ", "Dense"];
stimuliOut=["Area", "Radius", "Circ", "Dense"];
outputNames=["SumEdges", "SumLum",  "SumEdgesNorm","SumLumNorm"];

cd('/mnt/data/CueStimuliScriptsParams/')

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
            params.dotOrder(n)=sum(sum(images(:,:,indices(n))))./10000;
        end
        params.dotOrder=log(params.dotOrder);
        mostLowLog=min(mostLowLog, min(params.dotOrder));
        mostHighLog=max(mostHighLog, max(params.dotOrder));
        blanksLog=[blank params.dotOrder(end)];
        save(['/mnt/data/CueStimuliScriptsParams/Log/params_', char(outputNames(imType)), char(stimuliOut(stim)), '.mat'], 'params');
        params.dotOrder=exp(params.dotOrder);
        mostLow=min(mostLow, min(params.dotOrder));
        mostHigh=max(mostHigh, max(params.dotOrder));
        blanks=[blank params.dotOrder(end)];
        save(['/mnt/data/CueStimuliScriptsParams/Linear/params_', char(outputNames(imType)), char(stimuliOut(stim)), '.mat'], 'params');
        figure; plot(params.dotOrder)
    end
    [char(imageFiles(imType)), char(norms(imType))]
    mostLow
    mostHigh
    blanks
    mostLowLog
    mostHighLog
    blanksLog
end

    
stimuli=["Area", "Radius", "Circ", "Dense"];
models=["Number", "DisplayRMS", "EdgeDensity", "HullArea", "HullLength", "HullRMS", "ItemArea", "ItemRadius", "LuminanceDensity", "NumberDensity", "SFamplitude", "SFauc", "SFspread", "TotalArea", "TotalCirc", "SumLum", "SumEdges", "SumLumNorm",  "SumEdgesNorm"];

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
