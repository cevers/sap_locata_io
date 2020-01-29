function varargout = load_data(dir_name, is_dev)

% function [audio_array, audio_source, position_array, position_source, required_time] = load_data(dir_name)
% loads LOCATA csv and wav data in Matlab
%
% Inputs:
%   dir_name:     Directory name containing LOCATA data (default: ../data/)
%
% Outputs:
%   audio_array:    Structure containing audio data recorded at each of the arrays
%   audio_source:   Structure containing clean speech data
%   position_array:   Structure containing positional information of each of the arrays
%   position_source:  Structure containing positional information of each source
%   required_time:    Structure containing the timestamps at which participants must provide estimates 
%
% Author: Christine Evers, c.evers@imperial.ac.uk
%
% Notice: This is part of the LOCATA evaluation release. Please report
%         problems and bugs to info@locata-challenge.org.
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

% Time vector:
txt_table = readtable([dir_name filesep 'required_time.txt']);
txt_struct = table2struct(txt_table);
required_time = struct2time(txt_struct);

% Audio files:
wav_fnames = dir([dir_name, filesep, '*.wav']);
audio_array_idx = ~cellfun(@isempty, regexp({wav_fnames.name}, 'audio_array'));
if is_dev
    audio_source_idx = ~cellfun(@isempty, regexp({wav_fnames.name}, 'audio_source'));
    if any(audio_array_idx+audio_source_idx==0)
        error(['Unexpected audio file in folder ', dir_name])
    end
else
    audio_source_idx = ~cellfun(@isempty, regexp({wav_fnames.name}, 'audio_source'));
    if any(audio_array_idx+audio_source_idx==0)
        error(['Unexpected audio file in folder ', dir_name])
    end
end

% Audio array data:
audio_array_idx = find(audio_array_idx);
audio_array = load_wav(wav_fnames, audio_array_idx, 'audio_array');

% Audio source data:
if is_dev
    audio_source_idx = find(audio_source_idx);
    audio_source = load_wav(wav_fnames, audio_source_idx, 'audio_source');
    audio_source.NS = numel(fieldnames(audio_source.data));
end

% Position source data:
txt_fnames = dir([dir_name, filesep, '*.txt']);
if is_dev
    position_source_idx = find(~cellfun(@isempty, regexp({txt_fnames.name}, 'position_source')));
    position_source = load_txt(txt_fnames, position_source_idx, 'position_source');
end

% Position array data:
position_array_idx = find(~cellfun(@isempty, regexp({txt_fnames.name}, 'position_array')));
position_array = load_txt(txt_fnames, position_array_idx, 'position_array');

% Outputs:
if is_dev
    varargout{1} = audio_array;
    varargout{2} = audio_source;
    varargout{3} = position_array;
    varargout{4} = position_source;
    varargout{5} = required_time;
else
    varargout{1} = audio_array;
    varargout{2} = position_array;
    varargout{3} = required_time;
end

end

function obj = load_wav(fnames, obj_idx, obj_type)
for idx = 1 : length(obj_idx)
    % Load data:
    [data,fs] = audioread([fnames(obj_idx(idx)).folder filesep fnames(obj_idx(idx)).name]);

    % Array name:
    regexp_srt = regexp( fnames(obj_idx(idx)).name, '_([a-z]*[0-9]?).wav');
    this_obj = fnames(obj_idx(idx)).name(regexp_srt+1:end-4);

    % Load timestamps:
    txt_table = readtable([fnames(obj_idx(idx)).folder filesep obj_type, '_timestamps_', this_obj, '.txt']);
    txt_struct = table2struct(txt_table);
    timestamps = struct2time(txt_struct);

    % Copy to struct:
    obj.fs = fs;
    obj.data.(this_obj) = data;
    obj.time = timestamps.time;
end
end

function obj = load_txt(fnames, obj_idx, obj_type)
for idx = 1 : length(obj_idx)
    % Load data:
    txt_table = readtable([fnames(obj_idx(idx)).folder filesep fnames(obj_idx(idx)).name]);
    txt_struct = table2struct(txt_table);
    txt_data = struct2position(txt_struct, obj_type);

    % Array name:
    regexp_srt = regexp( fnames(obj_idx(idx)).name, '_([a-z]*[0-9]?).txt');
    this_source = fnames(obj_idx(idx)).name(regexp_srt+1:end-4);

    % Copy to struct:
    obj.time = txt_data.time;
    obj.data.(this_source) = txt_data.data.(obj_type);
end
end
