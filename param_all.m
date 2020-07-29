function params = param_all()


params.ring_attractor = param_Ring_Attractor();       % Ring attractor parameters
params.inputs = param_Inputs(params.ring_attractor);  % Visual ring neurons input parameters
params.plasticity = param_Plasticity(params.ring_attractor, params.inputs);   % Plasticity related parameters (e.g., synaptic weights, etc)


return;



 