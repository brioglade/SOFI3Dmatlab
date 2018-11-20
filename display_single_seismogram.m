function [] = display_single_seismograph(trace, x_time, varargin)
%Display single seismograph.
%Can use hold on to overlay plots.
%Input:     trace [N x 1] contains a seismic trace 
%           x_axis [N x 1] contains x values for plotting (Time in [s])
%Optional   cube_lenght [1] the cube's length in the direction of propagation [m]
%           This will pull up the interactive velocity picking screen

%Example call:  display_single_seismogram(stack, plt_params.x_time, 150e-6)
%where traces = [0,0,0,0,1,2,3,2,-1,-5]  and x_time = [1,2,3,4,5,6,7,8,9,10]

if ~isempty(varargin)
    velocity_lable = varargin{1}./x_time;
    velocity_lable(1) = NaN;
    figure();
    plot3(x_time, trace, velocity_lable, 'LineWidth', 2);
    title({['Seismogram: L = ',num2str(varargin{1}), ' m']});
    xlabel('Time (s)')
    ylabel('Amplitude')
    set(gcf,'color','w');
    set(gca,'FontSize',14);
    view([0 90])
else
    figure();
    h = plot(x_time, trace, 'LineWidth', 2);
    title('Seismogram')
    xlabel('Time (s)')
    ylabel('Amplitude')
    set(gcf,'color','w');
    set(gca,'FontSize',14);
end

end

