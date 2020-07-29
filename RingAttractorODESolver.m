function dydt = RingAttractorODESolver(t,y,session)

persistent y_record;  % can be used when an algorithm depends on the activity history

persistent vel_backup;
persistent adjusted_vel;


prm_ra = session.parameters.ring_attractor;
prm_inputs = session.parameters.inputs;

nw = prm_ra.n_wedge_neurons;
ni = prm_inputs.n_input_nodes;

%% These two variables will be updated
y1 = y(1:nw);      % wedge neuron activity (ring attractor activity)
y2 = y(nw+1:end);  % W_input
W_input = reshape(y2, nw, ni);


%% Take the index of the current time point
dt = session.sim_conds.dt;
ind = t/dt+1;
indf = floor(ind);
indc = ceil(ind);




%% Record keeping
if isempty(y_record)
    y_record = zeros(nw, numel(session.sim_conds.t));
end
if indc >0 && indc <= numel(session.sim_conds.t)
    y_record(:,indc) = y1;
end




%% Obtain interpolated inputs to wedge neurons

% input_neuron_activity: input from ring neurons (negative if ring neurons are inhibitory)
% vel_signal: velocity input
% wedge_injection_signal: direct current injection

if indf==indc
    input_neuron_activity = session.sim_conds.visual_input_neurons(:,indf);
    vel_signal = session.sim_conds.vel(indf);
    wedge_injection_signal = session.sim_conds.wedge_current_injection(:,indf);
else
    input_neuron_activity = (indc-ind)*session.sim_conds.visual_input_neurons(:,indf) + (ind-indf)*session.sim_conds.visual_input_neurons(:,indc);
    vel_signal = (indc-ind)*session.sim_conds.vel(indf) + (ind-indf)*session.sim_conds.vel(indc);
    wedge_injection_signal = (indc-ind)*session.sim_conds.wedge_current_injection(:,indf) + (ind-indf)*session.sim_conds.wedge_current_injection(:,indc);
end


%% Calculate the current from each input type to wedge neurons

%%%
% 1. Current from visual neurons
input_current_from_visual_neurons = W_input * (input_neuron_activity * 2*pi/ni) ;
if strcmp(session.parameters.plasticity.rule, 'Cope')
    [~,innn] = find(input_neuron_activity<max(input_neuron_activity));
    input_neuron_activity(innn) = 0;
    input_current_from_visual_neurons = session.parameters.plasticity.w_p * W_input * (input_neuron_activity * 2*pi/ni) ;
end
if prm_inputs.input_is_excitatory_1_inhibitory_m1 < 0
    input_current_from_visual_neurons = -input_current_from_visual_neurons;
end


%%%
% 2. Turning signal

% Scale the vel signal (discretization)
vel = vel_signal*nw/2/pi;
% To avoid asymmetricity, I used { [f(t+dt)-f(t)]/dt + [f(t)-f(t-dt)]/dt }/2
turning_signal = vel*(y1([end,1:end-1]) - y1([2:end, 1]))/2; % calculate turning_signal at a given moment;


%%%
% 3. Current injection
wedge_current_injection = wedge_injection_signal * 2*pi/nw;




%% Calculate the delta of the ring attractor

tmp = prm_ra.W_ring_attractor*y1 + 1 + input_current_from_visual_neurons + turning_signal + wedge_current_injection;
tmp(tmp>prm_ra.membrane_saturation) = prm_ra.membrane_saturation;
tmp(tmp<prm_ra.membrane_threshold) = prm_ra.membrane_threshold;

y1_tmp = tmp; clear tmp;
delta_y1 = (y1_tmp - y1) ./ prm_ra.tau_wedge;





%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Update the W_input with a plasticity rule.

ina_rep = repmat(input_neuron_activity', nw,1);
wedge_rep = repmat(y1,1,ni);

switch session.parameters.plasticity.rule
    
    case 'No learning'
        dW_input_dt = zeros(size(ina_rep));
    
        
    otherwise
        
        epsilon = session.parameters.plasticity.epsilon_W_input;
        W_max = session.parameters.plasticity.W_max;
        
        % The learning rate is assumed to be velocity dependent.
        % The actual source of velocity dependent modulation is not known.
        
        if numel(vel_backup) ~= numel(session.sim_conds.vel) || ...
                vel_backup(indc) ~= session.sim_conds.vel(indc) || ...
                t == session.sim_conds.t(1)
            vel_backup = session.sim_conds.vel;            
            tmp = vel_backup;
            tmp = tmp.^2;
            sss = mean(tmp)+1.5*std(tmp);
            adjusted_vel = tmp/sss;    % scaling
            
        end
        
        % interpolate
        if indf==indc
            fv = adjusted_vel(indf);
        else
            fv = (indc-ind)*adjusted_vel(indf) + (ind-indf)*adjusted_vel(indc);
        end
        
        
        % Compute dW
        
        switch session.parameters.plasticity.rule
            case 'SOM inhib, Post-synaptically gated, input profile'
                f_th = 0.04; % about half of the maximum wedge neuron activity. So, this can be dynamically adjustable, but not implemented.
                [PF, NF] = half_wave_rectify(wedge_rep-f_th); % PF is the positive part, NF is the negative part. Both are positive.
                
                dW_input_dt = 3* fv * epsilon *      wedge_rep .* ( W_max - ina_rep - W_input )     ;
                
                % In case, the wedge neurons are noisy, it may need to be
                % thresholded.
                % dW_input = fv * epsilon *      PF .* ( W_max - ina_rep - W_input )     ;
                
            case 'Hebb inhib, Pre-synaptically gated, wedge profile'
                %%% *** IMPORTANT: The mamp in the "sim_cond.m" should be small. See line 111 of sim_cond.m.
                g_th = 0.1/3; % About a bit less than the median of input activity.
                g_th = g_th*ones(size(ina_rep));
                [PG, NG] = half_wave_rectify(ina_rep-g_th); % PG is the positive part, NG is the negative part. Both are positive.
                
                %%% adaptive version
                %t_duration = 5;
                %tmp_ind = max(indf-round(t_duration/dt),1):max(indf,1);
                %scale_factor = repmat( max(0.02, max(y_record(:,tmp_ind),[],2) ),  1, ni);
                %scale_factor = repmat( 0.02 + max(y_record(:,tmp_ind),[],2) ,  1, ni);
                
                %%% Fixed version
                scale_factor = 0.08 * ones(size(wedge_rep));
                
                dW_input_dt = 6* fv * epsilon * (    W_max - (wedge_rep./scale_factor)*W_max  -  W_input ) .* PG;
                
        end
        

        
end

if t>10
    t = t;
end

% New W_input state
W_input = W_input + dW_input_dt;


% Cap the value
W_input(W_input<0) = 0;
if exist('W_max', 'var')
    W_input(W_input>W_max) = W_max;
end

% Calculate the delta
y2_tmp = reshape(W_input, numel(W_input),1);
delta_y2 = (y2_tmp - y2);



%% Combine results
dydt = [delta_y1;delta_y2];



%% Occasionally display the simulation time
if mod(t,20)<0.001 && rand()>0.7
    disp(['  ' num2str(t) 's']); 
end


return;
