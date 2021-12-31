%%%%%%%%%%%%%%%%%%%%%%
%% afni_preproc_All %%
%%%%%%%%%%%%%%%%%%%%%%

% specifying directories & parameters for pre-processing (https://github.com/MvaOosterhuis/fMRI_preproc) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPORTANT!
% 1a. Open a terminal and move to the directory where .startAfniToolbox lives
% 1b. Run the . startAfniToolbox command in the command line
% 1c. From the SAME terminal, start MATLAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vistasoftpath = '/mnt/data/afni/AFNI_preproc_current/vistasoft_preproc';
rmdpath = '/mnt/data/afni/AFNI_preproc_current/rmDevel';
AFNIpath = '/mnt/data/afni/AFNI_preproc_current/AFNI-stuff/';
r2apath = '/mnt/data/afni/AFNI_preproc_current/r2agui' ;
% 2a. Add afni_matlab toolbox (comes with AFNI) to path
% 2b. Add r2agui to the path
% 3a. Add mrVista to the path
% 3b. Add rmDevelop to the path.
% Change the definitions below:
addpath(genpath(AFNIpath));
addpath(genpath(r2apath));
addpath(genpath(vistasoftpath));
addpath(genpath(rmdpath));
% 4. Add the location of the fMRI_preproc & mrVistaPrepare functions
% to the path
addpath('/mnt/data/afni/AFNI_preproc_current/')
addpath('/mnt/data/afni/AFNI_preproc_current/scripts')

% 5. Start with ONE directory in which your PROJECT lives
% within this directory have ONE directory PER PARTICIPANT
% Within this directory have ONE directory PER SESSION
% within ONE SESSION directory make sure the following things reside:
% All the RAW PAR/REC files from the scanner
% High Resolution anatomical scan (+segmentation)
% params.ProjectDirectory = '/mnt/data/three_pass_try'; % Where your project is located
% % For both Participant and Session, numbers are associated to the
% % ALPHABETICALLY SORTED list of directories inside the project directory.
% params.ParticipantNumber; % Can be a vector of numbers as well, if set to [], will run ALL participants
% params.SessionNumber; % Can be a vector of numbers as well, if set to [], will run ALL sessions
% params.myTR;
% params.nTRs; % Total amount of TRs
% params.nPrescanTRs; % Number of Prescan TRs
% % params.realTRs = nTRsWithoutPrescan + nPrescanTRs;
% params.nTRsWithoutPrescan = nTRs - nPrescanTRs; % Number of TRs EXLCUDING the PrescanTRs

% Different procedures;
proc2do = 'all'; % Does the whole preprocessing (see fMRI_preproc for the specifics)
% proc2do = 'slice_and_reapply'; % Uses already processed data, slice times the original niftis, and applies the transformations from the previous preprocessing routine
% proc2do = 'reapply';

% 6. Call fMRI_preproc
% fMRI_preproc(Inputdir, participantNumber, sessionNumber, proc2do, numPass, skullStrip, skullStrippedAnatomy, topUp, sliceTiming, myTR, realTRs)
% RT = TR = Repetition Time in Seconds

% Visual field mapping pre-processing
ProjectDirectory = '/mnt/data/afni/vfm'; 
fMRI_preproc(ProjectDirectory, 1, 1, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Visual field mapping
fMRI_preproc(ProjectDirectory, 2, 1, proc2do, 4, 1,0, 0, 0, 0, 2.1, 182); % Visual field mapping
fMRI_preproc(ProjectDirectory, 3, 1, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Visual field mapping
fMRI_preproc(ProjectDirectory, 4, 1, proc2do, 4, 1,0, 0, 0, 0, 2.1, 182); % Visual field mapping
fMRI_preproc(ProjectDirectory, 5, 1, proc2do, 4, 1,0, 0, 0, 0, 2.1, 182); % Visual field mapping
fMRI_preproc(ProjectDirectory, 6, 1, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Visual field mapping
fMRI_preproc(ProjectDirectory, 7, 1, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Visual field mapping
fMRI_preproc(ProjectDirectory, 8, 1, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Visual field mapping
fMRI_preproc(ProjectDirectory, 9, 1, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Visual field mapping
fMRI_preproc(ProjectDirectory, 10, 1, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Visual field mapping
fMRI_preproc(ProjectDirectory, 11, 1, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Visual field mapping


% Numerosity pre-processing
ProjectDirectory = '/mnt/data/afni/numerosity'; 
fMRI_preproc(ProjectDirectory, 1, 1, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Constant Area
fMRI_preproc(ProjectDirectory, 1, 2, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Constant Item Size
fMRI_preproc(ProjectDirectory, 1, 3, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Constant Perimeter
fMRI_preproc(ProjectDirectory, 1, 4, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % High Density

fMRI_preproc(ProjectDirectory, 2, 1, proc2do, 4, 1,0, 0, 0, 0, 2.1, 182); % Constant Area
fMRI_preproc(ProjectDirectory, 2, 2, proc2do, 4, 1,0, 0, 0, 0, 2.1, 182); % Constant Item Size
fMRI_preproc(ProjectDirectory, 2, 3, proc2do, 4, 1,0, 0, 0, 0, 2.1, 182); % Constant Perimeter
fMRI_preproc(ProjectDirectory, 2, 4, proc2do, 4, 1,0, 0, 0, 0, 2.1, 182); % High Density

fMRI_preproc(ProjectDirectory, 3, 1, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Constant Area
fMRI_preproc(ProjectDirectory, 3, 2, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Constant Item Size
fMRI_preproc(ProjectDirectory, 3, 3, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Constant Perimeter
fMRI_preproc(ProjectDirectory, 3, 4, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % High Density

fMRI_preproc(ProjectDirectory, 4, 1, proc2do, 4, 1,0, 0, 0, 0, 2.1, 182); % Constant Area
fMRI_preproc(ProjectDirectory, 4, 2, proc2do, 4, 1,0, 0, 0, 0, 2.1, 182); % Constant Item Size
fMRI_preproc(ProjectDirectory, 4, 3, proc2do, 4, 1,0, 0, 0, 0, 2.1, 182); % Constant Perimeter
fMRI_preproc(ProjectDirectory, 4, 4, proc2do, 4, 1,0, 0, 0, 0, 2.1, 182); % High Density

fMRI_preproc(ProjectDirectory, 5, 1, proc2do, 4, 1,0, 0, 0, 0, 2.1, 182); % Constant Area
fMRI_preproc(ProjectDirectory, 5, 2, proc2do, 4, 1,0, 0, 0, 0, 2.1, 182); % Constant Item Size
fMRI_preproc(ProjectDirectory, 5, 3, proc2do, 4, 1,0, 0, 0, 0, 2.1, 182); % Constant Perimeter
fMRI_preproc(ProjectDirectory, 5, 4, proc2do, 4, 1,0, 0, 0, 0, 2.1, 182); % High Density

fMRI_preproc(ProjectDirectory, 6, 1, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Constant Area
fMRI_preproc(ProjectDirectory, 6, 2, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Constant Item Size

fMRI_preproc(ProjectDirectory, 7, 1, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Constant Area
fMRI_preproc(ProjectDirectory, 7, 2, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Constant Item Size

fMRI_preproc(ProjectDirectory, 8, 1, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Constant Area
fMRI_preproc(ProjectDirectory, 8, 2, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Constant Item Size

fMRI_preproc(ProjectDirectory, 9, 1, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Constant Area
fMRI_preproc(ProjectDirectory, 9, 2, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Constant Item Size

fMRI_preproc(ProjectDirectory, 10, 1, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Constant Area
fMRI_preproc(ProjectDirectory, 10, 2, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Constant Item Size

fMRI_preproc(ProjectDirectory, 11, 1, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Constant Area
fMRI_preproc(ProjectDirectory, 11, 2, proc2do, 4, 1,0, 0, 1, 0, 2.1, 182); % Constant Item Size

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check the alignments visually!!
% See preproc_check 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 7. Import to mrVista to run models
% afni2mrVista_runModels
