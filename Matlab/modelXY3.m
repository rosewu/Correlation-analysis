%% generate X and Y with low r
clear
nn=100; % sample number
n_sample=20; % randomly choose sub-samples
rng default
[mu,sigma]= fCalP(0.8);
YY0(:,1)=lognrnd(mu,sigma,nn,1);
[mu,sigma]= fCalP(0.6);
YY0(:,2)=lognrnd(mu,sigma,nn,1);
[mu,sigma]= fCalP(0.4);
YY0(:,3)=lognrnd(mu,sigma,nn,1);
[mu,sigma]= fCalP(0.55);
YY0(:,4)=lognrnd(mu,sigma,nn,1);

%% Simulation Model3

Model=3;

M=nan(size(YY0,1),1);
E=nan(size(YY0,1),1);
CD=nan(size(YY0,1),1);
CE=nan(size(YY0,1),1);
R=nan(size(YY0,1),1);
RP=nan(size(YY0,1),1);
RE=nan(size(YY0,1),1);

parpool(2,'IdleTimeout',Inf) % use parallel pool 

parfor i=1:nn
i
tspan=0:10:200;

y0 = zeros(1,7);
y0(2)=YY0(i,1);
y0(3)=YY0(i,2);
y0(4)=YY0(i,3);
y0(5)=YY0(i,4);

[t,y]=ode45(@(t,y) fXY3(t,y), tspan,y0);

M(i)=y(end,1);
E(i)=y(end,2);
CD(i)=y(end,3);
CE(i)=y(end,4);
R(i)=y(end,5);
RP(i)=y(end,6);
RE(i)=y(end,7);

end

save data_model3

% shut down Parallel
delete(gcp('nocreate'))

%% plot
load('data_model3.mat')
 
X1 = M;%
X2 = CD;%CycE
X3 = CE;%Rb
X4 = R;
Y = E;%E2F

xlim_lower=[0.0525 0.0162 2.75e-5 3.006];%the lower bound of xlim
xlim_upper=[0.0575 0.0176 3.15e-5 3.01];%the upper bound of xlim
ylimm=[1.7e-5 2.1e-5];

figure('Units','inches',...
    'Position',[0 0 11.69-2,(16.53-4)-4.5],...
    'PaperPositionMode','auto',...
    'PaperType','a4');
colors={[0 0.45 0.74],[0.47 0.67 0.19],[0.93 0.69 0.13],[0.49 0.18 0.56]};
colorsPP={[0 0.45 0.74],[0.85 0.33 0.1],[0.93 0.69 0.13],...
    [0.49 0.18 0.56],[0.47,0.67,0.19]};
 FS=12;
 X={X1,X2,X3,X4};
 Xlabels={'Myc','CyclinD','CyclinE','unphosphorylated Rb'};
 for i=1:4
subplot(3,4,i)
scatter(X{i},Y,0.05,'.','MarkerEdgeColor',colors{i})
[r1, p1] = corr(X{i}(:),Y(:), 'type', 'Pearson');
cov_r1(i)=r1;
[hh,icons,plots,txt]=legend({['\rho_x_y=',num2str(r1,'%.2f')]},'Location','northwest');
     hh.Box='off';
     hh.Position(1)=hh.Position(1)-0.04;
     hh.Position(2)=hh.Position(2)+0.015;
     icons(2).Visible='off';
     icons(1).FontSize=10;
     icons(1).FontWeight='bold';
set(gca,...
     'FontUnits','points',...
     'FontWeight','normal',...
     'FontSize',10,...
     'FontName','Helvetica')
 xlabel(Xlabels{i},'FontSize',FS)
 ylabel('E2F','FontSize',FS)
 xlim([xlim_lower(i) xlim_upper(i)])
 ylim(ylimm);
 end

% study r at population level

for kk=1:4
subplot(3,4,4+kk)
XX=X{kk};
[~,I]=sort(XX);

for i=1:floor(nn/n_sample) 
        rng default
    II=datasample(I(n_sample*(i-1)-round(n_sample/4)*(i>1)+1:n_sample*i+round(n_sample/4)*(i<floor(nn/n_sample))),n_sample/2,'replace',false);
    
    UU=XX(II);
    U(i)=mean(UU);
    errU(i)=std(UU);
        
    VV=Y(II);
    V(i)=mean(VV);
    errV(i)=std(VV);

hold on
scatter(UU,VV,0.05,'.','MarkerEdgeColor',colorsPP{i})
[r3, p3] = corr(UU(:),VV(:), 'type', 'Pearson');
RR{kk}(i)=r3;

end


errorbar(U,V,errV,'k-o','Linewidth',1)
[r4, p7] = corr(U(:),V(:), 'type', 'Pearson');
cov_r4(kk)=r4;

for j=1:5
scatter(U(j),V(j),20,'o','filled','MarkerFaceColor',colorsPP{j})
end

[hh,icons,plots,txt]=legend({['\rho_u_v=',num2str(r4,'%.2f')]},'Location','northwest');
     hh.Box='off';
     hh.Position(1)=hh.Position(1)-0.04;
     hh.Position(2)=hh.Position(2)+0.015;
     icons(2).Visible='off';
     icons(1).FontSize=10;
     icons(1).FontWeight='bold';
set(gca,...
     'FontUnits','points',...
     'FontWeight','normal',...
     'FontSize',10,...
     'FontName','Helvetica')
 xlabel(Xlabels{kk},'FontSize',FS)
 ylabel('E2F','FontSize',FS)
 xlim([xlim_lower(kk) xlim_upper(kk)])
 ylim(ylimm);
end

print FigureS -dpdf -r300

