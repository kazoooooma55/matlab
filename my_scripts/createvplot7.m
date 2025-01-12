function[h_quiver,h_surf,h_contour,h_annot]=  createvplot7(XData1,YData1,CData1,XData2,YData2,UData2,VData2,zdata2,scale,annot_str, title1,Cmin,Cmax, colmap, xsize,ysize,xmin,xmax,ymin,ymax,unit,LevelList)
%CREATEFIGURE(ZDATA1,YDATA1,XDATA1,CDATA1,ZDATA2)
%  ZDATA1:  surface zdata
%  YDATA1:  surface ydata
%  XDATA1:  surface xdata
%  CDATA1:  surface cdata
%  ZDATA2:  contour z

figure1 = figure('PaperSize',[20 30],...
    'Color',[1 1 1],...
    'Colormap',colmap,...
    'GraphicsSmoothing','off',...
    'Position',[0 0 xsize ysize]);

dx=xmax-xmin;
dy=ymax-ymin;
for i=0:10
    interval = 10^i;
    if(min(dx/10^i,dy/10^i)<10)
        break
    end
end

if strcmp(unit,'latlon')
    lat_m=median(YData1,'all');
    aspr=1/cos(lat_m/180*pi);
else
    aspr=1;
end

% axes
axes1 = axes('Parent',figure1,...
    'YTick', ymin:interval:ymax,...
    'XTick', xmin:interval:xmax,...
    'FontSize',9,...
    'FontName','Arial',...
    'CLim',[Cmin Cmax],...
    'Box','on');

% Axes
 xlim(axes1,[xmin xmax]);
 xticks('auto')
% Axes
 ylim(axes1,[ymin ymax]);
% ylim auto
yticks('auto')
hold(axes1,'all');
pbaspect([dx dy*aspr 1])


% surface

% colorbar
colorbar('peer',axes1,...
    'FontSize',9,'FontName','Arial');

h_surf=pcolor(XData1,YData1,CData1);
% shading flat;
shading interp;

% contour
h_contour=contour(XData1,YData1,zdata2,...
    'LineColor',[0.48 0.06 0.92],...
    'LevelList',LevelList,...
    'Parent',axes1,...
    'ShowText','off');

% quiver
U=UData2*scale;
V=VData2*scale;
h_quiver=quiver(XData2,YData2,U,V,...
    'Color', 'k',...
    'AutoScale','off');

if strcmp(unit,'km')
    % xlabel
    xlabel('X (km)','FontSize',9,'FontName','Arial');
    % ylabel
    ylabel('Y (km)','FontSize',9,'FontName','Arial');
elseif strcmp(unit,'m') 
    % xlabel
    xlabel('X (m)','FontSize',9,'FontName','Arial');
    % ylabel
    ylabel('Y (m)','FontSize',9,'FontName','Arial');
elseif strcmp(unit,'latlon')
    % xlabel
    xlabel('Longitude','FontSize',9,'FontName','Arial');
    % ylabel
    ylabel('Latitude','FontSize',9,'FontName','Arial');
end

% title
title(title1,'FontSize',12,'FontName','Arial', 'FontWeight', 'normal');

% colorbar
%colormap(colmap);
%colorbar('peer',axes1);

% textbox
h_annot=annotation(figure1,'textbox',...
    [0.0 0.015 0.9 0.035],...
    'HorizontalAlignment', 'center',...
    'String',annot_str,...
    'FontName','Arial',...
    'FontSize',11,...
    'FitBoxToText','on',...
    'LineStyle','none');




