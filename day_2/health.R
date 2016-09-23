############################################
# Tidying, Joining and Visualising Data
#
# http://vita.had.co.nz/papers/tidy-data.pdf
# http://docs.ggplot2.org
# Data from http://apps.who.int/gho/data/node.home
############################################

library(readr)
library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)

################  Load your data ################ 

# set your working directory


## Get data on infant mortality rates
## from the CSV file "infmort.csv" in the directory "data"
infmort <- ?

## Get data on maternal mortality
## from from the excel file "matmort.xls" in the directory "data"
matmort <- ?


## Get data on country codes from 
## https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv

ccodes <- ?

## check the column names and make them sensible



######################################################
# gather(data, key, value, start.column:end.column)
######################################################

## matmort is in wide format, with a separate column for each year
## change it to long format, with a row for each County/Year observation 

matmort2 <- ?

######################################################
# separate(data, col, into, sep)
######################################################

## value is a crazy format with some sort of confidence interval in brackets
## split it on the left bracket using separate(data, col, into, sep = "\\[")

matmort3 <- ?

infmort2 <- ?

######################################################
# mutate(date, col1 = newcol1)
######################################################

## also for matmort, they use a space instead of , or . to mark thousands!!!!
## replace this using mutate() and str_replace_all(string, search, replace)

matmort4 <- ?

## now make sure that these columns and Year are <int> or <dbl>, not <chr>

matmort5 <- ?

infmort3 <- ?


######################################################
# inner_join(data1, data2, by = c("col1", "col2"))
######################################################

## join up the data by Country and Year

inf.mat.mort <- ?
  

######################################################
# left_join(main.data, optional.data, by = c("main.col" = "opt.col")
######################################################

## join just the region from the country codes

data.final <- ?

## plot maternal mortality rate vs infant mortality rate


## plot maternal mortality rate vs infant mortality rate for each region

