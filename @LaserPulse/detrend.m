function detrend(pulse, domain)
%DETREND subtracts derivative offset from phase and store it separately
%   pulse.detrend('frequency') for spectral phases
%   pulse.detrend('time') for temporal phase
%   pulse.detrend('all') or pulse.detrend() for both phases

%% Copyright (c) 2015-2017, Alberto Comin, LMU Muenchen
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
% 1. Redistributions of source code must retain the above copyright notice,
% this list of conditions and the following disclaimer.
%
% 2. Redistributions in binary form must reproduce the above copyright
% notice, this list of conditions and the following disclaimer in the
% documentation and/or other materials provided with the distribution.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

if ~exist('domain','var')
  domain = 'all';
end

switch domain
  case 'frequency'
    freqDetrend(pulse); 
  case 'time'
    timeDetrend(pulse);
  case 'all'
    pulse.detrend('frequency');
    pulse.detrend('time');
  otherwise
    error('LaserPulse:detrend', 'unsupported domain Type (''%s'')', domain);
end

end

function timeDetrend(pulse)
% if the new phase is not compatible with the old amplitude,
% calculate the offset at the center of domain, rather that at
% the center of mass
% see also comments related to set.spectralPhase
pulse.updateField('time');
phaseDer = centralDiff(pulse.tempPhase_) / pulse.timeStep;
int = abs(pulse.tempAmp_).^2;
phi1 = sum(phaseDer(:) .* int(:)) ./ sum(int(:));
phase = bsxfun(@minus, pulse.tempPhase_ , phi1 * pulse.shiftedTimeArray_);
pulse.frequencyOffset = pulse.frequencyOffset - phi1/2/pi; % note the (-) sign
pulse.tempPhase_ = phase;
pulse.updatedDomain_ = 'time';
end

function freqDetrend(pulse)
% if the new phase is not compatible with the old amplitude,
% calculate the offset at the center of domain, rather that at
% the center of mass
pulse.updateField('frequency');
phaseDer = centralDiff(pulse.specPhase_) / pulse.frequencyStep;
int = abs(pulse.specAmp_).^2;
phi1 = sum(phaseDer(:) .* int(:)) ./ sum(int(:));
phase = bsxfun(@minus, pulse.specPhase_ , phi1 * pulse.shiftedFreqArray_);
pulse.timeOffset = pulse.timeOffset + phi1/2/pi; % note the (+) sign
pulse.specPhase_ = phase;
pulse.updatedDomain_ = 'frequency';
end
