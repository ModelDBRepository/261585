function conds = sim_cond(session)


main_config();


prm_ra = session.parameters.ring_attractor;
prm_inputs = session.parameters.inputs;



%%
if contains(sim_cond_list{sim_cond_id}, 'slow speed')
        s = 100;
        vel_1 = vel_1/s;  % pi per second
        vel_2 = vel_2/s;  % 2*pi per second
        vel_4 = vel_4/s;  % 4*pi per second
end
if contains(sim_cond_list{sim_cond_id}, 'zero speed')
    % With this condition, velocity dependent learning rules cannot be used.
        vel_1 = 0;  % pi per second
        vel_2 = 0;  % 2*pi per second
        vel_4 = 0;  % 4*pi per second
end


%%
n_input_azimuth = prm_inputs.n_input_azimuth;
n_wedge_neurons = prm_ra.n_wedge_neurons;







%% Natural turning information loading

load pos_data;
pos_data = pos_data;
dt = simulation_dt;
t_min = pos_data.time(1);
t_max = pos_data.time(end);

if use_2D_input
    t_min = 75;
    t_max = 150;
end


ddt = median(diff(pos_data.time(1:100)));
stride = round(dt/ddt);

xp = pos_data.xpos;

xpos_all = xp(1:stride:end);
sim_t_all = 0:dt:(dt*numel(xpos_all)-dt+1e-10);

tidx = find(sim_t_all>=t_min & sim_t_all<=t_max);
xpos = xpos_all(tidx);
sim_t = sim_t_all(tidx)-sim_t_all(tidx(1));


sim_visual_neurons = zeros(n_input_azimuth, numel(sim_t));
sim_wedge_current_injection = zeros(n_wedge_neurons, numel(sim_t));


% xpos_radian = unwrap_pva(    mod(xpos/88*2*pi-pi- (2*pi/88/2),   2*pi)  -pi       );
xpos_radian = mod(xpos/88*2*pi-pi- (2*pi/88/2),   2*pi)-pi;


vel_tmp = diff(xpos_radian);
vel_tmp = [vel_tmp(1), vel_tmp];
vel_tmp = mod(vel_tmp+pi,2*pi)-pi;

vel_tmp = vel_tmp/dt;
vel_tmp = my_moving_avg(vel_tmp, 100);
sim_vel = vel_tmp/pi*vel_1;


%%%%%%%%%%%%%%%%%%%%%%%%%
% pos input

d = 2*pi/n_input_azimuth;

mamp = 0.35;

if use_2D_input && n_input_elevation>2
    mamp = mamp*0.7;
end

if contains(rule_id_list{rule_id}, 'Pre-synaptic')
    mamp = mamp/3;
end

disp(['max amp of input=' num2str(mamp)]);

%mc = xpos_radian;

mcshift = ceil(mod(xpos_radian,2*pi)/(2*pi)*size(sim_visual_neurons,1));

testing_if_input_is_strong_enough = 0;
if testing_if_input_is_strong_enough
    id1 = ceil(numel(xpos_radian)/400*110);
    id2 = ceil(numel(xpos_radian)/400*350);
    mcshift(id1:id2) = mcshift(id1:id2) + ceil(size(sim_visual_neurons,1)/2);
end


if contains(sim_cond_list{sim_cond_id}, 'narrow')
    kappa = 15;
else
    kappa = 1;
end



