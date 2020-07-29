function params = param_Inputs(prm_ra)

main_config();


if contains(rule_id_list{rule_id}, 'threshold=')
    W_max = 0.02;
else
    W_max = 0.33;
end





%% Input weight matrix initialization
n_wedge_neurons = prm_ra.n_wedge_neurons;


switch input_weight_options{input_weight_id}
    case 'zero weight'
        W_input = zeros(n_wedge_neurons, n_input_nodes);
        
        
    case 'von Mises weight'
        d = 2*pi/n_input_nodes;
        kappa = 3;
        %p = circularPdfVonMises(0:d:(2*pi-0.001), 0, kappa, 'radian');
        
        W_input = zeros(n_wedge_neurons, n_input_nodes);
        for i = 1:size(W_input,1)
            W_input(i,:) = circularPdfVonMises(0:d:(2*pi-0.001), 2*pi/n_wedge_neurons*i, kappa, 'radian');
        end
        
        W_input = W_input/max(W_input(:))*W_max;
        
        
    case 'random weight'
        W_input = rand(n_wedge_neurons, n_input_nodes)*W_max;
        
end


%%
params.initial_weight_description = input_weight_options{input_weight_id};
params.use_2D_input = use_2D_input;
params.n_input_azimuth = n_input_azimuth;
params.n_input_elevation = n_input_elevation;
params.n_input_nodes = n_input_nodes;
params.W_input = W_input;
params.input_is_excitatory_1_inhibitory_m1 = input_is_excitatory_1_inhibitory_m1;

 