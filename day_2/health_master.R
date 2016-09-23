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

setwd("~/Analyses/DeBruine_hackathon")

## Get data on infant mortality rates
## from the CSV file "infmort.csv" in the directory "data"
infmort <- read_csv('data/infmort.csv')

## Get data on maternal mortality
## from from the excel file "matmort.xls" in the directory "data"
matmort <- read_csv("data/matmort.csv")

## Get data on country codes from 
## https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv

ccodes <- read_csv("https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv")

## check the column names and make them sensible
names(infmort)
names(infmort)[3] <- 'IMR'
names(matmort)
names(matmort)[2] <- '1990'
names(matmort)[3] <- '2000'
names(matmort)[4] <- '2015'


######################################################
# gather(data, key, value, start.column:end.column)
######################################################

## matmort is in wide format, with a separate column for each year
## change it to long format, with a row for each County/Year observation 

matmort2 <- gather(matmort, Year, MMR, 2:4)

######################################################
# separate(data, col, into, sep)
######################################################

## value is a crazy format with some sort of confidence interval in brackets
## split it on the left bracket using separate(data, col, into, sep = "\\[")

matmort3 <- separate(matmort2, MMR, into=c('MMR'), sep = "\\[")
infmort2 <- separate(infmort, IMR, into=c('IMR'), sep = "\\[")

######################################################
# mutate(date, col1 = newcol1)
######################################################

## also for matmort, they use a space instead of , or . to mark thousands!!!!
## replace this using mutate() and str_replace_all(string, search, replace)

matmort4 <- mutate(matmort3, 
                   MMR = str_replace_all(MMR, " ", ""))

## now make sure that these columns and Year are <int> or <dbl>, not <chr>
matmort5 <- mutate(matmort4, 
                   MMR = as.integer(MMR), 
                   Year = as.integer(Year))

infmort3 <- mutate(infmort2, 
                   IMR = as.numeric(IMR), 
                   Year = as.integer(Year))


######################################################
# inner_join(data1, data2, by = c("col1", "col2"))
######################################################

## join up the data by Country and Year
data.joined <- inner_join(matmort5, infmort3, by = c("Country", "Year"))
  

######################################################
# left_join(main.data, optional.data, by = c("col1" = "col2")
######################################################

## join just the region from the country codes

data.final <- left_join(data.joined, select(ccodes, name, region) , by = c("Country" = "name"))

## plot MMR vs IMR for each region
ggplot(data.final, aes(MMR, IMR)) + geom_point() + facet_wrap(~region)
