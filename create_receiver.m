function [receiver] = create_receiver(path,cube,receiver)

if isempty(receiver.location)
    increments = receiver.increment;
    pad = cube.pad;
    dimensions = [cube.nx cube.ny cube.nz];
    min = (pad+1).*cube.res;
    max = (dimensions(2)+pad).*cube.res;
    depth = (dimensions(3)+3*pad).*cube.res; %reciever
    add=(max-min)/increments;
    row=1;
    depth = (dimensions(3)+3*pad).*cube.res;
    for k=1:increments;
        for l=1:increments;
            receiver.location(row,:)=[min+add.*l, min+add.*k, depth];
            row=row+1;
        end
    end
    receiver.location(4,:)=[];
    receiver.location(7,:)=[];
    receiver.location(10:14,:)=[];
    x = receiver.location;
    receiver.path = [path.main, filesep, 'receiver.dat'];
    save(receiver.path,'x','-ascii')
    
else
    error('This function is not ready for general receiver location')
end

end

