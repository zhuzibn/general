function threed_plot(plot_z_layer,gridL,gridW,numplotW,numplotL,plotzstep,plotWstep,plotLstep,...
    atomtype_,mmx,mmy,mmz,natomL,natomW,natomz,plottime,plottimenew,arrowwidth,scale3d,plotmode,colorbarplot)

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

figure;hold on%initial magnetization
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
end