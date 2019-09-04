
function [Leader_pos,Convergence_curve]=woaforlssvm(SearchAgents_no,Max_iter,X1,y1,Xt,yt)
% initialize position vector and score for the leader
dim=2;
Leader_pos=zeros(1,dim);
Leader_score=-inf; %change this to -inf for maximization problems
lb=0;
ub=1000;
%Initialize the positions of search agents
for i=1:SearchAgents_no
    Positions(i,:)=rand(1,dim).*(ub-lb)+lb;
end
Convergence_curve=zeros(1,Max_iter);
% Main loop
for t=1:Max_iter
    t
    a=2-t*((2)/Max_iter); % a decreases linearly fron 2 to 0 in Eq. (2.3)
    
    % a2 linearly dicreases from -1 to -2 to calculate t in Eq. (3.12)
    a2=-1+t*((-1)/Max_iter);
    
    % Update the Position of search agents 
    for i=1:size(Positions,1)
        r1=rand(); % r1 is a random number in [0,1]
        r2=rand(); % r2 is a random number in [0,1]
        
        A=2*a*r1-a;  % Eq. (2.3) in the paper
        C=2*r2;      % Eq. (2.4) in the paper
        
        
        b=1;               %  parameters in Eq. (2.5)
        l=(a2-1)*rand+1;   %  parameters in Eq. (2.5)
        
        p = rand();        % p in Eq. (2.6)
        
        for j=1:size(Positions,2)
            
            if p<0.5   
                if abs(A)>=1
                    rand_leader_index = floor(SearchAgents_no*rand()+1);
                    X_rand = Positions(rand_leader_index, :);
                    D_X_rand=abs(C*X_rand(j)-Positions(i,j)); % Eq. (2.7)
                    Positions(i,j)=X_rand(j)-A*D_X_rand;      % Eq. (2.8)
                    
                elseif abs(A)<1
                    D_Leader=abs(C*Leader_pos(j)-Positions(i,j)); % Eq. (2.1)
                    Positions(i,j)=Leader_pos(j)-A*D_Leader;      % Eq. (2.2)
                end
                
            elseif p>=0.5
              
                distance2Leader=abs(Leader_pos(j)-Positions(i,j));
                % Eq. (2.5)
                Positions(i,j)=distance2Leader*exp(b.*l).*cos(l.*2*pi)+Leader_pos(j);
                
            end
            
        end
                % Return back the search agents that go beyond the boundaries of the search space

        Positions(i,:)=boundary(Positions(i,:),lb,ub);
        
        % Calculate objective function for each search agent
        fitness=fun(Positions(i,:),X1,y1,Xt,yt);
        
        % Update the leader
        if fitness>Leader_score % Change this to > for maximization problem
            Leader_score=fitness; % Update alpha
            Leader_pos=Positions(i,:);
        end
    end
    
    Convergence_curve(t)=Leader_score;
%     [t Leader_score]
end



