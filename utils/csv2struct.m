function csv2struct(dir_name, opts)

% function csv2struct(dir_name, opts)
% onverts CSV files in directory to Matlab structure in LOCATA format
%
% Inputs:
%     dir_name:                           String containing directory name of csv files
%     opts:                               Structure of parameters
%       opts.columns_position_source:     Column index of source positions in csv file

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

%% Write to file

position_source = [];

% Only needed for position_source as this is what the participants estimate

fnames = dir([dir_name, filesep, 'position_source*.txt']);

for f_idx = 1 : length(fnames)
    this_table = readtable([dir_name filesep fnames(f_idx).name]);
    this_struct = table2struct(this_table);

    fields = fieldnames(this_struct);
    if ~isempty( setxor(fields, opts.columns_position_source))
        disp('Unexpected columns:')
        disp(setxor(fields, opts.columns_position_source))
        error('Unexpected columns in table')
    end

    % Source name from filename
    name_srt = regexp(fnames(f_idx).name, 'position_source_', 'end');
    name_end = regexp(fnames(f_idx).name, '.txt', 'start');
    src_name = fnames(f_idx).name((name_srt+1):(name_end-1));

    if f_idx == 1
        position_source.time = [this_struct.year; this_struct.month; this_struct.day; this_struct.hour; this_struct.minute; this_struct.second];
    else
        temp_time = [this_struct.year; this_struct.month; this_struct.day; this_struct.hour; this_struct.minute; this_struct.second];
        if any(temp_time ~= position_source.time)
            error('Time stamps for each source must be identical.')
        end
    end

    position_source.data.(src_name).position = [this_struct.x; this_struct.y; this_struct.z];
    position_source.data.(src_name).ref_vec = [this_struct.ref_vec_x; this_struct.ref_vec_y; this_struct.ref_vec_y];
end

save([dir_name, filesep, 'position_source1.mat'], 'position_source')

end
