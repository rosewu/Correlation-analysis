function dydt=fXY1(t,y)

a1=2.5;
a2=0.25;
a4=0.5;
a6=0.75;
a8=0.75;

k3=0.5;
k5=0.5;
k7=5;

km1=10;
km2=8;
km3=15;
km4=15;
km5=15;
km6=15;
km7=15;
km8=15;

K=9;
n=1;

dydt=zeros(8,1);

v1=a1*y(1)/(km1+y(1))*K^n/(K^n+y(8)^n);
v2=a2*y(2)/(km2+y(2));
v3=k3*y(2)*y(3)/(km3+y(3));
v4=a4*y(4)/(km4+y(4));
v5=k5*y(4)*y(5)/(km5+y(5));
v6=a6*y(6)/(km6+y(6));
v7=k7*y(6)*y(7)/(km7+y(6));
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



