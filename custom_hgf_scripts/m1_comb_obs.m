function [logp, yhat, res, logp_split] = m1_comb_obs(r, infStates, ptrans)
% [logp, yhat, res, logp_split] = m1_comb_obs(r, infStates, ptrans)
%
% Calculates the combined log-probability of binary and continuous
% behavioural responses.
%
% INPUT
%   r             struct      Struct obtained from tapas_fitModel.m fct
%   infStates     tensor      Tensor containing inferred states from the
%                             perceptual model    
%   ptrans        vector      1xP vector with free param values (est space)
%
%   OPTIONAL:
%
% OUTPUT    
%   logp          vector       1xN vector containing trialwise log
%                              probabilities of responses
%   yhat          matrix       Nx2 matrix containing noise-free predictions
%   res           matrix       Nx2 matrix containing responses (bin + cont)
%   logp_split    matrix       Nx2 matrix containing trialwise logll values
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

%% introduce a bias for happy vs sad
% 
% happy_is_correct = r.y(:,3);
% muhat2 = infStates(:,2,1) = traj.muhat;
% 
% % if emo_bias > 0: participants more likely to say happy
% % which trials, correct is happy?
% % if muhat2 = belief about happy --> muhat2 + emo_bias
% % if muhat2 = belief about sad --> muhat2 - emo_bias
% 
% muhat1_new = inv_logit(muhat2 + happy_bias);
% muhat1 = infStates(:,1,1)
%% binary part of the response model

% compute log likelihood (binary responses)
[logp_binary, yhat_binary, res_binary] = ...
     tapas_softmax_binary(r, infStates, ptrans);
%     tapas_unitsq_sgm(r, infStates, ptrans);
   

%% continuous part of the response model

% prepare inputs for logRT GLM assuming that the input is a matrix with 2
% columns (1: binary predictions, 2: log response times).
rt = r;
rt.y = r.y(:,2);

% Compute the log likelihood (logRTs)
[logp_reactionTime, yhat_reactionTime, res_reactionTime] = ...
    m1_logrt_linear_binary(rt, infStates, ptrans);

%% confidence part of the response model
% confidence01 = r.y(:,4);
% 
% [logp_confidence, yhat_confidence, res_confidence] = ...
%     tapas_softmax_binary(confidence01, infStates, ptrans);

%% get combined log likelihood of two response data modalities
logp = logp_binary + logp_reactionTime;
logp_split = [logp_binary logp_reactionTime];

%% return predictions and responses for each response data modality
yhat = [yhat_binary yhat_reactionTime];
res = [res_binary res_reactionTime];

end
