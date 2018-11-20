# SOFI3Dmatlab
Matlab codes/functions which controls SOFI3D. 

SOFI3D is a finite-difference numerical simulation code which solves the elastic wave equation. The code is distributed here:https://git.scc.kit.edu/GPIAG-Software/SOFI3D. 

We write a personal MATLAB code which control SOFI3D from Windows. The codes take care of converting matlab variable to SOFI3D formats. After the simulation, they also convert SOFI3D outputs, mainly seismograms, into matlab variables.   

List of functions:

1. examine_cube()
Check the input cubes including velocities and density arrays. Return dimension of the cubes. 

2. define_core()
Link to pre-determined seismic machines specifications. If core.NPROX, core.NPROY, and core.NPROZ are not defined, the function will parallelize the computaion using the maximum available number of cores in a specified machine number.

3. create_source()
Write a source file.

4. create_receiver()
Write a receiver file.

5. create_cube()
Write input files for SOFI3D. 

6. write_SOFI_json2()
Write json file for SOFI3D. 

7. SSH_linux.py [NOT UPLOADED HERE!!]
Take care of ssh process. 
