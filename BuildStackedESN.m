function StackedESN= BuildStackedESN(nLayers,nInputDim,...
    nOutputDim,nReservoirDim,nSpectraRadius,nSparseDegree,SD_p,nSamNum,nNeglectSampleNum)
%��������������㼶ESN��������ݽṹ
%��������������Ԫ�����飬ÿ����������ÿһ��ESN�Ľṹ��
%Input error check
if(nLayers<=0)
    error('Layers of stacked ESN cannot be 0');
end
if(nInputDim<=0)
    error('Input dimension of stacked ESN cannot be 0');
end
if(nOutputDim<=0)
    error('Output dimension of stacked ESN cannot be 0');
end
s_z=size(nReservoirDim,2);
if(nLayers>s_z)
    error('size of nreservoir should be equal to layers');
end
s_z=size(nSpectraRadius,2);
if(nLayers>s_z)
    error('size of nSpectraRadius should be equal to layers');
end
s_z=size(nSparseDegree,2);
if(nLayers>s_z)
    error('size of nSparseDegree should be equal to layers');
end
%Build stacked ESN
  for i=1:nLayers
      StackedESN{i}.ID=i;
        if(i==1)
            StackedESN{i}.nInputDim=nInputDim;
        else
            StackedESN{i}.nInputDim=StackedESN{i-1}.nOutputDim;
        end
        StackedESN{i}.nInternalsDim     = nReservoirDim(i);
        StackedESN{i}.InternalState     = zeros(nReservoirDim(i),nSamNum);
        StackedESN{i}.fSpectraRadius    = nSpectraRadius(i);
        StackedESN{i}.fSparseDegree     = nSparseDegree(i);
        StackedESN{i}.nConnectionWays   = 1;
        if(i==nLayers)
            StackedESN{i}.nOutputDim=nOutputDim;
        else
            StackedESN{i}.nOutputDim=nReservoirDim(i);
        end   
        StackedESN{i}=BuildSingleReservoir(StackedESN{i},SD_p);
    end


