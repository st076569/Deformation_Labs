n = readmatrix('Data.csv');
St = n(:,1); %выборка для стали
Al = n(:,2); %выборка для алюминия
St_P = readmatrix('St_P'); % изменение времени для стали
Al_time = readmatrix('Al_time'); % изменение нагрузки для алюминия

%среднее значение твердости
st_m = mean(St);  
al_m = mean(Al);

t_an = 1.8; %коэфф Стьюдента при 10 измерениях и доверительной вероятности 90%
delta_st = delta_x(St,t_an); % абсолютная погрешность для стали
d_st = delta_st/st_m*100;    %относиельная [%]
delta_al = delta_x(Al,t_an);
d_al = delta_al/al_m*100;

d_i_2 = (St - st_m).^2;
s_x = sqrt(sum(d_i_2,'all')/90);