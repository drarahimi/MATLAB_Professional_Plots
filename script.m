clc; % clear workspace
clear; % clear command window
close all % close all open figures
%% preparing data
x = 0:0.01:2;
y1 = sin(10*x);
y2 = cos(20*x);
%% plotting properties
titles_font_size =15; % stores title font size
labels_font_size=20; % stores labels font size
legend_font_size = 13; % stores legend font size
font_name = 'Times'; % stores font name
line_width=1.5; % stores line width (thickness of trend lines)
num_of_x_grid = 10;
legend_line_width = 14;
legened_marker_size = 5;
legend_columns = 2;
  
%% plotting single plots
fig=figure('visible','on');  % adds a new figure with pre-defined position
set(fig, 'Units', 'Normalized', 'OuterPosition', [0.2, 0.2, 0.6, 0.7]); % set figure size    
set(fig, 'Color', 'w') %set the figure background to white instead of default grey

plot(x, y1,'r-','Displayname','$Sin(x)$', 'LineWidth', line_width) % plot data 1
hold on
plot(x, y2,'b-','Displayname','$Cos(x)$', 'LineWidth', line_width) % plot data 2

title('$Sin(x) + Cos(x)\ trends$', 'interpreter','latex','FontSize',titles_font_size) % add title
xlabel('$X\ [-]$', 'interpreter','latex','FontSize',labels_font_size) % add x label
ylabel('$Output\ Y\ [-]$', 'interpreter','latex','FontSize',labels_font_size) % add y label

grid on % add grid lines
set(gca,'GridLineStyle','--') % set grid line style

leg = legend('interpreter','latex','location','southwest', ...
    'Orientation','horizontal','NumColumns',legend_columns,'FontSize',legend_font_size); % add legend
leg.ItemTokenSize = [legend_line_width,legened_marker_size]; %set legend marker size and line width, default is line_width=30, marker_size=18 for chaning the line size in legend

%set(gca,'Fontsize',labels_font_size,'Fontname',font_name,'ycolor','k') % set label font name and size

%if you want to change the font name and size in all elements of the figure
%use the target in the fontsize and fontname as fig, otherwise use the
%target as individual axes
fontsize(fig,labels_font_size,"points") % set label font name and size
fontname(fig,font_name) % set label font name and size

% use only one of the following options
% option 1 to remove extra white spaces around the plot axes in the figure
ax(1) = gca; % get the current axis
ti = ax(1).TightInset;  % find current axis tight layout
%ax.Position = [ti(1), ti(2), 1 - ti(1) - ti(3), 1 - ti(2) - ti(4)]; % remove figures extra empty padding around axis

% option 2 to remove extra white spaces around the plot axes in the figure
set(gca, 'Position', get(gca, 'OuterPosition') - ...
    get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);

ylim([-5,2])

ax(1).YAxis.Exponent = 1; %if you need to make the axis numbers exponent form
ytickformat('%.1f') % the format for the exponent form on the axis ticks

box on % set axis box on/off

% if you wish to add a zoom plot use 
% note that if you leave the 2nd, 3rd, and 4th, elements in the function as
% empty (i.e.,[]) then the function will work interactively to help you
% place your zoomed axes on your main axis. It will also give you the final
% elements in the command window so you can use it in future to hard-code
% them in your main script after you identify the elements interactively
zoomPlot(ax(1),[],[],[],"showTicks","off");

set(fig, 'PaperPositionMode', 'auto') % note that needs to be set to avoid undesired print/save results
saveas(fig,'plot_single.svg') % save figure in svg (vector) format in the current directory
saveas(fig,'plot_single.png') % save figure in png format in the current directory

%% plotting multiple (sub) plots
% for this purpose we can use a great function developed by Eduard Reitmann
% note that you have to make your figure invisible first for this function
% to work properly and after all your work is done make it visible again
fig=figure('visible','off');  % adds a new figure with pre-defined position
set(fig, 'Units', 'Normalized', 'OuterPosition', [0.2, 0.2, 0.6, 0.7]); % set figure size    
set(fig, 'Color', 'w') %set the figure background to white instead of default grey

ax(1) = subplot_er(2,2,1);

plot(x, y1,'r-','Displayname','$Sin(x)$', 'LineWidth', line_width) % plot data 1
title('$Sin(x)\ trends$', 'interpreter','latex','FontSize',titles_font_size) % add title
xlabel('$X\ [-]$', 'interpreter','latex','FontSize',labels_font_size) % add x label
ylabel('$Output\ Y\ [-]$', 'interpreter','latex','FontSize',labels_font_size) % add y label

