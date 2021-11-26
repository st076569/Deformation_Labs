%начальные данные
K = 6.4 * 10^-7;
a = 28.7; %[мм]     
b = 2.2;  %[мм]
P = 50;  %[H]
S = a*b; %[мм^-2]
n = readmatrix('data2.csv'); %показания измерителя деформаций
% 1 и 2 столбец для продольных деформаций, 3 и 4 для поперечных

delta_n = n(1:end-1,:) -  n(2:end,:);

output_data(:,1) = 50:50:500;                           %нагрузка
output_data(:,2) = round(mean(delta_n(:,1:2),2),0);    %продольная деформация, деления
output_data(:,3) = round(mean(delta_n(:,3:4),2),0);    %поперечная деформация, деления
output_data(:,4) = output_data(:,2)*K*10^6;             % продольная деформация
output_data(:,5) = output_data(:,3)*K*10^6;             % поперечная деформация
output_data(:,6) = output_data(:,1)/S;                  % напряжение
output_data(:,7) = - output_data(:,5)./output_data(:,4);          %коэфф Пуассона
output_data(:,8) = output_data(1,6)./output_data(:,4)*10^-3*10^6; %модуль Юнга

writematrix(round(output_data,2), 'output_2.csv');
    x =  (round(mean(n(1,1:2),2) - mean(n(2:end,1:2),2)))*K *10^4 ; % продольная деформация с увеличением нагрузки
    y =  output_data(:,6);                            %напряжение с увеличением нагрузки
    p = polyfit(x,y,1);
    plot(x,y,'o',x, polyval(p,x));
    xlabel('\epsilon_{xx}, *10^{-4}');
    ylabel('\sigma, МПа');
    grid on 
  E = mean ([mean(output_data(2:5,8))  mean(output_data(7:9,8))]); % убрали 1, 6 и 10 значения
 nu = mean ([mean(output_data(2:5,7))  mean(output_data(7:9,7))]);
 %погрешности для 10 измерений, коэфф Стьюдента = 1.8 доверительная
 %вероятность 90%
 E_i = output_data(:,8) - E;
 delta_E = round(1.8*sqrt((sum(E_i,'all'))^2/(10*9)),0);
 D_E = delta_E/E*100;
 
 nu_i = output_data(:,7) - nu;
 delta_nu = round( 1.8*sqrt((sum(nu_i,'all'))^2/(10*9)),3);
  D_nu = delta_nu/nu*100;
 
 