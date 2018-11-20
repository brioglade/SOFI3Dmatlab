function [] = display_single_seismogram_pick(treshold, trace, plt_params)
%Plot seismograph with picking and error bar 


[breaks,~]=findchangepts(trace,'MaxNumChanges',treshold);
stack_first_arrival.idx = breaks(1);
stack_first_arrival.time = breaks(1)*(plt_params.x_time(2) - plt_params.x_time(1));
stack_velocity = plt_params.cube_Lz/stack_first_arrival.time;


%Plot output
figure
hold on
plot(plt_params.x_time, trace, 'LineWidth', 2);
plot(stack_first_arrival.time, 0,'rx', 'LineWidth', 2);
errorbar(stack_first_arrival.time, 0, std(first_arrival.time),'horizontal');
    
title({['stack seismogram: velocity = ',num2str(round(stack_velocity)), ' m/s', ' L = ', num2str(plt_params.cube_Lz), ' m']})
xlabel('Time (s)')
ylabel('Amplitude')
set(gcf,'color','w');
set(gca,'FontSize',14);
hold off


end

