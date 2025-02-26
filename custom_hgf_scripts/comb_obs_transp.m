function [pvect, pstruct] = comb_obs_transp(r, ptrans)
% [pvect, pstruct] = comb_obs_transp(r, ptrans)
%
% Transforms parameter values from estimation into native space.
% (Designed to be compatible with the HGF Toolbox as part of TAPAS).
%
% INPUT
%   r            struct      Struct obtained from tapas_fitModel.m fct
%   ptrans       vector      1xP vector containing model params (est space)
%
%   OPTIONAL:
%
% OUTPUT    
%   pvect        vector      1xP vector containing model params (nat space)
%   pstruct      struct      Empty struct
%
% _________________________________________________________________________
% Author: Alex Hess
%
% Copyright (C) 2023 Translational Neuromodeling Unit
%                    Institute for Biomedical Engineering
%                    University of Zurich & ETH Zurich
%
% This file is released under the terms of the GNU General Public Licence
% (GPL), version 3. You can redistribute it and/or modify it under the
% terms of the GNU General Public License as published by the Free Software
% Foundation, either version 3 of the License, or (at your option) any
% later version.
%
% This file is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
% more details.
% 
% You should have received a copy of the GNU General Public License along
% with this program. If not, see <https://www.gnu.org/licenses/>.
% _________________________________________________________________________

% empty array
pstruct = struct();

% vector with parameter values transformed back into native space
pvect = ptrans;
pvect(1) = exp(ptrans(1)); % decision temperature (binary obs model)
pvect(length(pvect)) = exp(ptrans(length(pvect))); % logRT model noise parameter

end
