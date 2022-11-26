function [desAx] = zoomPlot(srcAx,desLoc,srcLoc,conVec,options)
    arguments
        srcAx handle
        desLoc double
        srcLoc double
        conVec double
        options.showTicks {mustBeMember(options.showTicks,["on","off"])} = "on"
        options.showGridline {mustBeMember(options.showGridline,["on","off"])} = "off"
        options.axisBackColor string = 'none'
        options.boxColor string = 'k'
        options.lineColor string = 'k'
        options.boxStyle (1,1) string = '-'
        options.lineStyle (1,1) string = '-'
        options.lineWidth (1,1) {mustBeNumeric} = 1
    end
%%% This function add a magnified axis to the given axis to amplify the
%%% visibility of smaller details in the given axis

% Inputs
% srcAx  = given axis to the add a magnified axis to
% desLoc = destination axis, aka where the magnified axis is going to be 
%          added in the source axis coordinates 
%          [leftx bottomx rightx topx] all in src coordinate
% srcLoc = source axis, aka the axis you want to add magnification to 
%          highlight some details 
%          [leftx bottomx rightx topx] all in src coordinate
% conVec = connection vector, check the position of src and dees boxes for 
%          conneting lines. conVec goes from topLeft, topRight, bottomRight, 
%          bottomLeft in order of 1,2,3,4 resepctively. The first 2 are the 
%          location of the source axis and the second 2 are the locations 
%          of the des axis. For example [1,2,3,4] will connect the topLeft 
%          of the source to bottomRight of the des and topRight of the source 
%          to bottomLeft of the des
%
% Output
% desAx = the added axis to the given axis (srcAx)

% if any of the srcLoc, desLoc or conVec are empty, the function will ask
% user to input them or automatically assigns them
if (isempty(srcLoc))
    msg = text(0,1,'Step 1: Select SOURCE rectangle, 1st bottom-left then top-right corner', ...
        'color','r','FontSize',14,'BackgroundColor','w','HorizontalAlignment','left', ...
        'VerticalAlignment','top','Units','normalized');
    % note that first click is position of bottom-left and second click is
    % position of top-right corner of the box for srcLoc
    pts = ginput(2);
    srcLoc = [pts(1,1) pts(1,2) pts(2,1) pts(2,2)];
    % rectangle for the box on the src axis showing which area is being magnified (src)
    rectangle(srcAx,'Position',[srcLoc(1) srcLoc(2) srcLoc(3)-srcLoc(1) srcLoc(4)-srcLoc(2)],'EdgeColor',options.boxColor,'linestyle',options.lineStyle,'lineWidth',options.lineWidth)
    delete(msg);
end
if (isempty(desLoc))
    msg = text(0,1,'Step 2: Select DESTINATION rectangle, 1st bottom-left then top-right corner', ...
        'color','b','FontSize',14,'BackgroundColor','w','HorizontalAlignment','left', ...
        'VerticalAlignment','top','Units','normalized');
    % note that first click is position of bottom-left and second click is
    % position of top-right corner of the box for desLoc
    pts = ginput(2);
    desLoc = [pts(1,1) pts(1,2) pts(2,1) pts(2,2)];
    delete(msg);
end
if (isempty(conVec))
    srcCenter = [(srcLoc(1)+srcLoc(3))/2 (srcLoc(2)+srcLoc(4))/2];
    desCenter = [(desLoc(1)+desLoc(3))/2 (desLoc(2)+desLoc(4))/2];
    if (srcCenter(1)<desCenter(1))
        if(desCenter(2)>srcLoc(2) && desCenter(2)<srcLoc(4))
            conVec = [2 3 1 4];
        elseif (desCenter(2)<srcLoc(2))
            conVec = [3 4 2 1];
        elseif (desCenter(2)>srcLoc(2))
            conVec = [1 2 4 3];
        end
    else
        if(desCenter(2)>srcLoc(2) && desCenter(2)<srcLoc(4))
            conVec = [1 4 2 3];
        elseif (desCenter(2)<srcLoc(2))
            conVec = [3 4 2 1];
        elseif (desCenter(2)>srcLoc(2))
            conVec = [1 2 4 3];
        end
    end
end
fprintf('desLoc, srcLoc, conVec = [%.3g %3.g %.3g %.3g], [%.3g %.3g %.3g %.3g], [%d %d %d %d]\n',desLoc,srcLoc,conVec);

