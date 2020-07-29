function [P,N] = half_wave_rectify(X)
P=X;
N=X;
P(P<0)=0;
N(N>0)=0;
N=-N;

