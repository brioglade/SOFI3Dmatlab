function [] = create_cube(cube, path)

bulk=[36*1e9,1.01e6 ];
shear=[44*1e9,0];
rhoqz=2650;


vpair=330;
vsair=0;
rhoair=1;
Vp = cube.Vp;
Vs = cube.Vs;
den = cube.Rho;
sizes=size(Vp);

rhoqz=2650;
vpqz=((bulk(1)+(4./3).*shear(1))./rhoqz).^.5;
vsqz=(shear(1)/rhoqz).^.5;

padx=cube.pad;
pady=cube.pad;
padz=cube.pad;

vptop=ones(sizes(1),sizes(2),padz).*vpqz;
vstop=ones(sizes(1),sizes(2),padz).*vsqz;
rhotop=ones(sizes(1),sizes(2),padz).*rhoqz;



vp_new=ones(size(Vp)+[padx*2 pady*2 padz*4]).*vpair;
vp_new(padx+1:end-padx,pady+1:end-pady,padz*2+1:end-padz*2)=Vp;
vp_new(padx+1:end-padx,pady+1:end-pady,padz+1:padz*2)=vptop;
vp_new(padx+1:end-padx,pady+1:end-pady,end-padz*2+1:end-padz)=vptop;
vp_new(isnan(vp_new))=vpair;
Vp=vp_new;
%
vs_new=ones(size(Vs)+[padx*2 pady*2 padz*4]).*vsair;
vs_new(padx+1:end-padx,pady+1:end-pady,padz*2+1:end-padz*2)=Vs;
vs_new(padx+1:end-padx,pady+1:end-pady,padz+1:padz*2)=vstop;
vs_new(padx+1:end-padx,pady+1:end-pady,end-padz*2+1:end-padz)=vstop;
vs_new(isnan(vs_new))=vsair;
Vs=vs_new;

rho_new=ones(size(den)+[padx*2 pady*2 padz*4]).*rhoair;
rho_new(padx+1:end-padx,pady+1:end-pady,padz*2+1:end-padz*2)=den;
rho_new(padx+1:end-padx,pady+1:end-pady,padz+1:padz*2)=rhotop;
rho_new(padx+1:end-padx,pady+1:end-pady,end-padz*2+1:end-padz)=rhotop;
rho_new(isnan(rho_new))=rhoair;
Rho=rho_new;




fid=fopen(sprintf([strrep(path.input,'\','\\'),'\\',cube.name,'.rho']),'w');
fwrite(fid,Rho,'float');
fclose(fid);

fid=fopen(sprintf([strrep(path.input,'\','\\'),'\\',cube.name,'.vp']),'w');
fwrite(fid,Vp,'float');
fclose(fid);

fid=fopen(sprintf([strrep(path.input,'\','\\'),'\\',cube.name,'.vs']),'w');
fwrite(fid,Vs,'float');
fclose(fid);

end

