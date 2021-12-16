%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Лабораторная работа 6 : Изгиб балки.
% Выполнили             : Баталов Семен, Хайретдинова Диана, 2021.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Инициализация
l_1 = 8000;
l_3 = 8300;
%y_1 = [2 5 7 12 17 28];
%y_3 = [1 3 4 7 10 18];
y_1 = [1 4 6 10 15 25];
y_3 = [1 5 8 14 20 34];
delta_l = 200;
delta_y = 0.5;

%% Расчет значений
theta_1 = y_1 ./ l_1;
theta_3 = y_3 ./ l_3;
theta_1_delta = [0 0 0 0 0 0];
theta_3_delta = [0 0 0 0 0 0];

%% Расчет погрешностей
syms f_theta(y, l)
f_theta = y / l;
for i = 1:6
    f_der_y_1 = double(subs(diff(f_theta, y), {y, l}, [y_1(i), l_1]));
    f_der_l_1 = double(subs(diff(f_theta, l), {y, l}, [y_1(i), l_1]));
    f_der_y_3 = double(subs(diff(f_theta, y), {y, l}, [y_3(i), l_3]));
    f_der_l_3 = double(subs(diff(f_theta, l), {y, l}, [y_3(i), l_3]));
    theta_1_delta(i) = sqrt((f_der_y_1 * delta_y).^2 + ...
        (f_der_l_1 * delta_l)^2);
    theta_3_delta(i) = sqrt((f_der_y_3 * delta_y).^2 + ...
        (f_der_l_3 * delta_l)^2);
end

theta_1 = round(theta_1, 5);
theta_3 = round(theta_3, 5);
theta_1_delta = round(theta_1_delta, 5);
theta_3_delta = round(theta_3_delta, 5);

