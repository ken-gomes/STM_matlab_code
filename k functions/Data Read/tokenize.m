function [tokens, locs] = tokenize(intext)

%used by mvpagerd.m
idxws = diff([1 isspace(intext) 1]);
starts = find(idxws==-1);
ends = find(idxws==1);

tokens=[]; locs=zeros(5,1);
for i=1:length(starts),
   strg=intext(starts(i):ends(i)-1);
   tokens=strvcat(tokens, strg);
   switch strg,
   	case 'X', 		locs(1)=i;
      case 'Y', 		locs(2)=i;
      case 'Z', 		locs(3)=i;
      case 'XY',		locs(4)=i;
      case 'IV',		locs(5)=i;
      case 'scan', 	locs(6)=i;
      otherwise,
   end;
end;