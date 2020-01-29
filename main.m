function main(data_dir, results_dir, is_dev, arrays, tasks)

% function main_eval(data_dir, results_dir, arrays, tasks)
% main function for participants of the LOCATA Challenge to load each recording 
% for specific tasks and arrays to run their algorithm for the Eval or Dev database.
%
% Inputs:
%   data_dir:   String with directory path for the LOCATA Dev or Eval database 
%   save_dir:   String with directory path in which to save the results of this
%               function
%   is_dev:     Kind of database specified by data_dir 
%               0: Eval database
%               1: Dev database
%   arrays:     Cell array with array names which should be evaluated (optional)
%               Cell array {'benchmark2', 'eigenmike', 'dicit','dummy'} is taken
%               as default which contains all available arrays
%   tasks:      Vector with task(s) (optional)
%               Vector [1,2,3,4,5,6] is taken as default which evaluates 
%               over all available tasks
%
% Outputs: N/A (saves results as csv files in save_dir)
%
% Authors: Christine Evers, c.evers@imperial.ac.uk
%          Heiner Loellmann, Loellmann@LNT.de
%
% Reference: LOCATA documentation for participants (v3)
%            www.locata-challenge.org
%
% Notice: This programm is part of the LOCATA evaluation release. 
%         Please report problems and bugs to info@locata-challenge.org.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THE WORK (AS DEFINED BELOW) IS PROVIDED UNDER THE TERMS OF OPEN DATA
% COMMONS ATTRIBUTION LICENSE (ODC-BY) v1.0, WHICH CAN BE FOUND AT
% http://opendatacommons.org/licenses/by/1.0/.
% THE WORK IS PROTECTED BY COPYRIGHT AND/OR OTHER APPLICABLE LAW. ANY USE
% OF THE WORK OTHER THAN AS AUTHORIZED UNDER THIS LICENSE OR COPYRIGHT LAW
% IS PROHIBITED.
%
% BY EXERCISING ANY RIGHTS TO THE WORK PROVIDED HERE, YOU ACCEPT AND AGREE
% TO BE BOUND BY THE TERMS OF THIS LICENSE. TO THE EXTENT THIS LICENSE MAY
% BE CONSIDERED TO BE A CONTRACT, THE LICENSOR GRANTS YOU THE RIGHTS
% CONTAINED HERE IN CONSIDERATION OF YOUR ACCEPTANCE OF SUCH TERMS AND
% CONDITIONS.
%
% -------------------------------------------------------------------------
%
% Representations, Warranties and Disclaimer
%
% UNLESS OTHERWISE MUTUALLY AGREED TO BY THE PARTIES IN WRITING, LICENSOR
% OFFERS THE WORK AS-IS AND MAKES NO REPRESENTATIONS OR WARRANTIES OF ANY
% KIND CONCERNING THE WORK, EXPRESS, IMPLIED, STATUTORY OR OTHERWISE,
% INCLUDING, WITHOUT LIMITATION, WARRANTIES OF TITLE, MERCHANTIBILITY,
% FITNESS FOR A PARTICULAR PURPOSE, NONINFRINGEMENT, OR THE ABSENCE OF
% LATENT OR OTHER DEFECTS, ACCURACY, OR THE PRESENCE OF ABSENCE OF ERRORS,
% WHETHER OR NOT DISCOVERABLE. SOME JURISDICTIONS DO NOT ALLOW THE
% EXCLUSION OF IMPLIED WARRANTIES, SO SUCH EXCLUSION MAY NOT APPLY TO YOU.
%
% Limitation on Liability.
%
% EXCEPT TO THE EXTENT REQUIRED BY APPLICABLE LAW, IN NO EVENT WILL
% LICENSOR BE LIABLE TO YOU ON ANY LEGAL THEORY FOR ANY SPECIAL,
% INCIDENTAL, CONSEQUENTIAL, PUNITIVE OR EXEMPLARY DAMAGES ARISING OUT OF
% THIS LICENSE OR THE USE OF THE WORK, EVEN IF LICENSOR HAS BEEN ADVISED
% OF THE POSSIBILITY OF SUCH DAMAGES.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add matlab directory and sub-folders to path:
addpath(genpath('./'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% To be adjusted by the participants: 

% Selection of the localisation algorithm
%
% Enter the name of the MATLAB function of your localization algorithm.
% The LOCATA organizers provided MUSIC here as an example for the required interface. 
% Check the documentation inside for contents of structures.
my_alg_name = 'MUSIC';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize settings required for these scripts:
opts = init();

%% Check and process input arguments

% Create directories if they do not exist already
if ~exist(results_dir, 'dir')
    mkdir(results_dir)
    warning('Directory for results not found. New directory created.')
end

if ~exist(data_dir,'dir')
    error('Incorrect data path!')
end

if ~exist(my_alg_name,'file')
    error('Function specified by my_alg_name not found!')
end

if nargin<3 || ~exist('is_dev', 'var')
    error('Not enough input arguments.')
end

if ~exist('tasks','var')
    % Read all task IDs inside of data folder
    finpath = dir(data_dir);
    tasks = nan( length(finpath),1);
    for f_idx = 1 : length(finpath)
        if finpath(f_idx).isdir
            srt_idx = regexp(finpath(f_idx).name, 'task', 'end');
            tasks(f_idx) = str2double(finpath(f_idx).name((srt_idx+1):end));
        end
    end
    tasks = unique(tasks(~isnan(tasks)));
else
    % check if input contains valid tasks
   tasks = unique(intersect( 1:6, tasks));
   if isempty(tasks)
      error('Invalid input for task number(s)') 
   end
end

if ~exist('arrays','var')
    arrays = opts.valid_arrays; % evaluate over all arrays
else
    % check if input contains valid arrays names
    arrays = unique(intersect(arrays, opts.valid_arrays));
    if isempty(arrays)
        error('Incorrect input for arrays! Should be a cell array with the name(s) of the considered array(s).')
    end
end
fprintf('Available tasks in the dev dataset in %s: %s\n\n', data_dir, mat2str(tasks));

%% Process
%
% Evaluation of the localization algorithm (e.g., MUSIC)
% for each recording of the specified tasks and arrays

% Parse through all specified task folders
for task_idx = 1:length(tasks)
    this_task = tasks(task_idx);
    task_dir = [data_dir, filesep, 'task', num2str(this_task)];
    finpath = dir(task_dir);

    % Create directory for this task in results directory:
    results_task_dir = [results_dir filesep 'task', num2str(this_task)];
    if ~exist(results_task_dir, 'dir')
        mkdir(results_task_dir)
    end

    % Read all recording IDs available for this task:
    recordings = nan( length(finpath),1);
    for f_idx = 1 : length(finpath)
        if finpath(f_idx).isdir
            srt_idx = regexp(finpath(f_idx).name, 'recording', 'end');
            recordings(f_idx) = str2double(finpath(f_idx).name((srt_idx+1):end));
        end
    end
    recordings=unique(recordings(~isnan(recordings)));

    % Parse through all recordings within this task:
    for rec_idx = 1:length(recordings)
        this_recording = recordings(rec_idx);
        rec_dir = [task_dir, filesep, 'recording', num2str(this_recording)];
        finpath = dir(rec_dir);

        % Create directory for this recording in results directory:
        if ~exist([results_task_dir, filesep, 'recording', num2str(this_recording)], 'dir')
            mkdir([results_task_dir, filesep, 'recording', num2str(this_recording)])
        end

        % Read all recording IDs available for this task:
        array_names = {};
        for f_idx = 1 : length(finpath)
            if finpath(f_idx).isdir
                array_names{end+1} = finpath(f_idx).name;
            end
        end

        % array_names = unique(intersect(array_names, opts.valid_arrays));
        array_names = unique(intersect(array_names, arrays));
        
        for arr_idx = 1 : length(array_names)
            this_array = array_names{arr_idx};
            array_dir = [rec_dir filesep array_names{arr_idx}];

            fprintf('Processing task %d, recording %d, array %s...\n', this_task, this_recording, this_array);

            %% Load data

            % Load data from csv / wav files in database:
            fprintf('Loading data for task %d, recording %d... ', this_task, this_recording)
            if is_dev
                [audio_array, audio_source, position_array, position_source, required_time] = load_data(array_dir, is_dev);
            else
                [audio_array, position_array, required_time] = load_data(array_dir, is_dev);
            end
            fprintf('Complete!\n\n')

            % Create directory for this array in results directory:
            this_save_dir = [results_task_dir, filesep, 'recording', num2str(this_recording), filesep, this_array, filesep];
            if ~exist(this_save_dir, 'dir')
                mkdir(this_save_dir)
            end

            %% Load signal

            % Get number of mics and mic array geometry:
            in_localization.numMics = size(position_array.data.(this_array).mic,3);

            % Signal and sampling frequency:
            in_localization.y = audio_array.data.(this_array)';      % signal
            in_localization.fs = audio_array.fs;                     % sampling freq

            %% Users must provide estimates for each time stamp in in.timestamps

            % Time stamps required for evaluation
            in_localization.timestamps = elapsed_time(required_time.time);
            in_localization.timestamps = in_localization.timestamps(find(required_time.valid_flag));
            in_localization.time = required_time.time(:,find(required_time.valid_flag));

            %% Extract ground truth
            %
            % position_array stores all optitrack measurements.
            % Extract valid measurements only (specified by required_time.valid_flag).

            if is_dev
                truth = get_truth(this_array, position_array, position_source, required_time, is_dev);
            else
                truth = get_truth(this_array, position_array, [], required_time, is_dev);
            end

            %% Separate ground truth into positions of arrays (used for localization) and source position (used fo metrics)

            in_localization.array = truth.array;
            in_localization.array_name = this_array;
            in_localization.mic_geom = truth.array.mic;

            fprintf('...Running localization using %s... ', my_alg_name)
            tic;
            results = feval( my_alg_name, in_localization, opts);
            results.telapsed = toc;
            fprintf('Complete!\n')

            %% Check results structure is provided in correct format

            check_results(results, in_localization, opts);

            %% Plots & Save results to file

            fprintf('...Saving results to file... ')

            % Directory to save figures to:
            in_plots = in_localization;
            in_plots.results_dir = [this_save_dir, filesep, my_alg_name];
            if ~exist(in_plots.results_dir, 'dir')
                mkdir(in_plots.results_dir)
            end
            in_plots.plot_title = ['Task ', num2str(tasks(task_idx)), ', recording ', num2str(recordings(rec_idx)), ', array: ', this_array];
            plot_results( in_plots, results, opts, truth, is_dev);

            in_save.struct = results;
            in_save.save_dir = in_plots.results_dir;
            results2csv(in_save, opts);

            fprintf('Complete!\n\n')
        end
    end
end
disp('Processing finished!')

end
