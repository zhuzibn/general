%{
%usage
plottime=199e-12;% the time you want to see the magnetization state
plotWstep=1;%grid size along Width direction
plotLstep=1;%grid size along length direction
scale3d=0.5;%scale factor of the arrow size
arrowwidth=10;
plotmode=0;
%0:plot for 2D atomistic model;1:cross-section plot for 3D atomistic
%model;2:plot for 3D atomistic model
colorbarplot=1;%for FiM, choose 0 so that Fe and Gd are represented by red
% and blue, respectively. For FM, choose 1 so that the colorbar indicates
% the magnitude of mz

% movie options
generatemovie=0;%1:generate movie, 0: no movie
movieduration=10;%seconds
plotmoviestep=10;%movie step

threedplott(mmx_show,mmy_show,mmz_show,runtime,atomtype_,plottime,plotWstep,plotLstep,...
    scale3d,arrowwidth,plotmode,colorbarplot,generatemovie,movieduration,plotmoviestep)
%}

function threedplott(mmx_show,mmy_show,mmz_show,runtime,atomtype_,plottime,plotWstep,plotLstep,...
    scale3d,arrowwidth,plotmode,colorbarplot,generatemovie,movieduration,plotmoviestep)

%% don't change the following line unless you know what you are changing
switch plotmode
    case 0
        %the following value will not be used
        plot_z_layer=1;
        plotzstep=1;
    case 1
        plot_z_layer=7;%which z layer you want to plot
        %the following value will not be used
        plotzstep=1;
    case 2
        plotzstep=3;%grid size along thickness direction
        %the following value will not be used
        plot_z_layer=1;
end
%% data processing
mmx=mmx_show;
mmy=mmy_show;
mmz=mmz_show;

natomW=size(mmx,1);
natomL=size(mmx,2);
natomz=size(mmx,3);
if plotmode==0
    savedstep=size(mmx,3);%the third dimension of 2D atomistic model is time
else
    savedstep=size(mmx,4);
end

gridW = 1:plotWstep:natomW;
gridL = 1:plotLstep:natomL;

numplotW=size(gridW,2);
numplotL=size(gridL,2);

plottimenew=round((plottime/runtime)*savedstep)+1;%the time used in the plot function

if ~generatemovie
    plotmoviestep=1;
end
%% plot
for ct=1:plotmoviestep

    if generatemovie
    plottimenew=(ct-1)*floor(savedstep/plotmoviestep)+1;
    plottime=(plottimenew-1)/savedstep*runtime;
    end

    switch plotmode
        case 0
            [gridplotW,gridplotL] = meshgrid(gridL,gridW);
            gridz=zeros(numplotW,numplotL);
            numplotz=1;
        case 1
            [gridplotW,gridplotL] = meshgrid(gridL,gridW);
            gridz=zeros(numplotW,numplotL);
            numplotz=1;
        case 2
            gridz = 1:plotzstep:natomz;
            numplotz=size(gridz,2);
            [gridplotW,gridplotL,gridplotz] = meshgrid(gridL,gridW,gridz);
    end

    figure;hold on
    for ctz=1:numplotz
        for ctL=1:numplotL
            for ctW=1:numplotW
                plotatomW=(ctW-1)*plotWstep+1;
                plotatomL=(ctL-1)*plotLstep+1;
                switch plotmode
                    case 0
                        mmm=[mmx(plotatomW,plotatomL,plottimenew),mmy(plotatomW,plotatomL,plottimenew),...
                            mmz(plotatomW,plotatomL,plottimenew)];
                        p1=[gridplotW(numplotW-ctW+1,ctL),gridplotL(numplotW-ctW+1,ctL),gridz(ctW,ctL)];
                    case 1
                        mmm=[mmx(plotatomW,plotatomL,plot_z_layer,plottimenew),mmy(plotatomW,plotatomL,plot_z_layer,plottimenew),...
                            mmz(plotatomW,plotatomL,plot_z_layer,plottimenew)];
                        p1=[gridplotW(numplotW-ctW+1,ctL),gridplotL(numplotW-ctW+1,ctL),gridz(ctW,ctL)];
                    case 2
                        plotatomz=(ctz-1)*plotzstep+1;
                        mmm=[mmx(plotatomW,plotatomL,plotatomz,plottimenew),mmy(plotatomW,plotatomL,plotatomz,plottimenew),...
                            mmz(plotatomW,plotatomL,plotatomz,plottimenew)];
                        p1=[gridplotW(numplotW-ctW+1,ctL,ctz),gridplotL(numplotW-ctW+1,ctL,ctz),gridplotz(numplotW-ctW+1,ctL,ctz)];
                end
                p2=p1+scale3d*mmm;
                daspect manual
                switch plotmode
                    case 0
                        if colorbarplot
                            colormap turbo
                            arrow3(p1,p2,'|',arrowwidth);
                        else
                            if atomtype_(plotatomW,plotatomL)==0%TM
                                arrow3(p1,p2,'r',arrowwidth);
                            else
                                arrow3(p1,p2,'b',arrowwidth);
                            end
                        end
                    case 1
                        if atomtype_(plotatomW,plotatomL,plot_z_layer)==0%TM
                            arrow3(p1,p2,'r',arrowwidth);
                        else
                            arrow3(p1,p2,'b',arrowwidth);
                        end
                    case 2
                        if atomtype_(plotatomW,plotatomL,plotatomz)==0%TM
                            arrow3(p1,p2,'r',arrowwidth);
                        else
                            arrow3(p1,p2,'b',arrowwidth);
                        end
                end
            end
        end
    end
    xlabel('x axis');ylabel('y axis');zlabel('z axis');
    switch plotmode
        case 0
            title(['layer ',num2str(plot_z_layer),'-time=',num2str(plottime*1e12),'ps'])
            zlim([-2 2]);
            colorbar;
        case 1
            title(['layer ',num2str(plot_z_layer),'-time=',num2str(plottime*1e12),'ps'])
            zlim([-2 2]);
        case 2
            title(['time=',num2str(plottime*1e12),'ps'])
            zlim([0 natomz+1]);
    end
    xlim([0 natomL+1]);ylim([0 natomW+1]);
    view(-19,53)
    if generatemovie
        M(ct) = getframe(gcf);
    end
end

if generatemovie
v=VideoWriter('myavi.avi')
%v.FrameRate=round(plotsetp/movieduration);
v.FrameRate=1;
open(v)
writeVideo(v,M)
close all;clear all
end

if (0)%debug
    ddebug;
end
