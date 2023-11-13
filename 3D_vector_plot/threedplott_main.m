clear all;close all;clc

%% load data
load('two-D-FM-skyrmion')

%% parameters you can change
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