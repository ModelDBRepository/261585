
main_config();


%% 
tic_all = tic;


%% Simulation parameter setting

% Model parameters
session.parameters = param_all();

% Simulation conditions (such as ring neuron activity, velocity signal, input polarity etc...)
if ~recycle_sim_conds ...
        || ~exist('session', 'var') || ~isfield(session, 'sim_conds') ...
        || ~strcmp(sim_cond_list{sim_cond_id}, session.sim_conds.description)
    session.sim_conds = sim_cond(session);
end

disp(session.parameters.ring_attractor);
disp(session.parameters.inputs);
disp(session.sim_conds);
disp(session.parameters.plasticity);




%% Simulation

% Randomly initialize the compass neurons (= wedge neurons) activity level
x1 = rand(session.parameters.ring_attractor.n_wedge_neurons,1) * session.parameters.ring_attractor.info.A;

% Initialize the synaptic weight matrix W
if use_prev_sim_W_input && exist('W_last', 'var')
    tmp = W_last;  % uses the W from the last simulation
elseif use_prev_sim_W_input && exist('session', 'var') && isfield(session, 'results') && isfield(session.results, 'W_input')
    tmp = session.results.W_input(:,:,end);  % uses the W from the last simulation
else
    tmp = session.parameters.inputs.W_input; % uses initial value defined by param_all()
end
W_input_dim = size(tmp);
x2 = tmp(:);

sim_x = [x1;x2];
sim_t = session.sim_conds.t;

% Run the model
[t,y] = ode45(@(t, y) RingAttractorODESolver(t, y, session), sim_t, sim_x);
activity = y';

% Collect simulation result
session.results.t = t;
session.results.wedge_neurons = activity(1:numel(x1),:);
session.results.W_input = reshape(activity(numel(x1)+1:end,:),  W_input_dim(1),  W_input_dim(2), numel(t));

W_last = session.results.W_input(:,:,end);



%% check result
result_check(session);


%% display result & save
fn = [session.parameters.plasticity.rule ' - ' session.sim_conds.description ' - ' session.parameters.inputs.initial_weight_description ' - ' datestr(now,'yyyymmdd-HHMMSS')];

if display_and_save_summary_pdf
    result_display(session, [], fn);
end

save(fullfile('simple_result_W', ['W=' fn]), 'W_last');
if save_simulation_result
    save(['sim_result - ' fn], 'session');
end



%%
toc(tic_all)


return;
