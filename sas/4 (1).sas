data a;
input t x y;
lnx=log(x);
lny=log(y);
diflnx=dif(lnx);
diflny=dif(lny);  
cards;
1950	20.0	21.3
1951	24.2	35.3
1952	27.1	37.5
1953	34.8	46.1
1954	40.0	44.7
1955	48.7	61.1
1956	55.7	53.0
1957	54.5	50.0
1958	67.0	61.7
1959	78.1	71.2
1960	63.3	65.1
1961	47.7	43.0
1962	47.1	33.8
1963	50.0	35.7
1964	55.4	42.1
1965	63.1	55.3
1966	66.0	61.1
1967	58.8	53.4
1968	57.6	50.9
1969	59.8	47.2
1970	56.8	56.1
1971	68.5	52.4
1972	82.9	64.0
1973	116.9	103.6
1974	139.4	152.8
1975	143.0	147.4
1976	134.8	129.3
1977	139.7	132.8
1978	167.6	187.4
1979	211.7	242.9
1980	271.2	298.8
1981	367.6	367.7
1982	413.8	357.5
1983	438.3	421.8
1984	580.5	620.5
1985	808.9	1257.8
1986	1082.1	1498.3
1987	1470.0	1614.2
1988	1766.7	2055.1
1989	1956.0	2199.9
1990	2985.8	2574.3
1991	3827.1	3398.7
1992	4676.3	4443.3
1993	5284.8	5986.2
1994	10421.8	9960.1
1995	12451.8	11048.1
1996	12576.4	11557.4
1997	15160.7	11806.5
1998	15223.6	11626.1
1999	16159.8	13736.5
2000	20634.4	18638.8
2001	22024.4	20159.2
2002	26947.9	24430.3
2003	36287.9	34195.6
2004	49103.3	46435.8
2005	62648.1	54273.7
2006	77594.6	63376.9
2007	93455.6	73284.6
2008	100394.9 79526.5
;
/*proc gplot data=a;
plot x*t=1 y*t=2/overlay;
symbol1 v=none c=black i=join;
symbol2 v=none c=red i=join;
run;*/
proc gplot data=a;
plot diflnx*t=1 diflny*t=2/overlay;
symbol1 v=none c=black i=join;
symbol2 v=none c=red i=join;
run;
/*proc arima data=a;
identify var=lnx stationarity=(adf);
identify var=lny stationarity=(adf);
identify var=lnx(1) stationarity=(adf);
identify var=lny(1) stationarity=(adf);
identify var=lnx(1) stationarity=(pp);
identify var=lnx(1) stationarity=(pp);
run;*/
proc reg;
model lny=lnx /noint;
output out=out residual=residual;
proc arima data=out;
identify var=residual stationarity=(adf);
/*拟合残差*/
proc arima data=a;
identify var=lny crosscorr=(lnx);
estimate p=1 input=lnx noint;
forecast lead=10 id=year out=result;
/*对lny进行转变*/
data result;
set result;
y=exp(lny);
estimate=exp(forecast);
proc gplot data=result;
plot lny*year=1 forecast*year=2 /overlay;
plot y*year=1 estimate*year=2 /overlay;
symbol1 c=black i=none v=star;
symbol2 c=red i=join v=none;
/*ecm值*/
data b;
set a;
ecm=lny-0.99265*lnx;
lag_ecm=lag(ecm);
dif_lnx=dif(lnx);
dif_lny=dif(lny);
/*加入ecm的模型*/
proc reg data=b;
model dif_lny=dif_lnx lag_ecm /noint;
run;