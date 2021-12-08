function [d_a] = delta_x(a,t_an) %cлучайная погрешность
n = length(a);
a_m = mean(a);
d_i_2 = (a - a_m).^2;
s_x = sqrt(sum(d_i_2,'all')/(n*(n-1))); %средняя погрешность среднего
d_a = t_an*s_x;
end

