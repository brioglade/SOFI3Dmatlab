function [plt_params] = export_seismograph(cube, path, fd, receiver)
%Get seismograph and remove pad. Then, save to .mat file
%Output     plt_params: structure variable contains plotting params 
%           plt_params.x_time   x-axis of the seismogram
%           plt_params.cube_nx  Number of voxel in x direction (same as ny and nz)
%           plt_params.cube_Lx  Length of the domain [m] in x direction (same as Ly and Lz)
%All traces (vx, vy, vz, curl, div, p) and plt_params [.mat file] are saved in the output folder.

name = {'vx', 'vy', 'vz', 'curl', 'div', 'p'};
for i = 1:length(name)
    plottype = name{i};
    %Read the correspond data
    fid=fopen([path.output, filesep, cube.name, '_', plottype,'.bin']);
    data=fread(fid,'float');
    fclose(fid);
    
    %Split data into several seismic traces
    traces = {};
    for i = 1:receiver.number
        traces{i} = data((i-1)*length(data)/receiver.number+1:i*length(data)/receiver.number);
    end
    
    %Remove time from padding (i.e. shift each seismic trace to the left)
    shift_distance = (2*cube.pad - 1)*cube.res;
    shift_time = shift_distance/5.9835e+03;         %Quartz velocity = 5983.5 m/s
    block_time = (fd.maxtime/length(traces{1}));    %Time for 1 grid
    shift_block = round(shift_time/block_time);
    for i = 1:receiver.number
        x = traces{i};
        x(1:shift_block) = [];
        traces{i} = x;
    end
    save([path.output, filesep, 'trace_output_corrected_', plottype, '.mat'], 'traces')
    %stack
    stack = zeros(length(traces{1}) , 1);
    for i = 1:receiver.number
        stack = stack + traces{i};
    end
    save([path.output, filesep, 'stack_output_corrected_', plottype, '.mat'], 'stack')
end

%Plt_params
plt_params.x_time = [0:block_time:fd.maxtime];
plt_params.x_time = plt_params.x_time(1:length(traces{1}));
plt_params.cube_nx = cube.nx;
plt_params.cube_ny = cube.ny;
plt_params.cube_nz = cube.nz;
plt_params.cube_Lx = cube.nx*cube.res;
plt_params.cube_Ly = cube.ny*cube.res;
plt_params.cube_Lz = cube.nz*cube.res;


save([path.output, filesep, 'plt_params', '.mat'], 'plt_params')
end

