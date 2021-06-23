function dydt=fXY3(t,y)
% From the paper: A Precise Cdk Activity Threshold Determines Passage through the Restriction Point

S = lognrnd(-3.93,0.198);% mean = 0.02, std = 0.2*mean

k_M = 1;
k_E = 0.4;
k_b = 0.003;
k_RE = 180;
k_CDS = 0.45;
k_CE = 0.35;
k_R = 0.18;
k_DP =3.6;
k_p1 = 18;
k_p2 = 18;
k_CD = 0.03;

dM = 0.7;
dE = 0.25;
dCD = 1.5; 
dCE =1.5;
dR = 0.06;
dRP = 0.06;
dRE =0.03;

KM = 0.15;
KS = 0.5;
KCD = 0.92;
KE = 0.15;
KRP = 0.01;
KCE = 0.92;

dydt=zeros(7,1);

dydt(1)=k_M*S/(KS+S) - dM*y(1);
dydt(2)=k_E*(y(1)/(KM+y(1)))*(y(2)/(KE+y(2)))+...
        k_b*y(1)/(KM+y(1))+k_p1*y(3)*y(7)/(KCD+y(7))+...
        k_p2*y(4)*y(7)/(KCE+y(7)) - dE*y(2) - k_RE*y(5)*y(2);
dydt(3)=k_CD*y(1)/(KM+y(1)) + k_CDS*S/(KS+S) - dCD*y(3);
dydt(4)=k_CE*y(2)/(KE+y(2)) - dCE*y(4);
dydt(5)=k_R + k_DP*y(6)/(KRP+y(6)) - k_RE*y(5)*y(2)...
        - k_p1*y(3)*y(5)/(KCD+y(5)) - k_p2*y(4)*y(5)/(KCE+y(5)) - dR*y(5);
dydt(6)=k_p1*y(3)*y(5)/(KCD+y(5)) + k_p2*y(4)*y(5)/(KCE+y(7))...
        + k_p1*y(3)*y(7)/(KCD+y(7)) + k_p2*y(4)*y(7)/(KCE+y(7))...
        - k_DP*y(6)/(KRP+y(6)) - dRP*y(6);
dydt(7)=k_RE*y(5)*y(2) - k_p1*y(3)*y(7)/(KCD+y(7)) - k_p2*y(4)*y(7)/(KCE+y(7))-dRE*y(7);

% M = y(1)
% E = y(2)
% CD = y(3)
% CE = y(4)
% R = y(5)
% RP = y(6)
% RE = y(7)
end



