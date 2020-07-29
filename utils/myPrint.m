function varargout = myPrint(fid, varargin)
% myPrint('print_pdf', gcf, 'abc', [40,20], 'inches');
%
if ~exist('fid','var')% & ~exist('varargin','var')
    test_print();
    return;
end

fh = str2func(fid);
[varargout{1:nargout}] = fh(varargin{:});
return;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function test_print()

[X,Y] = meshgrid([-2:0.1:2]);
Z = X.*exp(-X.^2-Y.^2);
plot3(X,Y,Z)
grid on

hf=gcf;
filename = 'test';
papersize = [20,10];
units = 'inches';
renderer = 'painters';  % zbuffer opengl

myPrint('print_pdf',hf, filename, papersize, units, renderer);

return;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function print_tiff(hf, filename, papersize, units, renderer)
% ex: myPrint('print_pdf', gcf, 'abc', [40,20], 'inches');
figure(hf);
if ~exist('renderer','var')
    renderer='painters';
end
set(hf,'renderer',renderer);


if ~exist('papersize','var')
    papersize = get(hf, 'PaperSize');
end

if ~exist('unit','var')
    units = get(gcf, 'PaperUnits');
end

left = max(0.8, papersize(1)*0.05);
bottom = max(0.8,papersize(2)*0.05);
width = papersize(1)-left*2;
height = papersize(2)-bottom*2;

set(gcf, 'PaperUnits', units)
set(gcf,'papersize',papersize);
set(gcf, 'PaperPosition', [left, bottom, width, height]);

%print
print(hf, '-dtiff', filename);

return;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function print_eps(hf, filename, papersize, units, renderer)
% ex: myPrint('print_pdf', gcf, 'abc', [40,20], 'inches');
figure(hf);
if ~exist('renderer','var')
    renderer='painters';
end
set(hf,'renderer',renderer);


if ~exist('papersize','var')
    papersize = get(hf, 'PaperSize');
end

if ~exist('unit','var')
    units = get(gcf, 'PaperUnits');
end

left = max(0.8, papersize(1)*0.05);
bottom = max(0.8,papersize(2)*0.05);
width = papersize(1)-left*2;
height = papersize(2)-bottom*2;

set(gcf, 'PaperUnits', units)
set(gcf,'papersize',papersize);
set(gcf, 'PaperPosition', [left, bottom, width, height]);


