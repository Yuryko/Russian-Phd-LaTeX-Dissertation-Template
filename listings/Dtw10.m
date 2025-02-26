clear
close all
clc
PL=50000; %Количество точек рисуемых на графике (количество смещений порога)
PL2=1; % для масштабирования вычислений. 
% при расчете FAR срабатывание - есть ошибка, поэтому формула - (100% - счетчик)
FRR=100; % = 0 для расчета FAR и = 100 для FRR 
% при расчете EER необходимо этот же скрипт запустить в папке FAR, при этом параметр FRR=0
% все остальные значение должны быть СТРОГО одинаковы!
%Для DTW, использующего расстояние Евклида
Cou1=zeros(1,PL); % не прошедшие аутентификации для смартфона
Cou2=zeros(1,PL); % прошедшие аутентификации для смартфона
Cou3=zeros(1,PL); % не прошедшие аутентификации для умных часов
Cou4=zeros(1,PL); % прошедшие аутентификации для умных часов
%Для DTW, использующего квадратичное расстояние Евклида
Cous1=zeros(1,PL); 
Cous2=zeros(1,PL); 
Cous3=zeros(1,PL); 
Cous4=zeros(1,PL); 
%Для DTW, использующего расстояние Городских кварталов
Coua1=zeros(1,PL);  
Coua2=zeros(1,PL); 
Coua3=zeros(1,PL);  
Coua4=zeros(1,PL);
%Для Pdist2
% Расстояние Евклида
Cev1=zeros(1,PL);  
Cev2=zeros(1,PL);  
Cev3=zeros(1,PL);  
Cev4=zeros(1,PL);  
% Квадрат Евклидового расстояния (не удовлетворяет неравенству треугольника.)
Cevsq1=zeros(1,PL);  
Cevsq2=zeros(1,PL);  
Cevsq3=zeros(1,PL); 
Cevsq4=zeros(1,PL);  
% Расстояния городских кварталов
Ccit1=zeros(1,PL);  
Ccit2=zeros(1,PL); 
Ccit3=zeros(1,PL);  
Ccit4=zeros(1,PL);  
% Метрика Минковского
Cmin1=zeros(1,PL);  
Cmin2=zeros(1,PL);  
Cmin3=zeros(1,PL);  
Cmin4=zeros(1,PL);  
% расстояние Чебышева
Cche1=zeros(1,PL);  
Cche2=zeros(1,PL);  
Cche3=zeros(1,PL);  
Cche4=zeros(1,PL);  
% косинусное расстояние
Ccos1=zeros(1,PL); 
Ccos2=zeros(1,PL);  
Ccos3=zeros(1,PL);  
Ccos4=zeros(1,PL);  
% Корреляционное расстояние 
Ccor1=zeros(1,PL);  
Ccor2=zeros(1,PL);  
Ccor3=zeros(1,PL);  
Ccor4=zeros(1,PL); 
% Расстояние Спирмена
Cspe1=zeros(1,PL);  
Cspe2=zeros(1,PL);  
Cspe3=zeros(1,PL);  
Cspe4=zeros(1,PL);  
%Глобальные переменные
f=2; % значение сглаживающего фильтра
p=fileread('etalonW.txt'); %читаем эталон часов
p(p==',')='.';
k=textscan(p,' %f%f%f');
Rw=cell2mat(k);
Xw=Rw(:, 1);
Yw=Rw(:, 2);
Zw=Rw(:, 3);
Xw = smooth(Xw,f);
Yw = smooth(Yw,f);
Zw = smooth(Zw,f);
r=fileread('etalonP.txt'); %Читаем эталон телефона
  r(r==',')='.'; %заменяем запятую точкой
k=textscan(r,' %f%f%f');
Rp=cell2mat(k);
Xp=Rp(:, 1);
Yp=Rp(:, 2);
Zp=Rp(:, 3); 
Xp = smooth(Xp,f);
Yp = smooth(Yp,f);
Zp = smooth(Zp,f);
l=0; % переменная для поочередного считывания файлов    
j=1; % переменная для цикла заполнения массива
[fname, pname] = uigetfile('*.txt', 'Select txt data base files', 'MultiSelect', 'on');
%инициализируем массив в котором храниться расстояния для телефона
Dp=zeros(1,length(fname)/2);
Dps=zeros(1,length(fname)/2);
Dpa=zeros(1,length(fname)/2);
%для pdit2
Dpch=zeros(1,length(fname)/2);
Dpcit=zeros(1,length(fname)/2);
Dpcor=zeros(1,length(fname)/2);
Dpcos=zeros(1,length(fname)/2);
Dpev=zeros(1,length(fname)/2);
Dpevsq=zeros(1,length(fname)/2);
Dpmin=zeros(1,length(fname)/2);
Dpspe=zeros(1,length(fname)/2);
%инициализируем массив в котором храниться расстояния для часов
Dw=zeros(1,length(fname)/2); 
Dws=zeros(1,length(fname)/2);
Dwa=zeros(1,length(fname)/2);
%для pdit2
Dwch=zeros(1,length(fname)/2);
Dwcit=zeros(1,length(fname)/2);
Dwcor=zeros(1,length(fname)/2);
Dwcos=zeros(1,length(fname)/2);
Dwev=zeros(1,length(fname)/2);
Dwevsq=zeros(1,length(fname)/2);
Dwmin=zeros(1,length(fname)/2);
Dwspe=zeros(1,length(fname)/2);
if ~isequal(fname, 0) %загружаем в память все файлы
  if ~iscell(fname)
    fname = {fname};
  end
  fname = sort(fname);
    for k=1:length(fname)
    fullname = fullfile(pname, fname{k});
        m=fileread(fullname);
    m(m==',')='.';
      d=textscan(m,' %f%f%f');
    M=cell2mat(d);
    Xm = M(:, 1);
    Ym = M(:, 2);
    Zm = M(:, 3);
    % Фильтруем данные
    Xm = smooth(Xm,f);
    Ym = smooth(Ym,f);
    Zm = smooth(Zm,f);
   if l==0 
% выравниваем размерность векторов аппроксимацией(только для pdist2)      
  Xa = Xp;
  Ya = Yp;
  Za = Zp;     
if length(Xp) > length(Xm)
    for c=1:length(Xm)
        Xa(c)=Xm(c);
        Ya(c)=Ym(c);
        Za(c)=Zm(c);
    end
else
    for c=1:length(Xp)
        Xa(c)=Xm(c);
        Ya(c)=Ym(c);
        Za(c)=Zm(c);
    end
 end
 % по умолчанию pdist2 расстояние Евклида
    Ppdis_ev1 = pdist2(Xp',Xa');
    Ppdis_ev2 = pdist2(Yp',Ya');
    Ppdis_ev3 = pdist2(Zp',Za');   
