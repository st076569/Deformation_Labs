%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Лабораторная работа 5 : Определение микротвердости.
% Выполнили             : Баталов Семен, Хайретдинова Диана, 2021.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Основной расчет, подготовка данных

% Известные константы
c = 1854.367709133575;
n = 10;
P = 200;
t = 1.8;

% Инициализация
input_data = readmatrix('input_data_1.csv');

% Входные данные
st_d1 = input_data(1:n, 1);     % [мкм]
st_d2 = input_data(1:n, 2);     % [мкм]
al_d1 = input_data(11:2*n, 1);  % [мкм]
al_d2 = input_data(11:2*n, 2);  % [мкм]

% Входные данные
st_d1_mean = mean(st_d1);   % [мкм]
st_d2_mean = mean(st_d2);   % [мкм]
al_d1_mean = mean(al_d1);   % [мкм]
al_d2_mean = mean(al_d2);   % [мкм]

% Расчет всех величин
st_d = (st_d1_mean + st_d2_mean) / 2;   % [мкм]
al_d = (al_d1_mean + al_d2_mean) / 2;   % [мкм]
st_h = (c * P) / st_d ^ 2;              % [-]
al_h = (c * P) / al_d ^ 2;              % [-]

%% Определение погрешностей

% Расчет дисперсии и стандартного отклонения
st_d1_s2 = 0;
st_d2_s2 = 0;
al_d1_s2 = 0;
al_d2_s2 = 0;
for i = 1:n
    st_d1_s2 = st_d1_s2 + (st_d1(i) - st_d1_mean) ^ 2;
    st_d2_s2 = st_d2_s2 + (st_d2(i) - st_d2_mean) ^ 2;
    al_d1_s2 = al_d1_s2 + (al_d1(i) - al_d1_mean) ^ 2;
    al_d2_s2 = al_d2_s2 + (al_d2(i) - al_d2_mean) ^ 2;
end
st_d1_s2 = st_d1_s2 / (n - 1);
st_d1_s = sqrt(st_d1_s2);
st_d2_s2 = st_d2_s2 / (n - 1);
st_d2_s = sqrt(st_d2_s2);
al_d1_s2 = al_d1_s2 / (n - 1);
al_d1_s = sqrt(al_d1_s2);
al_d2_s2 = al_d2_s2 / (n - 1);
al_d2_s = sqrt(al_d2_s2);

% Коэффициент вариации
st_d1_W = (st_d1_s / st_d1_mean) * 100; % [%]
st_d2_W = (st_d2_s / st_d2_mean) * 100; % [%]
al_d1_W = (al_d1_s / al_d1_mean) * 100; % [%]
al_d2_W = (al_d2_s / al_d2_mean) * 100; % [%]

% Абсолютная погрешность прямых измерений
st_d1_delta = (st_d1_s / sqrt(n)) * t;  % [мкм]
st_d2_delta = (st_d2_s / sqrt(n)) * t;  % [мкм]
al_d1_delta = (al_d1_s / sqrt(n)) * t;  % [мкм]
al_d2_delta = (al_d2_s / sqrt(n)) * t;  % [мкм]

% Абсолютная погрешность косвенных измерений
st_d_delta = 0.5 * sqrt(st_d1_delta ^ 2 + st_d2_delta ^ 2); % [мкм]
al_d_delta = 0.5 * sqrt(al_d1_delta ^ 2 + al_d2_delta ^ 2); % [мкм]

syms f_H(d_)
f_H = (c * P) / d_ ^ 2;
st_der = double(subs(diff(f_H, d_), {d_}, [st_d]));
al_der = double(subs(diff(f_H, d_), {d_}, [al_d]));
st_h_delta = abs(st_der * st_d_delta);   % [-]
al_h_delta = abs(al_der * al_d_delta);   % [-]

%% Подготовка данных, запись в файл

% Округление
st_d1_mean = round(st_d1_mean, 0);
al_d1_mean = round(al_d1_mean, 0);
st_d2_mean = round(st_d2_mean, 0);
al_d2_mean = round(al_d2_mean, 0);
st_d1_delta = round(st_d1_delta, 0);
st_d2_delta = round(st_d2_delta, 0);
al_d1_delta = round(al_d1_delta, 0);
al_d2_delta = round(al_d2_delta, 0);

st_d = round(st_d, 0);
al_d = round(al_d, 0);
st_d_delta = round(st_d_delta, 0);
al_d_delta = round(al_d_delta, 0);

st_h = round(st_h, 0);
al_h = round(al_h, 0);
st_h_delta = round(st_h_delta, 0);
al_h_delta = round(al_h_delta, 0);

st_d1_s2 = round(st_d1_s2, 1);
st_d2_s2 = round(st_d2_s2, 1);
al_d1_s2 = round(al_d1_s2, 1);
al_d2_s2 = round(al_d2_s2, 1);

st_d1_s = round(st_d1_s, 1);
st_d2_s = round(st_d2_s, 1);
al_d1_s = round(al_d1_s, 1);
al_d2_s = round(al_d2_s, 1);

st_d1_W = round(st_d1_W, 0);
st_d2_W = round(st_d2_W, 0);
al_d1_W = round(al_d1_W, 0);
al_d2_W = round(al_d2_W, 0);

% Относительная погрешность
st_d1_delta_r = round(st_d1_delta / st_d1_mean * 100, 1);
st_d2_delta_r = round(st_d2_delta / st_d2_mean * 100, 1);
al_d1_delta_r = round(al_d1_delta / al_d1_mean * 100, 1);
al_d2_delta_r = round(al_d2_delta / al_d2_mean * 100, 1);

st_d_delta_r = round(st_d_delta / st_d * 100, 1);
al_d_delta_r = round(al_d_delta / al_d * 100, 1);

st_h_delta_r = round(st_h_delta / st_h * 100, 1);
al_h_delta_r = round(al_h_delta / al_h * 100, 1);

% Запись данных в файл
output_data = [[st_d1_mean, st_d2_mean, st_d, st_h, al_d1_mean, ...
    al_d2_mean, al_d, al_h]; [st_d1_s2, st_d2_s2, 0, 0, al_d1_s2, ...
    al_d2_s2, 0, 0]; [st_d1_s, st_d2_s, 0, 0, al_d1_s, al_d2_s, ... 
    0, 0]; [st_d1_W, st_d2_W, 0, 0, al_d1_W, al_d2_W, 0, 0]; ...
    [st_d1_delta, st_d2_delta, st_d_delta, st_h_delta, al_d1_delta, ...
    al_d2_delta, al_d_delta, al_h_delta]; [st_d1_delta_r, ...
    st_d2_delta_r, st_d_delta_r, st_h_delta_r, al_d1_delta_r, ...
    al_d2_delta_r, al_d_delta_r, al_h_delta_r]];
writematrix(output_data, 'output_data_1.csv');