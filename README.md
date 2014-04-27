The script can be run by typing:
> source(./run_analisys.R)

The folder containing the data should be in the working directory.

The library needed for the script are:
* plyr
* reshape2
These are loaded at the beginning of the script.

The script goes through the following main steps:
* load the features and activity list
* load the test and train data
* merge the test and train data (x_measurement)
* get list of features that are either standard deviations or means using 'grep' (searching for 'std' or 'mean(' in features name)
* get measurement for only these features and transpose the data set using 'melt' (x)
* calculate the mean for each features per patient and activity using ddply (x_mean)
* write to a file (x_mean.csv)
* generate the codebook.md
