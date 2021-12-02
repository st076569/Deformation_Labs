%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Лабораторная работа 4 : Модуль сдвига G.
% Выполнили             : Баталов Семен, Хайретдинова Диана, 2021.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Основной расчет, подготовка данных

% Известные константы
g = 9.81;           % [м/с^2]
l = 1.29;           % [м]
L = 1.07;           % [м]
r = 0.00305;        % [м]
R = 0.0552;         % [м]
start_1 = 0.122;    % [м]
start_2 = 0.123;    % [м]
student = 6.3;      % [-]

% Инициализация
input_data = readmatrix('input_data.csv');

% Входные данные
P = g * input_data(2:14, 1);                            % [н]
delta_1 = 10^(-2) * input_data(2:14, 2);                % [м]
delta_2 = 10^(-2) * input_data(2:14, 3);                % [м]
delta_1 = delta_1 - ones(length(delta_1), 1) * start_1; % [м]
delta_2 = delta_2 - ones(length(delta_2), 1) * start_2; % [м]

% Расчет всех величин
delta = (delta_1 + delta_2) / 2;    % [м]
phi = delta / (2 * L);              % [рад]
M = 2 * P * R;                      % [н * м]
J = (pi / 2) * r^4;                 % [м^4]
tau = (M * r) / J;                  % [Па]
gamma = (r * phi) / l;              % [рад]
G = tau ./ gamma;                   % [Па]

%% Расчет погрешностей величин

% Расчет систематической и статистической погрешностей
d_delta_1 = delta_1 - delta;                        % [м]
d_delta_2 = delta_2 - delta;                        % [м]
s_delta = sqrt((d_delta_1.^2 + d_delta_2.^2) / 2);  % [м]
d_delta_s = student * s_delta;                      % [м]
d_delta_p = ones(length(d_delta_s), 1) * 0.0005;    % [м]

% Абсолютная погрешность измерений
d_delta = d_delta_s + d_delta_p;    % [м]
d_P = 0.005;                        % [н]
d_l = 0.001;                        % [м]
d_L = 0.001;                        % [м]
d_r = 0.0001;                       % [м]
d_R = 0.0001;                       % [м]

% Символьное выражение для G
syms f_G(P_, R_, l_, L_, delta_, r_)
f_G = (8 * P_ * R_ * l_ * L_) / (pi * delta_ * r_^4);

% Расчет частных производных
der_P = ones(length(delta), 1);
der_R = ones(length(delta), 1);
der_l = ones(length(delta), 1);
der_L = ones(length(delta), 1);
der_delta = ones(length(delta), 1);
der_r = ones(length(delta), 1);

for i = 1:length(delta)
   der_P(i) = double(subs(diff(f_G, P_), ... 
       {P_, R_, l_, L_, delta_, r_}, [P(i), R, l, L, delta(i), r]));
   der_R(i) = double(subs(diff(f_G, R_), ... 
       {P_, R_, l_, L_, delta_, r_}, [P(i), R, l, L, delta(i), r]));
   der_l(i) = double(subs(diff(f_G, l_), ...
       {P_, R_, l_, L_, delta_, r_}, [P(i), R, l, L, delta(i), r]));
   der_L(i) = double(subs(diff(f_G, L_), ...
       {P_, R_, l_, L_, delta_, r_}, [P(i), R, l, L, delta(i), r]));
   der_delta(i) = double(subs(diff(f_G, delta_), ...
       {P_, R_, l_, L_, delta_, r_}, [P(i), R, l, L, delta(i), r]));
   der_r(i) = double(subs(diff(f_G, r_), ...
       {P_, R_, l_, L_, delta_, r_}, [P(i), R, l, L, delta(i), r]));
end

% Косвенная погрешность измерения G
d_G = sqrt((der_P * d_P).^2 + (der_R * d_R).^2 + ...
    (der_l * d_l).^2 + (der_L * d_L).^2 + ...
    (der_delta .* d_delta).^2 + (der_r * d_r).^2);  % [Па]
d_G_r = 100 * d_G ./ G;                             % [%]

%% Подготовка данных, запись в файл

% Округление
P = round(P, 3);                % [н]
delta = round(delta, 3);        % [м]
phi = round(phi, 3);            % [рад]
M = round(M, 3);                % [н * м]
tau = round(10^-6 * tau, 2);    % [МПа]
gamma = round(10^5 * gamma, 2); % [рад * 10^(-5)]
G = round(10^-9 * G, 1);        % [ГПа]
d_G = round(10^-9 * d_G, 1);    % [ГПа]
d_G_r = round(d_G_r, 0);        % [%]

% Запись данных в файл
output_data = [P, delta, phi, M, tau, gamma, G, d_G, d_G_r];
writematrix(output_data, 'output_data.csv');

%% Графики

% Диаграмма M-phi
figure
p = plot(phi, M);
xlim([0 0.05]);
ylim([0 0.4]);
xlabel('\phi  (рад)');
ylabel('M  (н\cdotм)');
grid on
grid minor
p.Marker = '*';
p.MarkerSize = 4;
p.LineWidth = 0.8;
p.Color = 'blue';

% Диаграмма tau-gamma
figure
p = plot(gamma, tau);
xlabel('\gamma  (рад\cdot10^{-5})');
ylabel('\tau  (МПа)');
grid on
grid minor
p.Marker = '*';
p.MarkerSize = 4;
p.LineWidth = 0.8;
p.Color = 'blue';