%% solve curie-weiss equation, include contribution from STT
%input 1.Hext:1x3
function [mmTM,mmRE]=cweqn_wSTT(Hext,D,muRE,muTM,J0RERE,J0TMTM,...
    J0TMRE,J0RETM,kb,T,x,q,mub,Msperatom,Ms0,ita,PFL,Jc,hbar,elev,...
    tFL,alp,ip,lang_or_bri,JFe,JGd,addSTT,addSOT,thetaSHE)
if x==0
    mRE=0;
    syms mTM
elseif x==1
    mTM=0;
    syms mRE
else
    syms mTM mRE
end
HARE=2*D/muRE*mRE;
HATM=2*D/muTM*mTM;
HeffRE=Hext(3)+HARE;
HeffTM=Hext(3)+HATM;
MsT=abs((x*muRE/mub*mRE+q*muTM/mub*mTM))/Msperatom*Ms0;
if addSOT
    Js=thetaSHE*Jc;
Hi=Js*hbar/(2*elev*MsT*tFL);   
elseif addSTT
Hi=ita*PFL*Jc*hbar/(2*elev*MsT*tFL);
end
HRE_MFA=(muRE*HeffRE+J0RERE*mRE+J0RETM*mTM+muRE*Hi/alp*ip(3))/muRE;%eqn5
HTM_MFA=(muTM*HeffTM+J0TMTM*mTM+J0TMRE*mRE+muTM*Hi/alp*ip(3))/muTM;%eqn6

%eqn 8
xiRE=muRE*HRE_MFA/(kb*T);
xiTM=muTM*HTM_MFA/(kb*T);
if lang_or_bri
    [LRE,~]=Bri_func(xiRE,JGd);
    [LTM,~]=Bri_func(xiTM,JFe);
else%brillouin
    [LRE,~]=Lang_fun(xiRE);
    [LTM,~]=Lang_fun(xiTM);
end

eqn1=mRE==LRE;
eqn2=mTM==LTM;
if x==0
    mTM=vpasolve(eqn2,mTM,0.5);
    if isempty(mTM)
        mmTM=0;
    else
        mmTM=double(abs(mTM));
    end
    mmRE=0;
elseif x==1
    mRE=vpasolve(eqn1,mRE,0.5);
    if isempty(mRE)
        mmRE=0;
    else
        mmRE=double(abs(mRE));
    end
    mmTM=0;
else
    sol=vpasolve([eqn1,eqn2],[mRE,mTM],[-0.5,0.5]);
    if isempty(sol.mRE)
        mmRE=0;
    else
        mmRE=double(sol.mRE);
    end
    if isempty(sol.mTM)
        mmTM=0;
    else
        mmTM=double(sol.mTM);
    end
end
if(0)
    double(subs(Hi/alp*ip(3),[mTM,mRE],[mmTM,mmRE]))
    double(subs(J0RERE*mRE/muRE,[mTM,mRE],[mmTM,mmRE]))
    double(subs(HeffRE,[mTM,mRE],[mmTM,mmRE]))
    double(subs(J0RETM*mTM/muRE,[mTM,mRE],[mmTM,mmRE]))
    
    HRE_MFA=(muRE*HeffRE+J0RERE*mRE+J0RETM*mTM+muRE*Hi/alp*ip(3))/muRE;%eqn5
    
    double(subs(MsT,[mTM,mRE],[mmTM,mmRE]))
end
end
