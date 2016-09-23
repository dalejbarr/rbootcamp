############################################
# Tidying, Joining and Visualising Data
#
# http://vita.had.co.nz/papers/tidy-data.pdf
# http://docs.ggplot2.org
############################################

library(readr)
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(viridis)

############################################
# Load your data
############################################

# set your working directory


# read in data from CSV files
pants <- read_csv('data/participants.csv')
pers <- read_csv('data/personality.csv')
sens <- read_csv('data/sensation_seeking.csv')

# check that they look OK
glimpse(pants)
glimpse(pers)
glimpse(sens)


############################################
# Make Summary Measures
############################################

# make summary sensation-seeking measure
colnames(sens)

# one way
# colsToSum <- sens %>% select(sss1:sss14)
# sens$sss <- rowSums(colsToSum)

# could also do it this way:
#sens <- sens %>% mutate(sss = rowSums(select(., sss1:sss14)))

# best way
sens <- gather(sens, Question, Response, sss1:sss14) %>%
  group_by(user_id, date) %>%
  summarise(sss = sum(Response)) %>%
  ungroup()

# have a look at your new variable, does it make sense?
summary(sens$sss)
qplot(sss, data=sens, geom='histogram', binwidth=1)

# make summary personality measures
colnames(pers)

# # slow and laborious way
# pers$Op  <- (pers$Op1 + pers$Op2 + pers$Op3 + 
#                pers$Op4 + pers$Op5 + pers$Op6)/6
# pers$Co <- (pers$Co1 + pers$Co2 + pers$Co3 + pers$Co4 + pers$Co5 + 
#               pers$Co6 + pers$Co7 + pers$Co8 + pers$Co9 + pers$Co10)/10
# pers$Ex <- (pers$Ex1 + pers$Ex2 + pers$Ex3 + pers$Ex4 + pers$Ex5 + 
#               pers$Ex6 + pers$Ex7 + pers$Ex8 + pers$Ex9)/9
# pers$Ag <- (pers$Ag1 + pers$Ag2 + pers$Ag3 + pers$Ag4 + 
#               pers$Ag5 + pers$Ag6 + pers$Ag7)/7
# pers$Ne <- (pers$Ne1 + pers$Ne2 + pers$Ne3 + pers$Ne4 + 
#               pers$Ne5 + pers$Ne6 + pers$Ne7 + pers$Ne8)/8

# faster way, less prone to error
# colsToSum.Op <- pers %>% select( c(Op1, Op2, Op3, Op4, Op5, Op6) )
# colsToSum.Co <- pers %>% select( c(Co1, Co2, Co3, Co4, Co5, Co6, Co7, Co8, Co9, Co10) )
# colsToSum.Ex <- pers %>% select( c(Ex1, Ex2, Ex3, Ex4, Ex5, Ex6, Ex7, Ex8, Ex9) )
# colsToSum.Ag <- pers %>% select( c(Ag1, Ag2, Ag3, Ag4, Ag5, Ag6, Ag7) )
# colsToSum.Ne <- pers %>% select( c(Ne1, Ne2, Ne3, Ne4, Ne5, Ne6, Ne7, Ne8) )

# pers$Op <- rowSums(colsToSum.Op) / ncol(colsToSum.Op)
# pers$Co <- rowSums(colsToSum.Co) / ncol(colsToSum.Co)
# pers$Ex <- rowSums(colsToSum.Ex) / ncol(colsToSum.Ex)
# pers$Ag <- rowSums(colsToSum.Ag) / ncol(colsToSum.Ag)
# pers$Ne <- rowSums(colsToSum.Ne) / ncol(colsToSum.Ne)

# best way, scales up to anything, least prone to error
pers <- gather(pers, 'Question', 'score', Op1:Ex9) %>%
  separate(Question, into=c('factor', 'n'), sep=2) %>%
  group_by(user_id, date, factor) %>%
  summarise(score = mean(score)) %>%
  ungroup()

# have a look at your new variables, do they make sense?


############################################
# Join your data together
############################################

# join all the data from the same participants
data.matched <- pers %>%
  inner_join(sens, by='user_id')

# how many participants did both?
length(data.matched$user_id)

# narrow it down to those who did both questionnaires on the same date
data.same.date <- pers %>%
  inner_join(sens, by=c('user_id', 'date'))

# how many participants do we have now?
length(data.same.date$user_id)

# join in the participant demographic data
data.all <- data.same.date %>%
  left_join(pants, by='user_id')

# how old is everyone?
data.all$age <- (ymd(data.all$date) - ymd(data.all$birthday))/365.25


############################################
# Visualise all the things!
############################################

# what is the distribution of sss by sex?
sss.aes <- aes(x=factor(sex), 
              y=sss, 
              colour=sex)

sex.colours <- scale_colour_manual(name = "Participant Sex    ", 
                                   values = c('grey','black'))

ggplot(filter(data.all, factor=='Op'), sss.aes) + 
  ggtitle("Sensation-Seeking Scores by Sex") +
  xlab("Participant Sex") +
  ylab("Sensation-Seeking") +
  sex.colours + 
  geom_violin(adjust=1.5, 
              trim=FALSE, 
              draw_quantiles = c(0.25, 0.5, 0.75),
              size=1.5, ) +
  theme(legend.position='none')


# How is personality related to sensation seeking?
pers.sss.aes <- aes(x=score, y = sss, colour=factor, fill=factor)

pers.colours <- scale_colour_manual(name = "Personality Factor", values = rev(viridis(5, alpha=1.0)) )
pers.fills <- scale_fill_manual(name = "Personality Factor", values = rev(viridis(5, alpha=0.05)) )

pers.sss.plot <- ggplot(filter(data.all, !is.na(sex)), pers.sss.aes) + 
  ggtitle("Is Personality Related to Sensation Seeking?") +
  xlab("Personality Score") +
  ylab("Sensation-Seeking Score") +
  pers.colours + 
  pers.fills + 
  facet_grid(. ~ sex) +
  geom_smooth(size=2) +
  theme(legend.background = element_rect(fill="transparent"),
        legend.justification=c(.5,1), 
        legend.position=c(.3,.95))

pers.sss.plot

# print as PNG
png('ocean_sss.png', width=2400, height=1800, res=300)
print(pers.sss.plot)
dev.off()

# print as PDF
pdf('ocean_sss.pdf',width=8,height=6)
print(pers.sss.plot)
dev.off()