%% calculating the required coordinates
% step 1: get destination axis data point's (x,y) coordinate for bottom
% left of the inserted axis in coordinates of the source axis
desAxXY = desLoc(1:2);                                                     % coordinate in data unit
% step 2: get the source axis x and y limits
xl = get(srcAx,'xlim');                                                    % limits in data unit
yl = get(srcAx,'ylim');                                                    % limits in data unit
% setp 3: get source axis position in its containing figure
set(srcAx, 'Units', 'Normalize');                                          % set the axis measurement unit to normalized
srcAxPos = get(srcAx,'position');                                          % source axis position in figure unit [0,1]
% step 4: convert data coordinate from data space to figure space
desAxXYNorm = (desAxXY - [xl(1),yl(1)]);                                   % deduct source axis origin from x,y
desAxXYNorm = desAxXYNorm./[max(xl)-min(xl),max(yl)-min(yl)];              % normalized to source axis
if strcmpi(get(srcAx, 'ydir'),'reverse')
    desAxXYNorm(2) = 1 - desAxXYNorm(2);                                   % This is needed iff y axis direction is reversed!
end
desAxXYFigNorm = srcAxPos(1:2) + srcAxPos(3:4).*desAxXYNorm;               % normalized to figure 
% step 5: create new axes  
desWidth = srcAxPos(3)/(max(xl)-min(xl))*(desLoc(3)-desLoc(1));            % calculate des axis width in normalized units
desHeight = srcAxPos(4)/(max(yl)-min(yl))*(desLoc(4)-desLoc(2));           % calculate des axis height in normalized units
desAxSize = [desWidth,desHeight];                                          % size of des axis in normalized units combining widht and height
desAx = axes('Units','Normalize', ...
             'Position',[desAxXYFigNorm, desAxSize], ...
             'color', options.axisBackColor);                              % add the des axis to the figure
% step 6: set axes x and y limits to be as zoomped area in the source axis
set(desAx,'xlim',[srcLoc(1), srcLoc(3)]);
set(desAx,'ylim',[srcLoc(2), srcLoc(4)]);

% step 7: copy all source axis objects to destination axis
srcAxChils = srcAx.Children;
copyobj(srcAxChils, desAx)

%% check and adds grids
if (options.showGridline=="on")
    grid on % add grid lines
    set(desAx,'GridLineStyle','--')
end

%% check and add x and y ticks
if (options.showTicks=="off")
    desAx.XTickLabel={};
    desAx.YTickLabel={};
    set(desAx,'XColor','none','YColor','none')
end 

%% check and add rectangles for the destination axes
% rectangle for the box on the source axis showing the magnified axis (des)
rectangle(desAx,'Position',[srcLoc(1) srcLoc(2) srcLoc(3)-srcLoc(1) srcLoc(4)-srcLoc(2)],'EdgeColor',options.boxColor,'linestyle',options.lineStyle,'lineWidth',options.lineWidth)

%% check and add connecting lines between the source and destination axes
x1=0;y1=0;
x2=0;y2=0;
x3=0;y3=0;
x4=0;y4=0;
switch conVec(1)
    case 1
        x1=srcLoc(1);
        y1=srcLoc(4);
    case 2
        x1=srcLoc(3);
        y1=srcLoc(4);
    case 3
        x1=srcLoc(3);
        y1=srcLoc(2);
    case 4
        x1=srcLoc(1);
        y1=srcLoc(2);
end
switch conVec(2)
    case 1
        x2=srcLoc(1);
        y2=srcLoc(4);
    case 2
        x2=srcLoc(3);
        y2=srcLoc(4);
    case 3
        x2=srcLoc(3);
        y2=srcLoc(2);
    case 4
        x2=srcLoc(1);
        y2=srcLoc(2);
end
switch conVec(3)
    case 1
        x3=desLoc(1);
        y3=desLoc(4);
    case 2
        x3=desLoc(3);
        y3=desLoc(4);
    case 3
        x3=desLoc(3);
        y3=desLoc(2);
    case 4
        x3=desLoc(1);
        y3=desLoc(2);
end
switch conVec(4)
    case 1
        x4=desLoc(1);
        y4=desLoc(4);
    case 2
        x4=desLoc(3);
        y4=desLoc(4);
    case 3
        x4=desLoc(3);
        y4=desLoc(2);
    case 4
        x4=desLoc(1);
        y4=desLoc(2);
end

line(srcAx,[x1,x3],[y1,y3],'Color',options.lineColor,'LineStyle',options.lineStyle,'HandleVisibility','off','lineWidth',options.lineWidth)
line(srcAx,[x2,x4],[y2,y4],'Color',options.lineColor,'LineStyle',options.lineStyle,'HandleVisibility','off','lineWidth',options.lineWidth)

end

