clc; % clear workspace
clear; % clear command window
close all % close all open figures
%% preparing data
x = 0:0.01:10;
y1 = sin(x);
y2 = cos(x);
%% plotting
titles_font_size =15; % stores title font size
labels_font_size=20; % stores labels font size
font_name = 'Times'; % stores font name
line_width=1.5; % stores line width (thickness of trend lines)
  
f=figure('visible','on');  % adds a new figure
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.2, 0.2, 0.6, 0.7]); % set figure size    
set(gcf, 'Color', 'w') %set the figure background to white instead of default grey

plot(x, y1,'r-', x, y2,'b-', 'LineWidth', line_width) % plot data
title('$Sin(x) + Cos(x)\ trends$','Fontsize',labels_font_size,'Fontname',font_name, 'interpreter','latex') % add title
xlabel('$X\ [-]$','Fontsize',labels_font_size,'Fontname',font_name, 'interpreter','latex') % add x label
ylabel('$Output\ Y\ [-]$','Fontsize',labels_font_size,'Fontname',font_name, 'interpreter','latex') % add y label
grid on % add grid lines
set(gca,'GridLineStyle','--') % set grid line style
legend('$Sin(x)$','$Cos(x)$', 'interpreter','latex') % add legend

set(gca,'Fontsize',labels_font_size,'Fontname',font_name,'ycolor','k') % set label font name and size

ax = gca; % get the current axis
ti = ax.TightInset;  % find current axis tight layout
ax.Position = [ti(1), ti(2), 1 - ti(1) - ti(3), 1 - ti(2) - ti(4)]; % remove figures extra empty padding around axis

saveas(gcf,'plot.svg') % save figure in svg (vector) format in the current directory