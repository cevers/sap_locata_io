function [y, t, f] = stft(x, w, num_inc, num_FFT, fs)

% function [y, t, f] = stft(x, w, num_inc, num_FFT, fs)
% performs a Short-Time Fourier Transform (STFT)
%
% Inputs
%   x:       num_samples x num_channels signal matrix
%   w:       Window of length win_length
%   fs:      Sample rate of input signal
%   num_inc: Frame increment in samples
%
% Outputs
%   y:       num_freq x num_channels x num_frames STFT matrix
%   t:       num_frames x 1 vector of centre times for each frame
%   f:       num_freq x 1 vector of frequencies corresponding to each bin
%
% Author: Christine Evers, c.evers@imperial.ac.uk
% Modified: Heiner Loellmann, loellmann@lnt.de
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

%% Initialisation

[num_samples, num_channels] = size(x);
win_length = length(w);

if 2^nextpow2(num_FFT)~=num_FFT
    num_FFT = 2^nextpow2(num_FFT);
end

%% Zero padding

% Zero-pad signal:
pre_pad_len = win_length - num_inc;
post_pad_len = num_inc - mod(num_samples, num_inc) + pre_pad_len;
x = [zeros(pre_pad_len,num_channels); x; zeros(post_pad_len,num_channels)];

% Enframe signal
frame_srt_idx = 1:num_inc:size(x,1) - (win_length-1);
num_frames = length(frame_srt_idx);
frame_idx = bsxfun(@plus, frame_srt_idx, (0:win_length-1)');

%% Apply window

% Reshape data matrix to win_length x num_channels x num_frames
y = reshape(x(frame_idx,:), [win_length, num_frames, num_channels]);
clear x
y = permute(y,[1,3,2]);

% Apply window
y = y .* repmat(w(:), [1, num_channels, num_frames]);

%% FFT

if num_FFT > win_length
    fft_pad = num_FFT-win_length;
    fft_pre_pad = round(fft_pad/2);
    fft_post_pad = fft_pad-fft_pre_pad;

    y = [zeros(fft_pre_pad,num_channels,num_frames); y; zeros(fft_post_pad,num_channels,num_frames)];
end

% Evaluate FFT:
y = fft(y,num_FFT,1);
y((num_FFT/2+2):end,:,:) =[];
t = (frame_srt_idx-1 - (pre_pad_len) + num_FFT/2) ./fs;
f = (0:num_FFT/2) * fs/num_FFT;

end
