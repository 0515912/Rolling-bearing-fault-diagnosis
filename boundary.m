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

end%���۸����㷨�Ż���ȼ���ѧϰ������392503054