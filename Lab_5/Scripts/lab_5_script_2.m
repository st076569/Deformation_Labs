%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Лабораторная работа 5 : Определение микротвердости.
% Выполнили             : Баталов Семен, Хайретдинова Диана, 2021.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Основной расчет, подготовка данных

% Известные константы
n1 = 8;
n2 = 5;

% Инициализация
input_data = readmatrix('input_data_2.csv');

% Входные данные
P1 = input_data(1:n1, 1);
HV1 = input_data(1:n1, 2);
T2 = input_data(n1+1:n1+n2, 1);
HV2 = input_data(n1+1:n1+n2, 2);

%% Графики

% Диаграмма нагрузка-твердость
figure
p = loglog(P1, HV1);
title('Сталь');
xlim([7 1400]);
ylim([110 280]);
xlabel('P, г');
ylabel('HV');
grid on
grid minor
p.Marker = '*';
p.MarkerSize = 4;
p.LineWidth = 0.8;
p.Color = 'blue';

% Диаграмма время-твердость
figure
p = plot(T2, HV2);
title('Алюминий');
xlim([0 65]);
ylim([133 147]);
xlabel('t, с');
ylabel('HV');
grid on
grid minor
p.Marker = '*';
p.MarkerSize = 4;
p.LineWidth = 0.8;
p.Color = 'blue';