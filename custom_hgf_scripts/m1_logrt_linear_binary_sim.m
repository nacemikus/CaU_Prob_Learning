function [y, logrt] = m1_logrt_linear_binary_sim(r, infStates, p)
% [y, logrt] = m1_logrt_linear_binary_sim(r, infStates, p)
%
% Simulates logRTs with Gaussian noise.
% (Designed to be compatible with the HGF Toolbox as part of TAPAS).
%
% INPUT
%   r             struct      Struct obtained from tapas_simModel.m fct
%   infStates     tensor      Tensor containing inferred states from the
%                             perceptual model    
%   p             vector      1xP vector with free param values (nat space)
%
%   OPTIONAL:
%
% OUTPUT    
%   y             vector       Nx1 vector with simulated logRTs
%   logrt         vector       Nx1 vector containing noise-free predictions
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

% Get parameters
be0  = p(2);
be1  = p(3);
be2  = p(4);
be3  = p(5);
be4  = p(6);
sa   = p(length(p));

% Number of trials
n = size(infStates,1);

% Inputs
u = r.u(:,1);

% Extract trajectories of interest from infStates
mu1hat = infStates(:,1,1);
sa1hat = infStates(:,1,2);
sa2hat = infStates(:,2,2);
mu3hat = infStates(:,3,1);

% Surprise
% ~~~~~~~~
poo = mu1hat.^u.*(1-mu1hat).^(1-u); % probability of observed outcome
surp = -log2(poo);
surp_shifted = [1; surp(1:(length(surp)-1))];

% Calculate predicted log-reaction time
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
logrt = be0 + be1.*surp_shifted + be2.*sa1hat + be3.*sa2hat + ...
    be4.*exp(mu3hat);

% Initialize random number generator
if isnan(r.c_sim.seed)
    rng('shuffle');
else
    rng(r.c_sim.seed);
end

% Simulate
y = logrt+sqrt(sa)*randn(n, 1);

end
