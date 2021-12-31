function vw = rmRunNumbersScriptLogMonotonic(vw,dataTypes, roi,wSearch,models, hrfParams, matFileName, maxCores, separateBetas)
%VOLUME{1} = rmRunNumbersScriptLog(VOLUME{1},5:8, 'gray-Layer1',8);
if ~exist('vw','var') || isempty(vw)
    vw = getCurView;
end
if ~exist('roi','var')
    roi = [];
end
if ~exist('wSearch','var') || isempty(wSearch)
    wSearch = 9; % Grid fit only: make sure we turn of coarse to fine
end
if ~exist('models','var') || isempty(models)
    models = {'1g'};%,'dog'};
end

if ~exist('hrfParams','var') || isempty(hrfParams)
    hrfParams = {'two gammas (SPM style)', [5.4000 5.2000 10.8000 7.3500 0.3500]};
end

if ~exist('matFileName','var') || isempty(matFileName)
    if strcmp(models{1},'1g')
        matFileName = sprintf('retModel-%s-Monotonic-Log-FullBlanks-DT0.5',models{1}, datestr(now,'yyyymmdd-HHMMSS')); 
    elseif strcmp(models{1},'dog')
        matFileName = sprintf('retModel-%s-1DDoGaussian-Log-FullBlanks-DT0.5-Fine',models{1}, datestr(now,'yyyymmdd-HHMMSS'));
    end
end

if ~exist('maxCores','var') || isempty(maxCores)
    maxCores=5; % Grid fit only: make sure we turn of coarse to fine
end

if ~exist('separateBetas','var') || isempty(separateBetas)
    separateBetas=1;
end
    
% restrict roi to non NaN data or create one that covers all gray matter
%vw = roiRestrictToNonNan(vw);

 
% If you sample pRF size at 0.1
%'minrf',.25,'maxrf',14,'numbersigmas',139,...
% 0.2
%'minrf',.25,'maxrf',14,'numbersigmas',69,...

% If you sample pRF position at 0.1
% 'relativeGridStep',.4,...
% 'minrf',.25,...

%models = {'dog'}
ncores=length(dataTypes);
if ncores>maxCores
    ncores=maxCores;
end
if ncores>1
    parpool(ncores)
end
parfor dt=1:length(dataTypes)
    for n=1:numel(models)
        switch lower(models{n})
            case '1g'
                % actual call with modified parameters - 1D 1 Gaussian model
                
                tmpv=rmMain([1 dataTypes(dt)],roi,wSearch,...
                    'prf model',{'1dgaussian'},...
                    'coarsetofine',false,...
                    'coarseDecimate',0,... % alldata no blurring
                    'minFieldSize',0,...
                    'sampleRate',.03,... % samplerate to make stimulus on
                    'fieldsize',3,...
                    'relativeGridStep',.333,... % sample x at relativeGridStep*minRF
                    'minrf',.03,'maxrf',3,'numbersigmas',400,... % sample prfs at <0.1 (whatever the unit is)
                    'spacesigmas','linear',...
                    'hrffitthreshve', 0.2,...
                    'hrf', hrfParams,...
                    'matfilename',matFileName,...
                    'separate betas', separateBetas);
                
            case 'dog'
                % actual call with modified parameters - 1D DoG model
                %matFileName = sprintf('retModel-%s-1DDoGaussian-ZeroBlanks',datestr(now,'yyyymmdd-HHMMSS'));
                sigmaRatio  = [1.1:.2:3 5 10];
                sigmaRatioMaxVal = 14.*sigmaRatio(1);
                
                tmpv=rmMain([1 dataTypes(dt)],roi,wSearch,...
                    'prf model',{'1ddog'},...
                    'coarsetofine',false,...
                    'coarseDecimate',0,... % alldata no blurring
                    'minFieldSize',0,...
                    'sampleRate',0.03,... % samplerate to make stimulus on
                    'fieldsize',2,...
                    'relativeGridStep',.333,... % sample x at relativeGridStep*minRF
                    'minrf',.03,'maxrf',3,'numbersigmas',400,... % sample prfs at <0.1 (whatever the unit is)
                    'spacesigmas','linear',...
                    'hrffitthreshve', 0.2,...
                    'sigmaRatio',sigmaRatio,...
                    'sigmaRatioMaxVal',sigmaRatioMaxVal,...
                    'matfilename',matFileName);
        end
%             hrftmp=viewGet(tmpv, 'rmhrf')
%             hrfOut{dt}=hrftmp{2};
    end
end
delete(gcp('nocreate'))
return
