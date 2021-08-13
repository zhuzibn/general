%this script plots the domain wall based on input file in the OVF format
%which can be generated by softwares linke mumax3 etc.
clear all;close all;clc
%% values can be tuned for visualization
%interval of plot along x direction, 
%e.g., if xmesh=512 and xplotstep=32, then m is plotted as #1,17, 33...
%along the horizontal direction
xplotstep=32;
%interval of plot along y direction
%e.g., if ymesh=30 and yplotstep=6, then m is plotted as #1,6, 11...
%along the longitudinal direction
yplotstep=6;
plot2dflg=1;%plot DW in 2D
plot3dflg=0;%plot DW in 3D
scale2d=0.3;%scale factor of the arrow size in 2D plot
scale3d=1;%scale factor of the arrow size in 3D plot
%% values from mx3 file
xmesh=512;%command gridsize(xmesh,ymesh,zmesh) in mumax3
ymesh=30;
zmesh=1;
cellsizex=4;%command setcellsize(cellsizex,cellsizey,cellsizez) in mumax3
cellsizey=4;
%% processed values for visualization, don't modify
xmin=0;
ymin=0;
xmax=xmesh*cellsizex;
ymax=ymesh*cellsizey;
xmaxplot=ymax*2;%2 is an arbitary number, just to show x size is larger than y
ymaxplot=ymax;
xscal=xmax/xmaxplot;
yscal=ymax/ymaxplot;
%% load the data
if (1)
    % Read the file
    fid = fopen('relaxed_m.ovf','r');
    str = textscan(fid,'%s','Delimiter','\n');
    fclose(fid);
    % skip the first 29 lines and load the rest data
    % you might need to check if other softwares is also 29 lines
    str2 = str{1}(30:xmesh*ymesh*zmesh+29);
    % Save as a text file
    fid2 = fopen('test.txt','w');
    fprintf(fid2,'%s\n', str2{:});
    fclose(fid2);
end
dattt=importdata('test.txt');
delete test.txt

%% plott
dwplot(xmesh,ymesh,zmesh,xmin,xmaxplot,cellsizex,xplotstep,ymin,ymaxplot,cellsizey,yplotstep,dattt,plot2dflg,plot3dflg,scale2d,scale3d)
if plot2dflg
    view(0,90)
    txt = ['length(nm) x ',num2str(xscal)];
    xlabel(txt);ylabel('width(nm)');
    xlim([xmin xmaxplot]);ylim([ymin ymaxplot]*1.2);
elseif plot3dflg
    figure;
    quiver3(X,Y,Z,u,v,k,scale3d)
end