%% Construction of the stimulus
switch sim_cond_list{sim_cond_id}
    case 'no input'
        % specific setting
        % sim_vel = ones(size(sim_t))*vel_1; % constant vel bias
        sim_vel = zeros(size(sim_t))*vel_1; % zero velocity input
        
    case 'no visual input and no curent injection'
        % As it is.
        
    case {  'natural turning, gaussian, narrow, top row in 2D', ...
            'natural turning, gaussian, narrow, bottom row in 2D'
            }
        
        a = circularPdfVonMises(0:d:(2*pi-0.0001), pi, kappa, 'radian') ;
        a = (a-min(a))/(max(a)-min(a))*mamp;
        
        sim_visual_neurons = [sim_visual_neurons;sim_visual_neurons];
        for i = numel(sim_t):-1:1
            if contains(sim_cond_list{sim_cond_id}, 'top row')
                sim_visual_neurons(1:2:end,i) = circshift(a(:),mcshift(i));
            elseif contains(sim_cond_list{sim_cond_id}, 'bottom row')
                sim_visual_neurons(2:2:end,i) = circshift(a(:),mcshift(i));
            end
        end
        
        
    case {  'natural turning, gaussian, narrow, 2D',...
            'natural turning, two gaussians, narrow, 2D'
            }
        
        a = circularPdfVonMises(0:d:(2*pi-0.0001), pi, kappa, 'radian') ;
        a = (a-min(a))/(max(a)-min(a))*mamp;
        
        for i = numel(sim_t):-1:1
            sim_visual_neurons(:,i) = circshift(a(:),mcshift(i));
        end
        
        
        if contains(sim_cond_list{sim_cond_id}, 'two gaussians')
            sn = size(sim_visual_neurons,1)/2;
            a = sim_visual_neurons + circshift(sim_visual_neurons,sn);
            sim_visual_neurons = (a-min(a(:)))/(max(a(:))-min(a(:)))*mamp;
        end
        
        
        tmp = zeros(n_input_azimuth*n_input_elevation, size(sim_visual_neurons,2));
        for ri = 1:n_input_azimuth
            tmp( (ri-1)*n_input_elevation + (1:n_input_elevation), :) = repmat(sim_visual_neurons(ri,:),n_input_elevation, 1);
        end
        sim_visual_neurons = tmp/n_input_elevation;
        
        
    case {  'natural turning, 4 objects, same elevation, 2D',...
            'natural turning, 4 objects, diff elevation, 2D',...
            'natural turning, 4 objects, diff elevation - arrangement 2, 2D', ...
            'natural turning, natural scene 1, 2D',...
            'natural turning, natural scene 2, 2D'
            }
        
        if n_input_elevation==8 && n_input_azimuth==32
            tmp = zeros(n_input_elevation, n_input_azimuth);
            if contains(sim_cond_list{sim_cond_id}, 'same elevation')
                tmp(4:5, 1:4) = 1;
                tmp(4:5, 9:12) = 1;
                tmp(4:5, 17:20) = 1;
                tmp(4:5, 25:28) = 1;
            elseif contains(sim_cond_list{sim_cond_id}, 'diff elevation, 2D')
                tmp(1:2, 1:3) = 1;
                tmp(3:4, 9:11) = 1;
                tmp(5:6, 17:19) = 1;
                tmp(7:8, 25:27) = 1;
            elseif contains(sim_cond_list{sim_cond_id}, 'arrangement 2')
                tmp(7:8, 1:3) = 1;
                tmp(5:6, 9:11) = 1;
                tmp(3:4, 17:19) = 1;
                tmp(1:2, 25:27) = 1;
            elseif contains(sim_cond_list{sim_cond_id}, 'natural scene 1')
                load('natural_scenes.mat','imgs');
                tmp = imgs{1}([1:2:15], round((1:32)*2.75) );
            elseif contains(sim_cond_list{sim_cond_id}, 'natural scene 2')
                load('natural_scenes.mat','imgs');
                tmp = imgs{2}([1:2:15], round((1:32)*2.75) );
            end
            
            tmpz = zeros(size(tmp));
            tmp2 = [tmpz, tmpz, tmpz; tmp, tmp, tmp; tmpz, tmpz, tmpz];
            
            sss = 1.5*[1,1];
            sss = 2*[1,1];
            tmp2 = imgaussfilt(tmp2, sss);
            tmp = tmp2(n_input_elevation+(1:n_input_elevation), n_input_azimuth+(1:n_input_azimuth));
            
            %figure(212); imagesc(tmp);
        else
            error('dimension not defined');
        end
        
        
        a = tmp;
        a = (a-min(a(:)))/(max(a(:))-min(a(:)))*mamp;%*3;
        
        sim_visual_neurons = zeros(n_input_azimuth*n_input_elevation, numel(sim_t));
        for i = numel(sim_t):-1:1
            tmp = circshift(a,mcshift(i),2);
            sim_visual_neurons(:,i) = tmp(:);
        end
        
        
        
    case {  'natural turning, gaussian, narrow',...
            'natural turning, complex scene, narrow'
            }
        
        a = circularPdfVonMises(0:d:(2*pi-0.0001), pi, kappa, 'radian') ;
        
        if contains(sim_cond_list{sim_cond_id}, 'complex scene')
            atm = rand(1,15);
            a = circularPdfVonMises(0:d:(2*pi-0.0001), pi-pi*atm(1), kappa*atm(2)*3, 'radian')'/mamp*atm(3)*0.7 + ...
                    circularPdfVonMises(0:d:(2*pi-0.0001), pi-pi*atm(4), kappa*atm(5)*3, 'radian')'/mamp*atm(6)*0.7 + ...
                    circularPdfVonMises(0:d:(2*pi-0.0001), pi+pi*atm(7), kappa*atm(8)*3, 'radian')'/mamp*atm(9)*0.7 + ...
                    circularPdfVonMises(0:d:(2*pi-0.0001), pi-pi*atm(10), kappa*atm(11)*3, 'radian')'/mamp*atm(12)*0.7 + ...
                    circularPdfVonMises(0:d:(2*pi-0.0001), pi+pi*atm(13), kappa*atm(14)*3, 'radian')'/mamp*atm(15)*0.7 ;
        end
        
        %a = circshift(a(:),10);
        
        a = (a-min(a))/(max(a)-min(a))*mamp;
        
        for i = numel(sim_t):-1:1
            sim_visual_neurons(:,i) = circshift(a(:),mcshift(i));
        end
        
        
    case {'natural turning, two gaussians, narrow'
            }
        a = circularPdfVonMises(0:d:(2*pi-0.0001), pi, kappa, 'radian') ;
        a = (a-min(a))/(max(a)-min(a))*mamp;
        
        for i = numel(sim_t):-1:1
            sim_visual_neurons(:,i) = circshift(a(:),mcshift(i));
        end
        
        sn = size(sim_visual_neurons,1)/2;
        a = sim_visual_neurons + circshift(sim_visual_neurons,sn);
        sim_visual_neurons = (a-min(a(:)))/(max(a(:))-min(a(:)))*mamp;
        
        
    case {  'narrow, probe, 360d span'
            }
        
        t_total = 40; % seconds
        t_single_duration = 0.25; % seconds
        
        
        %%
        a = circularPdfVonMises(0:d:(2*pi-0.0001), pi, kappa, 'radian') ;
        a = (a-min(a))/(max(a)-min(a))*mamp;
        
        nstep = n_input_azimuth;
        step = round(n_input_azimuth/nstep);
        step_start = 0;
        
        npoints = round(t_single_duration/dt);
        
        tmp=[];
        for tmpi = 1:nstep
            tmp = [tmp ones(1,npoints)*step_start];
            step_start = step_start+step;
        end
        tmp = [tmp tmp(end:-1:1) tmp tmp(end:-1:1) tmp tmp tmp(end:-1:1) tmp(end:-1:1)];

        
        
        mcshift = repmat(tmp,1, ceil(t_total/dt/numel(tmp)));
        sim_visual_neurons = [];
        for i = numel(mcshift):-1:1
            sim_visual_neurons(:,i) = circshift(a(:),mcshift(i));
        end
        
        
        sim_wedge_current_injection = zeros(n_wedge_neurons, size(sim_visual_neurons,2));
        sim_vel = zeros(1,numel(mcshift));
        
        
        sim_t = 0:dt:dt*(numel(sim_vel)-1);
        

        
    case {  'narrow, optogenetic offsetting at 0d, 360d span',...
            'narrow, optogenetic offsetting at 0d, 180d span',...
            'narrow, optogenetic offsetting at 0d, 060d span',...
            'narrow, optogenetic offsetting at 0d, 360d span, opposite', ...
            'narrow, optogenetic offsetting at 0d, 360d span, complex scene'
            
            }
        
        t_total_opto = 100; % seconds
        t_single_opto_duration = 1.5; % seconds
        
        
        %%
        a = circularPdfVonMises(0:d:(2*pi-0.0001), pi, kappa, 'radian') ;
        a = (a-min(a))/(max(a)-min(a))*mamp;
        
        if contains(sim_cond_list{sim_cond_id}, 'complex scene')
            % The actual visual input profile should have been saved before
            % running this protocol.
            load('complex_scene_sample.mat');
            a = circshift(saved_input_profile,20);
        end
        
        
        if contains(sim_cond_list{sim_cond_id}, '360d span')
            step = round(n_input_azimuth/8);
            nstep = 8;
            step_start = 0;
            %step_start = round(n_input_azimuth/2);
        elseif contains(sim_cond_list{sim_cond_id}, '180d span')
            step = round(n_input_azimuth/16);
            nstep = 8;
            step_start = 0;
            step_start = 20;
        elseif contains(sim_cond_list{sim_cond_id}, '060d span')
            step = round(n_input_azimuth/12);
            nstep = 3;
            step_start = -step;
            step_start = 20-step;
        end
        
        npoints = round(t_single_opto_duration/dt);
        
        tmp=[];
        for tmpi = 1:nstep
            tmp = [tmp ones(1,npoints)*step_start];
            step_start = step_start+step;
        end
        if contains(sim_cond_list{sim_cond_id}, '360d span')
            tmp = [tmp tmp tmp(end:-1:1) tmp(end:-1:1)];
        else
            tmp = [tmp tmp(end:-1:1)];
        end
        
        if contains(sim_cond_list{sim_cond_id}, '360d span') && contains(sim_cond_list{sim_cond_id}, 'opposite')
            step_start = 0;
            tmp=[];
            for tmpi = 1:nstep
                tmp = [tmp ones(1,npoints)*step_start];
                step_start = step_start+step;
            end
            tmp = [tmp(end:-1:1) tmp(end:-1:1) tmp tmp ];
        end
        
        
        mcshift = repmat(tmp,1, ceil(t_total_opto/dt/numel(tmp)));
        sim_visual_neurons = [];
        for i = numel(mcshift):-1:1
            sim_visual_neurons(:,i) = circshift(a(:),mcshift(i));
        end
        
        
        %%
        opto_kappa = 10;
        ww_mamp = mamp*2;
        disp(['max amp of wedges=' num2str(ww_mamp)]);
        ww_d = 2*pi/n_wedge_neurons;
        ww_a = circularPdfVonMises(0:ww_d:(2*pi-0.0001), pi, opto_kappa, 'radian') ;
        ww_a(ww_a>max(ww_a)/2) = max(ww_a);
        ww_a = (ww_a-min(ww_a))/(max(ww_a)-min(ww_a))*ww_mamp;

        if contains(sim_cond_list{sim_cond_id}, '360d span')
            step = round(n_wedge_neurons/8);
            nstep = 8;
            step_start = 0;
        elseif contains(sim_cond_list{sim_cond_id}, '180d span')
            step = round(n_wedge_neurons/16);
            nstep = 8;
            step_start = 0;
        elseif contains(sim_cond_list{sim_cond_id}, '060d span')
            step = round(n_wedge_neurons/12);
            nstep = 3;
            step_start = -step;
        end
        
        npoints = round(t_single_opto_duration/dt);
        
        tmp=[];
        for tmpi = 1:nstep
            tmp = [tmp ones(1,npoints)*step_start];
            step_start = step_start+step;
        end
        if contains(sim_cond_list{sim_cond_id}, '360d span')
            tmp = [tmp tmp tmp(end:-1:1) tmp(end:-1:1)];
        else
            tmp = [tmp tmp(end:-1:1)];
        end
        
        
        ww_mcshift = repmat(tmp,1, ceil(t_total_opto/dt/numel(tmp)));
        sim_wedge_current_injection = [];
        for i = numel(ww_mcshift):-1:1
            sim_wedge_current_injection(:,i) = circshift(ww_a(:),ww_mcshift(i));
        end
        
        
        while numel(sim_vel)<numel(ww_mcshift)
            sim_vel = [sim_vel, sim_vel];
        end
        sim_vel = sim_vel(1:numel(ww_mcshift));
        sim_vel = zeros(size(sim_vel));
        
        
        sim_t = 0:dt:dt*(numel(sim_vel)-1);
        
        
        
        