% pdist2 квадратичное расстояние Евклида    
    Ppdis_evsq1 = pdist2(Xp',Xa', 'squaredeuclidean');
    Ppdis_evsq2 = pdist2(Yp',Ya', 'squaredeuclidean');
    Ppdis_evsq3 = pdist2(Zp',Za', 'squaredeuclidean');    
% pdist2 расстояние городских кварталов    
    Ppdis_cit1 = pdist2(Xp',Xa', 'cityblock');
    Ppdis_cit2 = pdist2(Yp',Ya', 'cityblock');
    Ppdis_cit3 = pdist2(Zp',Za', 'cityblock');    
% pdist2 расстояние Минковского    
    Ppdis_min1 = pdist2(Xp',Xa', 'minkowski');
    Ppdis_min2 = pdist2(Yp',Ya', 'minkowski');
    Ppdis_min3 = pdist2(Zp',Za', 'minkowski');     
% pdist2 расстояние Чебышева    
    Ppdis_che1 = pdist2(Xp',Xa', 'chebychev');
    Ppdis_che2 = pdist2(Yp',Ya', 'chebychev');
    Ppdis_che3 = pdist2(Zp',Za', 'chebychev');
% pdist2 косинусное расстояние    
    Ppdis_cos1 = pdist2(Xp',Xa', 'cosine');
    Ppdis_cos2 = pdist2(Yp',Ya', 'cosine');
    Ppdis_cos3 = pdist2(Zp',Za', 'cosine');   
% pdist2 выборочная корреляция    
    Ppdis_cor1 = pdist2(Xp',Xa', 'correlation');
    Ppdis_cor2 = pdist2(Yp',Ya', 'correlation');
    Ppdis_cor3 = pdist2(Zp',Za', 'correlation');
% pdist2 выборочная корреляция Спирмена 
    Ppdis_spe1 = pdist2(Xp',Xa', 'spearman');
    Ppdis_spe2 = pdist2(Yp',Ya', 'spearman');
    Ppdis_spe3 = pdist2(Zp',Za', 'spearman');     
% dtw (по умолчанию использует расстояние Евклида)   
    d1=dtw(Xp,Xm); 
    d2=dtw(Yp,Ym);
    d3=dtw(Zp,Zm);    
%   'squared' квадрат расстояния Евклида 
    ds1= dtw(Xp,Xm,'squared'); 
    ds2= dtw(Yp,Ym,'squared');
    ds3= dtw(Zp,Zm,'squared');
%   'absolute' - расстояние городских кварталов
    da1= dtw(Xp,Xm,'absolute'); 
    da2= dtw(Yp,Ym,'absolute');
    da3= dtw(Zp,Zm,'absolute');
% Вычисляем расстояние как сумму расстояний по осям       
    Dp(j)=abs(d1)+abs(d2)+abs(d3);
    Dps(j)=abs(ds1)+abs(ds2)+abs(ds3);
    Dpa(j)=abs(da1)+abs(da2)+abs(da3);
    % Pdist2 восемь вариантов
    Dpch(j)=abs(Ppdis_che1)+abs(Ppdis_che2)+abs(Ppdis_che3);
    Dpcit(j)=abs(Ppdis_cit1)+abs(Ppdis_cit2)+abs(Ppdis_cit3);
    Dpcor(j)=abs(Ppdis_cor1)+abs(Ppdis_cor2)+abs(Ppdis_cor3);
    Dpcos(j)=abs(Ppdis_cos1)+abs(Ppdis_cos2)+abs(Ppdis_cos3);
    Dpev(j)=abs(Ppdis_ev1)+abs(Ppdis_ev2)+abs(Ppdis_ev3);
    Dpevsq(j)=abs(Ppdis_evsq1)+abs(Ppdis_evsq2)+abs(Ppdis_evsq3);
    Dpmin(j)=abs(Ppdis_min1)+abs(Ppdis_min2)+abs(Ppdis_min3);
    Dpspe(j)=abs(Ppdis_spe1)+abs(Ppdis_spe2)+abs(Ppdis_spe3);
    l=l+1;   
    else
% находим дистанцию 
% сравниваем эталон часов с файлом
  Xa = Xw;
  Ya = Yw;
  Za = Zw;     
if length(Xw) > length(Xm)
    for t=1:length(Xm)
        Xa(t)=Xm(t);
        Ya(t)=Ym(t);
        Za(t)=Zm(t);
    end
    for t=length(Xm)+1:length(Xw)
        Xa(t)=Xm(length(Xm));
        Ya(t)=Ym(length(Ym));
        Za(t)=Zm(length(Zm));
    end
else
    for t=1:length(Xw)
        Xa(t)=Xm(t);
        Ya(t)=Ym(t);
        Za(t)=Zm(t);
    end
 end
    l=l-1;
% pdist2 (8 способов)
% по умолчанию pdist2 расстояние Евклида
    Wpdis_ev1 = pdist2(Xw',Xa');
    Wpdis_ev2 = pdist2(Yw',Ya');
    Wpdis_ev3 = pdist2(Zw',Za');
% pdist2 квадратичное расстояние Евклида    
    Wpdis_evsq1 = pdist2(Xw',Xa', 'squaredeuclidean');
    Wpdis_evsq2 = pdist2(Yw',Ya', 'squaredeuclidean');
    Wpdis_evsq3 = pdist2(Zw',Za', 'squaredeuclidean');
% pdist2 Расстояние по Манхеттену. Определяется как сумма абсолютных величин отклонений по всем измерениям.    
    Wpdis_cit1 = pdist2(Xw',Xa', 'cityblock');
    Wpdis_cit2 = pdist2(Yw',Ya', 'cityblock');
    Wpdis_cit3 = pdist2(Zw',Za', 'cityblock');
% pdist2 Метрика Минковского   
    Wpdis_min1 = pdist2(Xw',Xa', 'minkowski');
    Wpdis_min2 = pdist2(Yw',Ya', 'minkowski');
    Wpdis_min3 = pdist2(Zw',Za', 'minkowski');   
% pdist2 расстояние Чебышева    
    Wpdis_che1 = pdist2(Xw',Xa', 'chebychev');
    Wpdis_che2 = pdist2(Yw',Ya', 'chebychev');
    Wpdis_che3 = pdist2(Zw',Za', 'chebychev'); 
% pdist2 косинусное расстояние. Определяется как единица минус косинус от угла между объектами. Объекты в многомерном пространстве рассматриваются как векторы.    
    Wpdis_cos1 = pdist2(Xw',Xa', 'cosine');
    Wpdis_cos2 = pdist2(Yw',Ya', 'cosine');
    Wpdis_cos3 = pdist2(Zw',Za', 'cosine');
