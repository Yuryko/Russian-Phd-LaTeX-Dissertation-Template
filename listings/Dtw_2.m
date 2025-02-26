clear
close all
clc
mex dtw_c.c;
f=3; % { значение сглаживающего фильтра } 
p=fileread('etalonW.txt'); %читаем  эталон  часов
p(p==',')='.';
k=textscan(p,' %f%f%f');
Rw=cell2mat(k);
Xw=Rw(:, 1);
Yw=Rw(:, 2);
Zw=Rw(:, 3);
Xw = smooth(Xw,f);
Yw = smooth(Yw,f);
Zw = smooth(Zw,f);
r=fileread('etalonP.txt'); %Читаем  эталон телефона
r(r==',')='.';
k=textscan(r,' %f%f%f');
Rp=cell2mat(k);
Xp=Rp(:, 1);
Yp=Rp(:, 2);
Zp=Rp(:, 3);
Xp = smooth(Xp,f);
Yp = smooth(Yp,f);
Zp = smooth(Zp,f);
l=0; j=1; 
[fname, pname] = uigetfile('*.txt', 'Select txt data base files', 'MultiSelect', 'on');
Dp=0:length(fname)/2; 
Dw=0:length(fname)/2; 
if ~isequal(fname, 0) %загружаем в память все файлы
  if ~iscell(fname)
    fname = {fname};
  end
  fname = sort(fname);
    for k=1:length(fname)
    fullname = fullfile(pname, fname{k});
        m=fileread(fullname);
    m(m==',')='.';
      k=textscan(m,' %f%f%f');
    M=cell2mat(k);
    Xm = M(:, 1);
    Ym = M(:, 2);
    Zm = M(:, 3);
    Xm = smooth(Xm,f);% Фильтруем   данные
    Ym = smooth(Ym,f);
    Zm = smooth(Zm,f);
    if l==0 
    d1=dtw_c(Xp,Xm); 
    d2=dtw_c(Yp,Ym);
    d3=dtw_c(Zp,Zm);
    l=l+1;
    Dp(j)=abs(d1)+abs(d2)+abs(d3);
    else
    d1=dtw_c(Xw,Xm); 
    d2=dtw_c(Yw,Ym);
    d3=dtw_c(Zw,Zm);
    l=l-1;
    Dw(j)=abs(d1)+abs(d2)+abs(d3);
    j=j+1;
    end;
    fprintf('h=%f\n',abs(d1)+abs(d2)+abs(d3));
     end;
 end;

z=0; s=0;  
MaxP = Dp(1);  
MaxW = Dw(1);  
for k=1:length(Dw)
    z = z + Dp(k);
    if Dp(k) > MaxP
        MaxP = Dp(k);
    end;
    s = s + Dw(k);
    if Dw(k) > MaxW
        MaxW = Dw(k);
    end;
end;
PorogP = z/length(Dp)+z/(length(Dp)*4);
PorogW = s/length(Dw)+s/(length(Dw)*4);
z=0; 
s=0;
l=0; 
Cou1=0;
Cou2=0;    
j=1; 
for k=1:length(Dw)
if Dp(k) > PorogP 
        z=z+1;
        l = l+1;
end;   
if Dw(k) > PorogW
        s=s+1;
        l = l+1;
end;
if l == 1
    Cou2 = Cou2+1;
    Cou1 = Cou1+1;
    DdiffP(Cou2) = Dp(k)/1000;
    DdiffW(Cou2) = Dw(k)/1000;

end;
if l == 2
    Cou1 = Cou1+1;
end;
l = 0;
end;
Dt1=[0, MaxW]; 
Dt2=[PorogP,PorogP];
Du1=[0, MaxP]; 
Du2=[PorogW,PorogW]; 
plot(Dp, Dw,'b.');
xlabel('Стоимость DTW от эталона телефона');
ylabel('Стоимость DTW от эталона часов');
title('Мультимодальная трехмерная динамическая подпись')
hold on;
plot(Dt2, Dt1); 
plot(Du1, Du2); 
plot(DdiffP, DdiffW, 'ro');