end

sim_visual_neurons = sim_visual_neurons - min(sim_visual_neurons(:));
    
if max(sim_visual_neurons(:))>0
    %sim_visual_neurons = sim_visual_neurons/sum(sim_visual_neurons(end-1,:))*mw; % normalize the input power
    sim_visual_neurons = sim_visual_neurons/max(sim_visual_neurons(:))*mamp; % normalize the max
end




if display_and_save_summary_pdf
figure(1); hold off;
plot(sim_visual_neurons(:,1));
if sum(sim_wedge_current_injection(:))~=0
    hold on;
    plot(sim_wedge_current_injection(:,1));
end
title('activity profile of the ring neuron population');
xlabel('ring (input) neuron id');
box off;
grid on;
drawnow;
end




%%

if add_noise
    m = 0;
    v = max(sim_visual_neurons(:))*0.5; % 0.2;
    if v==0
        v=0.1;
    end
    %n = v*randn(size(sim_visual_neurons))+m;
    n = v*(rand(size(sim_visual_neurons))-0.5)+m;
    sim_visual_neurons = sim_visual_neurons+n;
    for sii = 1:size(sim_visual_neurons,1)
        sim_visual_neurons(sii,:) = my_moving_avg(sim_visual_neurons(sii,:),5);
    end
end
   
if add_noise || contains( sim_cond_list{sim_cond_id}, 'optogenetic')
    m = 0;
    v = max(sim_vel(:))*0.2;
    if v==0
        v=vel_1/4;
    end
    %n = v*randn(size(sim_vel))+m;
    n = v*(rand(size(sim_vel))-0.5)+m;
    sim_vel = sim_vel+n;
    sim_vel = my_moving_avg(sim_vel,5);
    
end



%%
conds.description = sim_cond_list{sim_cond_id};
conds.t = sim_t;
conds.dt = dt;
conds.vel = sim_vel;
conds.visual_input_neurons = sim_visual_neurons;
conds.wedge_current_injection = sim_wedge_current_injection;
