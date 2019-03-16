function [o,order] = generate_City(N,ub,lb,m)

o = [(ub-lb)*rand(1,N)-ub;(ub-lb)*rand(1,N)-ub];
for j = 1:m
    order{j} = 1:N;
end


end