%% TO DO
%%

% Script to play around with modelling the TOSSTE data
close all; clear;

filename_save = 'Analysis_results_0102_2025';

run_from_id = 1;
separator = '\' ; %off server
% separator = '/' ; %on server
data_file = ['preproc data',separator,'Rodent_data_20250201.mat']
scriptpath = which(mfilename);
rootdir = scriptpath(1:find(scriptpath == separator,1,'last'));

cd (rootdir)

addpath(genpath(rootdir));%,'ReinfLearn')); % modelling code
addpath(genpath([rootdir, 'tapas']))
dataFolder = [rootdir, 'pilot data'];

%%add your HGF script foaddpath(genpath(GenScriptsFolder))lder to path
% GenScriptsFolder = 'P:\Projects\General Scripts';
% addpath(genpath(GenScriptsFolder));%,'ReinfLearn')); % modelling code


%% load data if


if run_from_id ~= 1
    load(filename_save);
else
    % writetable(data_all, 'Rodent_data_CaU.csv');  % Specify the desired file name
    data_all = load(data_file);
    data_all = data_all.data_all;
    
    
    %% prep data
    data_all.rt = data_all.time_stim_touched - data_all.time_stim_presented;
    data_all.left_rewarded = data_all.reward == data_all.choice;
    data_all.log_rt = log(data_all.rt) ;
    
    %example
    
    
    
    %% Get configuration structures
    prc_model_config = tapas_ehgf_binary_config(); % perceptual model
    obs_model_config = m1_comb_obs_config();%tapas_logrt_linear_binary_config(); % response model
    optim_config     = tapas_quasinewton_optim_config(); % optimisation algorithm
    
    %% set empty placeholders
    
    prc_params_vect = NaN(data_all.index(end),14);
    obs_params_vect = NaN(data_all.index(end),7);
    
    prc_params_sim_vect = NaN(data_all.index(end),14);
    obs_params_sim_vect =  NaN(data_all.index(end),7);
end
%% fit real data

for i = run_from_id: data_all.index(end)
    skip_this_session = 0;
    
    data_all_id = data_all(data_all.index == i,:);
    if size(data_all_id,1) < 90
        skip_this_session =1;
    else
        %% Get configuration structures
        %     prc_model_config = tapas_ehgf_binary_config(); % perceptual model
        %     obs_model_config = m1_comb_obs_config();%tapas_logrt_linear_binary_config(); % response model
        %     optim_config     = tapas_quasinewton_optim_config(); % optimisation algorithm
        
        y = [data_all_id.choice, data_all_id.log_rt];
        u = data_all_id.left_rewarded;
        count_nop = 0;
        
        while count_nop < 5
            
            try
                disp(['Trying subj ', num2str(i), ', no of times: ',num2str(count_nop+1) ]);
                
                est = tapas_fitModel(...
                    y,... %,confidence],...
                    u,...
                    prc_model_config,...
                    obs_model_config,...
                    optim_config);
                
                
                
                
                % % Check parameter identifiability
                % tapas_fit_plotCorr(est)
                %
                % tapas_hgf_binary_plotTraj(est)
                %
                % figure;histogram(est.optim.yhat(:,1),50)
                %
                % figure;plot(1:length(est.optim.yhat(:,1)), est.optim.yhat(:,1))
                %
                %
                % figure;plot(est.optim.yhat(:,2),data_all_id.log_rt, '.')
                % figure;histogram(log(RT(2:end)))
                % figure;plot(log(RT), est.optim.yhat(:,1), '.')
                % [r,p]=corr(est.optim.yhat(2:end,2),data_all_id.log_rt(2:end))
                %
                % est.p_obs
                %
                %     data_all_id.sahat1 = est.traj.sahat(:,1);
                %     data_all_id.sahat2 = est.traj.sahat(:,2);
                %     data_all_id.sahat3 = est.traj.sahat(:,3);
                %     data_all_id.muhat3= est.traj.muhat(:,3);
                %     lm = fitlm(data_all_id, 'log_rt ~ sahat1 + sahat2+sahat3+ muhat3');
                %     disp(lm)
                %     corr([est.traj.sahat, exp(est.traj.muhat(:,3))])
                % figure;plot(data_all_id.sahat2,data_all_id.log_rt, '.')
                % figure;plot(data_all_id.muhat3,data_all_id.log_rt, '.')
                % [r,p] = corr(data_all_id.muhat3,data_all_id.log_rt);
                % %
                
                
                %% recover pars
                disp(['Recovering par for subj ', num2str(i)]);
                
                prc_params = est.p_prc.p;
                obs_params = est.p_obs.p;
                sim = tapas_simModel(u,...
                    'tapas_ehgf_binary',...
                    prc_params,...
                    'm1_comb_obs',...
                    obs_params,...
                    123456789);
                
                est_sim = tapas_fitModel(...
                    sim.y,...
                    sim.u,...
                    prc_model_config,...
                    obs_model_config,...
                    optim_config);
                
                prc_params_vect(i,:) = est.p_prc.p;
                obs_params_vect(i,:) = est.p_obs.p;
                
                prc_params_sim_vect(i,:) = est_sim.p_prc.p;
                obs_params_sim_vect(i,:) = est_sim.p_obs.p;
                model_fits{i} = est;
                
                
                count_nop =5;
                skip_this_session = 0;
            catch
                count_nop = count_nop +1;
                disp(['caught error for subj ', num2str(i), ', no of times: ',num2str(count_nop) ]);
                skip_this_session = 1;
                
            end
        end
    end
    
    if  skip_this_session == 1
        
        model_fits{i} = NaN;
    end
end

save([filename_save, '.mat'])


%% playaround
if 1==0
    plot(prc_params_sim_vect(1:13,14), prc_params_vect(1:13,14),'.')
    corr(prc_params_sim_vect(1:13,14), prc_params_vect(1:13,14))
    
    figure;plot(prc_params_sim_vect(1:13,13), prc_params_vect(1:13,13),'.')
    corr(prc_params_sim_vect(1:13,13), prc_params_vect(1:13,13))
    
    par_no = 7
    close all
    figure;plot(obs_params_sim_vect(1:13,par_no), obs_params_vect(1:13,par_no),'.')
    corr(obs_params_sim_vect(1:13,par_no), obs_params_vect(1:13,par_no))
    
    checkpriors = [mean(obs_params_vect(1:13,:));...
        std(obs_params_vect(1:13,:))/sqrt(12)]
end