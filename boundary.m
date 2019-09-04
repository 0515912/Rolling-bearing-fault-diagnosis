function y=boundary(x,hmin,hmax);
[m n]=size(x);
for i=1:m
    for j=1:n
    if x(i,j)>=hmax
        x(i,j)=rand*(hmax-hmin)+hmin;
    elseif x(i,j)<=hmin
        x(i,j)=rand*(hmax-hmin)+hmin;
    end
end
y=x;

end%出售各类算法优化深度极限学习机代码392503054