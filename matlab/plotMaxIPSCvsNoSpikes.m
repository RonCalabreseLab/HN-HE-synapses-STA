function plotMaxIPSCvsNoSpikes(diffSyn)

figure();
plot(diffSyn,'-','color',[0.2 0.8 0.6]);
set(gca,'Visible','on','Box','off','FontSize',12,'FontWeight','normal');
set(gca,'Xcolor',[0.8 0.2 0.3],'Ycolor',[0.8 0.2 0.3]);
xlabel('Number of Spike');
ylabel('Maximum IPSC');

end
