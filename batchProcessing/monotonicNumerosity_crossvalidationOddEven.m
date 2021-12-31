%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% monotonicNumerosity_crossvalidationOddEven %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

% startup vo
% add vistaSoft to path

load('/mnt/data/allModelParamsMix.mat')

whichSubs=1:11;

for thisSub=1:length(whichSubs)    
    allXvalDTs=NumerosityDTs{whichSubs(thisSub)}(end-1:end); %NumerosityAllOdd & %NumerosityAllEven
    
    cd(paths{whichSubs(thisSub)})
    mrVista 3;
    
    %Copy to cross-validation folders
    for n = 1:length(allXvalDTs)
        if ~isdir(fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(n)).name,'/SearchFit_monotonic']))
            eval(['!mkdir ',  '"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(n)).name]), '/SearchFit_monotonic"']);
            eval(['!mkdir ',  '"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(n)).name,'/SearchFit_monotonic']), '/xval"']);
            files = dir([pwd '/Gray/' dataTYPES(allXvalDTs(mod(n,2)+1)).name, '/*Monotonic*gFit-gFit.mat']);
            
            thisPath = [pwd,'/Gray/' dataTYPES(allXvalDTs(n)).name];
            otherPath = [pwd,'/Gray/' dataTYPES(allXvalDTs(mod(n,2)+1)).name];
            
            for whichFile = 1:length(files)
                eval(['!cp ', '"', otherPath, files(whichFile).name, '" "', thisPath, 'SearchFit_monotonic/xval/xval-', files(whichFile).name, '"']);
            end
        end
    end
    
    %Determine fits of these models in cross-validated data
    wSearch = 9;
    %parpool(length(allXvalDTs))
    %parfor whichDT = 1:length(allXvalDTs)
    for whichDT = 1:length(allXvalDTs)
        whichModel = 1;
        folderName = [pwd '/Gray/' dataTYPES(allXvalDTs(whichDT)).name, '/SearchFit_monotonic/xval'];
        modelFiles = dir([folderName '/*-gFit.mat']);
        setAllRetParams(paramsNumerosity, allXvalDTs(whichDT))
        rmMainPostSearch([1 allXvalDTs(whichDT)],'gray-Layer1',wSearch, [folderName '/' modelFiles(whichModel).name]);
    end
    %delete(gcp('nocreate'))
    
    for whichDT = 1:length(allXvalDTs)
        %move and rename cross-validated model files
        if wSearch == 10
            modelName = dir([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/*gFit-gFit-gFit-gFit.mat']);
            eval(['!mv ','"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/' modelName.name]), '" "',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/SearchFit_monotonic/xval/'  modelName.name]),'"']);
            eval(['!mv ','"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/SearchFit_monotonic/xval/' modelName.name]), '" "',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/SearchFit_monotonic/xval/xval-'  modelName.name]),'"']);
            modelName = dir([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/*gFit-hrfFit.mat']);
            eval(['!mv ','"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/' modelName.name]), '" "',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/SearchFit_monotonic/xval/'  modelName.name]),'"']);
            eval(['!mv ','"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/SearchFit_monotonic/xval/' modelName.name]), '" "',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/SearchFit_monotonic/xval/xval-'  modelName.name]),'"']);
        end
        modelName = dir([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/*gFit-gFit-gFit.mat']);
        eval(['!mv ','"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/' modelName.name]), '" "',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/SearchFit_monotonic/xval/'  modelName.name]),'"']);
        eval(['!mv ','"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/SearchFit_monotonic/xval/' modelName.name]), '" "',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/SearchFit_monotonic/xval/xval-'  modelName.name]),'"']);
    end
    
    close(1); mrvCleanWorkspace;
end


%% monotonic numerosity cross-validation (odd vs. even scans) - Area,Size,Peri,Dens conditions
paths{1}='/mnt/data/P01/mrVistaSession';
paths{2}='/mnt/data/P02/mrVistaSession';
paths{3}='/mnt/data/P03/mrVistaSession';
paths{4}='/mnt/data/P04/mrVistaSession';
paths{5}='/mnt/data/P05/mrVistaSession';

modelNames{1}=["logItemArea", "logTotalArea", "logTotalCirc", "logHullLength", "logHullArea","logLuminanceDensity", "logHullRMS", "logDisplayRMS", "logNumber", "logNumberDensity", "logSFamplitude", "logSFspread", "logSFauc", "logItemRadius", "logEdgeDensity", "logSumLum", "logSumEdges", "logSumLumNorm", "logSumEdgesNorm", "logAggFourierPower"];
modelNames{2}=["ItemArea", "TotalArea", "TotalCirc", "HullLength", "HullArea","LuminanceDensity", "HullRMS", "DisplayRMS", "Number", "NumberDensity", "SFamplitude", "SFspread", "SFauc", "ItemRadius", "EdgeDensity", "SumLum", "SumEdges", "SumLumNorm", "SumEdgesNorm", "AggFourierPower"];
logLinNames=["Log","Linear"];

% startup vo
% add vistaSoft to path

whichSubs=1:5;
thisN=1:8;
otherN=[5:8,1:4];

for thisSub=1:length(whichSubs)
    
    if thisSub==3||thisSub==5
        DTsOdd=34:37;
        DTsEven=38:41;        
    else
        DTsOdd=27:30;
        DTsEven=31:34;
    end
    
    allXvalDTs=[DTsOdd,DTsEven]; %[Area,Size,Peri,Dens (odd)], [Area,Size,Peri,Dens (even)] 
    
    cd(paths{whichSubs(thisSub)})
    mrVista 3;
    
    %Copy to cross-validation folders
    for n = 1:numel(allXvalDTs)
        for logLin = 1:2
            if ~isdir(fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(n)).name,'/',char(logLinNames(logLin)),'/GridFit_monotonic']))
                eval(['!mkdir ',  '"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(n)).name]),'/',char(logLinNames(logLin)),'/GridFit_monotonic"']);
                eval(['!mkdir ',  '"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(n)).name,'/',char(logLinNames(logLin)),'/GridFit_monotonic']), '/xval"']);
                files = dir([pwd '/Gray/' dataTYPES(allXvalDTs(n)).name,'/',char(logLinNames(logLin)), '/*.mat']);
                
                thisPath = [pwd,'/Gray/' dataTYPES(allXvalDTs(thisN(n))).name,'/',char(logLinNames(logLin))];
                otherPath = [pwd,'/Gray/' dataTYPES(allXvalDTs(otherN(n))).name,'/',char(logLinNames(logLin))];
                
                for whichFile = 1:length(files)
                    eval(['!cp ', '"', otherPath,'/',files(whichFile).name, '" "', thisPath, '/GridFit_monotonic/xval/xval-', files(whichFile).name, '"']);
                end
            end
        end
    end
    
    %Determine fits of these models in cross-validated data
    wSearch = 9;
    %parpool(numel(allXvalDTs))
    %parfor whichDT = 1:length(allXvalDTs)
    for whichDT = 1:numel(allXvalDTs)
        for logLin = 1:2
            
            if logLin==1
                cd('/mnt/data/monotonic_numerosity/CueStimuliScriptsParams')
                load('CueModelParamsLog.mat');
                load('/mnt/data/cueRunModelsParams.mat');
                paramsNumerosityMonotonicXval=paramsNumerosityMonotonicLog;
                cd(paths{whichSubs(thisSub)})
            else
                cd('/mnt/data/monotonic_numerosity/CueStimuliScriptsParams')
                load('CueModelParamsLinear.mat');
                load('/mnt/data/cueRunModelsParams.mat');
                paramsNumerosityMonotonicXval=paramsNumerosityMonotonicLin;
                cd(paths{whichSubs(thisSub)})
            end
            
            folderName = [pwd '/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/',char(logLinNames(logLin)), '/GridFit_monotonic/xval'];
            modelFiles = dir([folderName '/*-gFit.mat']);
            modelNamesXval = sort(modelNames{2});
            
            for whichModel = 1:length(modelFiles)               
                setAllRetParams(paramsNumerosityMonotonicXval, allXvalDTs(whichDT));
                eval(['dataTYPES(allXvalDTs(whichDT)).retinotopyModelParams.paramsFile=groupParams.',(modelNamesXval{whichModel}),'(mod(whichDT-1,4)+1).paramsFile;']);
                rmMainPostSearch([1 allXvalDTs(whichDT)],'gray-Layer1',wSearch, [folderName '/' modelFiles(whichModel).name]);
            end
        end
    end
    %delete(gcp('nocreate'))
    
    for whichDT = 1:length(allXvalDTs)
        for logLin = 1:2
            for whichModel = 1:length(modelFiles)
                %move and rename cross-validated model files
                %         if wSearch == 10
                %             modelName = dir([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/*gFit-gFit-gFit-gFit.mat']);
                %             eval(['!mv ','"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/' modelName.name]), '" "',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/SearchFit_monotonic/xval/'  modelName.name]),'"']);
                %             eval(['!mv ','"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/SearchFit_monotonic/xval/' modelName.name]), '" "',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/SearchFit_monotonic/xval/xval-'  modelName.name]),'"']);
                %             modelName = dir([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/*gFit-hrfFit.mat']);
                %             eval(['!mv ','"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/' modelName.name]), '" "',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/SearchFit_monotonic/xval/'  modelName.name]),'"']);
                %             eval(['!mv ','"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/SearchFit_monotonic/xval/' modelName.name]), '" "',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/SearchFit_monotonic/xval/xval-'  modelName.name]),'"']);
                %         end
                modelName = dir([pwd,'/Gray/', dataTYPES(allXvalDTs(whichDT)).name, '/*-',char(modelNames{logLin}(whichModel)), '-*gFit-gFit.mat']);
                eval(['!mv ','"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/' modelName.name]), '" "',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/',char(logLinNames(logLin)),'/GridFit_monotonic/xval/'  modelName.name]),'"']);
                eval(['!mv ','"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/',char(logLinNames(logLin)), '/GridFit_monotonic/xval/' modelName.name]), '" "',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/',char(logLinNames(logLin)),'/GridFit_monotonic/xval/xval-'  modelName.name]),'"']);
            end
        end
    end

    close(1); mrvCleanWorkspace;
end
