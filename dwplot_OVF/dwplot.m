%plot the 2D domain wall
%xmesh,ymesh,zmesh: %command gridsize(xmesh,ymesh,zmesh) in mumax3
%xmin: starting point, value,[nm], normally set to 0
%xmax=xmesh*cellsizex;
%ymin: starting point, value,[nm], normally set to 0
%ymax=ymesh*cellsizey;
%cellsizex,cellsizey %command setcellsize(cellsizex,cellsizey,cellsizez) in mumax3
%dattt: input data, spatial information of magnetization, n-by-3 matrix
%xplotstep
%yplotstep
%plot2dflg: plot DW in 2D
%plot3dflg
%scale2d: scale factor of the arrow size in 2D plot
%scale3d
function [X,Y,Z,u,v,k]=dwplot(xmesh,ymesh,zmesh,xmin,xmax,cellsizex,xplotstep,ymin,ymax,cellsizey,yplotstep,dattt,plotip,plot2dflg,plot3dflg,scale2d,scale3d)
if ~(mod(xmesh,xplotstep)==0)
    error('xmesh need to be integer times of xplotstep')
end
if ~(mod(ymesh,yplotstep)==0)
    error('ymesh need to be integer times of yplotstep')
end
u=(reshape(dattt(:,1),[xmesh,ymesh]))';
u=u(1:yplotstep:end,1:xplotstep:end);
v=(reshape(dattt(:,2),[xmesh,ymesh]))';
v=v(1:yplotstep:end,1:xplotstep:end);
k=(reshape(dattt(:,3),[xmesh,ymesh]))';
k=k(1:yplotstep:end,1:xplotstep:end);
locx=linspace(xmin+cellsizex,xmax,xmesh/xplotstep);
locy=linspace(ymin+cellsizey,ymax,ymesh/yplotstep);
locz=zmesh;
[X,Y,Z]=meshgrid(locx,locy,locz);

if plot2dflg
    figure;
    if plotip
    quiver(X,Y,u,k,scale2d,'k')
    else
    quiver(X,Y,u,v,scale2d,'k')    
    end
elseif plot3dflg
    figure;
    quiver3(X,Y,Z,u,v,k,scale3d)
end
end
