%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% tuned numerosity cross-validation (odd vs. even scans) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
        if ~isdir(fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(n)).name,'/SearchFit_tuned']))
            eval(['!mkdir ',  '"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(n)).name]), '/SearchFit_tuned"']);
            eval(['!mkdir ',  '"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(n)).name,'/SearchFit_tuned']), '/xval"']);
            files = dir([pwd '/Gray/' dataTYPES(allXvalDTs(3-n)).name, '/*Log-FullBlanks-DT0.5-Fineret*Fine-gFit.mat']);
            
            thisPath = [pwd,'/Gray/' dataTYPES(allXvalDTs(n)).name];
            otherPath = [pwd,'/Gray/' dataTYPES(allXvalDTs(3-n)).name];
            
            for whichFile = 1:length(files)
                eval(['!cp ', '"', fullfile(otherPath, files(whichFile).name), '" "', fullfile(thisPath, ['SearchFit_tuned/xval/xval-', files(whichFile).name]), '"']);
            end
        end
    end
    
    %Determine fits of these models in cross-validated data
    wSearch = 4;
    %parpool(length(allXvalDTs))
    %parfor whichDT = 1:length(allXvalDTs)
    for whichDT = 1:length(allXvalDTs)
        whichModel = 1;
        folderName = [pwd '/Gray/' dataTYPES(allXvalDTs(whichDT)).name, '/SearchFit_tuned/xval'];
        modelFiles = dir([folderName '/*-gFit.mat']);
        setAllRetParams(paramsNumerosity, allXvalDTs(whichDT))
        rmMainPostSearch([1 allXvalDTs(whichDT)],'gray-Layer1',wSearch, [folderName '/' modelFiles(whichModel).name]);
    end
    %delete(gcp('nocreate'))
    
    for whichDT = 1:length(allXvalDTs)
        %move and rename cross-validated model files
%         modelName = dir([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/*gFit-hrfFit.mat']);
%         eval(['!mv ','"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/' modelName.name]), '" "',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/SearchFit_tuned/xval/'  modelName.name]),'"']);
%         eval(['!mv ','"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/SearchFit_tuned/xval/' modelName.name]), '" "',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/SearchFit_tuned/xval/xval-'  modelName.name]),'"']);
         
        modelName = dir([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/*gFit-fFit.mat']);
        eval(['!mv ','"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/' modelName.name]), '" "',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/SearchFit_tuned/xval/'  modelName.name]),'"']);
        eval(['!mv ','"',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name '/SearchFit_tuned/xval/' modelName.name]), '" "',fullfile([pwd,'/Gray/' dataTYPES(allXvalDTs(whichDT)).name,'/SearchFit_tuned/xval/xval-'  modelName.name]),'"']);
    end
    
    close(1); mrvCleanWorkspace;
end
