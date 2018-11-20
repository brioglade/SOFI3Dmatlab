function [core] = define_core(core, SSH_machine_num, cube)
%Get core and SSH machine number and return the maximum number of cores
%that could be used for the simulation 

%Create a container map for core list
keySet = [1 ,2 ,3 ,4, 5, 6, 7, 8, 9, 10, 18 ,19 ,20, 23];
valueSet = [16, 16, 16, 16, 16, 16, 16, 8, 8, 8, 24, 24, 24, 24];
M = containers.Map(keySet,valueSet);

if ~ismember(SSH_machine_num, keySet)
    error("Your machine is not on the list, Please manually define the core number")
end

if isempty(core.NPROCX)
    try
        [maxLength, idx] = max([cube.nx+2*cube.pad, cube.ny+2*cube.pad, cube.nz+4*cube.pad]);
        factorNx = 1:cube.nx+2*cube.pad;       factorNx = factorNx(rem(cube.nx+2*cube.pad,1:cube.nx+2*cube.pad)==0);     factorNx(factorNx > M(SSH_machine_num)) = [];
        factorNy = 1:cube.ny+2*cube.pad;       factorNy = factorNy(rem(cube.ny+2*cube.pad,1:cube.ny+2*cube.pad)==0);     factorNy(factorNy > M(SSH_machine_num)) = [];
        factorNz = 1:cube.nz+4*cube.pad;       factorNz = factorNz(rem(cube.nz+4*cube.pad,1:cube.nz+4*cube.pad)==0);     factorNz(factorNz > M(SSH_machine_num)) = [];

        [X,Y,Z] = ndgrid(factorNx, factorNy, factorNz);
        A = [X(:), Y(:), Z(:), X(:).*Y(:).*Z(:)];
        A(A(:, 4) > M(SSH_machine_num), :) = [];
        B = A;
        %Remove 1s
        A(A(:, 1) == 1, :) = [];     A(A(:, 2) == 1, :) = [];      A(A(:, 3) == 1, :) = [];
        
        if size(A,1) == 0
           %special case where an axis (or axes) could not be discretized    
           %Remove options that contain two 1s (Two axes that are not discretizable). 
           B(sum(B == 1, 2) >= 2, :) = [];
           
           B =  sortrows(B, 4, 'descend');  
           maxCore = B(1, 4);
           B(B(:, 4) < maxCore, :) = [];   
           B = sortrows(B, idx, 'descend');
           
           core.NPROCX = B(1, 1);  core.NPROCY = B(1, 2);    core.NPROCZ = B(1, 3);
           
           return 
        end
        
        A = sortrows(A, 4, 'descend' );

        maxCore = A(1, 4);
        A(A(:, 4) < maxCore, :) = [];

        A = sortrows(A, idx, 'descend');

        core.NPROCX = A(1, 1);  core.NPROCY = A(1, 2); core.NPROCZ = A(1, 3);
    catch
        warning("define_core cannot discretize your domain");
        core.NPROCX = 1;  core.NPROCY = 1; core.NPROCZ = 1;
    end
end
end 