function [cube] = examine_cube(cube, filename, path)
%% load data 
load([path.input, filesep, filename])
cube.Vp = Vp;       cube.Vs = Vs;       cube.Rho = den;
cube.name = strrep(filename,'.mat','');

%Check Unit
if mean(cube.Vp(:)) < 100
    error(' YOUR Vp is probably in the wrong unit: Vp need to be in [m/s]' )
elseif mean(cube.Vs(:)) < 100
    error(' YOUR Vs is probably in the wrong unit: Vs need to be in [m/s]' )
elseif mean(cube.Rho(:)) < 5
    error(' YOUR Den is probably in the wrong unit: Vp need to be in [kg/m^3]' )
end    

%Examine cube dimension
cube.nx = size(Vp,1) ;       cube.ny = size(Vp,2);      cube.nz = size(Vp,3);


end

