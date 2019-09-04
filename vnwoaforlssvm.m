% 冯洛伊曼结构的鲸鱼优化
function [Leader_pos,Convergence_curve]=vnwoaforlssvm(popsize,Max_iter,X1,y1,Xt,yt)
dim=2;
lb=0;
ub=1000;
Convergence_curve=zeros(1,Max_iter);
%%  初始全局最优解
%Initialize the positions of search agents
for i=1:popsize
    Positions(i,:)=rand(1,dim).*(ub-lb)+lb;
end

for i=1:popsize
    p(i)=fun(Positions(i,:),X1,y1,Xt,yt); %计算当前个体适应度值
end
[~, index]=min(p);
Leader_pos=Positions(index,:);
Leader_score=p(index);


% 构造冯洛伊曼拓扑
for i=1:popsize
    if i==1
        %luoyiman_localbest(前，后，中间，左，右)
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
    %% 种群更新
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
       %% 检测鲸鱼是否越界 并做越界处理
        Positions(i,:)=boundary(Positions(i,:),lb,ub);
        %% 冯洛伊曼 判断与更新
        if i==1
            %luoyiman_localbest(前，后，中间，左，右)
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
        % 利用冯洛伊曼网格中的局部最优与当前迭代次数对应的全局最优进行更新，随着迭代的进行，局部最优逐渐和全局最优重合
        w=1-exp(1-t);
        Positions(i,:)=w*plocal(i,:)+(1-w)*Leader_pos;%文章中两者的权重均为0.5.这里我采用自适应权重，随着迭代的进行，可以加速
        % Calculate objective function for each search agent
        fitness=fun(Positions(i,:),X1,y1,Xt,yt);
   %%  全局最优解更新
        if fitness>Leader_score 
            Leader_score=fitness; 
            Leader_pos=Positions(i,:);%更新全局最优解
        end
    end
    Convergence_curve(t)=Leader_score;
end



