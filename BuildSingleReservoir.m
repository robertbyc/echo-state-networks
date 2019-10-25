%构造单个ESN网络
function [s_ESN]=BuildSingleReservoir(s_ESN,SD_p)
%nInput:        input demensions
%nInternals:    reservoir dimensions
%nOutput:       output dimensions
%fSpectra:      spectra radius
%fSparseDegree: sparse degree
%nWays:         connection method of reservoir
%construct input matrix
% rand( 'seed', 43 );
s_ESN.W_in=rand(s_ESN.nInternalsDim,s_ESN.nInputDim+1)-0.5;
% for i=1:s_ESN.nInternalsDim
%     for j=1:s_ESN.nInternalsDim
%         p=rand();
%         if(p<s_ESN.fSparseDegree||p>1-s_ESN.fSparseDegree)    
%             s_ESN.W_r(i,j)=2*rand()-1;
%         else
%             s_ESN.W_r(i,j)=0;
%         end
%     end
% end
% rand( 'seed', 42 );
s_ESN.W_r = sprand(s_ESN.nInternalsDim,s_ESN.nInternalsDim,s_ESN.fSparseDegree);
W_mask = (s_ESN.W_r~=0); 
s_ESN.W_r(W_mask) = (s_ESN.W_r(W_mask)-0.5);
% s_ESN.W_r = rand(s_ESN.nInternalsDim,s_ESN.nInternalsDim)-0.5;
%Adjust spectra radius
dSR=max(abs(eigs(s_ESN.W_r)))-s_ESN.fSpectraRadius;
while(abs(dSR)>0.05)
    if(dSR>0.05)
        s_ESN.W_r=0.9*s_ESN.W_r;
    else
        s_ESN.W_r=1.1*s_ESN.W_r;
    end
    dSR=max(abs(eigs(s_ESN.W_r)))-s_ESN.fSpectraRadius;
end