% pdist2 выборочная корреляция    
    Wpdis_cor1 = pdist2(Xw',Xa', 'correlation');
    Wpdis_cor2 = pdist2(Yw',Ya', 'correlation');
    Wpdis_cor3 = pdist2(Zw',Za', 'correlation');
% pdist2 выборочная корреляция Спирмена 
    Wpdis_spe1 = pdist2(Xw',Xa', 'spearman');
    Wpdis_spe2 = pdist2(Yw',Ya', 'spearman');
    Wpdis_spe3 = pdist2(Zw',Za', 'spearman');    
    d1= dtw(Xw,Xm); 
    d2= dtw(Yw,Ym);
    d3= dtw(Zw,Zm);
%   'squared' квадратичное расстояние Евклида
    ds1= dtw(Xw,Xm,'squared'); 
    ds2= dtw(Yw,Ym,'squared');
    ds3= dtw(Zw,Zm,'squared');
%     'absolute' - расстояние городских кварталов
    da1= dtw(Xw,Xm,'absolute'); 
    da2= dtw(Yw,Ym,'absolute');
    da3= dtw(Zw,Zm,'absolute');  
  % Pdist2 восемь вариантов
    Dwch(j)  =abs(Wpdis_che1) +abs(Wpdis_che2) +abs(Wpdis_che3);
    Dwcit(j) =abs(Wpdis_cit1) +abs(Wpdis_cit2) +abs(Wpdis_cit3);
    Dwcor(j) =abs(Wpdis_cor1) +abs(Wpdis_cor2) +abs(Wpdis_cor3);
    Dwcos(j) =abs(Wpdis_cos1) +abs(Wpdis_cos2) +abs(Wpdis_cos3);
    Dwev(j)  =abs(Wpdis_ev1)  +abs(Wpdis_ev2)  +abs(Wpdis_ev3);
    Dwevsq(j)=abs(Wpdis_evsq1)+abs(Ppdis_evsq2)+abs(Wpdis_evsq3);
    Dwmin(j) =abs(Wpdis_min1) +abs(Ppdis_min2) +abs(Wpdis_min3);
    Dwspe(j) =abs(Wpdis_spe1) +abs(Wpdis_spe2) +abs(Wpdis_spe3);
    %вычисление dtw три способа 
    Dw(j)=abs(d1)+abs(d2)+abs(d3);
    Dws(j)=abs(ds1)+abs(ds2)+abs(ds3);
    Dwa(j)=abs(da1)+abs(da2)+abs(da3);
    fprintf('%d',j);
    fprintf('=%f\n',abs(d1)+abs(d2)+abs(d3));
    j=j+1; % следующее значение в массиве
    end 
  %  p=p+1;
    end
    %fprintf('h=%f\n', h);
end
    SummP=0; SummW=0; 
%     
   for k=1:length(Xp)
       SummP=SummP+abs(Xp(k))+abs(Yp(k))+abs(Zp(k));
   end
   for k=1:length(Xw)
       SummW=SummW+abs(Xw(k))+abs(Yw(k))+abs(Zw(k));
   end
%    
   fid9 = fopen('input.txt', 'wt'); %тут будут все погрешности в виде
                                   %временных рядов
Ppdtw=zeros(1,PL);  
Pwdtw=zeros(1,PL); 
Ppdtws=zeros(1,PL); 
Pwdtws=zeros(1,PL); 
Ppdtwea=zeros(1,PL);
Pwdtwea=zeros(1,PL); 
Ppev=zeros(1,PL);
Pwev=zeros(1,PL); 
Ppevsq=zeros(1,PL);
Pwevsq=zeros(1,PL); 
Ppch=zeros(1,PL);
Pwch=zeros(1,PL);
Ppcit=zeros(1,PL); 
Pwcit=zeros(1,PL);
Ppcor=zeros(1,PL); 
Pwcor=zeros(1,PL);
Ppcos=zeros(1,PL);
Pwcos=zeros(1,PL);
Ppmin=zeros(1,PL); 
Pwmin=zeros(1,PL); 
Ppspe=zeros(1,PL);
Pwspe=zeros(1,PL); 
%начальное значение (смещение влево)  
Ppdtw(1)=0; 
Pwdtw(1)=0; 
Ppdtws(1)=0; 
Pwdtws(1)=0; 
Ppdtwea(1)=341;
Pwdtwea(1)=141;
Ppev(1)= 40; 
Pwev(1)=40;
Ppevsq(1)=2000; 
Pwevsq(1)=2000;
Ppch(1)=7;
Pwch(1)=12.5;
Ppcit(1)=850; 
Pwcit(1)=850;
Ppcor(1)=0.07; 
Pwcor(1)=0.07; 
Ppcos(1)=0.05;
Pwcos(1)=0.05;
Ppmin(1)=80; 
Pwmin(1)=80; 
Ppspe(1)=0.4;
Pwspe(1)=0.4;
for E=2:PL
%dtw Евклид    
Ppdtw(E)=Ppdtw(E-1) + 0.3*PL2; 
Pwdtw(E)=Pwdtw(E-1) + 0.3*PL2; 
%dtw квадратичный Евклид
Ppdtws(E)=Ppdtws(E-1)+0.8*PL2; 
Pwdtws(E)=Pwdtws(E-1)+0.8*PL2; 
%dtw расстояние городских кварталов
Ppdtwea(E)=Ppdtwea(E-1)+0.2*PL2;
Pwdtwea(E)=Pwdtwea(E-1)+0.2*PL2;
% ситываем пороги для pdist2
%расстояние евклида
Ppev(E)=Ppev(E-1)+0.01*PL2;
Pwev(E)=Pwev(E-1)+0.01*PL2;
%квадратичное расстояние евклида
Ppevsq(E)=Ppevsq(E-1)+6*PL2; 
Pwevsq(E)=Pwevsq(E-1)+6*PL2;
 %расстояние чебышева
