%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Лабораторная работа 6 : Изгиб балки.
% Выполнили             : Баталов Семен, Хайретдинова Диана, 2021.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Инициализация

% Промежутки балки
a = [80 578 779 862 375] * 10^(-3); % [м]
delta_l = 2 * 10^(-3);              % [м]

% Сечение балки
b = 5.4 * 10^(-3);          % [м]
h = 36.1 * 10^(-3);         % [м]
delta_bh = 0.1 * 10^(-3);   % [м]

% Модуль Юнга
E = 200 * 10^9; % [Па]

% Нагружение
P = [1 2 3 5 7 12]; % [Н]

%% Расчет величин

% Момент инерции
syms f_I(b_, h_)
f_I = b_ * h_ ^ 3 / 12;
f_der_b = double(subs(diff(f_I, b_), {b_, h_}, [b h]));
f_der_h = double(subs(diff(f_I, h_), {b_, h_}, [b h]));
I = b * h ^ 3 / 12;
delta_I = sqrt((f_der_b * delta_bh) ^ 2 + (f_der_h * delta_bh) ^ 2);

% Реакции опоры
syms f_RA(a_1, a_2, a_3)
f_RA = P * (a_2 - a_3) / (a_1 - a_3) ;
f_der_a_1 = double(subs(diff(f_RA, a_1), {a_1 a_2 a_3}, [a(1) a(2) a(3)]));
f_der_a_2 = double(subs(diff(f_RA, a_2), {a_1 a_2 a_3}, [a(1) a(2) a(3)]));
f_der_a_3 = double(subs(diff(f_RA, a_3), {a_1 a_2 a_3}, [a(1) a(2) a(3)]));
RA = double(subs(f_RA, {a_1 a_2 a_3}, [a(1) a(2) a(3)]));
delta_RA = sqrt((f_der_a_1 * delta_l) .^ 2 + ...
    (f_der_a_2 * delta_l) .^ 2 + (f_der_a_3 * delta_l) .^ 2);

syms f_RB(a_1, a_2, a_3)
f_RB = P * (a_1 - a_2) / (a_1 - a_3) ;
f_der_a_1 = double(subs(diff(f_RA, a_1), {a_1 a_2 a_3}, [a(1) a(2) a(3)]));
f_der_a_2 = double(subs(diff(f_RA, a_2), {a_1 a_2 a_3}, [a(1) a(2) a(3)]));
f_der_a_3 = double(subs(diff(f_RA, a_3), {a_1 a_2 a_3}, [a(1) a(2) a(3)]));
RB = double(subs(f_RB, {a_1 a_2 a_3}, [a(1) a(2) a(3)]));
delta_RB = sqrt((f_der_a_1 * delta_l) .^ 2 + ...
    (f_der_a_2 * delta_l) .^ 2 + (f_der_a_3 * delta_l) .^ 2);

% Постоянные интегрирования
syms f_y_1(a_1, a_2, a_3, I_)
f_y_1 = (P / (6 * E * I_)) * ((a_2 - a_3) * (a_3 - a_1) ^ 2 + ...
    (a_3 - a_2) ^ 3) / (a_3 - a_1) ;
f_der_a_1 = double(subs(diff(f_y_1, a_1), {a_1 a_2 a_3 I_}, ...
    [a(1) a(2) a(3) I]));
f_der_a_2 = double(subs(diff(f_y_1, a_2), {a_1 a_2 a_3 I_}, ...
    [a(1) a(2) a(3) I]));
f_der_a_3 = double(subs(diff(f_y_1, a_3), {a_1 a_2 a_3 I_}, ...
    [a(1) a(2) a(3) I]));
f_der_I_ = double(subs(diff(f_y_1, I_), {a_1 a_2 a_3 I_}, ...
    [a(1) a(2) a(3) I]));
theta_1 = double(subs(f_y_1, {a_1 a_2 a_3 I_}, [a(1) a(2) a(3) I]));
delta_theta_1 = sqrt((f_der_a_1 * delta_l) .^ 2 + ...
    (f_der_a_2 * delta_l) .^ 2 + (f_der_a_3 * delta_l) .^ 2 +...
    (f_der_I_ * delta_I) .^ 2);

syms f_theta_1(a_1, y_1_)
f_theta_1 = -a_1 * y_1_;
y_1 = [0 0 0 0 0 0];
delta_y_1 = [0 0 0 0 0 0];
for i = 1:6
f_der_a_1 = double(subs(diff(f_theta_1, a_1), {a_1 y_1_}, [a(1) theta_1(i)]));
f_der_y_1_ = double(subs(diff(f_theta_1, y_1_), {a_1 y_1_}, [a(1) theta_1(i)]));
y_1(i) = double(subs(f_theta_1, {a_1 y_1_}, [a(1) theta_1(i)]));
delta_y_1(i) = sqrt((f_der_a_1 * delta_l) ^ 2 + ...
    (f_der_y_1_ * delta_theta_1(i)) ^ 2);
end

% Значения прироста и угла поворота
%y_2 = 1 / (E * I) * (RA * (a(5) - a(1)) ^ 3 / 6 - ...
%    P * (a(5) - a(2)) ^ 3 / 6) + y_1 + theta_1 * a(5);
y_2 = 1 / (E * I) * RA * (a(5) - a(1)) ^ 3 / 6 + y_1 + theta_1 * a(5);
y_3 = 1 / (E * I) * (RA * (a(4) - a(1)) ^ 3 / 6 - ...
    P * (a(4) - a(2)) ^ 3 / 6 + RB * (a(4) - a(3)) ^ 3 / 6) + ...
    y_1 + theta_1 * a(4);
theta_3 = 1 / (E * I) * (RA * (a(3) - a(1)) ^ 2 / 2 - ...
    P * (a(3) - a(2)) ^ 2 / 2) + theta_1;

y_1 = round(y_1 * 10^5, 3);
y_2 = round(y_2 * 10^5, 3);
y_3 = round(y_3 * 10^5, 3);
theta_1 = round(theta_1 * 10^3, 3);
theta_3 = round(theta_3 * 10^3, 3);
delta_y_1 = round(delta_y_1 * 10^5, 3);
delta_theta_1 = round(delta_theta_1 * 10^3, 3);

% Вывод данных в файл
output_data = [y_1.' delta_y_1.' y_2.' delta_y_1.' y_3.' ...
    delta_y_1.' theta_1.' delta_theta_1.' theta_3.' delta_theta_1.'];
writematrix(output_data, 'output_data_1.csv');