function params = param_Ring_Attractor()

%% Parameters for the ring attractor, i.e., E-PG neurons, a.k.a. compass neurons

% See the Supplimentary Materials of Kim et al. 2017 Science paper for the
% variable naming convention in this script.

    
main_config();



%% This routine checks stability of the ring attractor dynamics
param_Ring_Attractor_check();






%% Weight matrix for the Ring Attractor (local model)
W_ring_attractor = -beta_discrete*ones(n_wedge_neurons, n_wedge_neurons);
for i = 1:size(W_ring_attractor,1)
    W_ring_attractor(i,i) = alpha_-2*D-beta_discrete;
    ind = [i-1, i+1];
    ind = mod(ind-1, n_wedge_neurons)+1;
    W_ring_attractor(i, ind) = D - beta_discrete;
end


%%
params.info.bump_width = bump_width;
params.info.D_cont = D_cont;
params.info.beta_cont = beta_cont;
params.info.S = S;
params.info.A = A;
params.info.omega = omega;
params.info.phi = phi;

params.n_wedge_neurons = n_wedge_neurons;
params.tau_wedge = tau_wedge*ones(n_wedge_neurons,1);
params.membrane_threshold = 0;
params.membrane_saturation = 1000;
params.W_ring_attractor = W_ring_attractor;



