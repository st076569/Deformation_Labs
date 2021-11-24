K = 6.4 * 10^-7;
E = 0.7*10^5; % [МПа]
nu = 0.33; 
a = 300;   %[мм]
l = 260;   %[мм]
d = 41;    %[мм]
h = 1;     %[мм]
F = 10;    %[H]
n0 = [966 824 851]; % данные ид недеформированного образца
n = readmatrix('data.csv');

% теор расчет
sigma_m_th = 4*F*l/(pi*h*d^2);             % [МПа]
tau_m_th = 2*F*a/(pi*h*d^2);
sigma_1_th = sigma_m_th/2 + sqrt((sigma_m_th/2)^2 + tau_m_th^2 );    % [МПа]
sigma_3_th = sigma_m_th/2 - sqrt((sigma_m_th/2)^2 + tau_m_th^2 );    % [МПа]
tg_2beta_th = 2*tau_m_th/sigma_m_th;

%расчет средней разности и деформаций
n_aver(1,:) = n0;
for i = 1:4
n_aver(i+1,:) = round(mean(n(i:4:end,:)),0);
end
delta_n(:,1:1:3) =  n_aver(2:end,:) - n_aver(1:end-1,:);
delta_n_aver = mean(delta_n,1);
e_z = delta_n_aver(1)*K;
e_u = delta_n_aver(2)*K;
e_v = delta_n_aver(3)*K;



syms e1(ez,eu,ev) e3(ez,eu,ev);
e1(ez,eu,ev) = (eu + ev)/2 + sqrt(((eu - ez)^2 + (ev - ez)^2)/2);
e3(ez,eu,ev) = (eu + ev)/2 - sqrt(((eu - ez)^2 + (ev - ez)^2)/2);
e_1 = double(e1(e_z,e_u,e_v));
e_3 = double(e3(e_z,e_u,e_v));
syms sigma1(e11,e33) sigma2(e11,e33);
sigma1(e11,e33) = E*(e11 + nu*e33)/(1 - nu^2);
sigma3(e11,e33) = E*(e33 + nu*e11)/(1 - nu^2);
sigma_1 = double(sigma1(e_1,e_3));          %[МПа]
sigma_3 = double(sigma3(e_1,e_3));          %[МПа]
syms tg2beta(ez,eu,ev);
tg2beta(ez,eu,ev) = (2*ez - ev - eu)/(eu - ev);
tg_2beta = double(tg2beta(e_z,e_u,e_v));

%погрешность
for i = 1:4
    n_1(i,:) = n(i:4:end,1);                      % переопределили таблицу, 12 измерений 4 раза
    n_1(4 + i,:) = n(i:4:end,2);
    n_1(8 + i,:) = n(i:4:end,3);
end
n_aver_delta = n_aver(2:end,:);
for i = 1:12
    S_xx(i) = sqrt(sum((n_1(i,:) - n_aver_delta(i)).^2,'all')/12); % погрешность среднего для каждого из 12 показаний
end;
S_x = round(mean(S_xx),1);
dn = 2.4*S_x + 1;              % погрешность среднего + погрешность прибора
de = dn*K;
e1_ez = diff(e1,ez);
e1_eu = diff(e1,eu);
e1_ev = diff(e1,ev);
e3_ez = diff(e3,ez);
e3_eu = diff(e3,ez);
e3_ev = diff(e3,ez);
de1 = (abs(double(e1_ez(e_z,e_u,e_v))) + abs(double(e1_eu(e_z,e_u,e_v))) + abs(double(e1_ev(e_z,e_u,e_v))))*de;
de3 = (abs(double(e3_ez(e_z,e_u,e_v))) + abs(double(e3_eu(e_z,e_u,e_v))) + abs(double(e3_ev(e_z,e_u,e_v))))*de;

sigma1_e11 = diff(sigma1,e11);
sigma1_e33 = diff(sigma1,e33);
sigma3_e11 = diff(sigma3,e11);
sigma3_e33 = diff(sigma3,e33);
dsigma_1 = abs(double(sigma1_e11(e_1,e_3)))*de1 + abs(double(sigma1_e33(e_1,e_3)))*de3;
dsigma_3 = abs(double(sigma3_e11(e_1,e_3)))*de1 + abs(double(sigma3_e33(e_1,e_3)))*de3;

tg2beta_ev = diff(tg2beta,ev);
tg2beta_eu = diff(tg2beta,eu);
tg2beta_ez = diff(tg2beta,ez);
dtg2beta = (abs(double(tg2beta_ez(e_z,e_u,e_v))) + abs(double(tg2beta_eu(e_z,e_u,e_v))) + abs(double(tg2beta_ev(e_z,e_u,e_v))))*de;

%таблички
output_data(:,1) = 10:10:40;      % прикладываемая сила
output_data(:,2:1:4) = delta_n *K*10^5; % деформация для 3 тд   *10^-5

output_data_2(1,:) = round([sigma_1_th sigma_3_th tg_2beta_th],2);       % теория
output_data_2(2,:) = round([sigma_1 sigma_3 tg_2beta],2);                % эксперимент
output_data_2(3,:) = round([dsigma_1/abs(sigma_1)*100 dsigma_3/abs(sigma_3)*100 dtg2beta/tg_2beta*100],0); %относительная погрешность

writematrix(output_data,'output_1.csv');
writematrix(output_data_2,'output_2.csv');