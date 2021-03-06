function [ flag ] = CopulaCTMPipe(NumOfTopic,NumOfDoc,OutName)
%copula pipeline runs
%data path is hard coded
matlabpool open 8
fprintf('using 8 cores\n');
InName = '/bos/usr0/cx/tmp/CopulaTopicModel/nips12raw_str602.mat';
load(InName);
fprintf('load data [%d-%d]:\n',size(counts,2),size(counts,1));

k=ceil(str2double(NumOfTopic));
m=ceil(str2double(NumOfDoc));
fprintf('start fitting [%d] topics, output to [%s]\n',k,OutName);
beta = 0.01;
[mu,Sigma, Eta,Phi]=CopulaCTM(counts(:,1:m)',beta,k);
DumpWordTopic(wl,Phi,OutName);
flag = 1;



