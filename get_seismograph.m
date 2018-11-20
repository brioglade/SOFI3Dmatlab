function [traces, stack] = get_seismograph(cube, path, fd, receiver, plottype)
%Get seismograph and remove pad. Then save output as a cell variable in you ouput folder

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
shift_time = shift_distance/5.9835e+03;         %Quartz velocity = 59835 m/s
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

%x-axis



end

