function [velocity, stack_velocity] = plot_seismograph(trace_treshold, stack_treshold,traces, stack, cube, fd, receiver, source)

%Parameter
shift_distance = (2*cube.pad - 1)*cube.res;
shift_time = shift_distance/5.9835e+03;         %Quartz velocity = 59835 m/s
block_time = (fd.maxtime/length(traces{1}));    %Time for 1 grid
shift_block = round(shift_time/block_time);

%Pick first arrival
first_arrival.idx = zeros(receiver.number,1);
first_arrival.time = zeros(receiver.number,1);

for i = 1:receiver.number
    [breaks,~]=findchangepts(traces{i},'MaxNumChanges',trace_treshold);
    first_arrival.idx(i) = breaks(1);
    first_arrival.time(i) = breaks(1)*block_time;
    velocity(i) = cube.nz*cube.res/first_arrival.time(i);
end



[breaks,~]=findchangepts(stack,'MaxNumChanges',stack_treshold);
stack_first_arrival.idx = breaks(1);
stack_first_arrival.time = breaks(1)*block_time;
stack_velocity = cube.nz*cube.res/stack_first_arrival.time;


%Plot output
x_time = [0:block_time:fd.maxtime];
x_time = x_time(1:length(traces{i}));

%Individual plot [Plot first 9 seismograms]
if receiver.number > 9
    subplot_number = 9;
else
    subplot_number = receiver.number;
end

figure

for i = 1:subplot_number
    subplot(3,3,i);
    h = plot(x_time,traces{i}, first_arrival.time(i),0,'rx');
    set(h(1), 'LineWidth', 2);
    title(['traces: ', num2str(i), ' v = ', num2str(velocity(i)), ' m/s']);
    xlabel('Time (s)')
    ylabel('Amplitude (m)')
    set(gcf,'color','w');
end
title('Individual seismogram plot')

%stack plot
figure
hold on
plot(x_time, stack, 'LineWidth', 2);
plot(stack_first_arrival.time, 0,'rx', 'LineWidth', 2);
errorbar(stack_first_arrival.time, 0, std(first_arrival.time),'horizontal');
%Check source type (P [z-direcion] or S [x-direction])
if source.type == 4
    s = 'P-wave';
elseif source.type == 2
    s = 'S-wave [x-direction]';
elseif source.type == 3
    s = 'S-wave [y-direction]';
else
    s = [];
end
    
title({['stack seismogram: velocity = ',num2str(round(stack_velocity)), ' m/s'], s})
xlabel('Time (s)')
ylabel('Amplitude')
set(gcf,'color','w');
set(gca,'FontSize',14);
hold off


end