Ppch(E)=Ppch(E-1)+0.001*PL2;
Pwch(E)=Pwch(E-1)+0.001*PL2;
%расстояние городских кварталов
Ppcit(E)=Ppcit(E-1)+1*PL2; 
Pwcit(E)=Pwcit(E-1)+01*PL2;
%корреляционное расстояние
Ppcor(E)=Ppcor(E-1)+0.0001*PL2; 
Pwcor(E)=Pwcor(E-1)+0.0001*PL2; 
% косинусное расстояние
Ppcos(E)=Ppcos(E-1)+0.0001*PL2;
Pwcos(E)=Pwcos(E-1)+0.0001*PL2;
%расстояние минковского 
Ppmin(E)=Ppmin(E-1)+0.03*PL2; % не уменьшать
Pwmin(E)=Pwmin(E-1)+0.03*PL2; % не уменьшать
%расстояние спирмена
Ppspe(E)=Ppspe(E-1)+0.0001*PL2;
Pwspe(E)=Pwspe(E-1)+0.0001*PL2;
% 11 циклов вычисляющих ошибки
%DTW, использующего расстояние Евклида
g1=0;  % Счетчик до трех попыток самртфона
g2=0;  % Счетчик до трех попыток часов
for k=1:length(Dw)
     if Dp(k) > Ppdtw(E)
        g1 = g1+1;
        if g1==3 % три попытки по смартфону не прошли
           Cou1(E) = Cou1(E)+1;
           g1 = 0;
        end
     else
    Cou2(E) = Cou2(E) + 1; % смартфон прошел аутентификацию
    g1 = 0;
     end
    if Dw(k) > Pwdtw(E) % если часов значение выше порога  
        g2 = g2 + 1; % неудачные только по часам
        if g2 == 3 % три попытки часы сработали
        Cou3(E) = Cou3(E) + 1; %  часы не прошли
        g2 = 0;
        end
     else
       Cou4(E) = Cou4(E) + 1; % часы прошли аутентификацию
       g2 = 0;
    end
end
% DTW, использующего квадратичное расстояние Евклида
g1=0;  % Счетчик до трех попыток самртфона
g2=0;  % Счетчик до трех попыток часов

for k=1:length(Dps)
if Dps(k) > Ppdtws(E)
         g1 = g1+1;
        if g1==3 % три попытки по смартфону не прошли
           Cous1(E) = Cous1(E)+1;
           g1 = 0;
        end
         else
    Cous2(E) = Cous2(E) + 1; 
    g1 = 0;
end
if Dws(k) > Pwdtws(E)
    g2 = g2 + 1; % неудачные только по часам
        if g2 == 3 % три попытки часы сработали
        Cous3(E) = Cous3(E) + 1; %  часы не прошел
        g2 = 0;
        end
     else
       Cous4(E) = Cous4(E) + 1; % часы прошли аутентификацию
       g2 = 0;
end
end
% DTW, исп. расстояние городских кварталов
g1=0;  % Счетчик до трех попыток всего
g2=0;  % Служебная переменная для подсчета аутентификации только по смартфону

for k=1:length(Dwa)
if Dpa(k) > Ppdtwea(E)
          g1 = g1+1;
        if g1==3 % три попытки по смартфону не прошли
           Coua1(E) = Coua1(E)+1;
           g1 = 0;
        end
else
    Coua2(E) = Coua2(E) + 1; 
    g1 = 0;
end
if Dwa(k) > Pwdtwea(E)
     g2 = g2 + 1; % неудачные только по часам
        if g2 == 3 % три попытки часы сработали
        Coua3(E) = Coua3(E) + 1; %  часы не прошел
        g2 = 0;
        end
     else
       Coua4(E) = Coua4(E) + 1; % часы прошли аутентификацию
       g2 = 0;
end
end
% Ищем для pdist2, расстояние чебышева 
g1=0;  % Счетчик до трех попыток всего
g2=0;  % Служебная переменная для подсчета аутентификации только по смартфону

for k=1:length(Dpch)
if Dpch(k) > Ppch(E)
          g1 = g1+1;
        if g1==3 % три попытки по смартфону не прошли
           Cche1(E) = Cche1(E)+1;
           g1 = 0;
        end
else
    Cche2(E) = Cche2(E) + 1; % смартфон прошел аутентификацию
    g1 = 0;
end
if Dwch(k) > Pwch(E)
   g2 = g2 + 1; % неудачные только по часам
        if g2 == 3 % три попытки часы сработали
        Cche3(E) = Cche3(E) + 1; %  часы не прошел
        g2 = 0;
        end
     else
       Cche4(E) = Cche4(E) + 1; % часы прошли аутентификацию
       g2 = 0;
end end
% pdist2, расстояние городских кварталов
g1=0;  % Счетчик до трех попыток всего
g2=0;  % Служебная переменная для подсчета аутентификации только по смартфону
for k=1:length(Dpcit)
if Dpcit(k) > Ppcit(E)
           g1 = g1+1;
        if g1==3 % три попытки по смартфону не прошли
           Ccit1(E) = Ccit1(E)+1;
           g1 = 0;
        end
else
    Ccit2(E) = Ccit2(E) + 1; % смартфон прошел аутентификацию
    g1 = 0;
end
if Dwcit(k) > Pwcit(E)
g2 = g2 + 1; % неудачные только по часам
        if g2 == 3 % три попытки часы сработали
        Ccit3(E) = Ccit3(E) + 1; %  часы не прошел
        g2 = 0;
        end
     else
       Ccit4(E) = Ccit4(E) + 1; % часы прошли аутентификацию
       g2 = 0;
end end
% Ищем для pdist2, метрика минковского
g1=0;  
g2=0;  
for k=1:length(Dpmin)
if Dpmin(k) > Ppmin(E)
        g1 = g1+1;
        if g1==3 % три попытки по смартфону не прошли
           Cmin1(E) = Cmin1(E)+1;
           g1 = 0;
        end
else
    Cmin2(E) = Cmin2(E) + 1; %смартфон прошел аутентификацию
    g1 = 0;
end
if Dwmin(k) > Pwmin(E)
 g2 = g2 + 1; % неудачные только по часам
        if g2 == 3 % три попытки часы сработали
        Cmin3(E) = Cmin3(E) + 1; %  часы не прошел
        g2 = 0;
        end
     else
       Cmin4(E) = Cmin4(E) + 1; % часы прошли аутентификацию
       g2 = 0;
end end
% pdist2, расстояние Евклида
g1=0;  % 
g2=0;  % 
for k=1:length(Dpev)
if Dpev(k) > Ppev(E)
         g1 = g1+1;
        if g1==3 % три попытки по смартфону не прошли
           Cev1(E) = Cev1(E)+1;
           g1 = 0;
        end
else
    Cev2(E) = Cev2(E) + 1; % смартфон прошел аутентификацию
    g1 = 0;
end
if Dwev(k) > Pwev(E)
  g2 = g2 + 1; % неудачные только по часам
        if g2 == 3 % три попытки часов сработали
        Cev3(E) = Cev3(E) + 1; %  часы не прошел
        g2 = 0;
        end
     else
       Cev4(E) = Cev4(E) + 1; % часы прошли аутентификацию
       g2 = 0;
end
end
% pdist2, квадрат расстояния Евклида
g1=0; 
g2=0;  
for k=1:length(Dpevsq)
if Dpevsq(k) > Ppevsq(E)
       g1 = g1+1;
        if g1==3 % три попытки по смартфону не прошли
           Cevsq1(E) = Cevsq1(E)+1;
           g1 = 0;
        end
