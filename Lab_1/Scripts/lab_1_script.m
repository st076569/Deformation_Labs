%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Лабораторная работа 1 : Испытание на растяжение.
% Выполнили             : Баталов Семен, Хайретдинова Диана, 2021.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Инициализация
input_data = readmatrix('input_data.csv');

% Входные данные
P = input_data(:, 2);               % [кг]
delta_l = input_data(:, 3);         % [мм]
d_ = input_data(:, 4);              % [-]

% Известные константы
l_0 = 43;                           % [мм]
d_0 = 5.4;                          % [мм]
K = 0.63;                           % [-]

% Расчет величин
d = d_ * K;                         % [мм]
F = pi * d.^2 / 4;                  % [мм^2]
sigma = P / F(1) * 10^2;            % [кг / см^2]
S = P ./ F * 10^2;                  % [кг / см^2]
epsilon = delta_l ./ l_0;           % [-]
psi = 1 - F / F(1);                 % [-]
epsilon_ = log(1 + epsilon) * 10^2; % [-]
psi_ = log(F(1) ./ F) * 10^2;       % [-]
epsilon = epsilon * 10^2;           % [-]
psi = psi * 10^2;                   % [-]

% Диаграмма P-delta_l
figure
p = plot(delta_l, P);
title('P-\Deltal');
xlim([0 3.5]);
ylim([0 1400]);
xlabel('\Deltal (мм)');
ylabel('P (кг)');
grid on
grid minor
p.Marker = '*';
p.MarkerSize = 7;
p.LineWidth = 1;
p.Color = 'blue';

% Диаграмма sigma-epsilon
figure
p = plot(epsilon, sigma);
title('\sigma-\epsilon');
xlim([0 8]);
ylim([0 6200]);
xlabel('\epsilon (%)');
ylabel('\sigma (10^5 Па)');
grid on
grid minor
p.Marker = '*';
p.MarkerSize = 7;
p.LineWidth = 1;
p.Color = 'blue';

% Диаграмма S-psi
for i = 1:20
   if psi(i) == 0
       psi(i) = 0.001;
   end
end
figure
p = semilogx(psi, S);
title('S-\psi');
xlim([0 80]);
ylim([0 9500]);
xlabel('\psi (%)');
ylabel('S (10^5 Па)');
grid on
grid minor
p.Marker = '*';
p.MarkerSize = 7;
p.LineWidth = 1;
p.Color = 'blue';

% Диаграмма S-epsilon_
figure
p = plot(epsilon_, S);
title('S-e');
xlim([0 8]);
ylim([0 9500]);
xlabel('e (%)');
ylabel('S (10^5 Па)');
grid on
grid minor
p.Marker = '*';
p.MarkerSize = 7;
p.LineWidth = 1;
p.Color = 'blue';

% Округляем все значения
d = round(d, 1);
F = round(F, 1);
sigma = round(sigma, 0);
S = round(S, 0);
epsilon = round(epsilon, 1);
psi = round(psi, 1);
epsilon_ = round(epsilon_, 1);
psi_ = round(psi_, 1);

% Записываем данные в файл
output_data = [P, delta_l, d_, d, F, sigma, S, ...
    epsilon, psi, epsilon_, psi_];
writematrix(output_data, 'output_data.csv');
