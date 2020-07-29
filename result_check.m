function result_check(session)

disp('checking values for the ring attractor');

tmp = sum(session.results.wedge_neurons(:,end));
S = session.parameters.ring_attractor.info.S;
n_wedge_neurons = session.parameters.ring_attractor.n_wedge_neurons;
disp(['S: ratio=' num2str(S/tmp) ', S_mean=' num2str(S/n_wedge_neurons) ', sum(activity)_mean=' num2str(tmp/n_wedge_neurons) ]);


A = session.parameters.ring_attractor.info.A;
omega = session.parameters.ring_attractor.info.omega;
phi = session.parameters.ring_attractor.info.phi;
Adm = 0;
for n = 0:n_wedge_neurons
    Adm = max(Adm, A*(  sin(omega * n - phi) + sin(phi)    )   );       % eq 13: Solution for the discrete model
end
tmp = max(session.results.wedge_neurons(:,end));
disp(['A: ratio=' num2str(Adm/tmp) ', ~2*A=' num2str(Adm) ', max(activity)=' num2str(tmp) ]);


 
