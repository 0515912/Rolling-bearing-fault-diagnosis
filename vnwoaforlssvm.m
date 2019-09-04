% ���������ṹ�ľ����Ż�
function [Leader_pos,Convergence_curve]=vnwoaforlssvm(popsize,Max_iter,X1,y1,Xt,yt)
dim=2;
lb=0;
ub=1000;
Convergence_curve=zeros(1,Max_iter);
%%  ��ʼȫ�����Ž�
%Initialize the positions of search agents
for i=1:popsize
    Positions(i,:)=rand(1,dim).*(ub-lb)+lb;
end

for i=1:popsize
    p(i)=fun(Positions(i,:),X1,y1,Xt,yt); %���㵱ǰ������Ӧ��ֵ
end
[~, index]=min(p);
Leader_pos=Positions(index,:);
Leader_score=p(index);


% ���������������
for i=1:popsize
    if i==1
        %luoyiman_localbest(ǰ�����м䣬����)
        plocal(i,:)=luoyiman_localbest(Positions(popsize-1,:),Positions(popsize,:),Positions(i,:),Positions(i+1,:),Positions(i+2,:),X1,y1,Xt,yt);
    elseif i==2
        plocal(i,:)=luoyiman_localbest(Positions(popsize,:),Positions(i-1,:),Positions(i,:),Positions(i+1,:),Positions(i+2,:),X1,y1,Xt,yt);
    elseif i==popsize-1 
        plocal(i,:)=luoyiman_localbest(Positions(i-2,:),Positions(i-1,:),Positions(i,:),Positions(popsize,:),Positions(1,:),X1,y1,Xt,yt);
    elseif i==popsize
        plocal(i,:)=luoyiman_localbest(Positions(i-2,:),Positions(i-1,:),Positions(i,:),Positions(1,:),Positions(2,:),X1,y1,Xt,yt);
    else
        plocal(i,:)=luoyiman_localbest(Positions(i-2,:),Positions(i-1,:),Positions(i,:),Positions(i+1,:),Positions(i+2,:),X1,y1,Xt,yt);
    end
end



%% Main loop
for t=1:Max_iter
    t
    %% ��Ⱥ����
    for i=1:size(Positions,1)
        a=2-t*(2/Max_iter); % a decreases linearly from 2 to 0
        % a2 linearly dicreases from -1 to -2 to calculate t
        a2=-1+t*((-1)/Max_iter);
        r1=rand; % r1 is a random number in [0,1]
        r2=rand; % r2 is a random number in [0,1]
        A=2*a*r1-a;  
        C=2*r2;      
        b=1;              
        l=(a2-1)*rand+1;   
        p = rand;        
        for j=1:size(Positions,2)
            if p<0.5   
                if abs(A)>=1
                    rand_leader_index = floor(popsize*rand()+1);
                    X_rand = Positions(rand_leader_index, :);
                    D_X_rand=abs(C*X_rand(j)-Positions(i,j)); 
                    Positions(i,j)=X_rand(j)-A*D_X_rand;      
                elseif abs(A)<1
                    D_Leader=abs(C*Leader_pos(j)-Positions(i,j)); 
                    Positions(i,j)=Leader_pos(j)-A*D_Leader;      
                end
            elseif p>=0.5
                distance2Leader=abs(Leader_pos(j)-Positions(i,j));
                Positions(i,j)=distance2Leader*exp(b.*l).*cos(l.*2*pi)+Leader_pos(j);
            end
        end
       %% ��⾨���Ƿ�Խ�� ����Խ�紦��
        Positions(i,:)=boundary(Positions(i,:),lb,ub);
        %% �������� �ж������
        if i==1
            %luoyiman_localbest(ǰ�����м䣬����)
            plocal(i,:)=luoyiman_localbest(Positions(popsize-1,:),Positions(popsize,:),Positions(i,:),Positions(i+1,:),Positions(i+2,:),X1,y1,Xt,yt);
        elseif i==2
            plocal(i,:)=luoyiman_localbest(Positions(popsize,:),Positions(i-1,:),Positions(i,:),Positions(i+1,:),Positions(i+2,:),X1,y1,Xt,yt);
        elseif i==popsize-1
            plocal(i,:)=luoyiman_localbest(Positions(i-2,:),Positions(i-1,:),Positions(i,:),Positions(popsize,:),Positions(1,:),X1,y1,Xt,yt);
        elseif i==popsize
            plocal(i,:)=luoyiman_localbest(Positions(i-2,:),Positions(i-1,:),Positions(i,:),Positions(1,:),Positions(2,:),X1,y1,Xt,yt);
        else
            plocal(i,:)=luoyiman_localbest(Positions(i-2,:),Positions(i-1,:),Positions(i,:),Positions(i+1,:),Positions(i+2,:),X1,y1,Xt,yt);
        end
        % ���÷������������еľֲ������뵱ǰ����������Ӧ��ȫ�����Ž��и��£����ŵ����Ľ��У��ֲ������𽥺�ȫ�������غ�
        w=1-exp(1-t);
        Positions(i,:)=w*plocal(i,:)+(1-w)*Leader_pos;%���������ߵ�Ȩ�ؾ�Ϊ0.5.�����Ҳ�������ӦȨ�أ����ŵ����Ľ��У����Լ���
        % Calculate objective function for each search agent
        fitness=fun(Positions(i,:),X1,y1,Xt,yt);
   %%  ȫ�����Ž����
        if fitness>Leader_score 
            Leader_score=fitness; 
            Leader_pos=Positions(i,:);%����ȫ�����Ž�
        end
    end
    Convergence_curve(t)=Leader_score;
end



