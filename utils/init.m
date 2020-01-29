function opts = init()

%  opts = init()
% init  function for participants of the LOCATA challenge to set the
% parameters for the main function
%
% Inputs: N/A
%
% Outputs: struct opts with all settings and parameters for main.m
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

% Field names used throughout code:
opts.valid_arrays = {'dummy', 'eigenmike', 'benchmark2', 'dicit'};
opts.valid_sources = {'talker2', 'talker4', 'talker1', 'talker5', 'talker3', 'loudspeaker1', 'loudspeaker2', 'loudspeaker3', 'loudspeaker4'};
opts.valid_results = {'time', 'timestamps', 'broadside_angle', 'azimuth', 'elevation', 'range', 'x', 'y', 'z', 'ID'};
opts.fields_position_array = {'rotation', 'position', 'ref_vec', 'mic', 'valid_flags'};
opts.fields_position_source = {'rotation', 'position', 'ref_vec', 'valid_flags'};
opts.fields_audio_source = {'time', 'fs', 'data', 'NS'};
opts.fields_audio_array = {'time', 'fs', 'data'};
opts.fields_table = {'year', 'month', 'day', 'hour', 'minute', 'second'};
opts.columns_position_source = {'year', 'month', 'day','hour','minute','second','ref_vec_x','ref_vec_y','ref_vec_z','x','y','z'};

% Number of mics:
opts.dicit.M = 15;
opts.eigenmike.M = 32;
opts.benchmark2.M = 12;
opts.dummy.M = 4;

opts.c = 340;   %[m/s]
