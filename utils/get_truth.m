function truth = get_truth(array_name, position_array, position_source, required_time, is_dev)

% truth = get_truth(array_name, position_array, position_source, required_time, is_dev)     
% creates structure containing OptiTrac ground truth data for and relative to the specified array
%
% Inputs:
%   array_name:       String containing array name: 'eigenmike', 'dicit', 'benchmark2', 'dummy'
%   position_array:   Structure containing array position data
%   position_source:  Structure containing source position data
%   required_time:    Vector of timestamps at which ground truth is required
%   is_dev:           If 0, the evaluation database is considered and the 
%                     development database otherwise.
%
% Outputs:
%   truth:            Structure containing ground truth data
%                     Positional information about the sound sources are
%                     only returned for the development datbase 
%                     (is_dev = 1).
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

%% Specified array

truth.array = position_array.data.(array_name);
fields = fieldnames(truth.array);
for fidx = 1 : length(fields)
    truth.array.(fields{fidx}) = truth.array.(fields{fidx})(:,find(required_time.valid_flag),:);
end

%% Source

if is_dev
    Ns = sum(required_time.valid_flag);
    truth.source = position_source.data;
    
    %% All sources for this recording
    
    src_names = fieldnames(truth.source);
    for src_idx = 1 : length(src_names)
        fields = fieldnames(truth.source.(src_names{src_idx}));
        for fidx = 1 : length(fields)
            truth.source.(src_names{src_idx}).(fields{fidx}) = truth.source.(src_names{src_idx}).(fields{fidx})(:,find(required_time.valid_flag),:);
            
            truth.source.(src_names{src_idx}).azimuth = zeros(1,Ns);
            truth.source.(src_names{src_idx}).elevation = zeros(1,Ns);
            truth.source.(src_names{src_idx}).broadside_angle = zeros(1,Ns);
            
            % Azimuth and elevation relative to microphone array
            for t = 1 : Ns
                % Apply rotation / translation of array to source
                R = squeeze(truth.array.rotation(:,t,:));
                p = truth.array.position(:,t);
                h = truth.source.(src_names{src_idx}).position(:,t);
                v = R'*(h - p);
                
                % Spherical position
                % NOTE: azimuth = 0 deg is defined along the positive y-axis,
                %       elevation = 0 deg is defined along the positive z-axis
                [truth.source.(src_names{src_idx}).azimuth(t),truth.source.(src_names{src_idx}).elevation(t),~] = mycart2sph(v(1), v(2), v(3));
            end
        end
    end
end

end
