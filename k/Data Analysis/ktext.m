function out=ktext(txt, x,y, ftsz)

% out=ktext(txt, x,y, ftsz)
% generates a text of "txt" located at x and y with font size ftsz

if nargin<4, ftsz=12;end;
if nargin<2, x=10; y=5; end;

out=text(x,y, txt,'color','white','FontSize',ftsz,'FontWeight', 'Bold','FontName','Helvetica', 'BackgroundColor', [.3,.3,.3]);