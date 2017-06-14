%% solution of curie-weiss equation with STT, vector form
%input 1.Hext:1x3
function [mmTM,mmRE]=cweqn_wST_vec(Hext,D,muRE,muTM,J0RERE,J0TMTM,...
    J0TMRE,J0RETM,kb,T,x,q,mub,Msperatom,Ms0,ita,PFL,Jc,hbar,elev,...
    tFL,alp,ip,lang_or_bri,JFe,JGd,addSTT,addSOT,thetaSHE)
%[mmTM,mmRE]=cweqn_wST_vec(Hext,D,muRE,muTM,J0RERE,J0TMTM,J0TMRE,J0RETM,kb,T,x)
if x==0
    mRE=0;
    syms mTM
elseif x==1
    mTM=0;
    syms mRE
else
    syms mTMx mTMy mTMz mREx mREy mREz
end
mTM=[mTMx mTMy mTMz];
mRE=[mREx mREy mREz];

HARE=[0,0,2*D/muRE*mRE(3)];
HATM=[0,0,2*D/muTM*mTM(3)];
HeffRE=Hext+HARE;
HeffTM=Hext+HATM;

MsT=abs((x*muRE/mub*mRE(3)+q*muTM/mub*mTM(3)))/Msperatom*Ms0;
if addSOT
    Js=thetaSHE*Jc;
Hiy=Js*hbar/(2*elev*MsT*tFL);   
elseif addSTT
Hiy=ita*PFL*Jc*hbar/(2*elev*MsT*tFL);
end
Hi=[0,Hiy,0];

HRE_MFA=(muRE*HeffRE+J0RERE*mRE+J0RETM*mTM+muRE*Hi.*ip/alp)/muRE;%eqn5
HTM_MFA=(muTM*HeffTM+J0TMTM*mTM+J0TMRE*mRE+muTM*Hi.*ip/alp)/muTM;%eqn6
%eqn 8
xiRE=muRE*HRE_MFA/(kb*T);
xiTM=muTM*HTM_MFA/(kb*T);
if lang_or_bri
    [LRE,~]=Bri_func(norm(xiRE),JGd);
    [LTM,~]=Bri_func(norm(xiTM),JFe);
else%brillouin
    [LRE,~]=Lang_fun(norm(xiRE));
    [LTM,~]=Lang_fun(norm(xiTM));
end
% LRE=lange(norm(xiRE));
% LTM=lange(norm(xiTM));

eqn1=mREx==LRE*xiRE(1)/norm(xiRE);
eqn2=mREy==LRE*xiRE(2)/norm(xiRE);
eqn3=mREz==LRE*xiRE(3)/norm(xiRE);

eqn4=mTMx==LTM*xiTM(1)/norm(xiTM);
eqn5=mTMy==LTM*xiTM(2)/norm(xiTM);
eqn6=mTMz==LTM*xiTM(3)/norm(xiTM);

if x==0
    mTM=vpasolve(eqn2,mTM,0.5);
    if isempty(mTM)
        mmTM=0;
    else
        mmTM=abs(mTM);
    end
    mmRE=0;
elseif x==1
    mRE=vpasolve(eqn1,mRE,0.5);
    if isempty(mRE)
        mmRE(1)=0;
    else
        mmRE(1)=abs(mRE);
    end
    mmTM=0;
else
    sol=vpasolve([eqn1,eqn2,eqn3,eqn4,eqn5,eqn6],...
        [mREx,mREy,mREz,mTMx,mTMy,mTMz],[0,0,-0.5,0,0,0.5]);
    if isempty(sol.mREx)
        mmRE(1)=0;
    else
        mmRE(1)=double(sol.mREx);
    end
    if isempty(sol.mREy)
        mmRE(2)=0;
    else
        mmRE(2)=double(sol.mREy);
    end
    if isempty(sol.mREz)
        mmRE(3)=0;
    else
        mmRE(3)=double(sol.mREz);
    end
    
    if isempty(sol.mTMx)
        mmTM(1)=0;
    else
        mmTM(1)=double(sol.mTMx);
    end
    if isempty(sol.mTMy)
        mmTM(2)=0;
    else
        mmTM(2)=double(sol.mTMy);
    end
    if isempty(sol.mTMz)
        mmTM(3)=0;
    else
        mmTM(3)=double(sol.mTMz);
    end
end
end