data = readmatrix('data.csv'); %[*10^-5 м]

for i = 1:6
data_mean(i,:) = abs((data(i,:) + data(end - i + 1,:)))/2;
end;
delta_data = 10^-2; %[мм]

l_1 = [80 404 83]; %[мм]
l_2 = [80 295 83]; %[мм]
delta_l = 1; %[мм]

tg_teta_1(:,1) = data_mean(:,2)*10^-2/l_1(1) * 10^3;
tg_teta_1(:,2) = data_mean(:,3)*10^-2/l_1(2) * 10^3;
tg_teta_1(:,3) = data_mean(:,4)*10^-2/l_1(3) * 10^3;

tg_teta_2(:,1) = data_mean(:,5)*10^-2/l_2(1) * 10^3;
tg_teta_2(:,2) = data_mean(:,6)*10^-2/l_2(2) * 10^3;
tg_teta_2(:,3) = data_mean(:,7)*10^-2/l_2(3) * 10^3;

delta_teta(:,1) = delta_data *(1/l_1(1)) + delta_l *(data_mean(:,2)/(l_1(1))^2); 
delta_teta(:,2) = delta_data *(1/l_1(2)) + delta_l *(data_mean(:,3)/(l_1(2))^2); 
delta_teta(:,3) = delta_data *(1/l_1(3)) + delta_l *(data_mean(:,4)/(l_1(3))^2); 

figure;
plot(data_mean(:,1), data_mean(:,2),'b-*',data_mean(:,1),...
    abs( data_mean(:,3)),'r-*', data_mean(:,1), data_mean(:,4),'k-*',linewidth = 0.8);
ylabel('\nu, 10^{-2} мм');
xlabel('P, Н');
axis([0 13 -5 70])
text(data_mean(5,1),data_mean(5,2),'-\leftarrow 1 инд.');
text(data_mean(5,1),data_mean(5,3),'-\leftarrow 2 инд.');
text(data_mean(5,1),data_mean(5,4),'-\leftarrow 3 инд.');
title('Опыт №1');
grid on;
grid minor;

figure;
plot(data_mean(:,1), data_mean(:,5),'b-*',data_mean(:,1),...
    data_mean(:,6),'r-*', data_mean(:,1), data_mean(:,7),'k-*',linewidth = 0.8);
ylabel('\nu, 10^{-2} мм');
xlabel('P, Н');
axis([0 13 -5 80])
text(data_mean(5,1),data_mean(5,5),'-\leftarrow 1 инд.');
text(data_mean(5,1),data_mean(5,6),'-\leftarrow 2 инд.');
text(data_mean(5,1),data_mean(5,7),'-\leftarrow 3 инд.');
title('Опыт №2');
grid on;
grid minor;

figure;
plot(data_mean(:,1), tg_teta_1(:,1),'b-*',data_mean(:,1),...
    tg_teta_1(:,2),'r-*', data_mean(:,1), tg_teta_1(:,3),'k-*',linewidth = 0.8);
ylabel('\theta, 10^{-3} rad');
xlabel('P, Н');
axis([0 13 -0.2 4]);
text(data_mean(5,1),tg_teta_1(5,1),'-\leftarrow 1 инд.');
text(data_mean(5,1),tg_teta_1(5,2),'-\leftarrow 2 инд.');
text(data_mean(5,1),tg_teta_1(5,3),'-\leftarrow 3 инд.');
title('Опыт №1');
grid on;
grid minor;

figure;
plot(data_mean(:,1), tg_teta_2(:,1),'b-*',data_mean(:,1),...
    tg_teta_2(:,2),'r-*', data_mean(:,1), tg_teta_2(:,3),'k-*',linewidth = 0.8);
ylabel('\theta, 10^{-3} rad');
xlabel('P, Н');
axis([0 13 -0.2 4.3]);
text(data_mean(5,1),tg_teta_2(5,1),'-\leftarrow 1 инд.');
text(data_mean(5,1),tg_teta_2(5,2),'-\leftarrow 2 инд.');
text(data_mean(5,1),tg_teta_2(5,3),'-\leftarrow 3 инд.');
title('Опыт №2');
grid on;
grid minor;
