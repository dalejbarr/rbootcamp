############################################
# Tidying, Joining and Visualising Data
#
# http://vita.had.co.nz/papers/tidy-data.pdf
# http://docs.ggplot2.org
############################################

library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(viridis)


################  Load your data ################  

# set your working directory


# read in data from CSV files in data folder 
# (participants.csv, personality.csv and sensation_seeking.csv)
pants <- ?
pers <- ?
sens <- ?
  
# Check that they look OK
### pants should have user_id, sex and birthday columns, and 52043 rows
### pers should have user_id, date, and lots of personality scores in columns, and 15000 rows
### sens should have id, user_id, date and 14 sensation-seeking scores in columns, and 27021 rows


######################################################
# select(data, start.column:end.column)
######################################################

# make summary sensation-seeking measure
sens$sss <- ?

######################################################
# qplot(column, data, geom='histogram', binwidth)
######################################################

# have a look at your new variable, does it make sense?

  
# make summary personality measures: sum the subscores and divide by the number of scores
pers$Op <- ? 
pers$Co <- ?
pers$Ex <- ?
pers$Ag <- ?
pers$Ne <- ?

  
# have a look at your new variable, do they make sense?  


######################################################
# inner_join(data1, data2, by = c("col1", "col2"))
######################################################

# join all the data from the same participants

data.matched <- ?

# how many participants did both?


# narrow it down to those who did both questionnaires on the same date

data.same.date <- ?

# how many participants do we have now?


######################################################
# left_join(main.data, optional.data, by = "col")
######################################################

# join in the participant demographic data

data.wide <- ?


# get just the columns you want to analyse using select()

data.analyse <- ?

# how many incomplete rows?



######################################################
# filter(data, col1 == "match1" & col2 == "match2")
######################################################

# select just the rows you want using na.omit() and filter()

data.complete <- ?

######################################################
# gather(data, key, value, start.column:end.column)
######################################################

## data is in wide format, with a separate column for each personality factor
## change it to long format, with a row for each personality factor per person 

data.long <- ?
  

################  Visualise all the things! ################ 


# what is the distribution of sss by sex?



# what is the distribution of personality scores by sex?



# How is personality related to sensation seeking?



######################################################
# png('filename.png', width = px, height = px, res = px/inch)
######################################################

# print as PNG



######################################################
# pdf('filename.pdf', width - inches, height = inches)
######################################################

# print as PDF

