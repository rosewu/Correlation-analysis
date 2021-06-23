function dydt=fXY2(t,y)

a1=2.5;
a2=0.25;
a3=2.5;
a4=0.25;
a5=2.5;
a6=0.25;
a8=0.75;

km1=10;
km2=8;
km3=10;
km4=8;
km5=10;
km6=8;
km8=15;

K=9;
n1=1;
n2=1;
n3=1;

k1=0.5;
k2=0.5;
k3=0.5;
ka1=15;
ka2=15;
ka3=15;

dydt=zeros(8,1);

v1=a1*y(1)/(km1+y(1))*K^n1/(K^n1+y(8)^n1);
v2=a2*y(2)/(km2+y(2));
v3=a3*y(3)/(km3+y(3))*K^n2/(K^n2+y(8)^n2);
v4=a4*y(4)/(km4+y(4));
v5=a5*y(5)/(km5+y(5))*K^n3/(K^n3+y(8)^n3);
v6=a6*y(6)/(km6+y(6));

v7=k1*y(2)*y(7)/(ka1+y(7))+k2*y(4)*y(7)/(ka2+y(7))+k3*y(6)*y(7)/(ka3+y(7));

v8=a8*y(8)/(km8+y(8));

dydt(1)=v2-v1;
dydt(2)=v1-v2;
dydt(3)=v4-v3;
dydt(4)=v3-v4;
dydt(5)=v6-v5;
dydt(6)=v5-v6;
dydt(7)=v8-v7;
dydt(8)=v7-v8;

end



