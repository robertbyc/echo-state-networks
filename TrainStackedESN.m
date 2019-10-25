function [StackedESN] = TrainStackedESN(TrainInput,TrainOutput,StackedESN,nLayers,nNeglectSampleNum,delayorder,scalefactor,alpha,Flag)
nSampleNum=size(TrainInput,1);
if(nNeglectSampleNum>nSampleNum/2)
    error('neglected training samples is too much');
end
X=[];
ColStateMatrix=[];
for j=1:nSampleNum
    ColStateMatrix=[];
    for i=1:nLayers
        if(i<=1)
            StackedESN{i}.in=[TrainInput(j,:)'];
            totalin= StackedESN{i}.W_in*[1;StackedESN{i}.in]+...
                StackedESN{i}.W_r* StackedESN{i}.InternalState(:,max(j-1,1));
        else
            StackedESN{i}.in=StackedESN{i-1}.InternalState(:,max(j-delayorder(i),1));
            totalin= StackedESN{i}.W_in*[1;1*StackedESN{i}.in]+...
                StackedESN{i}.W_r* StackedESN{i}.InternalState(:,max(j-1,1));
        end
        x=(1-alpha)*StackedESN{i}.InternalState(:,max(j-1,1))+...
            alpha*tanh(scalefactor(i)*totalin);
        StackedESN{i}.InternalState(:,j)=x;
        if(j>nNeglectSampleNum)
                ColStateMatrix=[ColStateMatrix;x];
        end
    end
    X=[X,ColStateMatrix];
end
resSize=size(X,1);
Yt=TrainOutput(nNeglectSampleNum+1:nSampleNum,:);
a=X*X';
b=1e-7*eye(resSize);
c=X*Yt;
StackedESN{nLayers}.W_out=(a+ b) \ c; 
end

