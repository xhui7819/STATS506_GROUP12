clear all
* Loading the data
import delimited iris.csv 
list in 1/5

* Discription of Data
summarize sepal_length sepal_width petal_length petal_width
tab species 
* Check the missing values 
misstable summarize

* Separate the data into train set and test set
gene seqnum=_n
generate training = 1 if seqnum <= 40 | seqnum >= 51 & seqnum <= 90 | seqnum >= 101 & seqnum <= 140
replace training = 0 if training == .

* In the model, we choose to pick virginica as the baseline category 
* Since mlogit only accepts numeric arguments, thus encoding string into numeric
encode species, generate(new_species)
mlogit new_species sepal_length sepal_width petal_length petal_width if training == 1, base(3)
mlogit, rrr

* Get the Prediction by using test dataset
keep if training == 0 
predict setosa
predict versicolor, equation(versicolor)
predict virginica, equation(virginica)
* Encode the origin species to numbers 
gen species_ori = 1 if species == "setosa"
replace species_ori = 2 if species == "versicolor"
replace species_ori = 3 if species == "virginica"
* Consider the catogory of highest probability as the last predict model 
gen species_pre=1 if setosa > versicolor & setosa > virginica
replace species_pre=2 if versicolor > setosa & versicolor > virginica
replace species_pre=3 if virginica > setosa & virginica > versicolor
* Check the difference between prediction and the original category
display species_pre - species_ori



