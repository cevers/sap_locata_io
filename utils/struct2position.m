function out = struct2position(in, array_name)

% function out = struct2position(in, array_name)
% converts a structure obtained using table2struct into LOCATA format required for position_array / position_source
%
% Inputs:
%   in:           Structure obtained using table2struct
%   array_name:   String of array name ('benchmark2', 'dicit', 'dummy', 'eigenmike')
%
% Outputs:
%   out:          Structure in LOCATA format
%
% Author: Christine Evers, c.evers@imperial.ac.uk
%
% Notice: This is a part of the LOCATA evaluation release. Please report
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

Ns = size([in.year],1);
fields = fieldnames(in);
for f_idx = 1 : length(fields)
    if size([in.(fields{f_idx})],1) ~= Ns || size([in.(fields{f_idx})],1) ~= 1
        error(['Each field in input struct must be a vector of size [', num2str(Ns), ',1].']);
    end
end

% Read time vector:
out = struct2time(in);

% Read data:
out.data = [];
out.data = struct(array_name,[]);
out.data.(array_name).position(1,:) = [in.x]';
out.data.(array_name).position(2,:) = [in.y]';
out.data.(array_name).position(3,:) = [in.z]';
out.data.(array_name).ref_vec(1,:) = [in.ref_vec_x]';
out.data.(array_name).ref_vec(2,:) = [in.ref_vec_y]';
out.data.(array_name).ref_vec(3,:) = [in.ref_vec_z]';
out.data.(array_name).rotation(1,:,1) = [in.rotation_11]';
out.data.(array_name).rotation(1,:,2) = [in.rotation_12]';
out.data.(array_name).rotation(1,:,3) = [in.rotation_13]';
out.data.(array_name).rotation(2,:,1) = [in.rotation_21]';
out.data.(array_name).rotation(2,:,2) = [in.rotation_22]';
out.data.(array_name).rotation(2,:,3) = [in.rotation_23]';
out.data.(array_name).rotation(3,:,1) = [in.rotation_31]';
out.data.(array_name).rotation(3,:,2) = [in.rotation_32]';
out.data.(array_name).rotation(3,:,3) = [in.rotation_33]';

% Microphone positions:
mic_idx = find(~cellfun(@isempty, regexp(fields, 'mic')));
num_mics = length(mic_idx)/3;
for mic = 1 : num_mics
    this_mic_idx = find(~cellfun(@isempty, regexp(fields, ['mic', num2str(mic), '_'])));
    if length(this_mic_idx) > 3
        error('Microphone must be specified by x,y,z position only.');
    end
    out.data.(array_name).mic(1,:,mic) = [in.(['mic', num2str(mic), '_x'])]';
    out.data.(array_name).mic(2,:,mic) = [in.(['mic', num2str(mic), '_y'])]';
    out.data.(array_name).mic(3,:,mic) = [in.(['mic', num2str(mic), '_z'])]';
end

end
