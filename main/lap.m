function [Lap,V]=lap(stroke,depth,y_static,x_static)
Lap=zeros(size(stroke,1));
for i=1:size(stroke,1)
    y=stroke(i,1);
    x=stroke(i,2);
    A=find((y-2)<stroke(:,1)&stroke(:,1)<(y+2)&(x-2)< stroke(:,2)& stroke(:,2)<(x+2));
    Lap(i,A)=-1;
    Lap(i,i)=length(A)-1;
end
V=Lap*depth;

ind_static=[];
V_static=zeros(length(y_static),1);
Lap_static=zeros(length(y_static),size(Lap,2));
for i=1:length(y_static)
    ind_static(i)=find(stroke(:,1)==x_static(i)& stroke(:,2)==y_static(i));
    V_static(i)=depth(ind_static(i));
    Lap_static(i,ind_static(i))=1;
end
Lap=[Lap;Lap_static];
V=[V;V_static];
end


