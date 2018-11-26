FILENAME REFFILE '/folders/myfolders/Iris.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=work.import;
	GETNAMES=YES;
RUN;

/* print the first 5 rows for a few variales */
proc print data=work.import(obs=5);      /* (obs=5) is an 'option' */

/* get some basic information about the imported data */
proc contents data=work.import;
run;

/*
proc corr data=work.import2;
var Sepal_Length Sepal_Width Petal_Length Petal_Width;
run;

proc logistic data = work.import2 outest=betas covout;
class species (ref = "virginic");
model species =  Sepal_Length Sepal_Width Petal_Length Petal_Width / link = glogit;
output out=pred p=phat lower=lcl upper=ucl predprob=(individual crossvalidate);
run;

/*proc print data=betas;
title2 'Parameter Estimates and Covariance Matrix';
run;

proc print data=pred;
title2 'Predicted Probabilities and 95% Confidence Limits';
run;
*/

proc logistic data = work.import;
class species (ref = "virginic");
model species =  Sepal_Length Sepal_Width Petal_Length Petal_Width / link = glogit;
score data=work.import out=valpred;
run;

/*
proc print data=valpred;
run;

proc tabulate data=valpred;
 var p_setosa;
 table p_setosa*N p_setosa*max p_setosa*min;
 by Species;
run;*/

data prediction;
 set valpred;
 species_pre = 0;
 species_ori = 0;
 accuracy = 1;
 if species = 'setosa' then species_ori=1;
 if species = 'versicol' then species_ori=2; 
 if species = 'virginic' then species_ori=3;
 if P_setosa > P_versicol and p_setosa > P_virginic then species_pre=1;
 if P_versicol > P_setosa and P_versicol > P_virginic then species_pre=2; 
 if P_virginic > P_setosa and P_virginic > P_versicol then species_pre=3;
 if species_ori > species_pre then delete;
 if species_ori < species_pre then delete;
 keep species accuracy;
 
proc tabulate data=prediction;
 var accuracy;
 table accuracy*N;
run;

proc summary data=prediction;
output out=accuracy
sum(accuracy) = acc;

data final;
set accuracy;
a = acc/150;
run;
proc print data=final;
run;


/*
proc print data=prediction;
run;
*/

