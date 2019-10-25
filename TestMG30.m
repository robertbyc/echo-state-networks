clear StackedESN;
close all;
clc;
alpha           = 1.0;
nLayers         = 4;
nInputDim       = 1;
nOutputDim      = 1;
nReservoirDim   = 1000/nLayers*ones(1,nLayers);
nSpectraRadius  = [0.7,1.15*ones(1,nLayers)];
nSparseDegree   = 0.05+0.0*ones(1,nLayers);
delayorder      = 13+0*ones(nLayers,1);
SD_p            = 0.9;
rand( 'seed', 65);
%Acquire samples
nSamNum=3000;
nNeglectSampleNum=200;
fraction=2000/nSamNum;
scalefactor=[1,0.80*ones(1,nLayers)];
[Input_sequence_p,Output_sequence,nSamNum,PS]=generate_Smaples(nSamNum,17,0);
% plot(Output_sequence);
train_x=Input_sequence_p(1:floor(nSamNum*fraction),:);
train_y=Output_sequence(1:floor(nSamNum*fraction),:);
test_x=Input_sequence_p(floor(nSamNum*fraction)+1:nSamNum,:);
test_y=Output_sequence(floor(nSamNum*fraction)+1:nSamNum,:);
disp('building the network......');
tic
StackedESN= BuildStackedESN(nLayers,nInputDim,nOutputDim,...
    nReservoirDim,nSpectraRadius,nSparseDegree,SD_p,nSamNum);
disp('done......');
toc

disp('training network......');
tic
StackedESN=TrainStackedESN(train_x,train_y,StackedESN,nLayers,...
    nNeglectSampleNum,delayorder,scalefactor,alpha,1);
disp('done......');
toc
disp('testing network......');
tic
[StackedESN,PredictedOutput] = TestStackedESN(test_x,StackedESN,...
    nLayers,1,delayorder,scalefactor,alpha,1,nSamNum);
disp('done......');
toc
PredictedOutput=PredictedOutput(1:end);
test_y=test_y(1:end);
figure(1);
plot(PredictedOutput,'r-','LineWidth',1);
hold on;
plot(test_y,'b:','LineWidth',1);
xlabel('time step k');
ylabel('Signal amplitude');

set(gca,'FontSize',14,'FontName','TimeNewsRoman','FontWeight','bold');
set(get(gca,'YLabel'),'FontSize',14,'FontName','TimeNewsRoman','FontWeight','bold');
set(get(gca,'XLabel'),'FontSize',14,'FontName','TimeNewsRoman','FontWeight','bold');
set(gca,'linewidth',2);

sz=size(test_y,1);
PredictedError=(PredictedOutput-test_y);
PredictedNRMSE=sqrt(sum(PredictedError(1:500).^2)/var(test_y(1:500))/500)

figure(3);
plot(PredictedError,'r-.','LineWidth',1);
xlabel('time step k');
ylabel('error');

set(gca,'FontSize',14,'FontName','TimeNewsRoman','FontWeight','bold');
set(get(gca,'YLabel'),'FontSize',14,'FontName','TimeNewsRoman','FontWeight','bold');
set(get(gca,'XLabel'),'FontSize',14,'FontName','TimeNewsRoman','FontWeight','bold');
set(gca,'linewidth',2);


