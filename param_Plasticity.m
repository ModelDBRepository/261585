function plasticity = param_Plasticity(prm_ra, prm_inputs)

main_config();



%%

plasticity.rule = rule_id_list{rule_id};

switch rule_id_list{rule_id}
    case 'No learning'
        plasticity.W_max = 0;
        
        
    case 'SOM inhib, Post-synaptically gated, input profile'

        epsilon_W_input = 0.5;
        if use_2D_input
            epsilon_W_input = 0.75;
        end
        W_max = 0.33;
        
        plasticity.epsilon_W_input = epsilon_W_input;
        plasticity.W_max = W_max;
        
    case 'Hebb inhib, Pre-synaptically gated, wedge profile'
        plasticity.epsilon_W_input = 0.5;
        plasticity.W_max = 0.33;
        
    otherwise
        error('no such plasticity rule');
end






