function [y ,trace]=psoforlssvm(N,ger,X1,y1,Xt,yt)
ger ; %��Ⱥ��������
N ;  %��Ⱥ��
d=2;%gamma sig2
hid=d;
hmin=0;
hmax=1000;% ���ݷ�Χ[0 1000]
wmax = 0.9;  wmin=0.5;
cmax = 0.9;  cmin=0.5;
for i=1:hid
    xlim(i,1:2)=[hmin,hmax];
    vlim(i,1:2)=[-1,1];
end
xlimit = xlim(:,1:2);  
vlimit =vlim(:,1:2);  
%% ��Ⱥ��ʼ��  
x1 = repmat(xlimit(:,1)',N,1)+repmat(diff(xlimit'),N,1).*rand(N,d);  
x=boundary(x1,hmin,hmax);
v = repmat(vlimit(:,1)',N,1)+repmat(diff(vlimit'),N,1).*rand(N,d);  

xm = x;  
fxm = -inf*ones(N,1);  
ym = xlimit(:,1)'+diff(xlimit').*rand(1,d);  
fym = -inf;  
%% ��ʼ����  
for i = 1 : ger  
    t=i
    for j = 1 : N  
        % ��Ӧ�Ⱥ��� 
       x=boundary(x,hmin,hmax);%�жϱ߽�����
       y(j)=fun(x,X1,y1,Xt,yt);
        if y(j)>fxm(j)  
                 fxm(j)=y(j);  
                xm(j,:) = x(j,:);     %���弫ֵ����λ��
        end  
         if y(j)>fym  
                fym = y(j);  
                ym = x(j,:); %Ⱥ�弫ֵ����λ��
         end  
    end  
    fit(i)=fym;
    w=wmax-(wmax-wmin)*i./ger;
    c1=cmax-(cmax-cmin)*i./ger;
    c2=cmin+(cmax-cmin)*i./ger;
    v = w*v+c1*rand*(xm-x)+c2*rand*(repmat(ym,N,1)-x);  
    x = x+v;  
    x = min(x,repmat(xlimit(:,2)',N,1));  
    x = max(x,repmat(xlimit(:,1)',N,1));  
    v = min(v,repmat(vlimit(:,2)',N,1));  
    v = max(v,repmat(vlimit(:,1)',N,1));  
end  
trace=fit;
y=xm;
%���۸����㷨�Ż���ȼ���ѧϰ������392503054