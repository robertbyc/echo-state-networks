function [StackedESN,PredictedOutput] =TestStackedESN(TestInput,StackedESN,...
    nLayers,Flag,delayorder,scalefactor,alpha,Flag1,nSamNum)
nTestNum=size(TestInput,1);
nPos=nSamNum-nTestNum;
for j=1:nTestNum
    ColStateMatrix=[];
    for i=1:nLayers
        if(i==1)
            if(j==1||Flag==0)
                StackedESN{i}.in=TestInput(j,:)';
            else
                StackedESN{i}.in=PredictedOutput(j-1,:)';
            end
            totalin= StackedESN{i}.W_in*[1;StackedESN{i}.in]...
                +StackedESN{i}.W_r* StackedESN{i}.InternalState(:,nPos+j-1);
        else
            StackedESN{i}.in=...
                StackedESN{i-1}.InternalState(:,nPos+j-delayorder(i));
            totalin= StackedESN{i}.W_in*[1;1*StackedESN{i}.in]+...
                StackedESN{i}.W_r* StackedESN{i}.InternalState(:,nPos+j-1);
        end
        x=(1-alpha)*StackedESN{i}.InternalState(:,nPos+j-1)+...
            alpha*tanh(scalefactor(i)*totalin);
        StackedESN{i}.InternalState(:,nPos+j)=x;
            ColStateMatrix=[ColStateMatrix;x];
    end
    PredictedOutput(j,:)=(StackedESN{nLayers}.W_out'*ColStateMatrix)';
end
end

