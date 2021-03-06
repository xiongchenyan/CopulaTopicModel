function [LowerEta,UpperEta] = SampleBound(Z,LastEta)
%sample the bound for eta given Z
%Z,LastEta is the sampling results
%LowerEta, UpperEta is D\times K dim vector showing the lower and upper bound
    %for each document

% fprintf('sampling bounds\n');
% tic;
LowerEta = zeros(size(LastEta));
UpperEta = zeros(size(LastEta));
m = size(LastEta,1);
k = size(LastEta,2);
TotalC =sum(exp(LastEta),2);

parfor i=1:m
    C = TotalC(i) * ones(k,1) - exp(LastEta(i,:)');
    DocTopicProb = exp(LastEta(i,:)');
    DocTopicProb = DocTopicProb ./ sum(DocTopicProb);
    NumOfTopic = zeros(k,1);
    for j = 1:k
        NumOfTopic(j) = sum(Z(i,:)==j);
    end
    MaxU = SampleUniformMax(zeros(size(DocTopicProb)),DocTopicProb,NumOfTopic);
    MinU = SampleUniformMin(DocTopicProb,ones(size(DocTopicProb)), sum(NumOfTopic) - NumOfTopic);
    
    
    LowerEta(i,:) = log(C .* MaxU ./ (ones(k,1) - MaxU));
    UpperEta(i,:) = log(C .* MinU ./ (ones(k,1) - MinU));
%     fprintf('[%d/%d] bound sampled\n',i,m);
end
% fprintf('bounds sampled\n');
% toc


