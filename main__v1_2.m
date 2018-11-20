clear
%% This file run sofi 3D and collect data for you  
%Edit: Dec 1, 2017 (Ken Ikeda, Eric Goldfarb), ver -1.1 (automatically add path and fix
%master directory)
%Edit Dec 12, 2017: Change json file directory to the working directory
%Edit Jan 19, 2018 (v1.2): Use python to SSH and get realtime output
% PLEASE USE SI UNITS
%%% Input
%Place your data as a SINGLE matlab variable file (*.m) that contain 'Vp',
%'Vs', and 'Rho' variable in the desired input folder
% Example   :   test_cube.m  should be placed in .\dataset and contains
%               Vp      100 x 100 x 100
%               Vs      100 x 100 x 100
%               den     100 x 100 x 100
%% Preset your Parameter
%%%%% Major Setting %%%%
filename = 'berea_model_1_40.mat';       %string specifies your file name [e.g. 'test_cube.m']
%path
path.UTEID = 'ejg2454';      % Your UT EID
path.main = 'S:\ejg2454\sofi3D\par\DRP\berea_1_40';
path.input = 'S:\ejg2454\sofi3D\par\DRP\berea_1_40';
path.output = 'S:\ejg2454\sofi3D\par\DRP\berea_1_40\output';
path.sofi = 'S:\Rock Deformation Lab\SOFI3D-master';
SSH_machine = 'seismic20.geo.utexas.edu';

%Physical properties of cube
cube.res = 40e-6;                   %Grid size [m]
cube.pad = 15;                      %Pad size (integer) [voxels]
%Finite Difference parameter
fd.spaceorder = 8;                %FD order [1, 2, 4, 8, 12]
fd.timeorder = 2;   
fd.timestep = 1e-9;               %time step [s]
fd.maxtime = 1e-6;                %time length [s]
%output plot
plottype = 'vz';                  %Choose from ['vx', 'vy', 'vz', 'curl', 'div', 'p'] 
%system config
core.NPROCX = 2;                  %leave it to [] if you want to use every possible core
core.NPROCY = 5;
core.NPROCZ = 1;

%%%% Minor setting (Do not change unless necessary) %%%%

source.shape = 1;           %ricker=1;fumue=2;from_SIGNAL_FILE=3;SIN**3=4
source.type = 4;            %explosive=1;force_in_x=2;in_y=3;in_z=4;custom=5;earthquake=6     %Change to 2 for S-wave along x-axis
source.location = [];
source.frequency = 2e6 ;     %[Hz] source frequency  
source.amplitude = 0.001;   %[m] source amplitude
source.increment = 100;

receiver.location = [];
receiver.increment = 4;
receiver.number = 9;

snapshot.snap = 0;               % = 1 if you want to take a snapshot
snapshot.Tsanp1 = 1e-12;
snapshot.Tsanp2 = 0.5e-5;
snapshot.Tsanpinc = 0.5e-6;
snapshot.idx = 1;
snapshot.idy = 1;
snapshot.idz = 1;
snapshot.snap_format = 3;
snapshot.snap_file = ' ';
snapshot.snap_plane = 2;
%% Calculation DO NOT MODIFY %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('S:\Rock Deformation Lab\SOFI3D-master')
% Examine cube
[cube] = examine_cube(cube, filename, path);
display('Finished examine_cube')
% Check number of core

% Write source file
[source] = create_source(path,cube,source);
display('Finished create_source')
% Write receiver file
[receiver] = create_receiver(path,cube,receiver);
display('Finished create_receiver')
% Create cube
create_cube(cube, path);
display('Finished create_cube')
% Write json
write_SOFI_json2(path,fd,cube,core,source,receiver,snapshot,filename);
display('Finished create_cube')

%% Run linux
path.sofi = '/home/p1/Rock_Deformation_Lab/SOFI3D-master';
path.main = strrep(path.main,['S:\', path.UTEID], ['/home/u1/', path.UTEID]);
path.main = strrep(path.main,'\','/');

command = ['module load openmpi && mpirun -np ', num2str(core.NPROCX*core.NPROCY*core.NPROCZ),' nice -19 ', path.sofi, '/','bin/sofi3D ', path.main, '/sofi3D.json | tee ', path.sofi, '/','par/in_and_out/sofi3D.jout'];

fileID = fopen('S:\Rock Deformation Lab\SOFI3D-master\command.txt','w');
fprintf(fileID,'%s\r\n',command);
fprintf(fileID,'%s\r\n',SSH_machine);
fprintf(fileID,'%s\r\n',path.UTEID);

fclose(fileID);

command_py = ['cd S:\Rock Deformation Lab\SOFI3D-master & python -u SSH_linux.py'];
system(command_py)
%% Read output and Plot Seismogram
[traces, stack] = get_seismograph(cube, path, fd, receiver, plottype);
trace_treshold = 150;
stack_treshold = 150;
[velocity, stack_velocity] = plot_seismograph(trace_treshold, stack_treshold, traces, stack, cube, fd, receiver, source);