grid on % add grid lines
set(gca,'GridLineStyle','--') % set grid line style

ax(1).YAxis.Exponent = 1; %if you need to make the axis numbers exponent form
ytickformat('%.1f') % the format for the exponent form on the axis ticks

leg = legend('interpreter','latex','location','best','Orientation','horizontal', ...
    'NumColumns',legend_columns,'FontSize',legend_font_size); % add legend
leg.ItemTokenSize = [legend_line_width,legened_marker_size]; %set legend marker size and line width, default is line_width=30, marker_size=18 for chaning the line size in legend

%if you want to change the font name and size in all elements of the figure
%use the target in the fontsize and fontname as fig, otherwise use the
%target as individual axes
fontsize(ax(1),labels_font_size,"points") % set label font name and size
fontname(ax(1),font_name) % set label font name and size

ax(2) = subplot_er(2,2,2);

plot(x, y2,'b-','Displayname','$Cos(x)$', 'LineWidth', line_width) % plot data 2
title('$Cos(x)\ trends$', 'interpreter','latex','FontSize',titles_font_size) % add title
xlabel('$X\ [-]$', 'interpreter','latex','FontSize',labels_font_size) % add x label
ylabel('$Output\ Y\ [-]$', 'interpreter','latex','FontSize',labels_font_size) % add y label

grid on % add grid lines
set(gca,'GridLineStyle','--') % set grid line style

ax(2).YAxis.Exponent = 1; %if you need to make the axis numbers exponent form
ytickformat('%.1f') % the format for the exponent form on the axis ticks

leg = legend('interpreter','latex','location','best','Orientation','horizontal', ...
    'NumColumns',legend_columns,'FontSize',legend_font_size); % add legend
leg.ItemTokenSize = [legend_line_width,legened_marker_size]; %set legend marker size and line width, default is line_width=30, marker_size=18 for chaning the line size in legend

%if you want to change the font name and size in all elements of the figure
%use the target in the fontsize and fontname as fig, otherwise use the
%target as individual axes
fontsize(ax(2),labels_font_size,"points") % set label font name and size
fontname(ax(2),font_name) % set label font name and size

ax(3) = subplot_er(2,2,[3 4]);

plot(x, y1+y2,'g-','Displayname','$Sin(x)+Cos(x)$', 'LineWidth', line_width) % plot data 2

title('$Sin(x) + Cos(x)\ trends$', 'interpreter','latex','FontSize',titles_font_size) % add title
xlabel('$X\ [-]$', 'interpreter','latex','FontSize',labels_font_size) % add x label
ylabel('$Output\ Y\ [-]$', 'interpreter','latex','FontSize',labels_font_size) % add y label

grid on % add grid lines
set(gca,'GridLineStyle','--') % set grid line style

leg = legend('interpreter','latex','location','best', ...
    'Orientation','horizontal','NumColumns',legend_columns,'FontSize',legend_font_size); % add legend
leg.ItemTokenSize = [legend_line_width,legened_marker_size]; %set legend marker size and line width, default is line_width=30, marker_size=18 for chaning the line size in legend

%if you want to change the font name and size in all elements of the figure
%use the target in the fontsize and fontname as fig, otherwise use the
%target as individual axes
fontsize(ax(3),labels_font_size,"points") % set label font name and size
fontname(ax(3),font_name) % set label font name and size

ylim([-5,2])

ax(3).YAxis.Exponent = 1; %if you need to make the axis numbers exponent form
ytickformat('%.1f') % the format for the exponent form on the axis ticks

box on % set axis box on/off

% if you wish to add a zoom plot use 
% note that if you leave the 2nd, 3rd, and 4th, elements in the function as
% empty (i.e.,[]) then the function will work interactively to help you
% place your zoomed axes on your main axis. It will also give you the final
% elements in the command window so you can use it in future to hard-code
% them in your main script after you identify the elements interactively
%zoomPlot(ax,[],[],[],"showTicks","off");

set(fig,'Visible','on')

set(fig, 'PaperPositionMode', 'auto') % note that needs to be set to avoid undesired print/save results
saveas(fig,'plot_multiple.svg') % save figure in svg (vector) format in the current directory
saveas(fig,'plot_multiple.png') % save figure in png format in the current directory
