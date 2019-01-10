data a;
b=0.1;
do t=1 to 1000 by 1;
x=b*t+10*rannor(54321);
Y=b*t;
output;
end;
data a;
set a;
residual1=dif(x);
residual2=x-y;
proc gplot;
plot x*T=1;
plot residual1*T=1/vref=-28.2,28.2;
plot residual2*T=1/vref=-20,20;
symbol1 c=black i=join v=none;
proc arima data=a;
identify var=x stationarity=(adf=1);
identify var=x(1) stationarity=(adf=1);
identify var=residual1 stationarity=(adf=1);
identify var=residual2 stationarity=(adf=1);
run;