% set(hf,'Units','Inches');
% pos = get(hf,'Position');
% set(hf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
% % fig = gcf;
% % fig.PaperPositionMode = 'auto'
% % fig_pos = fig.PaperPosition;
% % fig.PaperSize = [fig_pos(3) fig_pos(4)];

%print
print(hf, '-depsc', '-adobecset', filename);

return;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function print_pdf(hf, filename, papersize, units, renderer)
% ex: myPrint('print_pdf', gcf, 'abc', [40,20], 'inches');

%figure(hf);

if ~exist('renderer','var')
    renderer='painters';
end
set(hf,'renderer',renderer);

if ~exist('papersize','var')
    papersize = get(hf, 'PaperSize');
end

if ~exist('unit','var')
    units = get(hf, 'PaperUnits');
end


set(hf, 'PaperUnits', units)
set(hf, 'papersize',papersize);
% 
set(hf, 'PaperPosition', [0, 0, papersize(1), papersize(2)]);

%print
print(hf, '-dpdf', filename);

return;



function print_pdf_old(hf, filename, papersize, units, renderer)
% ex: myPrint('print_pdf', gcf, 'abc', [40,20], 'inches');

%figure(hf);

if ~exist('renderer','var')
    renderer='painters';
end
set(hf,'renderer',renderer);


if ~exist('papersize','var')
    papersize = get(hf, 'PaperSize');
end

if ~exist('unit','var')
    units = get(hf, 'PaperUnits');
end


set(hf, 'PaperUnits', units)
set(hf, 'papersize',papersize);



% Old method
left = max(0.8, papersize(1)*0.05);
bottom = max(0.8,papersize(2)*0.05);
width = papersize(1)-left*2;
height = papersize(2)-bottom*2;



% New method
margin_xl = 0.015;
margin_xr = 0.035;
margin_y = 0.01;

children = hf.Children;
ppp = [1 1 0 0 ];
for ci = 1:numel(children)
    if strcmp(class(hf.Children(ci)), 'matlab.ui.container.ContextMenu')
        continue;
    end
    pos = hf.Children(ci).Position;
    if strcmp(class(hf.Children(ci)), 'matlab.graphics.axis.Axes')
    %if isfield(hf.Children(ci), 'TightInset')
        tightinset = hf.Children(ci).TightInset;
    else
        tightinset = [0 0 0 0];
    end
    
    ppp(1) = min( ppp(1), pos(1)-tightinset(1)-margin_xl );
    ppp(2) = min( ppp(2), pos(2)-tightinset(2)-margin_y );
    ppp(3) = max( ppp(3), pos(1)+pos(3)+tightinset(3)+margin_xr );
    ppp(4) = max( ppp(4), pos(2)+pos(4)+tightinset(4)+margin_y );
    
end

left = -papersize(1) / (ppp(3)-ppp(1)) * ppp(1);
width = papersize(1) / (ppp(3)-ppp(1));
bottom = -papersize(2) / (ppp(4)-ppp(2)) * ppp(2);
height = papersize(2) / (ppp(4)-ppp(2));


% 
set(hf, 'PaperPosition', [left*0.8, bottom*0.7, width*0.9, height*0.9]);
%set(hf, 'PaperPosition', [0, 0, width, height]);




% set(hf,'Units','Inches');
% pos = get(hf,'Position');
% set(hf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
% % fig = gcf;
% % fig.PaperPositionMode = 'auto'
% % fig_pos = fig.PaperPosition;
% % fig.PaperSize = [fig_pos(3) fig_pos(4)];
% 

%print
print(hf, '-dpdf', filename);

return;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function print_ai(hf, filename, papersize, units, renderer)
% ex: myPrint('print_ai', gcf, 'abc', [40,20], 'inches');
figure(hf);
if ~exist('renderer','var')
    renderer='painters';
end
set(hf,'renderer',renderer);


if ~exist('papersize','var')
    papersize = get(hf, 'PaperSize');
end

if ~exist('unit','var')
    units = get(gcf, 'PaperUnits');
end

left = max(0.8, papersize(1)*0.05);
bottom = max(0.8,papersize(2)*0.05);
width = papersize(1)-left*2;
height = papersize(2)-bottom*2;

set(gcf, 'PaperUnits', units)
set(gcf,'papersize',papersize);
set(gcf, 'PaperPosition', [left, bottom, width, height]);

% set(hf,'Units','Inches');
% pos = get(hf,'Position');
% set(hf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
% % fig = gcf;
% % fig.PaperPositionMode = 'auto'
% % fig_pos = fig.PaperPosition;
% % fig.PaperSize = [fig_pos(3) fig_pos(4)];


%print
print(hf, '-dill', filename);

return;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function print_jpg(hf, filename, papersize, units, renderer)
% ex: myPrint('print_ai', gcf, 'abc', [40,20], 'inches');
figure(hf);
if ~exist('renderer','var')
    renderer='painters';
end
set(hf,'renderer',renderer);


if ~exist('papersize','var')
    papersize = get(hf, 'PaperSize');
end

if ~exist('unit','var')
    units = get(gcf, 'PaperUnits');
end

left = max(0.8, papersize(1)*0.05);
bottom = max(0.8,papersize(2)*0.05);
width = papersize(1)-left*2;
height = papersize(2)-bottom*2;

set(gcf, 'PaperUnits', units)
set(gcf,'papersize',papersize);
set(gcf, 'PaperPosition', [left, bottom, width, height]);

%print
print(hf, '-djpeg', filename);

return;




