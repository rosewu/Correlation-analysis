clear
Model = 1; % Model = 1 or Model = 2

%%
if Model == 1
    load('data_model1.mat')
    xlim_lower=[0.5 0.1 0.02];%the lower bound of xlim
    xlim_upper=[1.7 0.7 0.17];%the upper bound of xlim
    ylim_lower=0;
    ylim_upper=0.25;
else
    load('data_model2.mat')
    xlim_lower=[0.5 0.3 0.2];%the lower bound of xlim
    xlim_upper=[1.8 1.5 1];%the upper bound of xlim
    ylim_lower=0.05;
    ylim_upper=0.5;
end

figure('Units','inches',...
    'Position',[0 0 11.69-2,(16.53-4)-4.5],...
    'PaperPositionMode','auto',...
    'PaperType','a4');
colors={[0 0.45 0.74],[0.47 0.67 0.19],[0.93 0.69 0.13]};
colorsPP={[0 0.45 0.74],[0.85 0.33 0.1],[0.93 0.69 0.13],...
    [0.49 0.18 0.56],[0.47,0.67,0.19]};
 FS=12;
 
%% add random error
X_noise_labels={'X1^\ast+ Random error','X2^\ast+ Random error','X3^\ast+ Random error'};

for i=1:3
XX=X{i};
mm1=mean(XX)*0.5;
mm2=mean(Y)*0.5;
X_noise{i}=nan(length(XX),1);
Y_noise=nan(length(Y),1);

[mu1,sigma1]= fCalP(mm1);
[mu2,sigma2]= fCalP(mm2);
%adding random error
rng default
    if Model == 1
        lognrnd(mu1,sigma1,nn*20,1);
    else
        lognrnd(mu2,sigma2,nn*18,1);
    end

X_noise{i}=XX+lognrnd(mu1,sigma1,nn,1);
Y_noise=Y+lognrnd(mu2,sigma2,nn,1);

subplot(3,3,i)

scatter(X_noise{i},Y_noise,0.05,'.','MarkerEdgeColor',colors{i})

[r2, p] = corr(X_noise{i}(:),Y_noise(:), 'type', 'Pearson');
cov_r2(i)=r2;
ylim([ylim_lower ylim_upper]);
[hh,icons,plots,txt]=legend({['\rho_x_y^,=',num2str(r2,'%.2f'),'     \rho_x_y^,/\rho_x_y=',num2str(r2/cov_r1(i),'%.2f')]},'Location','northwest');
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
 xlabel(X_noise_labels{i},'FontSize',FS)
 ylabel('Y^\ast+ Random error','FontSize',FS)
 xlim([xlim_lower(i) xlim_upper(i)])
end

%% study r at population level(noise)
II={};

for kk=1:3
subplot(3,3,3+kk)
XX=X_noise{kk};

[~,I]=sort(XX);

for i=1:floor(nn/n_sample) 
        rng default
    II{i}=datasample(I(n_sample*(i-1)-round(n_sample/4)*(i>1)+1:n_sample*i+round(n_sample/4)*(i<floor(nn/n_sample))),n_sample/2,'replace',false);
    
    UU=XX(II{i});
    U(i)=mean(UU);
    errU(i)=std(UU);
        
    VV=Y_noise(II{i});
    V(i)=mean(VV);
    errV(i)=std(VV);

hold on
scatter(UU,VV,0.05,'.','MarkerEdgeColor',colorsPP{i})
[r5, p3] = corr(UU(:),VV(:), 'type', 'Pearson');
RR_noise{kk}(i)=r5;

end

errorbar(U,V,errV,'k-o','Linewidth',1)
[r6, p7] = corr(U(:),V(:), 'type', 'Pearson');

for j=1:5
scatter(U(j),V(j),20,'o','filled','MarkerFaceColor',colorsPP{j})
end

ylim([ylim_lower ylim_upper]);
[hh,icons,plots,txt]=legend({['\rho_u_v^,=',num2str(r6,'%.2f'),'     \rho_u_v^,/\rho_u_v=',num2str(r6/cov_r4(kk),'%.2f')]},'Location','northwest');
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
 xlabel(X_noise_labels{kk},'FontSize',FS)
 ylabel('Y^\ast+ Random error','FontSize',FS)
 xlim([xlim_lower(kk) xlim_upper(kk)])
end

if Model == 1
    print Figure_1N -dpdf -r300
else
    print Figure_2N -dpdf -r300
end