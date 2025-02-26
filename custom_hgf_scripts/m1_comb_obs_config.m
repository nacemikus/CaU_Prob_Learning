function [c] = m1_comb_obs_config()
% [c] = m1_comb_obs_config()
%
% Contains the prior configurations of the combined response model M1.
% (Designed to be compatible with the HGF Toolbox as part of TAPAS).
%
% INPUT
%   argin         type  
%
%   OPTIONAL:
%
% OUTPUT    
%   c             struct       Struct containing obs model prior configs
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


%% Config structure
c = struct;

% Is the decision based on predictions or posteriors? Comment as appropriate.
c.predorpost = 1; % Predictions
%c.predorpost = 2; % Posteriors

% Model name
c.model = 'm1_comb_obs';


%% Sufficient statistics of Gaussian parameter priors
%-----------------------------------
% Model for binary predictions
% zeta - inv decision noise
c.logzemu = log(48);
c.logzesa = 1;

%-----------------------------------
% Model for Reaction Time fit
% beta0 - intercept
c.beta0mu = 4;
c.beta0sa = 2;

% beta1
c.beta1mu = 0;
c.beta1sa = 1;%5;

% beta2
c.beta2mu = 0;
c.beta2sa = 5;%5;

% beta3
c.beta3mu = 0;
c.beta3sa = 1;%5;

% % beta4
c.beta4mu = 0;
c.beta4sa = 1;%5;

% Sigma (noise term)
c.logsamu = log(1);
c.logsasa = 2;


%% Gather prior settings in vectors
c.priormus = [
    c.logzemu,...
    c.beta0mu, ...
    c.beta1mu, ...
    c.beta2mu, ...
    c.beta3mu, ...
    c.beta4mu, ...
    c.logsamu ...
         ];

c.priorsas = [
    c.logzesa,...
    c.beta0sa, ...
    c.beta1sa, ...
    c.beta2sa, ...
    c.beta3sa, ...
    c.beta4sa, ...
    c.logsasa ...
    ];

% Model filehandle
c.obs_fun = @m1_comb_obs;

% Handle to function that transforms perceptual parameters to their native
% space from the space they are estimated in
c.transp_obs_fun = @comb_obs_transp;

return;
