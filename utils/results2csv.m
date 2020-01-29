function results2csv( results, opts )

% function results2csv( results, opts )
% converts results structure to csv file for LOCATA submission.
%
% Inputs:
%     results:           Structure containing the following fields:
%     results.struct:    Results structure (see GCC_PHAT_online.m how to generate this)
%     results.save_dir:  Path to folder where csv files will be saved
%
% Outputs: N/A (saves results.struct to files results results.save_dir)
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

%% Write elapsed time to file

fid = fopen([results.save_dir, filesep, 'telapsed.txt'], 'w');
fprintf(fid, '%f', results.struct.telapsed);
fclose(fid);

%% Loop through sources results results

for src_idx = 1 : length(results.struct.source)
    if ~isempty(setxor(fieldnames(results.struct.source(src_idx)), opts.valid_results))
        disp('Unexpected field(s):')
        disp(setxor(fieldnames(results.struct.source(src_idx)), opts.valid_results))
        error('Invalid field in source results');
    end

    this_array = results2tablestruct( results.struct.source(src_idx) );

    % Write to Table and rename headers
    this_table = struct2table(this_array);
    writetable(this_table, [results.save_dir, filesep, 'source_', num2str(src_idx)], 'Delimiter', '\t');

    clear this_array this_table
end

end

function this_struct = results2tablestruct( in )

fields = fieldnames(in);
for f_idx =1 : length(fields)
    if ~strcmp(fields{f_idx} , 'time') && ~isempty(in.(fields{f_idx}))
        this_struct.(fields{f_idx}) = in.(fields{f_idx})';
    else
        this_struct.year = in.time(1,:)';
        this_struct.month = in.time(2,:)';
        this_struct.day = in.time(3,:)';
        this_struct.hour = in.time(4,:)';
        this_struct.minute = in.time(5,:)';
        this_struct.second = in.time(6,:)';
    end
end

end
