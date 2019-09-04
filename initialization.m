
function Positions=initialization(SearchAgents_no,dim,ub,lb)
for i=1:dim
    ub_i=ub;
    lb_i=lb;
    Positions(:,i)=rand(SearchAgents_no,1).*(ub_i-lb_i)+lb_i;
end
