function [loss,gradient] = sloss_hellinger(weights,features,labels,alpha,gamma,computeGradient)

k = size(features,1);

temp = alpha.*features * weights;
phi = (tanh(temp) + 1)./2;
phi2 = alpha.*sech(temp).^2./2;

P = double(labels > 0);

correlations = corr(P,phi);
if sum(correlations <= 0) > 0
    for i = 1:1:size(P,2)
        if correlations(i) <= 0
            P(:,i) = ~P(:,i);
        end
    end
end

N = double(~P);

pcard = sum(P);
ncard = k - pcard;

pphi1 = phi' * P;
nphi1 = phi' * N;

pphi2 = pcard - pphi1;
nphi2 = ncard - nphi1;

pphi1(pcard == 0) = 1;
pphi2(pcard == 0) = 1;
pcard(pcard == 0) = 1;
nphi1(ncard == 0) = 1;
nphi2(ncard == 0) = 1;
ncard(ncard == 0) = 1;

dpphi1 = features' * bsxfun(@times,phi2,P);
dnphi1 = features' * bsxfun(@times,phi2,N);

dpphi2 = -dpphi1;
dnphi2 = -dnphi1;

v1 = real(sqrt(pphi1./pcard));
v2 = real(sqrt(nphi1./ncard));
v3 = real(sqrt(pphi2./pcard));
v4 = real(sqrt(nphi2./ncard));

d1 = (pcard .* (v1 + realmin('single'))) + 0.00001;
d2 = (ncard .* (v2 + realmin('single'))) + 0.00001;
d3 = (pcard .* (v3 + realmin('single'))) + 0.00001;
d4 = (ncard .* (v4 + realmin('single'))) + 0.00001;

normGrad =  (1 ./ (1 + exp(-1000000*weights))) - (1 ./ (1 + exp(1000000*weights)));

loss = sum(double(-(v1 - v2).^2 - (v3 - v4).^2)) + gamma*norm(weights,1);
gradient = [];
if computeGradient
	gradient = double(sum(bsxfun(@times,(v2 - v1),(bsxfun(@rdivide,dpphi1,d1) - bsxfun(@rdivide,dnphi1,d2))) + bsxfun(@times,(v4 - v3),(bsxfun(@rdivide,dpphi2,d3) - bsxfun(@rdivide,dnphi2,d4))),2)) + gamma*normGrad;
end

end
