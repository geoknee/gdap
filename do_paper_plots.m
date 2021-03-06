cd ../cvx
cvx_setup cvx_license;
cd ../CPTPprojection

global ensemble drange LIswitch ensemble_size Npows

%% Figure 2a,d of the main paper

ensemble = 'qp';
drange = [2:8];
LIswitch = 0;
ensemble_size = 10; % must be >1

generate_clicks;
launch_solvers;
make_plots; %won't work on r2015a
save('./benchmarking_results/qpPRLresubmission')

clear all;

%% Figure 2b of the main paper

ensemble = 'qp';
drange = [4:4];
LIswitch = 1;
ensemble_size = 10;
Npows = [1,2,3,4,5,6,7,8,Inf];
    
Ndependence_clicks;
Ndependence_launch_solvers;
Ndependence_make_plots;

clear all;

%% Figure 8a,d

ensemble = 'fr';
drange = [2:8];
LIswitch = 0;
ensemble_size = 10;

generate_clicks;
launch_solvers;
make_plots; %won't work on r2015a
save('./benchmarking_results/frPRLresubmission')
clear all;

%% Figure 8b 
ensemble = 'fr';
drange = [4];
LIswitch = 0;
ensemble_size = 10;
Npows = [1,2,3,4,5,6,7,8,Inf];

Ndependence_clicks;
Ndependence_launch_solvers;
Ndependence_make_plots;

clear all;

%% Figure 5

ensemble = 'qp';
drange = [7];
LIswitch = 1; % with
ensemble_size = 10;
Npows = [1,2,3,4,5,6,7,8,Inf];

Ndependence_clicks;
Ndependence_launch_solvers;
Ndependence_make_plots;

clear all;