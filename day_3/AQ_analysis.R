## today's exercise: scoring the AQ
## http://talklab.psy.gla.ac.uk/r_training/scoring_the_AQ

library("readr")
library("dplyr")
library("tidyr")

dat <- read_csv("sm_data.csv", skip = 1)

dat2 <- gather(dat, Question, Response, Q1:Q10)

# one idea for coding agree vs. disagree
# (that will work, but IMO is not the best)
# dat3 <- separate(dat2, Response, into = c("amt", "agreement"), " ")

# now there are two main options for analyzing the data
# option 1: split the data into two sets
# option 2: use joins
#
# I personally prefer option 2, but do whatever suits you and gets the job done


###############################################
## If you want to go along the option 1 path:
##### (begin option 1)

dat3_f1 <- filter(dat2, Question %in% c("Q1", "Q7", "Q8", "Q10"))
dat3_f2 <- filter(dat2, !(Question %in% c("Q1", "Q7", "Q8", "Q10")))

## TODO: assign points to agree/disagree

## you might need to put the data back together again, e.g.:
## alldat <- bind_rows(dat3_f1, dat3_f2)

##### (end option 1)
###############################################

###############################################
## To go along the option 2 path:
## (begin option 2)
resp_cat <- c("Definitely Disagree", "Slightly Disagree",
              "Slightly Agree", "Definitely Agree")

lookup <- data_frame(Format = rep(1:2, each = 4),
                     Response = rep(resp_cat, 2),
                     Points = c(0, 0, 1, 1, 1, 1, 0, 0))
b2dat <- mutate(dat2,
                Format = ifelse(Question %in% c("Q1", "Q7", "Q8", "Q10"), 1, 2))

b2dat2 <- inner_join(b2dat, lookup, c("Format", "Response"))

## (end option 2)
###############################################

## TODO: create summaries for each participant

## TODO: make a histogram showing the distribution

## TODO: put it into an RMarkdown file and generate a report
## explaining what you did and how you did it, and export to HTML or
## PDF
