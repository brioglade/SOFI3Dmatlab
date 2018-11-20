function [] = display_all_seismograms(traces, x_time, varargin)
%Display first first 9 seismograms
%Input:     trace {9 x 1} contains a cell variable (output from main.m) 
%           x_axis [N x 1] contains x values for plotting (Time in [s])
%Optional   cube_lenght [1] the cube's length in the direction of propagation [m]
%           This will pull up the interactive velocity picking screen

%Example call:  display_single_seismogram(traces, plt_params.x_time, 150e-6)
%where traces = [0,0,0,0,1,2,3,2,-1,-5]  and x_time = [1,2,3,4,5,6,7,8,9,10]

if length(traces) > 9
    subplot_number = 9;
else
    subplot_number = length(traces);
end
if isempty(varargin)
    figure
    for i = 1:subplot_number
        subplot(3,3,i);
        h = plot(x_time,traces{i});
        set(h(1), 'LineWidth', 2);
        title(['traces: ', num2str(i)]);
        xlabel('Time (s)')
        ylabel('Amplitude (m)')
        set(gcf,'color','w');
    end
    suptitle('Individual seismogram plot')
else
    velocity_lable = varargin{1}./x_time;
    velocity_lable(1) = NaN;
    
    figure
    for i = 1:subplot_number
        subplot(3,3,i);
        h = plot3(x_time, traces{i}, velocity_lable, 'LineWidth', 2);
        set(h(1), 'LineWidth', 2);
        title(['traces: ', num2str(i)]);
        xlabel('Time (s)')
        ylabel('Amplitude (m)')
        set(gcf,'color','w');
        view([0 90])
    end
    suptitle(['Individual seismogram plot [velocity in m/s]: L = ',num2str(varargin{1}), ' m'])
end

end

