%%
% Conversion of continuous parameters into discrete parameters
% and check the stability of parameters
%
% See the Supplimentary Materials of Kim et al. 2017 Science paper for the
% equation numbers cited in this script.


%% Conversion to discrete space
m = n_wedge_neurons/2/pi*bump_width; % Number of active wedges

c2d_scalar = 2*pi/n_wedge_neurons;
D = D_cont  /  c2d_scalar^2;
alpha_ = (sin(pi/(m-0.5+2))*2)^2*D+1; %-0.5 is to ensure that the m is between m-0.5 and m+0.5
beta_discrete = beta_cont  *  c2d_scalar;


% % %% Parameters used in the paper (continuous system)
% D_cont = 0.1;
% beta_cont = 20;
% D = D_cont  /  c2d_scalar^2;
% alpha = 3;
% beta = beta_cont *  c2d_scalar;



%% Discrete system solution
omega = asin( sqrt((alpha_-1)/D) / 2 ) *2;           % eq.14
M_range = [2*pi/omega - 2,  2*pi/omega - 1];        % eq 18
M = ceil(M_range(1));                               % discrete variable
phi = atan( sin( (M+1)*omega )  /(  cos( (M+1)*omega ) - 1    ) ); % eq 19
tmp = (1-alpha_)*sin(phi) + beta_discrete*(  sin(omega)*cos(phi)/(1-cos(omega)) + (M+1)*sin(phi) );
beta_min =  (alpha_-1)*sin(phi)  / (  sin(omega)*cos(phi)/(1-cos(omega)) + (M+1)*sin(phi) );
beta_min_cont = beta_min / c2d_scalar;
A = 1/tmp;                                          % eq 21 : Amplitude
S = A* (   sin(omega)*cos(phi)/(1-cos(omega)) + (M+1)*sin(phi)   ); % eq 20 : Total activity

disp('=================================');
if beta_cont < beta_min_cont
    disp(['beta_cont must be at least ' num2str(beta_min_cont)]);
    error('beta_cont is too small');
end


%% check the condition
clear asrt;
tol = 0.0000000001;
asrt(1) = abs(2*sin(omega/2) - sqrt((alpha_-1)/D)) < tol;       % eq 14
asrt(end+1) = abs(A*(alpha_-1)*sin(phi) - (beta_discrete*S-1))  < tol;       % eq 15 % This is not right... 
asrt(end+1) = D*A*(sin(omega-phi) + sin(phi)) - (beta_discrete*S-1) < 0;    % eq 16
asrt(end+1) = abs(sin( (M+1)*omega - phi) + sin(phi)) < tol;       % eq 17

%% condition for the solution to exist
tmp1 = 2*(1-cos(2*pi/n_wedge_neurons));
tmp2 = (alpha_-1)/D;
asrt(end+1) = tmp1<tmp2;
asrt(end+1) = tmp2<4;
asrt(end+1) = A>0;

if sum(asrt)==numel(asrt)
    disp('Stable condition for the ring attractor was confirmed');
else
    disp('NOT STABLE');
end


 

