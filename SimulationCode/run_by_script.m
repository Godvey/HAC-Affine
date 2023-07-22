%% Delay & contoller setting
delays = [0.01, 0.1, 0.5, 1];
kp = 1;
kv = 10;
kbeta = 1.5;
% note: if you need to design leaders acceration, please go to Initial_Parameters.m
% furthermore you can design it with simulink file in "Leaders Acceration Design" Block.

%% Run Simulation
simtime = 50;
simstep = 0.01;

% begin simulation
out = [];
for delay = delays
    option = simset('fixedstep',simstep);
    out = [out sim('affine_double_integrator.slx', [0, simtime], option)];
    tout = out.tout;
end

%% figure
addpath("FigureUtility/")
set(0,'defaultfigurecolor','w');
figure('Name','SineSweep','Units','centimeters', 'Pos',[1 1 40 25], 'Name', "Result");
tg = uitabgroup;
fig_gitplotTra;
fig_norm_err(out, tout, tg, delays);
fig_approximate_ideal(out, out(1).ideal, tout, tg, delays);
fig_compare_hac_nohac(out, tout, delays, tg);
calculate_cohesiveness;

%% end
clear;