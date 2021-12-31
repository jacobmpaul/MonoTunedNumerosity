%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% monotonicNumerosity_crossvalidationOddEven_Dakin - odd/even scans %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dts = [{27:34},{27:34},{34:41},{27:34},{34:41}]; %Area, Size, Peri, Dens
maxCores = 8;
cd('/mnt/data/CueStimuliScriptsParams')
load('CueModelParamsLinear.mat');

load('/mnt/data/cueRunModelsParams.mat');

for whichSubs=3:5
    
    cd(paths{whichSubs})
    mrVista 3;
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.HighSFResp(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-HighSFResp-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 5.4558, 5.4558,.0852);
    
    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLin, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.RespRatio(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-RespRatio-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 2.661, 2.661,1.0956);
    
    close all; mrvCleanWorkspace;
end


%To generate a prediction
for n=1:4
    setAllRetParams(paramsNumerosityMonotonicLog, dts(n));
    dataTYPES(dts(n)).retinotopyModelParams.paramsFile=groupParams.SFauc_new(n).paramsFile;
end
saveSession;
VOLUME{1}= rmClearSettings(VOLUME{1});
rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'VFMafni_bothV1',9, [], [], sprintf('eachCondition-AggFourierPower-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 2.6, 2.6,1);


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
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.HighSFResp(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logHighSFResp-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 2.0379, 2.0379, .7082);

    for n=1:8
        setAllRetParams(paramsNumerosityMonotonicLog, dts{whichSubs}(n));
        dataTYPES(dts{whichSubs}(n)).retinotopyModelParams.paramsFile=groupParams.RespRatio(mod(n-1,4)+1).paramsFile;
    end
    saveSession;
    VOLUME{1}= rmClearSettings(VOLUME{1});
    rmRunCueScriptGeneralMonotonic(VOLUME{1},dts{whichSubs}, 'gray-Layer1',9, [], [], sprintf('eachCondition-logRespRatio-%s',datestr(now,'yyyymmdd-HHMMSS')), maxCores, 0, 2.149, 2.149, .8384);

    close all; mrvCleanWorkspace;
end


%% monotonic numerosity cross-validation (odd vs. even scans) - Area,Size,Peri,Dens conditions
paths{1}='/mnt/data/P01/mrVistaSession';
paths{2}='/mnt/data/P02/mrVistaSession';
paths{3}='/mnt/data/P03/mrVistaSession';
paths{4}='/mnt/data/P04/mrVistaSession';
paths{5}='/mnt/data/P05/mrVistaSession';

modelNames{1}=["logHighSFResp", "logRespRatio"];
modelNames{2}=["HighSFResp", "RespRatio"];
logLinNames=["Log","Linear"];

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
            %if ~isdir(fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(n)).name,'/',char(logLinNames(logLin)),'/GridFit_monotonic']))
                %eval(['!mkdir ',  '"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(n)).name]),'/',char(logLinNames(logLin)),'/GridFit_monotonic"']);
                %eval(['!mkdir ',  '"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(n)).name,'/',char(logLinNames(logLin)),'/GridFit_monotonic']), '/xval"']);
                files = dir([pwd '/Gray/' dataTYPES(allXvalDTs(n)).name,'/',char(logLinNames(logLin)), '/*.mat']);
                
                thisPath = [pwd,'/Gray/' dataTYPES(allXvalDTs(thisN(n))).name,'/',char(logLinNames(logLin))];
                otherPath = [pwd,'/Gray/' dataTYPES(allXvalDTs(otherN(n))).name,'/',char(logLinNames(logLin))];
                
                for whichFile = 1:length(files)
                    eval(['!cp ', '"', otherPath,'/',files(whichFile).name, '" "', thisPath, '/GridFit_monotonic\xval\xval-', files(whichFile).name, '"']);
                end
            %end
        end
    end
    
    %Determine fits of these models in cross-validated data
    wSearch = 9;
    %parpool(numel(allXvalDTs))
    %parfor whichDT = 1:length(allXvalDTs)
    for whichDT = 1:numel(allXvalDTs)
        for logLin = 1:2
            
            if logLin==1
                cd('/mnt/data/CueStimuliScriptsParams')
                load('CueModelParamsLog.mat');
                load('/mnt/data/cueRunModelsParams.mat');
                paramsNumerosityMonotonicXval=paramsNumerosityMonotonicLog;
                cd(paths{whichSubs(thisSub)})
            else
                cd('/mnt/data/CueStimuliScriptsParams')
                load('CueModelParamsLinear.mat');
                load('/mnt/data/cueRunModelsParams.mat');
                paramsNumerosityMonotonicXval=paramsNumerosityMonotonicLin;
                cd(paths{whichSubs(thisSub)})
            end
            
            folderName = [pwd '/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/',char(logLinNames(logLin)), '/GridFit_monotonic\xval'];
            modelFiles = dir([folderName '/*Resp*-gFit.mat']);
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
                eval(['!mv ','"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/' modelName.name]), '" "',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/',char(logLinNames(logLin)),'/GridFit_monotonic\xval/'  modelName.name]),'"']);
                eval(['!mv ','"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/',char(logLinNames(logLin)), '/GridFit_monotonic\xval/' modelName.name]), '" "',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/',char(logLinNames(logLin)),'/GridFit_monotonic\xval\xval-'  modelName.name]),'"']);
            end
        end
    end

    close(1); mrvCleanWorkspace;
end
