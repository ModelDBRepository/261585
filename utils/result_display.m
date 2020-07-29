function result_display(session, tw, filename)

W_display_times = [0.01, floor(session.results.t(end)/4), floor(session.results.t(end)/2),  floor(session.results.t(end)/4*3), session.results.t(end)];

nt = numel(W_display_times);


if ~exist('tw', 'var') || isempty(tw)
    tw = session.results.t([1,end]);
end

if numel(tw)==1
    tw = tw+ session.results.t([1, end]);
end



%% plot
hf=figure(9); close(hf); hf=figure(9);
set(hf, 'position', [1          29        1008         776]);

% Bump activity
hsp(5) = subplot(6,1,5);
hbump = imagesc(session.results.wedge_neurons);
set(hbump, 'xdata', tw);
set(gca, 'ydir', 'normal');
axis tight;
xlabel('t');
ylabel('wedge neuron ID');
title('bump activity');
colorbar;


% Current injection to wedge neurons
hsp(3) = subplot(6,1,3);
hcurrents = imagesc(session.sim_conds.wedge_current_injection);
set(hcurrents, 'xdata', tw);
set(gca, 'ydir', 'normal');
axis tight;
%xlabel('t');
ylabel('wedge neuron ID');
title('current injection into wedge neurons');
colorbar;


% Visual input
hsp(1) = subplot(6,1,1);
if session.parameters.inputs.input_is_excitatory_1_inhibitory_m1 > 0
    input_signal = session.sim_conds.visual_input_neurons;
elseif session.parameters.inputs.input_is_excitatory_1_inhibitory_m1 < 0
    input_signal = -session.sim_conds.visual_input_neurons;
end

hinputs = imagesc(input_signal);
set(hinputs, 'xdata', tw);
set(gca, 'ydir', 'normal');
axis tight;
%xlabel('t');
ylabel('input neuron ID');
title('input current from ring neurons');
colorbar;


% Velocity signal
hsp(2) = subplot(6,1,2);

%hvel = plot(session.sim_conds.t + tw(1), session.sim_conds.vel, 'r');
%xlim(session.sim_conds.t([1 end])+tw(1));
%grid on;

epg=session.results.wedge_neurons;
tmp=(epg([end,1:end-1],:) - epg([2:end, 1],:))/2;
vel_signal = session.sim_conds.vel;
vel = vel_signal*session.parameters.ring_attractor.n_wedge_neurons/2/pi; % discretization scaling
vel = repmat( vel  ,  size(tmp,1), 1);
turning_signal = vel.*tmp; % calculate turning_signal at a given moment;
hvelimg=imagesc(turning_signal);
set(hvelimg, 'xdata', tw); axis tight;

%tstmp = turning_signal(:, ceil(end/2):end);
%set(gca, 'clim', [min(tstmp(:)), max(tstmp(:))]);


set(gca, 'ydir', 'normal');
%xlabel('t');
ylabel('velocity (motor)');
title('velocity (motor from P-EN, not visual) signal');
colorbar;





% Total input
hsp(4) = subplot(6,1,4);
img = zeros(session.parameters.ring_attractor.n_wedge_neurons,  numel(session.results.t) );
for ti = 1:numel(session.results.t)
    e = session.results.W_input(:,:,ti);
    we = reshape(e, session.parameters.ring_attractor.n_wedge_neurons, session.parameters.inputs.n_input_nodes);
    img(:,ti) = we * input_signal(:,ti);
end
hinputs = imagesc(img+session.sim_conds.wedge_current_injection+turning_signal);
set(hinputs, 'xdata', tw);
set(gca, 'ydir', 'normal');
axis tight;
%xlabel('t');
ylabel('wedge neuron ID');
title('total input (weighted input from visual input + velocity (motor) + current injection)');
colorbar;








for wdti = 1:nt
    t = W_display_times(wdti);
    if t>max(session.results.t)
        t = max(session.results.t);
    end
    idx = find(session.results.t <= t, 1, 'last');
    e = session.results.W_input(:,:,idx);
    we = reshape(e, session.parameters.ring_attractor.n_wedge_neurons, session.parameters.inputs.n_input_nodes);

    
    
    
    hs(wdti)=subplot(6,nt,5*nt+wdti);
    imagesc(we);
    clim(wdti,:) = get(gca, 'clim');
    set(gca, 'ydir', 'normal');
    xlabel('input neuron ID');
    ylabel('wedge neuron ID');
    title({['input to wedge weights'],[ 'time = ' num2str(t) 's']});
    colorbar;



if session.parameters.inputs.use_2D_input
    hf2=figure(10+wdti); close(hf2); hf2=figure(10+wdti);
    set(hf2, 'position', [630+60*(wdti-1)   124-15*(wdti-1)   240   680]);
    W = e;
    for i = 1:8
        subplot(8,1,i);
        imagesc(reshape(W(i*4,:), session.parameters.inputs.n_input_elevation, session.parameters.inputs.n_input_azimuth));
        title({['input to wedge:' num2str(i*4)],[ 'time = ' num2str(t) 's']});
    end
    figure(hf);
end    


end
%model_param.W_input-we

clll = [min(clim(:,1)), max(clim(:,2))];
for hi = 1:numel(hs)
    set(hs(hi), 'clim', clll);
end


linkaxes(hsp, 'x');



drawnow;


if exist('myPrint.m', 'file')
    fn = [filename '.pdf'];
    myPrint('print_pdf',hf, fn, [15 11], 'inches');
end


return;



%% For debug
for idx = 1:100:8000
    e = session.results.W_input(:,:,idx);
    
    if exist('dW_input_dt', 'var')
        e = dW_input_dt;
    end
    
    figure(100);
    set(gcf, 'position', [630   124   500   680]);
    W = e;
    for i = 1:8
        subplot(8,1,i);
        imagesc(reshape(W(i*4,:), session.parameters.inputs.n_input_elevation, session.parameters.inputs.n_input_azimuth));
        colorbar;
        %title({['input to wedge:' num2str(i*4)],[ 'time = ' num2str(t(idx)) 's']});
    end
    drawnow;
    pause;
end

