%% generate X and Y with low r
clear
nn=10000; % sample number
n_sample=2000; % randomly choose sub-samples
rng default
[mu,sigma]= fCalP(0.8);
YY0(:,1)=lognrnd(mu,sigma,nn,1);
[mu,sigma]= fCalP(0.6);
YY0(:,2)=lognrnd(mu,sigma,nn,1);
[mu,sigma]= fCalP(0.4);
YY0(:,3)=lognrnd(mu,sigma,nn,1);
[mu,sigma]= fCalP(0.25);
YY0(:,4)=lognrnd(mu,sigma,nn,1);

%% Simulation Model1 or Model2

Model=1;% Model = 1 or Model =2

X1=nan(size(YY0,1),1);
X2=nan(size(YY0,1),1);
X3=nan(size(YY0,1),1);

Y=nan(size(YY0,1),1);

for i=1:nn

tspan=0:1:100;
y0(1)=YY0(i,1);
y0(2)=0;
y0(3)=YY0(i,2);
y0(4)=0;
y0(5)=YY0(i,3);
y0(6)=0;
y0(7)=YY0(i,4);
y0(8)=0;

if Model == 1
    [t,y]=ode45(@(t,y) fXY1(t,y), tspan,y0); 
else
    [t,y]=ode45(@(t,y) fXY2(t,y), tspan,y0);
end

X1(i)=y(end,2);
X2(i)=y(end,4);
X3(i)=y(end,6);

Y(i)=y(end,8);

end

%% plot
if Model == 1
    xlim_lower=[0.2 0.06 0];%the lower bound of xlim
    xlim_upper=[1.4 0.56 0.15];%the upper bound of xlim
    ylimm=[0.01 0.2];
else
    xlim_lower=[0.2 0.1 0.1];%the lower bound of xlim
    xlim_upper=[1.4 1.2 0.65];%the upper bound of xlim
    ylimm=[0.05 0.3];
end

figure('Units','inches',...
    'Position',[0 0 11.69-2,(16.53-4)-4.5],...
    'PaperPositionMode','auto',...
    'PaperType','a4');
colors={[0 0.45 0.74],[0.47 0.67 0.19],[0.93 0.69 0.13]};
colorsPP={[0 0.45 0.74],[0.85 0.33 0.1],[0.93 0.69 0.13],...
    [0.49 0.18 0.56],[0.47,0.67,0.19]};
 FS=12;
 X={X1,X2,X3};
 Xlabels={'X1^\ast','X2^\ast','X3^\ast'};
 for i=1:3
subplot(3,3,i)
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
 ylabel('Y^\ast','FontSize',FS)
 xlim([xlim_lower(i) xlim_upper(i)])
 ylim(ylimm);
 end


% study r at population level

for kk=1:3
subplot(3,3,3+kk)
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
 ylabel('Y^\ast','FontSize',FS)
 xlim([xlim_lower(kk) xlim_upper(kk)])
 ylim(ylimm);
end

if Model == 1
    save data_model1
    print Figure_1 -dpdf -r300
else
    save data_model2
    print Figure_2 -dpdf -r300
end
