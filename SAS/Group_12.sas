/*Import our data iris*/
FILENAME REFFILE '/Iris.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=work.import;
	GETNAMES=YES;
RUN;

/*Separate the data set into training set and testing set*/
data train;
    set work.import;
    if _N_ in (1:40, 51:90, 101:140) then output;

data test;
    set work.import;
    if _N_ in (41:50, 91:100, 141:150) then output;
run;


/* get some basic information about the imported data */
proc summary data=work.import min q1 mean q3 max std n;
var Sepal_Length Sepal_Width Petal_Length Petal_Width;
by Species;
output out = iris_summary;

proc print data = iris_summary;
title 'Summary of Iris data set';
run;


/*Build the Multinomial Logistic Regression Model with four predictors*/
proc logistic data = train;
class species (ref = "virginic");
model species =  Sepal_Length Sepal_Width Petal_Length Petal_Width / link = glogit;
score data=test out=valpred;
title 'Multinomial Logistic Regression Model';
run;


/*Test the accuracy of our model on the test set*/
data prediction;
 set valpred;
 species_pre = 0;
 species_ori = 0;
 accuracy = 1;
/*Labe the original species into 1(setosa), 2(versicolor), 3(virginica) and generate a new variable species_orei to save that label*/
 if species = 'setosa' then species_ori=1;
 if species = 'versicol' then species_ori=2; 
 if species = 'virginic' then species_ori=3;
/*Choose the highest probability of three speices as the final result*/
 if P_setosa > P_versicol and p_setosa > P_virginic then species_pre=1;
 if P_versicol > P_setosa and P_versicol > P_virginic then species_pre=2; 
 if P_virginic > P_setosa and P_virginic > P_versicol then species_pre=3;
/*Compare the original species and the predict species and reserve the data with same result*/
 if species_ori > species_pre then delete;
 if species_ori < species_pre then delete;
 keep species accuracy;

/*Compute accuracy ratio*/
proc summary data=prediction;
output out=accuracy
sum(accuracy) = accuracy;

data final;
set accuracy;
accuracy = accuracy/30;

proc print data=final;
title 'Test the Accuracy by Test Set';
run;
