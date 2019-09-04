function [bestchrom ,trace]=gaforlssvm(sizepop,maxgen,X1,y1,Xt,yt)
%% �Ŵ��㷨������ʼ��
maxgen;                         %��������������������
sizepop;                        %��Ⱥ��ģ
pcross=[0.7];                       %�������ѡ��0��1֮��
pmutation=[0.05];                    %�������ѡ��0��1֮��
%Ѱ������
numsum=2;
lenchrom=ones(1,numsum);       
bound=[zeros(numsum,1) 1000*ones(numsum,1)];    %���ݷ�Χ[0 100]
%------------------------------------------------------��Ⱥ��ʼ��------------------------------%------------------
individuals=struct('fitness',zeros(1,sizepop), 'chrom',[]);  %����Ⱥ��Ϣ����Ϊһ���ṹ��
avgfitness=[];                      %ÿһ����Ⱥ��ƽ����Ӧ��
bestfitness=[];                     %ÿһ����Ⱥ�������Ӧ��
bestchrom=[];                       %��Ӧ����õ�Ⱦɫ��
trace=0;
%��ʼ����Ⱥ
for i=1:sizepop
    %�������һ����Ⱥ
    individuals.chrom(i,:)=Code(lenchrom,bound);    %����
    x=individuals.chrom(i,:);
    %������Ӧ��
    individuals.fitness(i)=fun(x,X1,y1,Xt,yt);   %Ⱦɫ�����Ӧ��
end

%����õ�Ⱦɫ��
[bestfitness bestindex]=max(individuals.fitness);
bestchrom=individuals.chrom(bestindex,:);  %��õ�Ⱦɫ��
%% ���������ѳ�ʼ��ֵ��Ȩֵ
% ������ʼ
for i=1:maxgen
    i
    %ѡ��
    individuals=select(individuals,sizepop);
    %����
    individuals.chrom=Cross(pcross,lenchrom,individuals.chrom,sizepop,bound);
    %����
    individuals.chrom=Mutation(pmutation,lenchrom,individuals.chrom,sizepop,i,maxgen,bound);
    % ������Ӧ��
    for j=1:sizepop
        x=individuals.chrom(j,:); %����
        individuals.fitness(j)=fun(x,X1,y1,Xt,yt);
    end
  %�ҵ���С�������Ӧ�ȵ�Ⱦɫ�弰��������Ⱥ�е�λ��
    [newbestfitness,newbestindex]=max(individuals.fitness);
    [worestfitness,worestindex]=min(individuals.fitness);
    % ������һ�ν�������õ�Ⱦɫ��
    if bestfitness<newbestfitness
        bestfitness=newbestfitness;
        bestchrom=individuals.chrom(newbestindex,:);
    end
    individuals.chrom(bestindex,:)=bestchrom;
    individuals.fitness(bestindex)=bestfitness;
    trace(i)=bestfitness ;%��¼ÿһ����������õ���Ӧ�Ⱥ�ƽ����Ӧ��
    
end

end%���۸����㷨�Ż���ȼ���ѧϰ������392503054