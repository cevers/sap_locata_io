function timestamps = elapsed_time( time )

% timestamps = elapsed_time( time )
% evaluate time delays between time stamps
%
% Inputs:
%   time:           6 x T matrix of date vectors, where each 6 x 1 vector
%                   is formatted as [Year Month Day Hour Minute Second]
%
% Outputs:
%   timestamps:     1 x T vector of time delays, evaluated using etime
%
% Author:
%   Christine Evers, c.evers@imperial.ac.uk
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

timestamps = zeros( 1, size(time,2) );
for t = 2 : size(time,2)
    timestamps(t) = etime(time(:,t)',time(:,t-1)');
end

timestamps = cumsum(timestamps);

end
