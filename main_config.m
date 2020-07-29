%% Main configuration file for simulation


addpath('./utils/');
addpath('./utils/circularStat');
addpath('./utils/DrosteEffect-BrewerMap-7fdcfcf');


%% (used in sim_cond.m)
simulation_dt = 0.01; % 0.005; 0.05;


%% (used in this file, main_config.m)
use_2D_input = 0;
is_optogenetics_trial = 0;


%% (used in main_sim.m)

use_prev_sim_W_input = 1;   % uses the synaptic weight matrix of the previous simulation as an initial matrix
recycle_sim_conds = 1;      % useful for 'complex scene', which generates random activity profile.
save_simulation_result = 0; % saving the entire simulation. It requires large storage space.
display_and_save_summary_pdf = 1;





%% E-PG neurons (compass neurons), ring attractor (used in param_Ring_Attractor.m)

% The ring attractor parameters for simulation : ***** Kept constant across all simulations *****
% See "Motor parameters" at the bottom of this script for the reason of fixing these parameters   
% 

% See the Supplimentary Materials of Kim et al. 2017 Science paper for the
% variable naming convention.

% tau and D affect the bump speed.
% Larger D or larger tau mean slower flow
% beta_discrete has minimal to no impact on the speed of the bump.

n_wedge_neurons = 32;
tau_wedge = 0.05;
D_cont = 0.2;
beta_cont = 10;

% bump_width: tail to tail
bump_width = pi/2*1.2; % For most simulations. Half width is around pi/2.






%% Bulb ring neurons (input nodes)   (used in param_Inputs.m)

% # of ring neurons input nodes
n_input_elevation = 1;
if use_2D_input
    % n_input_elevation = 2;
    % n_input_elevation = 6;
    n_input_elevation = 8;
end
n_input_azimuth = 32;
n_input_nodes = n_input_elevation * n_input_azimuth;

input_is_excitatory_1_inhibitory_m1 = -1; % 1: excitatory,    -1: inhibitory

% initial synaptic weights
input_weight_id = 3; % 3 or 4

input_weight_options = {
    'zero weight'           % zero initial synaptic weight
    'von Mises weight'      % well-shaped initial input weight matrix
    'random weight'         
    };







%% Plasticity rule   (used in param_Plasticity.m)

%rule_id = 1;
rule_id = 2;
%rule_id = 3;

rule_id_list = {
    'No learning'
    'SOM inhib, Post-synaptically gated, input profile'
    'Hebb inhib, Pre-synaptically gated, wedge profile'
    };


if ~strcmp (rule_id_list{rule_id}, 'No learning')
    if     input_is_excitatory_1_inhibitory_m1 < 0     &&     ~contains(rule_id_list{rule_id}, 'inhib')
        error(['input_is_excitatory_1_inhibitory_m1 should be positive for the rule: ' rule_id_list{rule_id}]);
    elseif input_is_excitatory_1_inhibitory_m1 > 0     &&     contains(rule_id_list{rule_id}, 'inhib')
        error(['input_is_excitatory_1_inhibitory_m1 should be negative for the rule: ' rule_id_list{rule_id}]);
        
    end
end





%% Simulation conditions (visual input, velocity etc)     (used in sim_cond.m)

add_noise = 1;  % adds some noise to both input neurons (ring neurons) and velocity signal


%sim_cond_id = 3; % probe stim
%sim_cond_id = 6; % normal gaussian
%sim_cond_id = 7; % two gaussians
sim_cond_id = 8; % complex scene


if is_optogenetics_trial
    %sim_cond_id = 11; % optogenetics  360d
    sim_cond_id = 12; % optogenetics  180d
    %sim_cond_id = 13; % optogenetics  60d
    %sim_cond_id = 14; % optogenetics  360d opposite direction
    %sim_cond_id = 15; % optogenetics  with a complex scene
    %sim_cond_id = 3; % optogenetics  probe
end



if use_2D_input
%      sim_cond_id = 19;
      sim_cond_id = 20;

%     sim_cond_id = 21;
%     sim_cond_id = 22;

%     sim_cond_id = 23;
%     sim_cond_id = 24;
     
end


sim_cond_list = {
    'no input'
    'no visual input and no curent injection'
    'narrow, probe, 360d span'
    ''
    ''
    %5
    
    % For publication
    'natural turning, gaussian, narrow'
    'natural turning, two gaussians, narrow'
    'natural turning, complex scene, narrow'
    ''
    ''
    %10
    
    'narrow, optogenetic offsetting at 0d, 360d span'
    'narrow, optogenetic offsetting at 0d, 180d span'
    'narrow, optogenetic offsetting at 0d, 060d span'
    'narrow, optogenetic offsetting at 0d, 360d span, opposite'
    'narrow, optogenetic offsetting at 0d, 360d span, complex scene'
    %15
    
    'natural turning, gaussian, narrow, 2D'
    'natural turning, two gaussians, narrow, 2D'
    'natural turning, 4 objects, same elevation, 2D'
    'natural turning, 4 objects, diff elevation, 2D'
    'natural turning, 4 objects, diff elevation - arrangement 2, 2D'
    %20
    'natural turning, natural scene 1, 2D'
    'natural turning, natural scene 2, 2D'
    'natural turning, gaussian, narrow, top row in 2D'
    'natural turning, gaussian, narrow, bottom row in 2D'
    
    };

stim_str = sim_cond_list{sim_cond_id};
if n_input_elevation~=2 && ...
        (strcmp(stim_str,'natural turning, gaussian, narrow, top row in 2D') ...
        || strcmp(stim_str,'natural turning, gaussian, narrow, bottom row in 2D'))
    
    error([stim_str ' is intended for 2-row toy examples.']);
    
elseif n_input_elevation==2 && ...
        (~strcmp(stim_str,'natural turning, gaussian, narrow, top row in 2D') ...
        && ~strcmp(sim_cond_list{sim_cond_id},'natural turning, gaussian, narrow, bottom row in 2D'))
    
    error([stim_str ' is intended for 8-row 2D scenes.']);
    
end




%% Motor parameters for simulation. This depends on the ring attractor parameters.
%% So, it is a good idea not to modify the ring attractor parameters.
%% (used in sim_cond.m)
% These values were obtained by trial and error in simulations.
% Note that vel is not perfectly linear, but reasonably linear.
vel_1 = 0.1775;%   pi per second
vel_2 = 0.375;  % 2*pi per second
vel_4 = 0.765;  % 4*pi per second







