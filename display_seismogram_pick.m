function [] = display_seismogram_pick(trace_treshold, stack_treshold, traces, stack, plt_params)
%Plot seismograph with picking and error bar 

for i = 1:length(traces)
    [breaks,~]=findchangepts(traces{i},'MaxNumChanges',trace_treshold);
    first_arrival.idx(i) = breaks(1);
    first_arrival.time(i) = breaks(1)*(plt_params.x_time(2) - plt_params.x_time(1));
    velocity(i) = plt_params.cube_Lz/first_arrival.time(i);
end

[breaks,~]=findchangepts(stack,'MaxNumChanges',stack_treshold);
stack_first_arrival.idx = breaks(1);
stack_first_arrival.time = breaks(1)*(plt_params.x_time(2) - plt_params.x_time(1));
stack_velocity = plt_params.cube_Lz/stack_first_arrival.time;


%Plot output


%Individual plot [Plot first 9 seismograms]
if length(traces) > 9
    subplot_number = 9;
else
    subplot_number = length(traces);
end

figure

for i = 1:subplot_number
    subplot(3,3,i);
    h = plot(plt_params.x_time,traces{i}, first_arrival.time(i),0,'rx');
    set(h(1), 'LineWidth', 2);
    title(['traces: ', num2str(i), ' v = ', num2str(velocity(i)), ' m/s']);
    xlabel('Time (s)')
    ylabel('Amplitude (m)')
    set(gcf,'color','w');
end
suptitle('Individual seismogram plot')

%stack plot
figure
hold on
plot(plt_params.x_time, stack, 'LineWidth', 2);
plot(stack_first_arrival.time, 0,'rx', 'LineWidth', 2);
errorbar(stack_first_arrival.time, 0, std(first_arrival.time),'horizontal');
    
title({['stack seismogram: velocity = ',num2str(round(stack_velocity)), ' m/s', ' L = ', num2str(plt_params.cube_Lz), ' m']})
xlabel('Time (s)')
ylabel('Amplitude')
set(gcf,'color','w');
set(gca,'FontSize',14);
hold off


end

