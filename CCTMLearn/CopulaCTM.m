function [mu,Sigma, Eta,Phi] = CopulaCTM(W,beta,k)
%learn the copula topic model parameters from W((can be sparse)doc-word mtx) and beta (dir
%prior) 
%mu,Sigma: the parameter for NPN
%Eta the Doc-topic prob mtx (DK), used to estimate the empirical cdf F in
%Phi, the recovered word-topic matrix (V * k)
%NPN

%will call GibbsSample(), and NPNFit() as E step and M step

MaxIte = 100;
ConvergeRate = 0.01;  %change of mu and Sigma

%random init
[m,V] = size(W);
mu = rand(k,1);
Sigma = diag(rand(k,1));
NPNEta = rand(m,k);

for ite = 1:MaxIte
    fprintf('[%d] sampling\n',ite);
    [ lZ,lEta ] = GibbsSample(W,beta,mu,Sigma,NPNEta);
    fprintf('[%d] npn fit\n',ite);
    NPNEta = MeanOfSparse3DMtx(lEta);
    [ThisMu,ThisSigma] = NPNFit(NPNEta);
    %add noise at diagnonal to avoid sigularity
    ThisSigma = ThisSigma + 0.01 * diag(ones(size(ThisSigma,1),1));
    MuDiff = sum(abs(ThisMu - mu)) / sum(abs(mu));
    SigmaDiff = sum(sum(abs(ThisSigma - Sigma))) / sum(sum(abs(Sigma)));
    fprintf('[%d] ite diff [%f][%f]\n',ite,MuDiff,SigmaDiff);
    
    mu = ThisMu;
    Sigma = ThisSigma;
    Eta  = NPNEta;
    if (MuDiff + SigmaDiff) < ConvergeRate
        fprintf('coverge\n');
        break;
    end
end

Phi = RecoverWordTopicProb(lZ,beta,V,k);
return