else
    Cevsq2(E) = Cevsq2(E) + 1; % смартфон прошел аутентификацию
    g1 = 0;
      
end
if Dwevsq(k) > Pwevsq(E)
 g2 = g2 + 1; % неудачные только по часам
        if g2 == 3 % три попытки часов сработали
        Cevsq3(E) = Cevsq3(E) + 1; %  часы не прошел
        g2 = 0;
        end
     else
       Cevsq4(E) = Cevsq4(E) + 1; % часы прошли аутентификацию
       g2 = 0;
end end
% pdist2, раговая метрика Спирмена
g1=0;  
g2=0;  
for k=1:length(Dpspe)
if Dpspe(k) > Ppspe(E)
        g1 = g1+1;
        if g1==3 % три попытки по смартфону не прошли
           Cspe1(E) = Cspe1(E)+1;
           g1 = 0;
        end
else
    Cspe2(E) = Cspe2(E) + 1; % смартфон прошел аутентификацию
    g1 = 0;
end
if Dwspe(k) > Pwspe(E)
   g2 = g2 + 1; % неудачные только по часам
        if g2 == 3 % три попытки часов сработали
        Cspe3(E) = Cspe3(E) + 1; %  часы не прошел
        g2 = 0;
        end
     else
       Cspe4(E) = Cspe4(E) + 1; % часы прошли аутентификацию
       g2 = 0;
end end
% Ищем для pdist2, косинусная мера
g1=0;  % Счетчик до трех попыток всего
g2=0;  % Служебная переменная для подсчета аутентификации только по смартфону
for k=1:length(Dpcos)
if Dpcos(k) > Ppcos(E)
    g1 = g1+1;
        if g1==3 % три попытки по смартфону не прошли
           Ccos1(E) = Ccos1(E)+1;
           g1 = 0;
        end
else
    Ccos2(E) = Ccos2(E) + 1; % смартфон прошел аутентификацию
    g1 = 0;
end
if Dwcos(k) > Pwcos(E)
    g2 = g2 + 1; % неудачные только по часам
        if g2 == 3 % три попытки часов сработали
        Ccos3(E) = Ccos3(E) + 1; %  часы не прошел
        g2 = 0;
        end
     else
       Ccos4(E) = Ccos4(E) + 1; % часы прошли аутентификацию
       g2 = 0;
end end
% Ищем для pdist2, корреляционная мера
g1=0;  % Счетчик до трех попыток всего
g2=0;  % Служебная переменная для подсчета аутентификации только по смартфону
for k=1:length(Dpcor)
if Dpcor(k) > Ppcor(E)
       g1 = g1+1;
        if g1==3 % три попытки по смартфону не прошли
           Ccor1(E) = Ccor1(E)+1;
           g1 = 0;
        end
else
    Ccor2(E) = Ccor2(E) + 1; % смартфон прошел аутентификацию
    g1 = 0;
end
if Dwcor(k) > Pwcor(E)
    g2 = g2 + 1; % неудачные только по часам
        if g2 == 3 % три попытки часов сработали
        Ccor3(E) = Ccor3(E) + 1; %  часы не прошел
        g2 = 0;
        end
     else
       Ccor4(E) = Ccor4(E) + 1; % часы прошли аутентификацию
       g2 = 0;
end end

% записываем в файл все данные переводя их в проценты.
% Записываем в строку, разделяя пробелами, 
% на выходе получится матрица, строки - различные алгоритмы 
%                              столбцы - значение порогов  

% порог смещается от минимального к максимальному, следовательно
% первоначально ошибки FAR максимальны, а FRR минимальны, поэтому для
% расчета FAR переменная FRR=100
%ДТВ алгоритм Евклида

RCou1(E)=abs(FRR-(100/(Cou1(E)+Cou2(E)))*Cou2(E)); %смартфон
RCou2(E)=abs(FRR-(100/(Cou3(E)+Cou4(E)))*Cou4(E)); %часы
fprintf(fid9, '%f', RCou1(E));
fprintf(fid9, ' %f', RCou2(E)); 

% %Для DTW, использующего квадратичное расстояние Евклида
RCous1(E)=abs(FRR-(100/(Cous1(E)+Cous2(E)))*Cous2(E)); 
RCous2(E)=abs(FRR-(100/(Cous3(E)+Cous4(E)))*Cous4(E)); 

fprintf(fid9, ' %f', RCous1(E));
fprintf(fid9, ' %f', RCous2(E));

% %Для DTW, использующего расстояние Городских кварталов
RCoua1(E)=abs(FRR-(100/(Coua1(E)+Coua2(E)))*Coua2(E));  % смартфон
RCoua2(E)=abs(FRR-(100/(Coua3(E)+Coua4(E)))*Coua4(E)); %часы

fprintf(fid9, ' %f', RCoua1(E));
fprintf(fid9, ' %f', RCoua2(E));

% %Для Pdist2
% % Расстояние Евклида
RCev1(E)=abs(FRR-(100/(Cev1(E)+Cev2(E)))*Cev2(E));  % смартфон
RCev2(E)=abs(FRR-(100/(Cev3(E)+Cev4(E)))*Cev4(E));  % часы

fprintf(fid9, ' %f', RCev1(E));
fprintf(fid9, ' %f', RCev2(E));

% Квадрат Евклидового расстояния (не удовлетворяет неравенству треугольника.)
RCevsq1(E)=abs(FRR-(100/(Cevsq1(E)+Cevsq2(E)))*Cevsq2(E));  % смартфон
RCevsq2(E)=abs(FRR-(100/(Cevsq3(E)+Cevsq4(E)))*Cevsq4(E));  % часы

fprintf(fid9, ' %f', RCevsq1(E));
fprintf(fid9, ' %f', RCevsq2(E));

% % Расстояния городских кварталов
RCcit1(E)=abs(FRR-(100/(Ccit1(E)+Ccit2(E)))*Ccit2(E)); % смартфон
RCcit2(E)=abs(FRR-(100/(Ccit3(E)+Ccit4(E)))*Ccit4(E)); % часы

fprintf(fid9, ' %f', RCcit1(E));
fprintf(fid9, ' %f', RCcit2(E));

% % Метрика Минковского
RCmin1(E)=abs(FRR-(100/(Cmin1(E)+Cmin2(E)))*Cmin2(E));  % смартфон
RCmin2(E)=abs(FRR-(100/(Cmin3(E)+Cmin4(E)))*Cmin4(E));  % часы

fprintf(fid9, ' %f', RCmin1(E));
fprintf(fid9, ' %f', RCmin2(E));

