clear
clc
%% This file run sofi 3D and collect data for you  %%
%Edit: Dec 1, 2017 (Ken Ikeda, Eric Goldfarb), ver -1.1 (automatically add path and fix
%master directory)
%Edit Dec 12, 2017: Change json file directory to the working directory
%Edit Jan 19, 2018 (v1.2): Use python to SSH and get realtime output
%Edit Feb 7, 2018: (v2.0): Major revision   
%                          1. Export ALL seismograms to .mat file  
%                          2. Interactive picking 
%Editt Mar 26, 2018: (v2.1)1. Debug for seismmic 1 -5, 7 which use Redhat7
%                            --> Need different SOFI directory
%                          2. Change SSH machine's input to a number
%                          (integer)
%                          3. path.sofi is now permanent. 
%Edit Oct 9, 2018: (v2.2) 1. RedHat 6 is no longer support --> move everything to RedHat 7  
% PLEASE USE SI UNITS %

%%% Input %%%
%Place your data as a SINGLE matlab variable file (*.m) that contain 'Vp',
%'Vs', and 'Rho' variable in the desired input folder
% Example   :   test_cube.m  should be placed in .\dataset and contains
%               Vp      100 x 100 x 100
%               Vs      100 x 100 x 100
%               den     100 x 100 x 100
%% Preset your Parameter
%%%%% Major Setting %%%%
filename = 'qtzCube.mat';       %string specifies your file name [e.g. 'test_cube.m']
%path
path.UTEID = 'ki2844';      % Your UT EID
path.main = 'S:\Rock Deformation Lab\SOFI3D-master-Redhat7\Test_data';
path.input = 'S:\Rock Deformation Lab\SOFI3D-master-Redhat7\Test_data\Qtz_cube';
path.output = 'S:\Rock Deformation Lab\SOFI3D-master-Redhat7\Test_data\Qtz_cube\SOFImatlabOUTPUT\P-wave';
SSH_machine_num = 1;                %An interger 

%Physical properties of cube
cube.res = 40e-6;                   %Grid size [m]
cube.pad = 15;                      %Pad size (integer) [voxels]
%Finite Difference parameter
fd.spaceorder = 8;                %FD order [1, 2, 4, 8, 12]
fd.timeorder = 2;   
fd.timestep = 1e-9;               %time step [s]
fd.maxtime = 1e-6;                %time length [s]
%Simulation
simulation = 'P';                  %Choose from ['P','Sx','Sy']
%system config
core.NPROCX = [];                 
core.NPROCY = [];
core.NPROCZ = [];


%%%% Minor setting (Do not change unless necessary) %%%%
source.shape = 1;           %ricker=1;fumue=2;from_SIGNAL_FILE=3;SIN**3=4
%explosive=1;force_in_x=2;in_y=3;in_z=4;custom=5;earthquake=6  
if simulation == 'P'
    source.type = 4;
elseif simulation == 'Sx' 
    source.type = 2;
elseif simulation == 'Sy'
    source.type = 3;
end

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculation DO NOT MODIFY %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Preset SOFI 3D path

%Redhat7 workstation
addpath('S:\Rock Deformation Lab\SOFI3D-master-Redhat7');
path.sofi = 'S:\Rock Deformation Lab\SOFI3D-master-Redhat7';
SSH_machine = ['seismic',int2str(SSH_machine_num),'.geo.utexas.edu'];

% Examine cube
[cube] = examine_cube(cube, filename, path);
display('Finished examine_cube')
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
display('Finished Writing Jason')

%% Run linux
path.sofi = '/home/p1/Rock_Deformation_Lab/SOFI3D-master-Redhat7';

path.main = strrep(path.main,['S:\', path.UTEID], ['/home/u1/', path.UTEID]);
path.main = strrep(path.main,'\','/');

command = ['module load openmpi && nice +20 mpirun -np ', num2str(core.NPROCX*core.NPROCY*core.NPROCZ),' nice -19 ', path.sofi, '/','bin/sofi3D ', path.main, '/sofi3D.json | tee ', path.sofi, '/','par/in_and_out/sofi3D.jout'];

fileID = fopen('S:\Rock Deformation Lab\SOFI3D-master\command.txt','w');
fprintf(fileID,'%s\r\n',command);
fprintf(fileID,'%s\r\n',SSH_machine);
fprintf(fileID,'%s\r\n',path.UTEID);

fclose(fileID);

command_py = ['cd S:\Rock Deformation Lab\SOFI3D-master & python -u SSH_linux.py'];
system(command_py)
% Export Seismogram and Plot output
[plt_params] = export_seismograph(cube, path, fd, receiver);


%% Display command (Choose one) --> Please manually load the data becuase I don't know which traces do you want to plot!!!
%%%%% Display a single seismogram | specify domain length for velocity picking 
% display_single_seismogram(stack, plt_params.x_time, plt_params.cube_Lz)

%%%%% Display 9 seismograms | specify domain length for velocity picking 
% display_all_seismograms(traces, plt_params.x_time, plt_params.cube_Lz)

%%%%% Automatic picking (Goldfarb, 2017) --> graph with autopick  
%trace_treshold = 150;
%stack_treshold = 150;
%display_seismogram_pick(trace_treshold, stack_treshold, traces, stack, plt_params);
