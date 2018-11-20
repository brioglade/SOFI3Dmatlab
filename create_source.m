function [source] = create_source(path,cube,source)

if isempty(source.location)
    pad = cube.pad;
    increments = source.increment;
    dimensions = [cube.nx cube.ny cube.nz];
    min = (pad+1).*cube.res;
    max = (dimensions(2)+pad).*cube.res;
    depth = min; %source
    add=(max-min)/increments;
    td=0;
    fc = source.frequency;
    amp = source.amplitude;
    row=1;
    col2=min;
    for k=1:increments;
        for l =1:increments;
            sources(row,:)=[min+add.*l, min+add.*k, depth, td, fc, amp];
            row=row+1;
        end
    end
    source.path = [path.main,filesep,'sources.dat'];
    save(source.path,'sources','-ascii')
else
    error('This function is not ready for general source location')
end

end