% % расстояние Чебышева
RCche1(E)=abs(FRR-(100/(Cche1(E)+Cche2(E)))*Cche2(E));  % смартфон
RCche2(E)=abs(FRR-(100/(Cche3(E)+Cche4(E)))*Cche4(E)); % часы

fprintf(fid9, ' %f', RCche1(E));
fprintf(fid9, ' %f', RCche2(E));

% % косинусное расстояние
RCcos1(E)=abs(FRR-(100/(Ccos1(E)+Ccos2(E)))*Ccos2(E)); % смартфон
RCcos2(E)=abs(FRR-(100/(Ccos3(E)+Ccos4(E)))*Ccos4(E));  % часы

fprintf(fid9, ' %f', RCcos1(E));
fprintf(fid9, ' %f', RCcos2(E));

% Корреляционное расстояние 
RCcor1(E)=abs(FRR-(100/(Ccor1(E)+Ccor2(E)))*Ccor2(E)); % смартфон
RCcor2(E)=abs(FRR-(100/(Ccor3(E)+Ccor4(E)))*Ccor4(E)); % часы

fprintf(fid9, ' %f', RCcor1(E));
fprintf(fid9, ' %f', RCcor2(E));

% Расстояние Спирмена
RCspe1(E)=abs(FRR-(100/(Cspe1(E)+Cspe2(E)))*Cspe2(E));  % смартфон
RCspe2(E)=abs(FRR-(100/(Cspe3(E)+Cspe4(E)))*Cspe4(E));  % часы

fprintf(fid9, ' %f', RCspe1(E));
fprintf(fid9, ' %f', RCspe2(E));

fprintf(fid9, '\n'); 
end % тут заканчивается цикл вычисления массива ошибок

fclose(fid9);

% Убираем первый элемент массива счетчиков, так как он не вычислялся и не
% записывался в файл
RCou1(1)=[]; %два устройства
RCou2(1)=[]; %одно устройство
RCous1(1)=[]; 
RCous2(1)=[]; 
RCoua1(1)=[];  % смартфон
RCoua2(1)=[]; % часы
RCev1(1)=[];  % смартфон
RCev2(1)=[];  % часы
RCevsq1(1)=[];  % смартфон
RCevsq2(1)=[];  % часы
RCcit1(1)=[]; % смартфон
RCcit2(1)=[]; % часы
RCmin1(1)=[];  % смартфон
RCmin2(1)=[];  % часы
RCche1(1)=[];  % смартфон
RCche2(1)=[]; % часы
RCcos1(1)=[]; % смартфон
RCcos2(1)=[];  % часы
RCcor1(1)=[]; % смартфон
RCcor2(1)=[]; % часы
RCspe1(1)=[];  % смартфон
RCspe2(1)=[]; 

