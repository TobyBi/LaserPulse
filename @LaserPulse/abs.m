function res = abs(pulse1)
% ABS calculates the absolute value of a pulse in the active domain.
%
% INPUTS:
%   pulse1: instance of LaserPulse
%
% OUTPUTS:
%   res: the resulting pulse

% Copyright (C) 2015-2017 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

res = copy(pulse1);

switch pulse1.activeDomain
  case 'time'
    res.temporalPhase = zeros(size(res.temporalPhase));
  case 'frequency'
    res.spectralPhase = zeros(size(res.spectralPhase));
  otherwise
      error('LaserPulse:abs', 'activeDomain not properly set');
end

end