%файл Input2.txt получается запуском данного скрипта в папке FRR при этом
%параметр FRR должен быть = 0 
FR=fileread('input2.txt'); %Читаем FRR
t=textscan(FR,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f');
Rt=cell2mat(t);

 RDTWev1 = Rt(:, 1)'; %DTW алгоритм Евклида смартфон
 RDTWev2 = Rt(:, 2)'; %DTW алгоритм Евклида часы
 RDTWevsq1 = Rt(:, 3)'; %DTW квадрат алгоритма Евклида смартфон
 RDTWevsq2 = Rt(:, 4)'; %DTW квадрат алгоритма Евклида часы
 RDTWcit1 = Rt(:, 5)'; %DTW городские кварталы смартфон
 RDTWcit2 = Rt(:, 6)'; %DTW городские кварталы часы
        
 RPdev1 = Rt(:, 7)'; % алгоритм Евклида смартфон
 RPdev2 = Rt(:, 8)'; % алгоритм Евклида часы
 RPdevsq1 = Rt(:, 9)'; % квадратичный алгоритм Евклида смартфон
 RPdevsq2 = Rt(:, 10)'; % квадратичный алгоритм Евклида часы
 RPdcit1 = Rt(:, 11)'; % Расстояние городских кварталов смартфон
 RPdcit2 = Rt(:, 12)'; % Расстояние городских кварталовчасы
 RPdmin1= Rt(:, 13)'; % метрика Минковского смартфон
 RPdmin2 = Rt(:, 14)'; % метрика Минковского часы    
 RPdche1 = Rt(:, 15)'; % расстояние Чебышева смартфон
 RPdche2 = Rt(:, 16)'; % расстояние Чебышева часы 
 RPdcos1 = Rt(:, 17)'; % косинусное расстояние смартфон
 RPdcos2 = Rt(:, 18)'; % косинусное расстояние часы     
 RPdcor1 = Rt(:, 19)'; % корреляционное расстояние смартфон
 RPdcor2 = Rt(:, 20)'; % корреляционное расстояние часы    
 RPdspe1 = Rt(:, 21)'; % расстояние Спирмена смартфон
 RPdspe2 = Rt(:, 22)'; % расстояние Спирмена часы
 
 %находим шаг пересечения FRR и FAR для линии на графике
 ZDTWev1 = 1; %DTW алгоритм Евклида смартфон
 ZDTWev2 = 1; %DTW алгоритм Евклида часы
 ZDTWevsq1 = 1; %DTW квадрат алгоритма Евклида смартфон
 ZDTWevsq2 = 1; %DTW квадрат алгоритма Евклида часы
 ZDTWcit1 = 1; %DTW городские кварталы смартфон
 ZDTWcit2 = 1; %DTW городские кварталы часы
 ZPdev1 = 1; % алгоритм Евклида смартфон
 ZPdev2 = 1; % алгоритм Евклида часы
 ZPdevsq1 = 1; % квадратичный алгоритм Евклида смартфон
 ZPdevsq2 = 1; % квадратичный алгоритм Евклида часы
 ZPdcit1 = 1; % Расстояние городских кварталов смартфон
 ZPdcit2 = 1; % Расстояние городских кварталовчасы
 ZPdmin1= 1; % метрика Минковского смартфон
 ZPdmin2 = 1; % метрика Минковского часы    
 ZPdche1 = 1; % расстояние Чебышева смартфон
 ZPdche2 = 1; % расстояние Чебышева часы 
 ZPdcos1 = 1; % косинусное расстояние смартфон
 ZPdcos2 = 1; % косинусное расстояние часы     
 ZPdcor1 = 1; % корреляционное расстояние смартфон
 ZPdcor2 = 1; % корреляционное расстояние часы    
 ZPdspe1 = 1; % расстояние Спирмена смартфон
 ZPdspe2 = 1; % расстояние Спирмена часы

 for f=1:PL-1
        if RCou1(f)>=RDTWev1(f) %DTW алгоритм Евклида смартфон
         ZDTWev1=ZDTWev1+1;
        end
         if RCou2(f)>=RDTWev2(f) %DTW алгоритм Евклида смартфон
         ZDTWev2=ZDTWev2+1;
         end
         if RCous1(f)>=RDTWevsq1(f)
             ZDTWevsq1=ZDTWevsq1+1;
         end
         if RCous2(f)>=RDTWevsq2(f)
             ZDTWevsq2=ZDTWevsq2+1;
         end
         if  RCoua1(f)>=RDTWcit1(f)
           ZDTWcit1= ZDTWcit1+1;
         end
         if RCoua2(f)>=RDTWcit2(f)
            ZDTWcit2= ZDTWcit2+1;
         end
         if RCev1(f)>=RPdev1(f)
            ZPdev1= ZPdev1+1;
         end
         if RCev2(f)>=RPdev2(f)
            ZPdev2= ZPdev2+1;
         end
         if RCevsq1(f)>=RPdevsq1(f)
            ZPdevsq1= ZPdevsq1+1;
         end
         if RCevsq2(f)>=RPdevsq2(f)
            ZPdevsq2= ZPdevsq2+1;
         end
         if RCcit1(f)>=RPdcit1(f)
            ZPdcit1= ZPdcit1+1;
         end
         if RCcit2(f)>=RPdcit2(f)
            ZPdcit2= ZPdcit2+1;
         end
         if RCmin1(f)>=RPdmin1(f)
            ZPdmin1= ZPdmin1+1;
         end
         if RCmin2(f)>=RPdmin2(f)
            ZPdmin2= ZPdmin2+1;
         end
         if RCche1(f)>=RPdche1(f)
            ZPdche1= ZPdche1+1;
         end
         if RCche2(f)>=RPdche2(f)
            ZPdche2= ZPdche2+1;
         end  
         if RCcos1(f)>=RPdcos1(f)
            ZPdcos1= ZPdcos1+1;
         end
         if RCcos2(f)>=RPdcos2(f)
            ZPdcos2= ZPdcos2+1;
         end  
         if RCcor1(f)>=RPdcor1(f)
            ZPdcor1= ZPdcor1+1;
         end
         if RCcor2(f)>=RPdcor2(f)
            ZPdcor2= ZPdcor2+1;
         end  
         if RCspe1(f)>=RPdspe1(f)
            ZPdspe1= ZPdspe1+1;
         end
         if RCspe2(f)>=RPdspe2(f)
            ZPdspe2= ZPdspe2+1;
         end    
end
 
 % линяя на графике (44 координаты)
  KDTWev1_1=[0,PL];
  KDTWev1_2=[RDTWev1(ZDTWev1),RDTWev1(ZDTWev1)];
  KDTWev2_1=[0,PL];
  KDTWev2_2=[RDTWev2(ZDTWev2),RDTWev2(ZDTWev2)];    
  KDTWevsq1_1=[0,PL];
  KDTWevsq1_2=[RDTWevsq1(ZDTWevsq1),RDTWevsq1(ZDTWevsq1)];
  KDTWevsq2_1=[0,PL];
  KDTWevsq2_2=[RDTWevsq2(ZDTWevsq2),RDTWevsq2(ZDTWevsq2)];      
  KDTWcit1_1=[0,PL];
  KDTWcit1_2=[RDTWcit1(ZDTWcit1),RDTWcit1(ZDTWcit1)];
  KDTWcit2_1=[0,PL];
  KDTWcit2_2=[RDTWcit2(ZDTWcit2),RDTWcit2(ZDTWcit2)];
  Kev1_1=[0,PL];
  Kev1_2=[RPdev1(ZPdev1),RPdev1(ZPdev1)];
  Kev2_1=[0,PL];
  Kev2_2=[RPdev2(ZPdev2),RPdev2(ZPdev2)]; 
  Kevsq1_1=[0,PL];
  Kevsq1_2=[RPdevsq1(ZPdevsq1),RPdevsq1(ZPdevsq1)];
  Kevsq2_1=[0,PL];
  Kevsq2_2=[RPdevsq2(ZPdevsq2),RPdevsq2(ZPdevsq2)]; 
  Kcit1_1=[0,PL];
  Kcit1_2=[RPdcit1(ZPdcit1),RPdcit1(ZPdcit1)];
  Kcit2_1=[0,PL];
  Kcit2_2=[RPdcit2(ZPdcit2),RPdcit2(ZPdcit2)];
  Kmin1_1=[0,PL];
  Kmin1_2=[RPdmin1(ZPdmin1),RPdmin1(ZPdmin1)];
  Kmin2_1=[0,PL];
  Kmin2_2=[RPdmin2(ZPdmin2),RPdmin2(ZPdmin2)]; 
  Kche1_1=[0,PL];
  Kche1_2=[RPdche1(ZPdche1),RPdche1(ZPdche1)];
  Kche2_1=[0,PL];
  Kche2_2=[RPdche2(ZPdche2),RPdche2(ZPdche2)];  
  Kcos1_1=[0,PL];
  Kcos1_2=[RPdcos1(ZPdcos1),RPdcos1(ZPdcos1)];
  Kcos2_1=[0,PL];
  Kcos2_2=[RPdcos2(ZPdcos2),RPdcos2(ZPdcos2)];  
  Kcor1_1=[0,PL];
  Kcor1_2=[RPdcor1(ZPdcor1),RPdcor1(ZPdcor1)];
  Kcor2_1=[0,PL];
  Kcor2_2=[RPdcor2(ZPdcor2),RPdcor2(ZPdcor2)];    
  Kspe1_1=[0,PL];
  Kspe1_2=[RPdspe1(ZPdspe1),RPdspe1(ZPdspe1)];
  Kspe2_1=[0,PL];
  Kspe2_2=[RPdspe2(ZPdspe2),RPdspe2(ZPdspe2)];    
  
  % надписи на графиках
str1=sprintf('EER= %g', RDTWev1(ZDTWev1));
str2=sprintf('EER= %g', RDTWev2(ZDTWev2));
str3=sprintf('EER= %g', RDTWevsq1(ZDTWevsq1));
str4=sprintf('EER= %g', RDTWevsq2(ZDTWevsq2));
str5=sprintf('EER= %g', RDTWcit1(ZDTWcit1));
str6=sprintf('EER= %g', RDTWcit2(ZDTWcit2));
str7=sprintf('EER= %g', RPdev1(ZPdev1));
str8=sprintf('EER= %g', RPdev2(ZPdev2));
str9=sprintf('EER= %g', RPdevsq1(ZPdevsq1));
str10=sprintf('EER= %g', RPdevsq2(ZPdevsq2));
str11=sprintf('EER= %g', RPdcit1(ZPdcit1));
str12=sprintf('EER= %g', RPdcit2(ZPdcit2));
str13=sprintf('EER= %g', RPdmin1(ZPdmin1));
str14=sprintf('EER= %g', RPdmin2(ZPdmin2));
str15=sprintf('EER= %g', RPdche1(ZPdche1));
str16=sprintf('EER= %g', RPdche2(ZPdche2));
str17=sprintf('EER= %g', RPdcos1(ZPdcos1));
str18=sprintf('EER= %g', RPdcos2(ZPdcos2));
str19=sprintf('EER= %g', RPdcor1(ZPdcor1));
str20=sprintf('EER= %g', RPdcor2(ZPdcor2));
str21=sprintf('EER= %g', RPdspe1(ZPdspe1));
str22=sprintf('EER= %g', RPdspe2(ZPdspe2));

figure('Name','DTWрасстояние Евклида');
p=plot(RCou1,'b');
tol=p.LineWidth;
p.LineWidth=1.7;
hold on;
o=plot(RDTWev1,'b');
o.LineWidth=1.7;
plot(KDTWev1_1,KDTWev1_2);
text(20000,RDTWev1(ZDTWev1)+3, str1) ;
plot(RCou2,'r');
plot(RDTWev2,'r');
plot(KDTWev2_1,KDTWev2_2);
text(25000,RDTWev2(ZDTWev2)+3, str2) ;


figure('Name','DTW квадратичное расстояние Евклида');
p=plot(RCous1,'b');
tol=p.LineWidth;
p.LineWidth=1.7;
hold on;
o=plot(RDTWevsq1,'b');
o.LineWidth=1.7;
plot(KDTWevsq1_1,KDTWevsq1_2);
text(15000,RDTWevsq1(ZDTWevsq1)+3, str3) ;
plot(RCous2,'r');
plot(RDTWevsq2,'r');
plot(KDTWevsq2_1,KDTWevsq2_2);
text(25000,RDTWevsq2(ZDTWevsq2)+3, str4) ;

figure('Name','DTW городские кварталы');
p=plot(RCoua1,'b');
tol=p.LineWidth;
p.LineWidth=1.7;
hold on;
o=plot(RDTWcit1,'b');
o.LineWidth=1.7;
plot(KDTWcit1_1,KDTWcit1_2);
text(20000,RDTWcit1(ZDTWcit1)+3, str5) ;
plot(RCoua2,'r');
plot(RDTWcit2,'r');
plot(KDTWcit2_1,KDTWcit2_2);
text(25000,RDTWcit2(ZDTWcit2)+3, str6) ;

figure('Name','Расстояние Евклида');
p=plot(RCev1,'b');
tol=p.LineWidth;
p.LineWidth=1.7;
hold on;
o=plot(RPdev1,'b');
o.LineWidth=1.7;
plot(Kev1_1,Kev1_2);
text(20000,RPdev1(ZPdev1)+3, str7) ;
plot(RCev2,'r');
plot(RPdev2,'r');
plot(Kev2_1,Kev2_2);
text(25000,RPdev2(ZPdev2)+3, str8) ;

figure('Name','Квадрат расстояния Евклида');
p=plot(RCevsq1,'b');
tol=p.LineWidth;
p.LineWidth=1.7;
hold on;
o=plot(RPdevsq1,'b');
o.LineWidth=1.7;
plot(Kevsq1_1,Kevsq1_2);
text(20000,RPdevsq1(ZPdevsq1)+3, str9) ;
plot(RCevsq2,'r');
plot(RPdevsq2,'r');
plot(Kevsq2_1,Kevsq2_2);
text(30000,RPdevsq2(ZPdevsq2)+3, str10) ;

figure('Name','Расстояния городских кварталов');
p=plot(RCcit1,'b');
tol=p.LineWidth;
p.LineWidth=1.7;
hold on;
o=plot(RPdcit1,'b');
o.LineWidth=1.7;
plot(Kcit1_1,Kcit1_2);
text(20000,RPdcit1(ZPdcit1)+3, str11) ;
plot(RCcit2,'r');
plot(RPdcit2,'r');
plot(Kcit2_1,Kcit2_2);
text(30000,RPdcit2(ZPdcit2)+3, str12) ;

figure('Name','Метрика Минковского');
p=plot(RCmin1,'b');
tol=p.LineWidth;
p.LineWidth=1.7;
hold on;
o=plot(RPdmin1,'b');
o.LineWidth=1.7;
plot(Kmin1_1,Kmin1_2);
text(20000,RPdmin1(ZPdmin1)+3, str13) ;
plot(RCmin2,'r');
plot(RPdmin2,'r');
plot(Kmin2_1,Kmin2_2);
text(30000,RPdmin2(ZPdmin2)+3, str14) ;

figure('Name',' расстояние Чебышева');
p=plot(RCche1,'b');
tol=p.LineWidth;
p.LineWidth=1.7;
hold on;
o=plot(RPdche1,'b');
o.LineWidth=1.7;
plot(Kche1_1,Kche1_2);
text(20000,RPdche1(ZPdche1)+3, str15) ;
plot(RCche2,'r');
plot(RPdche2,'r');
plot(Kche2_1,Kche2_2);
text(30000,RPdche2(ZPdche2)+3, str16) ;

figure('Name','косинусное расстояние');
p=plot(RCcos1,'b');
tol=p.LineWidth;
p.LineWidth=1.7;
hold on;
o=plot(RPdcos1,'b');
o.LineWidth=1.7;
plot(Kcos1_1,Kcos1_2);
text(20000,RPdcos1(ZPdcos1)+3, str17) ;
plot(RCcos2,'r');
plot(RPdcos2,'r');
plot(Kcos2_1,Kcos2_2);
text(30000,RPdcos2(ZPdcos2)+3, str18) ;

figure('Name','Корреляционное расстояние');
p=plot(RCcor1,'b');
tol=p.LineWidth;
p.LineWidth=1.7;
hold on;
o=plot(RPdcor1,'b');
o.LineWidth=1.7;
plot(Kcor1_1,Kcor1_2);
text(20000,RPdcor1(ZPdcor1)+3, str19) ;
plot(RCcor2,'r');
plot(RPdcor2,'r');
plot(Kcor2_1,Kcor2_2);
text(30000,RPdcor2(ZPdcor2)+3, str20) ;

figure('Name','Расстояние Спирмена');
p=plot(RCspe1,'b');
tol=p.LineWidth;
p.LineWidth=1.7;
hold on;
o=plot(RPdspe1,'b');
o.LineWidth=1.7;
plot(Kspe1_1,Kspe1_2);
text(20000,RPdspe1(ZPdspe1)+3, str21) ;
plot(RCspe2,'r');
plot(RPdspe2,'r');
plot(Kspe2_1,Kspe2_2);
text(30000,RPdspe2(ZPdspe2)+3, str22) ;


